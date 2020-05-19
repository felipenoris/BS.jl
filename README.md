# BS.jl

[![License][license-img]](LICENSE)
[![travis][travis-img]][travis-url]
[![codecov][codecov-img]][codecov-url]

[license-img]: http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat
[travis-img]: https://img.shields.io/travis/felipenoris/BS.jl/master.svg?label=Linux+/+macOS
[travis-url]: https://travis-ci.org/felipenoris/BS.jl
[codecov-img]: https://img.shields.io/codecov/c/github/felipenoris/BS.jl/master.svg?label=codecov
[codecov-url]: http://codecov.io/github/felipenoris/BS.jl?branch=master

Black-Scholes Option Pricing Formulae.

## Model Parameters

* `s` : current underlying asset price.

* `k` : strike price.

* `t` : time to expiry.

* `r` : continuously compounded risk-free rate.

* `σ` : underlying price volatility, as defined in the underlying price dynamics.

## Underlying Asset Price Dynamics

The Black-Scholes model assumes that `s` follows a Geometric Brownian Motion in the real world.

`ds = μ * s * dt + σ * S * dz`

The pricing uses the risk-neutral measure. In this case, `μ` equals the risk-free rate `r`.

## Examples

```julia
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
```

# Development status

This repo is a sketch only and not intended for new developments. No PRs will be accepted.
Feel free to copy the source code for your project.
