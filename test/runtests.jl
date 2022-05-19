#--------------------------------------------------
# Imports
#--------------------------------------------------

using JuliaPkgsList

using Test
using JSON

#--------------------------------------------------
# Aux values and functions
#--------------------------------------------------

# String → String
testFilePath(path :: String) = joinpath(@__DIR__, TEST_FILES_DIR, path)

const TEST_FILES_DIR = "test-files"
const PKGS_INFO_FILE = testFilePath("pkgs-info.json")
const SAMPLE_FILE    = testFilePath("sample-pkgs-info.json")

const JULIA_REPO = "https://github.com/JuliaLang/julia.git"
const JULIA_NAME = "julia"

tryrm(path :: AbstractString) =
    try rm(path); catch err @warn(err) end

#--------------------------------------------------
# Tests
#--------------------------------------------------

include("utils.jl")

@testset "JuliaPkgsList.jl :: main processing function" begin
    pkgs = loadPkgsData(SAMPLE_FILE)
    # main function
    namesSorted = getSortedPkgsInfo(pkgs, getName)
    @test namesSorted[1] == "julia"
    @test namesSorted[2] == "JuMP"
    reposSortedNoJulia = getSortedPkgsInfo(pkgs, getRepo; excludedRepos=[JULIA_REPO])
    @test reposSortedNoJulia[1] == "https://github.com/jump-dev/JuMP.jl.git"
    # aux repo/name function
    @test getSortedPkgs(pkgs)[3] == "https://github.com/FluxML/Zygote.jl.git"
    @test getSortedPkgs(pkgs, true; excludedRepos=[JULIA_REPO])[2] == "Zygote"
end

@testset "JuliaPkgsList.jl :: main entry function" begin
    # names with version, excluded packages
    fname1 = testFilePath("top-5-pkgs-list.txt")
    genTopPkgsList(5;
        pkgsListOutputFile=fname1, addPkgNum=false,
        showName=true, includeVersion=true,
        pkgsInfoFile=SAMPLE_FILE
    )
    @test isfile(fname1)
    @test read(fname1, String) ==
        "JuMP,0.21.5\nZygote,0.6.0\nJuliaDB,0.13.1\nJuliaZH,1.5.4\nJavis,0.4.0"
    tryrm(fname1)
    # repos, empty list of excluded packages
    fname2 = testFilePath("pkgs-list.txt")
    genTopPkgsList(4;
        pkgsListOutputFile=fname2, pkgsInfoFile=SAMPLE_FILE,
        excludedReposFile=testFilePath("noexcluded.txt")
    )
    fname2 = testFilePath("4-pkgs-list.txt")
    @test isfile(fname2)
    @test read(fname2, String) == join([
        "https://github.com/JuliaLang/julia.git", "https://github.com/jump-dev/JuMP.jl.git",
        "https://github.com/FluxML/Zygote.jl.git", "https://github.com/JuliaData/JuliaDB.jl.git"
    ], "\n")
    tryrm(fname2)
end

include("pkgs-API.jl")
