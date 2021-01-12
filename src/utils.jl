#######################################################################
# Macro for printing information depending on verbosity
#
# ASSUMPTION: the package defines variable `VERBOSE`
#######################################################################

# If verbose, prints information `info`
macro status(info)
    :(if VERBOSE ; @info($(esc(info))) end)
end
