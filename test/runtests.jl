
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
        @test BS.bsprice(BS.BSCall(), s, k, r, sigma, t) ≈ 4.759422392871542
        @test BS.bsprice(BS.BSPut(), s, k, r, sigma, t) ≈ 0.8085993729000975
    end

    let
        s = 40.0
        k = 40.0
        r = 0.1
        t = 0.5
        sigma = 0.3

        @test BS.bscall(s, k, r, sigma, t) ≈ 4.3625999408029585
        @test BS.bsput(s, k, r, sigma, t) ≈ 2.4117769208315245
        @test BS.bsprice(BS.BSCall(), s, k, r, sigma, t) ≈ 4.3625999408029585
        @test BS.bsprice(BS.BSPut(), s, k, r, sigma, t) ≈ 2.4117769208315245
    end
end

@testset "bs price dividends q" begin

    let
        s = 930
        k = 900
        r = 0.08
        sigma = 0.2
        t = 2/12
        q = 0.03

        @test BS.bscall(s, k, r, sigma, t, q) ≈ 51.83295679649086
        @test BS.bsput(s, k, r, sigma, t, q) ≈ 14.550996773772397
        @test BS.bsprice(BS.BSCall(), s, k, r, sigma, t, q) ≈ 51.83295679649086
        @test BS.bsprice(BS.BSPut(), s, k, r, sigma, t, q) ≈ 14.550996773772397
    end

    let
        s = 1.8
        k = 1.8
        r = 0.1
        rf = 0.03
        t = 0.5
        sigma = 0.2

        @test BS.bscall(s, k, r, sigma, t, rf) ≈ 0.13172208280604858
        @test BS.bsput(s, k, r, sigma, t, rf) ≈ 0.07073355562182104
        @test BS.bsprice(BS.BSCall(), s, k, r, sigma, t, rf) ≈ 0.13172208280604858
        @test BS.bsprice(BS.BSPut(), s, k, r, sigma, t, rf) ≈ 0.07073355562182104
    end
end
