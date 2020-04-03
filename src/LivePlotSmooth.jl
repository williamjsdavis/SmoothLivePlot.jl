# Smooth live plot
module LivePlotSmooth

using Observables, WebIO

include("plotFunctions.jl")
export modifyPlotObject!

include("plotMacros.jl")
export @makeLivePlot

end
