# Plotting test

using Plots
include("./src/SmoothLivePlot.jl")
gr(show = true)

@userplot DiffusionPlot
@recipe function f(dp::DiffusionPlot)
    x, y , yMax= dp.args
    n = length(x)
    inds = 1:n
    label --> false
    ylims --> [0, yMax]
    x[inds], y[inds]
end

const tStart = 0.0
const tEnd = 2.0
const ntSteps = 100
const xStart = -5.0
const xEnd = 5.0
const nxSteps = 20
const D = 1E-5

const tArray = range(tStart, tEnd, length = ntSteps)
const xArray = range(xStart, xEnd, length = nxSteps)

function main(tArray, xArray, D)

    p0 = getInitialDist(xArray)
    pMax = maximum(p0)
    p = copy(p0)

    dx = 1/(xArray.len-1);
    dt = 0.5*dx*dx/D;
    s = D*dt/(dx*dx);
    function stepTime(p, s, nx)
        p[2:end-1] = s.*p[3:nx]-(2*s-1).*p[2:nx-1]+s.*p[1:nx-2];
    end

    YplotObject = smoothLivePlotY(xArray, p0, myPlot)
    #YplotObject = @makeSmoothLivePlot myPlot(xArray, p0)
    for tt in tArray
        stepTime(p, s, xArray.len)
        YplotObject[] = copy(p)
    end
end
function main2(tArray, xArray, D)
    p0 = getInitialDist(xArray)
    pMax = maximum(p0)
    XplotObject = smoothLivePlotX(xArray, p0, myPlot)
    #YplotObject = @makeSmoothLivePlot myPlot(xArray, p0)
    for tt in tArray
        XplotObject[] = XplotObject[]*0.99
    end
end
function main3(tArray, xArray, D)
    p0 = getInitialDist(xArray)
    pMax = maximum(p0)
    XYplotObject = smoothLivePlotXY(xArray, p0, myPlot)
    #YplotObject = @makeSmoothLivePlot myPlot(xArray, p0)
    for tt in tArray
        XYplotObject[] = [XYplotObject[][1]*1.01, XYplotObject[][2]*0.99]
    end
end
function main4(tArray, xArray, D)
    x = 1:0.05:20
    y = 1:0.05:10
    f(x, y, t) = begin
        (3x + y^2) * abs(sin(x) + (1-t)*cos(y))
    end
    X = repeat(reshape(x, 1, :), length(y), 1)
    Y = repeat(y, 1, length(x))
    Z = map((x, y) -> f(x, y, 0.0), X, Y)
    ZplotObject = smoothLivePlotZ(x, y, Z, myPlotZ)
    #YplotObject = @makeSmoothLivePlot myPlot(xArray, p0)
    ttt = 0.0:0.1:1.0
    for tt in ttt
        Z = map((x, y) -> f(x, y, tt), X, Y)
        ZplotObject[] = [Z]
    end
end
function main5(tArray, xArray, D)
    p0 = getInitialDist(xArray)
    pMax = maximum(p0)
    p = copy(p0)
    titleText = "Title, step: "

    XtextPlotObject = smoothLivePlotXtext(myPlotTitle, [xArray, p0, titleText], (true, false, true))
    #YplotObject = @makeSmoothLivePlot myPlot(xArray, p0)
    for tt in 1:length(tArray)
        #XtextPlotObject[] = [XtextPlotObject[][1]*0.99, string(titleText, tt)]
        #XtextPlotObject[] = [XtextPlotObject[][1]*0.99, XtextPlotObject[][2], string(titleText, tt)]
        replaceMutablePlotElement!(XtextPlotObject, 3, string(titleText, tt))
    end
    return XtextPlotObject
end
function replaceMutablePlotElement!(MutablePlotArray, ind, agr3)
    MutablePlotArray[] = [MutablePlotArray[][1], MutablePlotArray[][2], agr3] # Make into a macro?
end
function getInitialDist(xArray)
    x0 = 0.0
    sig = 2.0
    f(x) = exp(-((x - x0)/sig)^2)
    p = f.(xArray)
end
function myPlot(xx, yy)
    plot(xx, yy, label = "", color = :red)
    scatter!(xx, yy, label = "")
    xlims!(-5, 5)
    ylims!(0, 1)
    title!("Title")
    xlabel!("X label")
    ylabel!("Y label")
end
function myPlotTitle(xx, yy, titleText)
    sleep(0.0001)
    plot(xx, yy, label = "", color = :red)
    scatter!(xx, yy, label = "")
    xlims!(-5, 5)
    ylims!(0, 1)
    title!(titleText)
    xlabel!("X label")
    ylabel!("Y label")
end
function myPlotZ(xx, yy, ZZ)
    p1 = contour(xx, yy, ZZ, fill = true, clims=(0,300));
    title!("Title")
    xlabel!("X label")
    ylabel!("Y label")
end

main5(tArray, xArray, D)
