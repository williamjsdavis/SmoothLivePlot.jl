## Test plot functions
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
        modifyPlotObject!(YplotObject, arg2 = p)
    end
end
function testModifyX()
    p0, xArray, tArray = getInitialDist()
    pMax = maximum(p0)

    XplotObject = @makeLivePlot myPlot(xArray, p0)
    for tt in tArray
        modifyPlotObject!(XplotObject, arg1 = XplotObject[][1]*0.99)
    end
end
function testModifyXY()
    p0, xArray, tArray = getInitialDist()

    pMax = maximum(p0)

    XYplotObject = @makeLivePlot myPlot(xArray, p0)
    for tt in tArray
        modifyPlotObject!(XYplotObject, arg2 = XYplotObject[][2]*0.99, arg1 = XYplotObject[][1]*1.01)
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
        modifyPlotObject!(ZplotObject, arg3 = Z)
    end
end
function testModifyXText()
    p0, xArray, tArray = getInitialDist()

    pMax = maximum(p0)
    p = copy(p0)
    titleText = "Title, step: "

    XtextPlotObject = @makeLivePlot myPlotTitle(xArray, p0, titleText)
    for tt in 1:50
        modifyPlotObject!(XtextPlotObject, arg3 = string(titleText, tt), arg1 = XtextPlotObject[][1]*0.99)
    end
end
function testModifyXColour()
    p0, xArray, tArray = getInitialDist()

    pMax = maximum(p0)
    p = copy(p0)
    scatterColour = range(0, 1, length=50)

    XColourPlotObject = @makeLivePlot myPlotColour(xArray, p0, scatterColour[1])

    for tt in 1:50
        modifyPlotObject!(XColourPlotObject, arg3 = scatterColour[tt], arg1 = XColourPlotObject[][1]*0.99)
    end
end
function testAddXY()
    p0, xArray, tArray = getInitialDist()

    pMax = maximum(p0)
    p = copy(p0)

    addXYPlotObject = @makeLivePlot myPlot(xArray, p0)

    for tt in 1:length(xArray)
        modifyPlotObject!(addXYPlotObject, arg1 = xArray[1:tt], arg2 = p0[1:tt])
    end
end
function testAddXYZ()
    attractor = Lorenz()
    plt = plot3d(
        1,
        xlim = (-30, 30),
        ylim = (-30, 30),
        zlim = (0, 60),
        title = "Lorenz Attractor",
        label = "",
        marker = 2,
    )

    addXYZPlotObject = @makeLivePlot myPlotXYZ(plt)

    for tt in 1:500
        step!(attractor)
        push!(plt, attractor.x, attractor.y, attractor.z)
        modifyPlotObject!(addXYZPlotObject, arg1 = plt)
    end
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
Base.@kwdef mutable struct Lorenz
    dt::Float32 = 0.02
    σ::Float32 = 10
    ρ::Float32 = 28
    β::Float32 = 8/3
    x::Float32 = 1
    y::Float32 = 1
    z::Float32 = 1
end
function step!(l::Lorenz)
    dx = l.σ * (l.y - l.x);         l.x += l.dt * dx
    dy = l.x * (l.ρ - l.z) - l.y;   l.y += l.dt * dy
    dz = l.x * l.y - l.β * l.z;     l.z += l.dt * dz
end
function myPlot(xx, yy)
    sleep(0.0001)
    plot(
        xx, yy,
        label = "",
        color = :red,
        xlim = (-5, 5),
        ylim = (0, 1),
        title = "Title",
        xlabel = "X label",
        ylabel = "Y label"
    )
    scatter!(xx, yy, label = "")
end
function myPlotTitle(xx, yy, titleText)
    sleep(0.0001)
    plot(
        xx, yy,
        label = "",
        color = :red,
        xlim = (-5, 5),
        ylim = (0, 1),
        title = titleText,
        xlabel = "X label",
        ylabel = "Y label"
    )
    scatter!(xx, yy, label = "")
end
function myPlotColour(xx, yy, cc)
    sleep(0.0001)
    plot(
        xx, yy,
        label = "",
        color = :red,
        xlim = (-5, 5),
        ylim = (0, 1),
        title = "Title text",
        xlabel = "X label",
        ylabel = "Y label"
        )
    scatter!(xx, yy, markersize = 20, color = RGBA(cc, 0.5, 0, 0), label = "")
end
function myPlotZ(xx, yy, ZZ)
    sleep(0.0001)
    p1 = contour(
        xx, yy, ZZ,
        fill = true, clims=(0,300),
        title = "Title text",
        xlabel = "X label",
        ylabel = "Y label"
    );
end
function myPlotXYZ(pltObj)
    sleep(0.0001)
    xx = getindex(pltObj.series_list[1].plotattributes, :x)
    yy = getindex(pltObj.series_list[1].plotattributes, :y)
    zz = getindex(pltObj.series_list[1].plotattributes, :z)
    plot3d(
        xx, yy, zz,
        xlim = (-30, 30),
        ylim = (-30, 30),
        zlim = (0, 60),
        title = "Lorenz Attractor",
        label = "",
        marker = 2,
    )
end
