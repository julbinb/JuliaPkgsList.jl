#######################################################################
# 
#######################################################################

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# 
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#--------------------------------------------------
# 
#--------------------------------------------------

module JuliaPkgsList

#--------------------------------------------------
# Exports
#--------------------------------------------------

export getSortedPkgsInfo, getSortedPkgs

#--------------------------------------------------
# Imports
#--------------------------------------------------

using JSON

#--------------------------------------------------
# Data
#--------------------------------------------------

# URL with JSON data on registered Julia packages
# from official Julia Computing web page (JuliaHub)
const PKGS_INFO_URL = "https://juliahub.com/app/packages/info"

# Expected format of JSON data: `{packages: [...]}`
const PKGS_KEY = "packages"
# Expected format of a single package:
# `{name: ..., metadata: {repo:..., starcount: ...}}`
const NAME_KEY          = "name"
const METADATA_KEY      = "metadata"
const REPO_KEY          = "repo"
const STARTCOUNT_KEY    = "starcount"

#--------------------------------------------------
# Code
#--------------------------------------------------

VERBOSE = true

include("utils.jl")
include("lib.jl")



end
