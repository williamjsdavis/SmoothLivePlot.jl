# Testing plot examples
using Plots
using SmoothLivePlot
using Test
gr(show = true)

# Test macro
macro no_error(ex)
    quote
        try
            $(esc(ex))
            true
        catch
            false
        end
    end
end

function main()
    @testset "All plots" begin
        @testset "Modify Y" begin
            @test @no_error testModifyY()
        end
        @testset "Modify X" begin
            @test @no_error testModifyX()
        end
        @testset "Modify X+Y" begin
            @test @no_error testModifyXY()
        end
        @testset "Modify Z" begin
            @test @no_error testModifyZ()
        end
        @testset "Modify X+Text" begin
            @test @no_error testModifyXText()
        end
        @testset "Modify X+Colour" begin
            @test @no_error testModifyXColour()
        end
        @testset "Add to X+Y" begin
            @test @no_error testAddXY()
        end
    end
end

main()
