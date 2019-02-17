
import BS
using Test

s = 42
k = 40
r = 0.1
sigma = 0.2
t = 0.5

@test BS.price(BS.EuropeanCall(), s, k, t, r, sigma) ≈ 4.759422392871542
@test BS.price(BS.EuropeanPut(), s, k, t, r, sigma) ≈ 0.8085993729000975
@test BS.delta(BS.EuropeanCall(), s, k, t, r, sigma) ≈ 0.7791312909426691
@test BS.delta(BS.EuropeanPut(), s, k, t, r, sigma) ≈ -0.22086870905733091
@test BS.theta(BS.EuropeanCall(), s, k, t, r, sigma) ≈ -4.559092194592626
@test BS.theta(BS.EuropeanPut(), s, k, t, r, sigma) ≈ -0.7541744965897705
@test BS.gamma(BS.EuropeanCall(), s, k, t, r, sigma) ≈ 0.04996267040591185
@test BS.gamma(BS.EuropeanPut(), s, k, t, r, sigma) ≈ 0.04996267040591185
@test BS.vega(BS.EuropeanCall(), s, k, t, r, sigma) ≈ 8.813415059602853
@test BS.vega(BS.EuropeanPut(), s, k, t, r, sigma) ≈ 8.813415059602853
@test BS.rho(BS.EuropeanCall(), s, k, t, r, sigma) ≈ 13.982045913360281
@test BS.rho(BS.EuropeanPut(), s, k, t, r, sigma) ≈ -5.042542576653999
@test BS.impvol(BS.EuropeanCall(), 4.12, s, k, t, r) ≈ 0.1135753892186858
@test BS.impvol(BS.EuropeanPut(), 4.12, s, k, t, r) ≈ 0.5246966268060681
