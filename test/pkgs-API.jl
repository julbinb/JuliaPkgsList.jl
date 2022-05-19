using Main.JuliaPkgsList: getName, getRepo, getStarCount
using Main.JuliaPkgsList: downloadCompat

@testset "JuliaPkgsList.jl :: pkgs API" begin
    @info "Downloading packages info..."
    # URL is still valid and produces a JSON file
    downloadCompat(JuliaPkgsList.PKGS_INFO_URL, PKGS_INFO_FILE)
    @test isfile(PKGS_INFO_FILE)

    @info "Checking the format..."
    # JSON object with a single entry is expected
    data = JSON.parsefile(PKGS_INFO_FILE)
    @test isa(data, Dict)
    @test length(data) == 1

    # The format is still the same: PKGS_KEY => [Package]
    @test haskey(data, JuliaPkgsList.PKGS_KEY)
    pkgs = data[JuliaPkgsList.PKGS_KEY]
    @test isa(pkgs, Vector)
    @test length(pkgs) > 1

    # The format of a single package info is the same
    pkg1 = pkgs[1]
    @test haskey(pkg1, JuliaPkgsList.NAME_KEY)
    @test isa(pkg1[JuliaPkgsList.NAME_KEY], String)
    @test haskey(pkg1, JuliaPkgsList.METADATA_KEY)
    md1 = pkg1[JuliaPkgsList.METADATA_KEY]
    @test isa(md1, Dict)
    @test haskey(md1, JuliaPkgsList.REPO_KEY)
    @test isa(md1[JuliaPkgsList.REPO_KEY], String)
    @test haskey(md1, JuliaPkgsList.VERSIONS_KEY)
    @test isa(md1[JuliaPkgsList.VERSIONS_KEY], Vector)

    # Julia package itself is in the list
    jlInd = findfirst(pkg -> getRepo(pkg) == JULIA_REPO, pkgs)
    @test isa(jlInd, Int) && jlInd > 0
    @test getName(pkgs[jlInd]) == JULIA_NAME

    # All packages have necessary information
    @test getSortedPkgs(pkgs)[1] == JULIA_REPO
    
    # `rm` was failing on Windows x64 (Jan 2020, Julia 1.5.3)
    tryrm(PKGS_INFO_FILE)
end