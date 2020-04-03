## Smooth live plot
using Observables, WebIO

function smoothLivePlotGeneral(plotFunction, plotArgs)
    data_obs = Observable{Any}(plotArgs)
    plt_obs = Observable{Any}(plotFunction(plotArgs...))
    map!(mapArg -> plotFunction(mapArg...), plt_obs, data_obs)

    # Create figure
    ui = dom"div"(plt_obs);
    display(ui)
    sleep(0.4)
    return data_obs
end
function replaceMutablePlotElement3!(mutablePlotArray; args...)
    Nargs = length(mutablePlotArray[])
    NargsSupplied = length(args)

    # Test arguments
    if .!all("arg" .== map(x -> string(x)[1:3], args.itr))
        error("""Mutable arguments must begin with \"arg\"""")
    end
    argStringNums = map(x -> parse(Int, string(x)[4:end]), args.itr)
    if .!all(argStringNums .<= Nargs)
        error("""Indices must be less than or equal to length of mutable array""")
    end

    mutablePlotArray[] = map(x -> x in argStringNums ? args.data[findfirst(x .== argStringNums)] : mutablePlotArray[][x], 1:Nargs)

end
macro makeLivePlot(plotExpression)
    # Turn plotting function into smooth version
    plotFunction = plotExpression.args[1]
    plotArgs = plotExpression.args[2:end]

    arrayArgs = map(x -> :($(esc(x))), plotArgs)
    splatArgs = :([$(arrayArgs...)])

    outExpression = :(smoothLivePlotGeneral($plotFunction, $splatArgs))
    return outExpression
end
