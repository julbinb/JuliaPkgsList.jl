#######################################################################
# Functions for processing information about packages
# and sorting them by the number of stars
#######################################################################

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Extracting list of packages
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# (Vector{PackageInfo}, Bool, Vector{String}) → Vector{String}
# Returns the list of package repos or package names depending on `showName`,
# sorted from the most to least starred packages,
# excluding packages with repos listed in `excludedRepos`
getSortedPkgs(
    pkgs :: Vector, showName :: Bool = false;
    excludedRepos :: Vector{String} = String[]
) :: Vector{String} = getSortedPkgsInfo(
    pkgs, showName ? getName : getRepo;
    excludedRepos=excludedRepos
)

# (Vector{PackageInfo}, PackageInfo→Any, Vector{String}) → Vector{Any}
# Returns the list of package information
# sorted from the most to least starred packages,
# excluding packages with repos listed in `excludedRepos`
getSortedPkgsInfo(
    pkgs :: Vector, getInfo :: Function;
    excludedRepos :: Vector{String} = String[]
) :: Vector = begin
    if !isempty(excludedRepos)
        @status "Cleaning packages..."
        pkgs = filter(pkg -> !in(getRepo(pkg), excludedRepos), pkgs)
    end
    @status "Sorting packages..."
    sorted = sortStarred(pkgs)
    @status "Extracting information..."
    unique(map(getInfo, sorted))
end

# (Vector{PackageInfo}, String) → Vector{PackageInfo}
# Sorts packages from the most starred to least starred
sortStarred(pkgs :: Vector) = sort(pkgs, by=getStarCount, rev=true)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Utilitites for working with packages info
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Retrieves the list of packages from file `pkgsInfoFilePath`
# ASSUMPTION: the file has the expected JSON format
loadPkgsData(pkgsInfoFilePath :: String) :: Vector = begin
    data = JSON.parsefile(pkgsInfoFilePath) 
    data[PKGS_KEY]
end

# (PackageInfo, String) → Any
# Retrieves the value of `key` from `pkgInfo` metadata
# or returns `default` value
# ASSUMPTION: `pkgInfo` contains metadata
getMetaDataValue(pkgInfo :: Dict, key :: String, default :: Any) :: Any = begin
    metaData = pkgInfo[METADATA_KEY]
    val = get(metaData, key, default)
    # in case the value of the element is `null` in JSON
    val !== nothing ? val : default
end

# (PackageInfo, String) → String
getName(pkgInfo :: Dict) :: String = get(pkgInfo, NAME_KEY, "<NA-name>")

# (PackageInfo, String) → String
getRepo(pkgInfo :: Dict) :: String =
    getMetaDataValue(pkgInfo, REPO_KEY, "<NA-repo>")

# (PackageInfo, String) → Int
getStarCount(pkgInfo :: Dict) :: Int =
    getMetaDataValue(pkgInfo, STARTCOUNT_KEY, 0)
