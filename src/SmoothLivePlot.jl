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
function replaceMutablePlotElement2!(mutablePlotArray, indexIn, argIn)
    Nargs = length(mutablePlotArray[])

    mutablePlotArray[] = map(x -> x == indexIn ? argIn : mutablePlotArray[][x], 1:Nargs)
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
