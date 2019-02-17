
import BS
using Test


@testset "BS Price" begin
    @testset "no dividends" begin

        let
            s = 42
            k = 40
            r = 0.1
            sigma = 0.2
            t = 0.5

            @test BS.call(s, k, r, sigma, t) ≈ 4.759422392871542
            @test BS.put(s, k, r, sigma, t) ≈ 0.8085993729000975
            @test BS.price(BS.EuropeanCall(), s, k, r, sigma, t) ≈ 4.759422392871542
            @test BS.price(BS.EuropeanPut(), s, k, r, sigma, t) ≈ 0.8085993729000975
        end

        let
            s = 40.0
            k = 40.0
            r = 0.1
            t = 0.5
            sigma = 0.3

            @test BS.call(s, k, r, sigma, t) ≈ 4.3625999408029585
            @test BS.put(s, k, r, sigma, t) ≈ 2.4117769208315245
            @test BS.price(BS.EuropeanCall(), s, k, r, sigma, t) ≈ 4.3625999408029585
            @test BS.price(BS.EuropeanPut(), s, k, r, sigma, t) ≈ 2.4117769208315245
        end
    end

    @testset "dividends q" begin

        let
            s = 930
            k = 900
            r = 0.08
            sigma = 0.2
            t = 2/12
            q = 0.03

            @test BS.call(s, k, r, sigma, t, q) ≈ 51.83295679649086
            @test BS.put(s, k, r, sigma, t, q) ≈ 14.550996773772397
            @test BS.price(BS.EuropeanCall(), s, k, r, sigma, t, q) ≈ 51.83295679649086
            @test BS.price(BS.EuropeanPut(), s, k, r, sigma, t, q) ≈ 14.550996773772397
        end

        let
            s = 1.8
            k = 1.8
            r = 0.1
            rf = 0.03
            t = 0.5
            sigma = 0.2

            @test BS.call(s, k, r, sigma, t, rf) ≈ 0.13172208280604858
            @test BS.put(s, k, r, sigma, t, rf) ≈ 0.07073355562182104
            @test BS.price(BS.EuropeanCall(), s, k, r, sigma, t, rf) ≈ 0.13172208280604858
            @test BS.price(BS.EuropeanPut(), s, k, r, sigma, t, rf) ≈ 0.07073355562182104
        end
    end
end

@testset "Greeks" begin

    s = 49
    k = 50
    r = 0.05
    t = 0.3846
    sigma = 0.2

    @testset "Delta" begin
        @test BS.delta(BS.EuropeanCall(), s, k, r, sigma, t) ≈ 0.5216016339715761
        @test BS.delta(BS.EuropeanPut(), s, k, r, sigma, t) ≈ -0.4783983660284239
    end

    @testset "Theta" begin
        @test BS.theta(BS.EuropeanCall(), s, k, r, sigma, t) ≈ -4.305389964546104
        @test BS.theta(BS.EuropeanPut(), s, k, r, sigma, t) ≈ -1.853005672196868
    end

    @testset "Gamma" begin
        @test BS.gamma(BS.EuropeanCall(), s, k, r, sigma, t) ≈ 0.06554537725247868
        @test BS.gamma(BS.EuropeanPut(), s, k, r, sigma, t) ≈ 0.06554537725247868
    end

    @testset "Vega" begin
        @test BS.vega(BS.EuropeanCall(), s, k, r, sigma, t) ≈ 12.105242754243843
        @test BS.vega(BS.EuropeanPut(), s, k, r, sigma, t) ≈ 12.105242754243843
    end

    @testset "Rho" begin
        @test BS.rho(BS.EuropeanCall(), s, k, r, sigma, t) ≈ 8.906574098800945
        @test BS.rho(BS.EuropeanPut(), s, k, r, sigma, t) ≈ -9.95716587794938
    end
end
