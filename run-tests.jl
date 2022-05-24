#!/usr/bin/env julia

# Runs tests of the package

using Pkg

Pkg.activate(".")
Pkg.test("JuliaPkgsList")

