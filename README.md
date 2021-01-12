# JuliaPkgsList.jl

[![Build Status](https://github.com/julbinb/JuliaPkgsList.jl/workflows/CI/badge.svg)](https://github.com/julbinb/JuliaPkgsList.jl/actions?query=workflow%3ACI+branch%3Amain)
[![codecov.io](http://codecov.io/github/julbinb/JuliaPkgsList.jl/coverage.svg?branch=main)](http://codecov.io/github/julbinb/JuliaPkgsList.jl?branch=main)

Generates the list of the N most starred Julia packages
using the data from [JuliaHub](https://juliahub.com/).

Namely, downloads [this JSON file](https://juliahub.com/app/packages/info),
and sorts packages from the most to least starred.
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

- [`Project.toml`](Project.toml) dependencies

- [`src`](src) source code

  - [`JuliaPkgsList.jl`](src/JuliaPkgsList.jl) main module with surface
    functions that use default files
  - [`lib.jl`](src/lib.jl) main functions for processing JSON data on packages
    and sorting them by the star count
  - [`utils.jl`](src/utils.jl) macro for printing info depending on verbosity

- [`test`](test) tests

    - [`runtests.jl`](test/runtests.jl) main test file
    - [`utils.jl`](test/utils.jl) tests for aux function dealing with
      info extraction from package data
    - [`pkgs-API.jl`](test/pkgs-API.jl) tests for the format of the current
      JSON file available from JuliaHub
    - [`test-files`](test/test-files) folder for storing sample JSON data
      and temporary files

- [`run-tests.jl`](run-tests.jl) script for easy running of
  [`test/runtests.jl`](test/runtests.jl)

## Dependencies

* [Julia](https://julialang.org/) with the following packages:
  - `JSON` for processing JSON file with the packages data
  - `ArgParse` for the aux script generating the list of packages


