#######################################################################
# 
#######################################################################



#--------------------------------------------------
# 
#--------------------------------------------------

module JuliaPkgsList

#--------------------------------------------------
# Exports
#--------------------------------------------------

export genTopPkgsList, getSortedPkgsInfo, getSortedPkgs
export PKGS_INFO_URL, loadPkgsData

#--------------------------------------------------
# Imports
#--------------------------------------------------

using JSON
using Downloads

#--------------------------------------------------
# Data and parameters
#--------------------------------------------------

# URL with JSON data on registered Julia packages
# from official Julia Computing web page (JuliaHub)
const PKGS_INFO_URL = "https://juliahub.com/app/packages/info"

# Path to the folder with data, relative to this file
const DATA_DIR = abspath(joinpath(@__DIR__, "..", "data"))

mkDataPath(fileName :: String) = joinpath(DATA_DIR, fileName)

# Default number of top packages
const TOP_PKGS_NUM = 100

# Default path to the output file with the list of packages
const PKGS_LIST_FILE = mkDataPath("top-pkgs-list.txt")
# Default path to the JSON file with packages info
const PKGS_INFO_FILE = mkDataPath("julia-pkgs-info.json")
# Default file with git-repos of excluded packages
const EXCLUDED_REPOS_FILE = mkDataPath("excluded.txt")

# If `true`, functions print some status information
VERBOSE = true

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Code
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#--------------------------------------------------
# Library
#--------------------------------------------------

include("utils.jl")
include("lib.jl")

#--------------------------------------------------
# Main entry function
#--------------------------------------------------

"""
    genTopPkgsList(...)

Entry function for generating the list of most starred Julia packages
using information from Julia Hub.

# Arguments
- `topPkgsNum::Int`: the number of most starred packages (natural number; if 0, means all packages)
- `reloadPkgsInfo::Bool`: if `true`, reloads JSON with packages info
- `pkgsListOutputFile::String`: ...
"""
genTopPkgsList(
    topPkgsNum          :: Int      = TOP_PKGS_NUM,
    reloadPkgsInfo      :: Bool     = false
;
    pkgsListOutputFile  :: String   = PKGS_LIST_FILE,
    addPkgNum           :: Bool     = true,
    showName            :: Bool     = false,
    includeVersion      :: Bool     = false,
    pkgsInfoFile        :: String   = PKGS_INFO_FILE,
    excludedReposFile   :: String   = EXCLUDED_REPOS_FILE,
    useStdOut           :: Bool     = false,
    useExcluded         :: Bool     = true
) = begin
    topPkgsNum >= 0 || exitErrWithMsg("The number of packages cannot be negative")
    @status("Packages list generation STARTED")
    # obtain package info
    if reloadPkgsInfo || !isfile(pkgsInfoFile)
        downloadPkgsInfo(pkgsInfoFile)
    end
    # load excluded packages
    excluded = useExcluded ? loadExcludedRepos(excludedReposFile) : String[]
    # get pkgs data
    pkgs = loadPkgsInfo(pkgsInfoFile)
    sortedPkgs = 
        try
            getSortedPkgs(pkgs, showName;
                excludedRepos=excluded, includeVersion=includeVersion)
        catch err
            exitErrWithMsg("Unable to process packages data", err)
        end
    # outputting information
    if topPkgsNum > length(sortedPkgs)
        topPkgsNum = length(sortedPkgs)
        @status("The number of packages is too big -- set to the max $(topPkgsNum)")
    end
    outputPkgsInfo(sortedPkgs, topPkgsNum, useStdOut, pkgsListOutputFile, addPkgNum)
    @status("Packages list generation COMPLETED")
end

#--------------------------------------------------
# Aux functions
#--------------------------------------------------

downloadPkgsInfo(pkgsInfoFile :: String) = begin
    @status("Downloading packages info into $(pkgsInfoFile)...")
    try
        Downloads.download(PKGS_INFO_URL, pkgsInfoFile)
    catch err
        exitErrWithMsg(
            "Unable to download Julia packages information from Julia Hub",
            err)
    end
end

loadExcludedRepos(excludedReposFile :: String) :: Vector{String} = begin
    @status("Loading the list of excluded repositories from $(excludedReposFile)...")
    text = 
        try
            read(excludedReposFile, String)
        catch err
            exitErrWithMsg(
                "Unable to load the list of excluded repositories",
                err)
        end
    repos = filter(!isempty, splitlines(text))
    Vector{String}(repos)
end

loadPkgsInfo(pkgsInfoFile :: String) :: Vector = begin
    @status("Loading packages data from $(pkgsInfoFile)...")
    try
        loadPkgsData(pkgsInfoFile)
    catch err
        exitErrWithMsg(
            "Unable to parse packages information",
            err)
    end
end

outputPkgsInfo(
    sortedPkgs :: Vector, topPkgsNum :: Int,
    useStdOut :: Bool, pkgsListOutputFile :: String, addPkgNum :: Bool
) = begin
    resultPkgs = topPkgsNum == 0 ? sortedPkgs : sortedPkgs[1:topPkgsNum]
    output = join(map(string, resultPkgs), '\n')
    if useStdOut
        println(output)
    else
        if addPkgNum && topPkgsNum > 0
            (dirPath, fileName) = splitdir(pkgsListOutputFile)
            pkgsListOutputFile = joinpath(dirPath, "$(topPkgsNum)-$(fileName)")
        end
        @status("Writing output to $(pkgsListOutputFile)...")
        try
            open(pkgsListOutputFile, "w") do io
                write(io, output)
            end
        catch err
            exitErrWithMsg(
                "Unable to write to the output file (possibly, the folder doesn't exist)",
                err)
        end
    end
end

end
