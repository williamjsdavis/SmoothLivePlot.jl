module SmoothLivePlot

using Observables, WebIO

include("plotFunctions.jl")
export modifyPlotObject!

include("plotMacros.jl")
export @makeLivePlot

end
