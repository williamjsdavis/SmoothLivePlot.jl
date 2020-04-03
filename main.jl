## Plotting examples
using Plots
using SmoothLivePlot
include("./test/testPlotFunctions.jl")
gr(show = true)

testModifyY()
testModifyX()
testModifyXY()
testModifyZ()
testModifyXText()
testModifyXColour()
testAddXY()
