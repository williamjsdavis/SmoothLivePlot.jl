# Plotting test

using Plots
include("./src/SmoothLivePlot.jl")
gr(show = true)

function testModifyY()

    p0, xArray, tArray = getInitialDist()

    pMax = maximum(p0)
    p = copy(p0)

    D = 1E-5
    dx = 1/(xArray.len-1);
    dt = 0.5*dx*dx/D;
    s = D*dt/(dx*dx);
    function stepTime(p, s, nx)
        p[2:end-1] = s.*p[3:nx]-(2*s-1).*p[2:nx-1]+s.*p[1:nx-2];
    end

    YplotObject = @makeLivePlot myPlot(xArray, p0)
    for tt in tArray
        stepTime(p, s, xArray.len)
        replaceMutablePlotElement3!(YplotObject, arg2 = p)
    end
end
function testModifyX()

    p0, xArray, tArray = getInitialDist()
    pMax = maximum(p0)

    XplotObject = @makeLivePlot myPlot(xArray, p0)
    for tt in tArray
        replaceMutablePlotElement3!(XplotObject, arg1 = XplotObject[][1]*0.99)
    end
end
function testModifyXY()

    p0, xArray, tArray = getInitialDist()

    pMax = maximum(p0)

    XYplotObject = @makeLivePlot myPlot(xArray, p0)
    for tt in tArray
        replaceMutablePlotElement3!(XYplotObject, arg2 = XYplotObject[][2]*0.99, arg1 = XYplotObject[][1]*1.01)
    end
end
function testModifyZ()
    x = 1:0.05:20
    y = 1:0.05:10
    f(x, y, t) = begin
        (3x + y^2) * abs(sin(x) + (1-t)*cos(y))
    end
    X = repeat(reshape(x, 1, :), length(y), 1)
    Y = repeat(y, 1, length(x))
    Z = map((x, y) -> f(x, y, 0.0), X, Y)

    ZplotObject = @makeLivePlot myPlotZ(x, y, Z)

    ttt = 0.0:0.1:1.0
    for tt in ttt
        Z = map((x, y) -> f(x, y, tt), X, Y)
        replaceMutablePlotElement3!(ZplotObject, arg3 = Z)
    end
end
function testModifyXText()

    p0, xArray, tArray = getInitialDist()

    pMax = maximum(p0)
    p = copy(p0)
    titleText = "Title, step: "

    XtextPlotObject = @makeLivePlot myPlotTitle(xArray, p0, titleText)
    for tt in 1:50
        replaceMutablePlotElement3!(XtextPlotObject, arg3 = string(titleText, tt), arg1 = XtextPlotObject[][1]*0.99)
    end
    return XtextPlotObject
end
function getInitialDist()
    tStart = 0.0
    tEnd = 2.0
    ntSteps = 100
    xStart = -5.0
    xEnd = 5.0
    nxSteps = 20

    tArray = range(tStart, tEnd, length = ntSteps)
    xArray = range(xStart, xEnd, length = nxSteps)

    x0 = 0.0
    sig = 2.0
    f(x) = exp(-((x - x0)/sig)^2)
    p = f.(xArray)

    return p, xArray, tArray
end
function myPlot(xx, yy)
    sleep(0.0001)
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
    sleep(0.0001)
    p1 = contour(xx, yy, ZZ, fill = true, clims=(0,300));
    title!("Title")
    xlabel!("X label")
    ylabel!("Y label")
end

#testModifyY()
#testModifyX()
#testModifyXY()
#testModifyZ()
#testModifyXText()
