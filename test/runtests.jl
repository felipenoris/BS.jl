
import BS
using Test

@testset "bs price" begin

    let
        s = 42
        k = 40
        r = 0.1
        sigma = 0.2
        t = 0.5

        @test BS.bscall(s, k, r, sigma, t) ≈ 4.759422392871542
        @test BS.bsput(s, k, r, sigma, t) ≈ 0.8085993729000975
    end

    let
        s = 40.0
        k = 40.0
        r = 0.1
        t = 0.5
        sigma = 0.3

        @test BS.bscall(s, k, r, sigma, t) ≈ 4.3625999408029585
        @test BS.bsput(s, k, r, sigma, t) ≈ 2.4117769208315245
    end
end
