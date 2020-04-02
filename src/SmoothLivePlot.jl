## Smooth live plot
using Observables, WebIO

function delayPlot2(plotFunction, inArgs...)
    sleep(0.0001)
    plotFunction(inArgs...)
end
function smoothLivePlotY(x, y, plotFunction)
    data_obs = Observable{Any}(y)
    plt_obs = Observable{Any}(plotFunction(x, y))

    map!(yy -> delayPlot2(plotFunction, x, yy), plt_obs, data_obs)

    ui = dom"div"(plt_obs);
    display(ui)
    sleep(0.4)
    return data_obs
end
function smoothLivePlotX(x, y, plotFunction)
    data_obs = Observable{Any}(x)
    plt_obs = Observable{Any}(plotFunction(x, y))

    map!(xx -> delayPlot2(plotFunction, xx, y), plt_obs, data_obs)

    ui = dom"div"(plt_obs);
    display(ui)
    sleep(0.4)
    return data_obs
end
function smoothLivePlotXY(x, y, plotFunction)
    data_obs = Observable{Any}([x, y])
    plt_obs = Observable{Any}(plotFunction([], []))

    map!(inArg -> delayPlot2(plotFunction, inArg...), plt_obs, data_obs)

    ui = dom"div"(plt_obs);
    display(ui)
    sleep(0.4)
    return data_obs
end
function smoothLivePlotZ(x, y, z, plotFunction)
    data_obs = Observable{Any}(z)
    plt_obs = Observable{Any}(plotFunction(x, y, z))

    map!(zz -> delayPlot2(plotFunction, x, y, zz), plt_obs, data_obs)

    ui = dom"div"(plt_obs);
    display(ui)
    sleep(0.4)
    return data_obs
end
mutable struct changableArguments
    x
    y
    titleText
end
function smoothLivePlotXtext(plotFunction, inArgs)
    x = inArgs[1]
    y = inArgs[2]
    titleText = inArgs[3]
    data_obs = Observable{Any}(inArgs)
    plt_obs = Observable{Any}(plotFunction(inArgs...))

    map!(mapArg -> plotFunction(mapArg...), plt_obs, data_obs)

    ui = dom"div"(plt_obs);
    display(ui)
    sleep(0.4)
    return data_obs
end
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
#=
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
=#
