# JuliaPkgsList.jl

[![Build Status](https://github.com/julbinb/JuliaPkgsList.jl/workflows/CI/badge.svg)](https://github.com/julbinb/JuliaPkgsList.jl/actions?query=workflow%3ACI+branch%3Amain)
[![codecov.io](http://codecov.io/github/julbinb/JuliaPkgsList.jl/coverage.svg?branch=main)](http://codecov.io/github/julbinb/JuliaPkgsList.jl?branch=main)

Generates the list of the N most starred Julia packages
using the data from [JuliaHub](https://juliahub.com/).

## Usage

### Script

For detailed help, run

    $ [julia] ./gen-pkgs-list.jl -h

**Note.** All specified dependencies need to be installed in the default
environment for the above to work.

#### Most common usages

```
$ [julia] ./gen-pkgs-list.jl 10 -o mydata/pkgs-list.txt -n --includeversion
```

outputs the list of names and latest versions of the 10 most starred packages
to the file `mydata/10-pkgs-list.txt` (folder `mydata` needs to exist),
excluding packages with repositories listed in
[`data/excluded.txt`](data/excluded.txt).

```
$ [julia] ./gen-pkgs-list.jl 0 -r -o julia-pkgs.txt --nopkgnum --noexclude
```

redownloads packages data JSON and
outputs the list of repositories of all packages (0 means all packages,
`--noexclude` means nothing is excluded)
to the file `julia-pkgs.txt` (`--nopkgnum` means that the number of packages
is not prepended to the output file name).

### Module

To obtain arbitrary information for the list of sorted packages,
for example, tuples of (package name, description, star count),
you can do the following:

```julia
include("src/JuliaPkgsList.jl")
# introduces PKGS_INFO_URL, loadPkgsData, getSortedPkgsInfo
using Main.JuliaPkgsList

getDescription(pkgInfo :: Dict) :: String =
    JuliaPkgsList.getMetaDataValue(pkgInfo, "description", "<no description>")

getMyInfo(pkgInfo :: Dict) = (
    JuliaPkgsList.getName(pkgInfo),
    getDescription(pkgInfo),
    JuliaPkgsList.getStarCount(pkgInfo))

const PKGS_JSON = "julia-pkgs-info.json"

download(PKGS_INFO_URL, PKGS_JSON)
pkgs = loadPkgsData(PKGS_JSON)

sortedPkgsInfo = getSortedPkgsInfo(pkgs, getMyInfo)
#=
4882-element Array{Tuple{String,String,Int64},1}:
 ("julia", "The Julia Programming Language", 31228)
 ("Flux", "Relax! Flux is the ML library that doesn't make you tensor", 2720)
 ("Pluto", "🎈 Simple reactive notebooks for Julia", 2237)
 ("IJulia", "Julia kernel for Jupyter", 2149)
 ("Gadfly", "Crafty statistical graphics for Julia.", 1598)
 ...
 ("Secp256k1", "", -1)
 ("SimpleCache", "", -1)
 ("SquashFS", "", -1)
 ("StanMCMCChain", "", -1)
 ("Unicode2LaTeX", "", -1)
 ("YahooFinance", "", -1)
=#
```

## Details

Downloads [this JSON file](https://juliahub.com/app/packages/info),
sorts packages from the most to least starred,
and outputs some information about the packages
(names or repos, optionally with latest versions).

The JSON file is expected to have the following structure:

```
{"packages" : [
    
    {
        "name" : "...",
        "metadata" : 
        {
            "repo" : "https://...",
            "starcount" : N
        }
    },
    {
        "name" : "...",
        "metadata" : 
        {
            "repo" : "https://...",
            "starcount" : N
        }
    }
]}
```

## Repository Organization

- [`README.md`](README.md) this file

- [`gen-pkgs-list.jl`](gen-pkgs-list.jl) script for an easy use of the module

- [`src`](src) source code

  - [`JuliaPkgsList.jl`](src/JuliaPkgsList.jl) main module with surface
    functions that use default files
  - [`lib.jl`](src/lib.jl) main functions for processing JSON data on packages
    and sorting them by the star count
  - [`utils.jl`](src/utils.jl) macro for printing info depending on verbosity

- [`test`](test) tests

    - [`runtests.jl`](test/runtests.jl) main test file that inlcudes
      other tests as well as tests for entry functions

    - [`utils.jl`](test/utils.jl) tests for aux function dealing with
      info extraction from package data
    - [`pkgs-API.jl`](test/pkgs-API.jl) tests for the format of the current
      JSON file available from JuliaHub
    - [`test-files`](test/test-files) folder for storing sample JSON data
      and temporary files

- [`run-tests.jl`](run-tests.jl) script for easy running of
  [`test/runtests.jl`](test/runtests.jl)

- [`Project.toml`](Project.toml) dependencies

## Dependencies

* [Julia](https://julialang.org/) with the following packages:
  - `JSON` for processing JSON file with the packages data
  - `Downloads` for downloading JSON with packages info
  - `ArgParse` for the aux script generating the list of packages

## Excluded packages

Some packages are no longer available publicly,
some are copies of other packages (have been renamed).

Packages excluded by default are listed in
[`data/excluded.txt`](data/excluded.txt).
Those include the following, as well as all packages from the next section
(not available):

- Julia language repo itself (`https://github.com/JuliaLang/julia.git`)
- Packages that don't appear to be Julia packages:
  - `https://github.com/Lonero-Team/Decentralized-Internet.git`
  - `https://github.com/plotly/dash-html-components.git`
- Empty package, which was merged somewhere
  (`https://github.com/dmlc/MXNet.jl.git`)
- Duplicate packages
  - Renamed to `Franklin.jl` (`https://github.com/tlienart/JuDoc.jl.git`)
  - Deprecated, became `ValueShapes.jl`
    (`https://github.com/oschulz/ShapesOfVariables.jl.git`)

#### Not available

```
https://github.com/Moelf/BigG.jl.git
https://github.com/bcbi/CountdownLetters.jl.git
https://github.com/bcbi/CountdownNumbers.jl.git
https://github.com/mipals/SymSemiseparableMatrices.jl.git
https://github.com/aramirezreyes/AvailablePotentialEnergyFramework.jl.git
https://github.com/MUsmanZahid/DTALib.jl.git
https://github.com/lucianolorenti/Estapir.jl.git
https://github.com/GuilhermeHaetinger/KelvinletsImage.jl.git
https://github.com/PetrKryslUCSD/MeshFinder.jl.git
https://github.com/PetrKryslUCSD/MeshMaker.jl.git
https://github.com/PetrKryslUCSD/MeshPorter.jl.git
https://github.com/PetrKryslUCSD/MeshKeeper.jl.git
https://github.com/tlienart/MLJScikitLearn.jl.git
https://github.com/THM-MoTE/ModelicaScriptingTools.jl.git
https://github.com/louiscmm/Sinaica.jl.git
https://github.com/MUsmanZahid/TeXTable.jl.git
https://github.com/rjdverbeek-tud/Atmosphere.jl.git
https://github.com/mrtkp9993/Bioinformatics.jl.git
https://github.com/anders-dc/Granular.jl.git
https://github.com/oscar-system/GAPTypes.jl.git
https://github.com/rbalexan/InfrastructureSensing.jl.git
https://github.com/slmcbane/MirroredArrayViews.jl.git
https://github.com/markushhh/YahooFinance.jl.git
https://github.com/StanJulia/StanMCMCChain.jl.git
```
