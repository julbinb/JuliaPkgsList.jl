using Main.JuliaPkgsList: getMetaDataValue, getName
using Main.JuliaPkgsList: getRepo, getStarCount, getLatestVersion
using Main.JuliaPkgsList: loadPkgsData, sortStarred

@testset "JuliaPkgsList.jl :: getMetaDataValue" begin
    FOO = "foo"
    m1 = Dict()
    m2 = Dict(FOO => 5)
    m3 = Dict(FOO => nothing)
    d = map(m -> Dict(JuliaPkgsList.METADATA_KEY => m), [m1, m2, m3])
    @test getMetaDataValue(d[1], FOO, 66) == 66
    @test getMetaDataValue(d[1], FOO, -7) == -7
    @test getMetaDataValue(d[2], FOO, 66) == 5
    @test getMetaDataValue(d[3], FOO, 66) == 66
end

@testset "JuliaPkgsList.jl :: pkg-info extraction" begin
    pkgs = loadPkgsData(SAMPLE_FILE)
    @test length(pkgs) == 148
    juliaPkg = pkgs[105]
    @test getName(juliaPkg) == "julia"
    @test getRepo(juliaPkg) == JULIA_REPO
    @test getStarCount(juliaPkg) == 31228
    @test getLatestVersion(juliaPkg) == "1.5.3"
    @test JuliaPkgsList.getNameAndVersion(juliaPkg) == "julia, 1.5.3"
    @test JuliaPkgsList.getRepoAndVersion(juliaPkg) == "$(JULIA_REPO), 1.5.3"
    yieldMacrosPkg = pkgs[20]
    @test getName(yieldMacrosPkg) == "AbstractYieldMacros"
    @test getStarCount(yieldMacrosPkg) == 0
    @test getLatestVersion(yieldMacrosPkg) == "0.1.0"
    # sorting
    sorted = sortStarred(pkgs)
    @test sorted[1] == juliaPkg
end