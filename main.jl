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

    YplotObject = @makeSmoothLivePlotGeneral myPlot(xArray, p0)
    for tt in tArray
        stepTime(p, s, xArray.len)
        YplotObject[] = [xArray, copy(p)]
    end
end
function testModifyX()

    p0, xArray, tArray = getInitialDist()
    pMax = maximum(p0)

    XplotObject = @makeSmoothLivePlotGeneral myPlot(xArray, p0)
    for tt in tArray
        XplotObject[] = [XplotObject[][1]*0.99, XplotObject[][2]]
    end
end
function testModifyXY()

    p0, xArray, tArray = getInitialDist()

    pMax = maximum(p0)

    XYplotObject = @makeSmoothLivePlotGeneral myPlot(xArray, p0)
    for tt in tArray
        XYplotObject[] = [XYplotObject[][1]*1.01, XYplotObject[][2]*0.99]
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

    ZplotObject = @makeSmoothLivePlotGeneral myPlotZ(x, y, Z)

    ttt = 0.0:0.1:1.0
    for tt in ttt
        Z = map((x, y) -> f(x, y, tt), X, Y)
        ZplotObject[] = [x, y, Z]
    end
end
function testModifyXText()

    p0, xArray, tArray = getInitialDist()

    pMax = maximum(p0)
    p = copy(p0)
    titleText = "Title, step: "

    XtextPlotObject = @makeSmoothLivePlotGeneral myPlotTitle(xArray, p0, titleText)
    for tt in 1:length(tArray)
        XtextPlotObject[] = [XtextPlotObject[][1]*0.99, XtextPlotObject[][2], string(titleText, tt)]

        #replaceMutablePlotElement!(XtextPlotObject, 3, string(titleText, tt))
        #@replaceMutablePlotElement2 XtextPlotObject(3, string(titleText, tt))
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

testModifyY()
#testModifyX()
#testModifyXY()
#testModifyZ()
#testModifyXText()
