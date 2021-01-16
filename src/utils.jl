#######################################################################
# Graceful exit
# and macro for printing information depending on verbosity
#
# ASSUMPTION: the package defines variable `VERBOSE`
#######################################################################

# String → Nothing
# Prints error message and terminates execution
exitErrWithMsg(msg :: String, err :: Exception) = begin
    @error(msg, err)
    exit(1)
end
exitErrWithMsg(msg :: String) = begin
    @error(msg)
    exit(1)
end

# If verbose, prints information `info`
macro status(info)
    :(if VERBOSE ; @info($(esc(info))) end)
end
