#!/usr/bin/env julia

#######################################################################
# Generation of a list of the top N most starred Julia packages
#######################################################################

#--------------------------------------------------
# Imports
#--------------------------------------------------

using Pkg
Pkg.activate(".")
Pkg.instantiate()
include("src/JuliaPkgsList.jl")
using Main.JuliaPkgsList

using ArgParse

#--------------------------------------------------
# Command line arguments
#--------------------------------------------------

# → Dict (arguments)
function parse_command_line_args()
    argsStr = ArgParseSettings(
        description = "Generates the list of top <pkgnum> most starred Julia packages using data from Julia Hub. Use -h or --help for usage details."
    )
    @add_arg_table! argsStr begin
        "pkgnum"
            help = "number of top most starred packages of interest (0 means all packages)"
            arg_type = Int
            required = true
        
        "--reload", "-r"
            help = "flag specifying if packages information must be reloaded"
            action = :store_true
        "--pkginfo", "-p"
            help = "JSON file with packages information"
            arg_type = String
            default = JuliaPkgsList.PKGS_INFO_FILE

        "--name", "-n"
            help = "flag specifying if the output should be packages' names instead of repositories"
            action = :store_true
        "--includeversion"
            help = "flag specifying if the output should include the latest version of packages"
            action = :store_true

        "--excluded", "-e"
            help = "file with a list of repositories to exclude"
            arg_type = String
            default = JuliaPkgsList.EXCLUDED_REPOS_FILE
        "--noexclude"
            help = "flag specifying if all packages should be included (i.e. ignore the file with excluded)"
            action = :store_true
        
        "--show", "-s"
            help = "flag specifying if the output should be printed to console instead of a file"
            action = :store_true

        "--out", "-o"
            help = "output file with the top packages list"
            arg_type = String
            default = JuliaPkgsList.PKGS_LIST_FILE
        "--nopkgnum"
            help = "flag specifying that the output file should not be prepended with the number of packages"
            action = :store_true
    end
    parse_args(argsStr)
end

# All script parameters
const PARAMS = parse_command_line_args()

#--------------------------------------------------
# Main
#--------------------------------------------------

genTopPkgsList(
    PARAMS["pkgnum"], PARAMS["reload"]
; 
    pkgsListOutputFile = PARAMS["out"],
    addPkgNum = !PARAMS["nopkgnum"],
    showName = PARAMS["name"],
    includeVersion = PARAMS["includeversion"],
    pkgsInfoFile = PARAMS["pkginfo"],
    excludedReposFile = PARAMS["excluded"],
    useStdOut = PARAMS["show"],
    useExcluded = !PARAMS["noexclude"]
)
