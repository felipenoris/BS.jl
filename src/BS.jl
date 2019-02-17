
module BS

using Distributions
import Roots

#
# types
#

struct D₁Parts{T}
    numerator::T
    denominator::T
end

abstract type BSOption end

"European call option."
struct EuropeanCall <: BSOption end

"European put option."
struct EuropeanPut <: BSOption end

#
# asset pays no dividends
#

@inline N(x) = cdf(Normal(), x)

@inline D₁Parts(s, k, t, r, σ) = D₁Parts(log(s/k) + (r + σ^2/2 )*t, σ*sqrt(t))

@inline d₁(parts::D₁Parts) = parts.numerator / parts.denominator
@inline d₂(parts::D₁Parts) = d₁(parts) - parts.denominator

@inline d₁(s, k, t, r, σ) = d₁(D₁Parts(s, k, t, r, σ))
@inline d₂(s, k, t, r, σ) = d₂(D₁Parts(s, k, t, r, σ))

@inline function call(s, k, t, r, σ)
    parts = D₁Parts(s, k, t, r, σ)
    return s*N(d₁(parts)) - k*exp(-r*t)*N(d₂(parts))
end

@inline function put(s, k, t, r, σ)
    parts = D₁Parts(s, k, t, r, σ)
    return k*exp(-r*t)*N(-d₂(parts)) - s*N(-d₁(parts))
end

@inline price(::EuropeanCall, s, k, t, r, σ) = call(s, k, t, r, σ)
@inline price(::EuropeanPut, s, k, t, r, σ) = put(s, k, t, r, σ)

function impvol(opt::BSOption, observed_price, s, k, t, r, interval::Tuple=infer_impvol_interval(opt, observed_price, s, k, t, r))
    f(σ) = observed_price - price(opt, s, k, t, r, σ)
    return Roots.find_zero(f, interval, Roots.Bisection())
end

function infer_impvol_interval(opt::BSOption, observed_price, s, k, t, r)
    # most instruments have volatility values below 100%
    min_vol = 0.0
    max_vol = 1.0
    if observed_price <= price(opt, s, k, t, r, max_vol)
        return (min_vol, max_vol)
    end

    # will increment max_vol 10x until we reach a final interval
    while true
        min_vol = max_vol
        max_vol = min_vol * 10
        if observed_price <= price(opt, s, k, t, r, max_vol)
            return (min_vol, max_vol)
        end
    end
end

#
# asset pays dividends at rate q
#

@inline D₁Parts(s, k, t, r, q, σ) = D₁Parts(s*exp(-q*t), k, t, r, σ)

@inline d₁(s, k, t, r, q, σ) = d₁(D₁Parts(s, k, t, r, q, σ))
@inline d₂(s, k, t, r, q, σ) = d₂(D₁Parts(s, k, t, r, q, σ))

@inline call(s, k, t, r, q, σ) = call(s*exp(-q*t), k, t, r, σ)
@inline put(s, k, t, r, q, σ) = put(s*exp(-q*t), k, t, r, σ)

@inline price(::EuropeanCall, s, k, t, r, q, σ) = call(s, k, t, r, q, σ)
@inline price(::EuropeanPut, s, k, t, r, q, σ) = put(s, k, t, r, q, σ)

function impvol(opt::BSOption, observed_price, s, k, t, r, q, interval::Tuple=infer_impvol_interval(opt, observed_price, s, k, t, r, q))
    return impvol(opt, observed_price, s*exp(-q*t), k, t, r, interval)
end

function infer_impvol_interval(opt::BSOption, observed_price, s, k, t, r, q)
    return infer_impvol_interval(opt, observed_price, s*exp(-q*t), k, t, r)
end

#
# Greeks
#

@inline delta(::EuropeanCall, s, k, t, r, σ) = N(d₁(s, k, t, r, σ))
@inline delta(::EuropeanPut, s, k, t, r, σ) = N(d₁(s, k, t, r, σ)) - 1

@inline function theta(::EuropeanCall, s, k, t, r, σ)
    parts = D₁Parts(s, k, t, r, σ)
    return -(s * pdf(Normal(), d₁(parts)) * σ) / ( 2*sqrt(t) ) - r*k*exp(-r*t)*N(d₂(parts))
end

@inline function theta(::EuropeanPut, s, k, t, r, σ)
    parts = D₁Parts(s, k, t, r, σ)
    return -(s * pdf(Normal(), d₁(parts)) * σ) / ( 2*sqrt(t) ) + r*k*exp(-r*t)*N(-d₂(parts))
end

@inline function gamma(::BSOption, s, k, t, r, σ)
    parts = D₁Parts(s, k, t, r, σ)
    return pdf(Normal(), d₁(parts)) / (s * parts.denominator)
end

@inline vega(::BSOption, s, k, t, r, σ) = s*sqrt(t)*pdf(Normal(), d₁(s, k, t, r, σ))

@inline rho(::EuropeanCall, s, k, t, r, σ) = k*t*exp(-r*t)*N(d₂(s, k, t, r, σ))
@inline rho(::EuropeanPut, s, k, t, r, σ) = -k*t*exp(-r*t)*N(-d₂(s, k, t, r, σ))

end # module
