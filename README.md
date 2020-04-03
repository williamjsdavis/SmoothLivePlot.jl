# SmoothLivePlot.jl

`SmoothLivePlot.jl` is a Julia package for creating live-style plots during calculations. 

# Motivation

Updating the plot plane in Juno sometimes gives a blinking effect. Links to posts:

- [Can you update a plot in Julia?](https://discourse.julialang.org/t/current-state-of-live-plots-in-atom-juno/30379)
- [Current State of Live Plots in Atom/Juno?](https://discourse.julialang.org/t/current-state-of-live-plots-in-atom-juno/30379/5)

This may be a specific Juno + Apple product issue (e.g. [Suppress Plot Window when output to animation](https://discourse.julialang.org/t/suppress-plot-window-when-output-to-animation/30724)).

To address this issue, I generalised a [solution found by user ckneale](https://discourse.julialang.org/t/current-state-of-live-plots-in-atom-juno/30379/7). It uses [Observables.jl](https://github.com/JuliaGizmos/Observables.jl) and [WebIO.jl](https://github.com/JuliaGizmos/WebIO.jl) so that the plot can listen to changes in its elements.

Currently, I have tested the following capabilities: 
- Modifying values in X and/or Y array(s) in scatter and plot
- Modifying colours in scatter and plot
- Modifying text elements (e.g. titles, xlabels, etc...)
- Modifying matricies in contour plots

# Using the package
1. Import the module using `using SmoothLivePlot`. 
2. Create a live plot with macro `outPlotObject = @makeLivePlot myPlotFunction(argument1, argument2, ...)`.
   - Function `myPlotFunction(argument1, argument2, ...)` is a user defined plotting function.
   - Output `outPlotObject` is a mutable output array of plot features. Its elements are the input aruments of `myPlotFunction()`.
3. Modify plot elements with function `modifyPlotObject!(outPlotObject, arg2 = newArg2, arg1 = newArg1, ...)`. 
   - The first argment of `modifyPlotObject!()` must be the mutable output array.
   - The following argments are optional and named. The name/value pair must be `arg<x> = newArg1`, where `<x>` in the name is an integer that indicates the position of the argument in the original plotting function `myPlotFunction()`. 
   - E.g. to modify `argument2` to `newArgument2`, use `modifyPlotObject!(outPlotObject, arg2 = newArgument2)`.

### Short example

Here's a video showing an output live-plot from some magnetohydrodynamic calculations:

![exampleSmoothPlot](https://user-images.githubusercontent.com/38541020/78403408-27771c00-75b1-11ea-9bef-063e8612720d.gif)

# TODOs
- [ ] Add capability to add additional elements to plots.
- [ ] Benchmark performance.

# Changelog
- Version 0.1.0 - Introduced original version.
