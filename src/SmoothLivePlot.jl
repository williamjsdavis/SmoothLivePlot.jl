## Smooth live plot
using Observables, WebIO


function delayPlot(x, y, plotFunction)
    sleep(0.0001)
    plotFunction(x, y)
end
function smoothLivePlot(x, y, plotFunction)
    data_obs = Observable{Any}(y)
    plt_obs = Observable{Any}(plotFunction(x, y))

    #map!(yy -> plot(x, yy), plt_obs, data_obs)
    map!(yy -> delayPlot(x, yy, plotFunction), plt_obs, data_obs)

    ui = dom"div"( plt_obs );
    display(ui)
    sleep(0.4)
    return data_obs
end
macro makeSmoothLivePlot(plotExpression)
    # Turn plotting function into smooth version

    plotFunction = plotExpression.args[1]
    plotArg1 = plotExpression.args[2]
    plotArg2 = plotExpression.args[3]

    newExpression = :(smoothLivePlot($plotArg1, $(esc(plotArg2)), $plotFunction))

    return newExpression
end
