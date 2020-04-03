# SmoothLivePlot.jl

`SmoothLivePlot.jl` is a Julia package for creating live-style plots during calculations. 

# Motivation

Updating the plot plane in Juno sometimes gives a blinking effect. 

# Using the package
1. Import the module using `using SmoothLivePlot`. 
2. Create a live plot with macro `outPlotObject = @makeLivePlot myPlotFunction(argument1, argument2, ...)`.
   - Function `myPlotFunction(argument1, argument2, ...)` is a user defined plotting function.
   - Output `outPlotObject` is a mutable output array of plot features. Its elements are the input aruments of `myPlotFunction()`.
3. Modify plot elements with function `modifyPlotObject!(YplotObject, arg2 = newArg2, arg1 = newArg1, ...)`. 
   - The first argment of `modifyPlotObject!()` must be the mutable output array.
   - The following argments are optional named of `modifyPlotObject!()` must be the mutable output array.

### Short example

Here's a video showing an output live-plot from some magnetohydrodynamic calculations:

![exampleSmoothPlot](https://user-images.githubusercontent.com/38541020/78403408-27771c00-75b1-11ea-9bef-063e8612720d.gif)

# TODOs
- [ ] Add capability to add additional elements to plots.
- [ ] Benchmark performance.

# Changelog
- Version 0.1.0 - Introduced original version.
