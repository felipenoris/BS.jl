
module BS

using Distributions

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

@inline D₁Parts(s, k, r, σ, t) = D₁Parts(log(s/k) + (r + σ^2/2 )*t, σ*sqrt(t))

@inline d₁(parts::D₁Parts) = parts.numerator / parts.denominator
@inline d₂(parts::D₁Parts) = d₁(parts) - parts.denominator

@inline d₁(s, k, r, σ, t) = d₁(D₁Parts(s, k, r, σ, t))
@inline d₂(s, k, r, σ, t) = d₂(D₁Parts(s, k, r, σ, t))

@inline function call(s, k, r, σ, t)
    parts = D₁Parts(s, k, r, σ, t)
    return s*N(d₁(parts)) - k*exp(-r*t)*N(d₂(parts))
end

@inline function put(s, k, r, σ, t)
    parts = D₁Parts(s, k, r, σ, t)
    return k*exp(-r*t)*N(-d₂(parts)) - s*N(-d₁(parts))
end

@inline price(::EuropeanCall, s, k, r, σ, t) = call(s, k, r, σ, t)
@inline price(::EuropeanPut, s, k, r, σ, t) = put(s, k, r, σ, t)

#
# asset pays dividends at rate q
#

@inline D₁Parts(s, k, r, σ, t, q) = D₁Parts(s*exp(-q*t), k, r, σ, t)

@inline d₁(s, k, r, σ, t, q) = d₁(D₁Parts(s, k, r, σ, t, q))
@inline d₂(s, k, r, σ, t, q) = d₂(D₁Parts(s, k, r, σ, t, q))

@inline call(s, k, r, σ, t, q) = call(s*exp(-q*t), k, r, σ, t)
@inline put(s, k, r, σ, t, q) = put(s*exp(-q*t), k, r, σ, t)

@inline price(::EuropeanCall, s, k, r, σ, t, q) = call(s, k, r, σ, t, q)
@inline price(::EuropeanPut, s, k, r, σ, t, q) = put(s, k, r, σ, t, q)

#
# Greeks
#

@inline delta(::EuropeanCall, s, k, r, σ, t) = N(d₁(s, k, r, σ, t))
@inline delta(::EuropeanPut, s, k, r, σ, t) = N(d₁(s, k, r, σ, t)) - 1

@inline function theta(::EuropeanCall, s, k, r, σ, t)
    parts = D₁Parts(s, k, r, σ, t)
    return -(s * pdf(Normal(), d₁(parts)) * σ) / ( 2*sqrt(t) ) - r*k*exp(-r*t)*N(d₂(parts))
end

@inline function theta(::EuropeanPut, s, k, r, σ, t)
    parts = D₁Parts(s, k, r, σ, t)
    return -(s * pdf(Normal(), d₁(parts)) * σ) / ( 2*sqrt(t) ) + r*k*exp(-r*t)*N(-d₂(parts))
end

@inline function gamma(::BSOption, s, k, r, σ, t)
    parts = D₁Parts(s, k, r, σ, t)
    return pdf(Normal(), d₁(parts)) / (s * parts.denominator)
end

@inline function vega(::BSOption, s, k, r, σ, t)
    return s*sqrt(t)*pdf(Normal(), d₁(s, k, r, σ, t))
end

@inline function rho(::EuropeanCall, s, k, r, σ, t)
    return k*t*exp(-r*t)*N(d₂(s, k, r, σ, t))
end

@inline function rho(::EuropeanPut, s, k, r, σ, t)
    return -k*t*exp(-r*t)*N(-d₂(s, k, r, σ, t))
end

end # module
