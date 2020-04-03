# Plotting macros
macro makeLivePlot(plotExpression)
    # Turn plotting function into smooth version
    plotFunction = plotExpression.args[1]
    plotArgs = plotExpression.args[2:end]

    arrayArgs = map(x -> :($(esc(x))), plotArgs)
    splatArgs = :([$(arrayArgs...)])

    outExpression = :(smoothLivePlotGeneral($(esc(plotFunction)), $splatArgs))
    return outExpression
end
