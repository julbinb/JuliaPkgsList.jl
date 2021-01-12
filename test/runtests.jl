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

#--------------------------------------------------
# Tests
#--------------------------------------------------

include("utils.jl")
include("pkgs-API.jl")

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
