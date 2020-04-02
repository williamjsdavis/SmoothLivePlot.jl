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
function smoothLivePlotXtext(plotFunction, inArgs, boolTuple)
    x = inArgs[1]
    y = inArgs[2]
    titleText = inArgs[3]
    mutableArgs = [boolTuple...]
    immutableArgs = [.!boolTuple...]
    mutableArray = inArgs[mutableArgs]

    #data_obs = Observable{Any}(mutableArray)
    data_obs = Observable{Any}(inArgs)
    plt_obs = Observable{Any}(plotFunction(x, y, titleText))

    function agrToMutableArgs(inArgs, mutableArgs, mapArgi)
        outArgs = similar(inArgs)
        j = 1
        for ii in 1:length(inArgs)
            if mutableArgs[ii]
                outArgs[ii] = mapArgi[j]
                j = j + 1
            else
                outArgs[ii] = inArgs[ii]
            end
        end
        return outArgs
    end

    #map!(mapArg -> delayPlot2(plotFunction, mapArg[1], y, mapArg[2]), plt_obs, data_obs)
    #map!(mapArg -> plotFunction(agrToMutableArgs(inArgs, mutableArgs, mapArg)...), plt_obs, data_obs)
    map!(mapArg -> plotFunction(mapArg...), plt_obs, data_obs)

    ui = dom"div"(plt_obs);
    display(ui)
    sleep(0.4)
    return data_obs
end
function agrToMutableArgs2(inArgs, mutableArgs, mapArgi)
    outArgs = similar(inArgs)
    j = 1
    for ii in 1:length(inArgs)
        if mutableArgs[ii]
            outArgs[ii] = mapArgi[j]
            j = j + 1
        else
            outArgs[ii] = inArgs[ii]
        end
    end
    return outArgs
end
function smoothLivePlotGeneral(plotFunction, plotArgs)
    data_obs = Observable{Any}(z)
    plt_obs = Observable{Any}(plotFunction(x, y, z))

    map!(zz -> delayPlot2(plotFunction, x, y, zz), plt_obs, data_obs)

    ui = dom"div"(plt_obs);
    display(ui)
    sleep(0.4)
    return data_obs
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
