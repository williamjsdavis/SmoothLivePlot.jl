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
    p = copy(p0)

    dx = 1/(xArray.len-1);
    dt = 0.5*dx*dx/D;
    s = D*dt/(dx*dx);

    XplotObject = smoothLivePlotX(xArray, p0, myPlot)
    #YplotObject = @makeSmoothLivePlot myPlot(xArray, p0)
    for tt in tArray
        XplotObject[] = XplotObject[]*0.99
    end
end
function main3(tArray, xArray, D)

    p0 = getInitialDist(xArray)
    pMax = maximum(p0)
    p = copy(p0)

    dx = 1/(xArray.len-1);
    dt = 0.5*dx*dx/D;
    s = D*dt/(dx*dx);

    XYplotObject = smoothLivePlotXY(xArray, p0, myPlot)
    #YplotObject = @makeSmoothLivePlot myPlot(xArray, p0)
    for tt in tArray
        XYplotObject[] = [XYplotObject[][1]*1.01, XYplotObject[][2]*0.99]
    end
    return XYplotObject
end
function getInitialDist(xArray)
    x0 = 0.0
    sig = 2.0
    f(x) = exp(-((x - x0)/sig)^2)
    p = f.(xArray)
end
function stepTime(p, s, nx)
    p[2:end-1] = s.*p[3:nx]-(2*s-1).*p[2:nx-1]+s.*p[1:nx-2];
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

testObj = main3(tArray, xArray, D)
