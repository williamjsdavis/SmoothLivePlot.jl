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
function replaceMutablePlotElement!(MutablePlotArray, ind, agr3)
    MutablePlotArray[] = [MutablePlotArray[][1], MutablePlotArray[][2], agr3] # Make into a macro?
end
macro replaceMutablePlotElement2(inArg)
    objectSymbol = inArg.args[1]
    mutableIndex = inArg.args[2]
    targetChange = inArg.args[3]
    #println(typeof(objectSymbol))

    newExpression = :($(esc(objectSymbol))[] = [$(esc(objectSymbol))[][1], $(esc(objectSymbol))[][2], $(esc(targetChange))])

    #println(newExpression)
    return newExpression
end
macro makeSmoothLivePlotGeneral(plotExpression)
    # Turn plotting function into smooth version

    plotFunction = plotExpression.args[1]
    plotArgs = plotExpression.args[2:end]

    arrayArgs = map(x -> :($(esc(x))), plotArgs)
    splatArgs = :([$(arrayArgs...)])

    outExpression = :(smoothLivePlotGeneral($plotFunction, $splatArgs))

    return outExpression
end
#=
macro makeSmoothLivePlot(plotExpression)
    # Turn plotting function into smooth version

    plotFunction = plotExpression.args[1]
    plotArg1 = plotExpression.args[2]
    plotArg2 = plotExpression.args[3]

    newExpression = :(smoothLivePlot($plotArg1, $(esc(plotArg2)), $plotFunction))

    return newExpression
end
=#
