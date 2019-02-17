
module BS

using Distributions

struct D₁Parts{T}
    numerator::T
    denominator::T
end

abstract type BSOption end
struct BSCall <: BSOption end
struct BSPut <: BSOption end

@inline N(x) = cdf(Normal(), x)

#
# asset pays no dividends
#

@inline D₁Parts(s, k, r, σ, t) = D₁Parts(log(s/k) + (r + σ^2/2 )*t, σ*sqrt(t))

@inline d₁(parts::D₁Parts) = parts.numerator / parts.denominator
@inline d₂(parts::D₁Parts) = d₁(parts) - parts.denominator

@inline d₁(s, k, r, σ, t) = d₁(D₁Parts(s, k, r, σ, t))
@inline d₂(s, k, r, σ, t) = d₂(D₁Parts(s, k, r, σ, t))

@inline function bscall(s, k, r, σ, t)
    parts = D₁Parts(s, k, r, σ, t)
    return s*N(d₁(parts)) - k*exp(-r*t)*N(d₂(parts))
end

@inline function bsput(s, k, r, σ, t)
    parts = D₁Parts(s, k, r, σ, t)
    return k*exp(-r*t)*N(-d₂(parts)) - s*N(-d₁(parts))
end

@inline bsprice(::BSCall, s, k, r, σ, t) = bscall(s, k, r, σ, t)
@inline bsprice(::BSPut, s, k, r, σ, t) = bsput(s, k, r, σ, t)

#
# asset pays dividends at rate q
#

@inline D₁Parts(s, k, r, σ, t, q) = D₁Parts(s*exp(-q*t), k, r, σ, t)

@inline d₁(s, k, r, σ, t, q) = d₁(D₁Parts(s, k, r, σ, t, q))
@inline d₂(s, k, r, σ, t, q) = d₂(D₁Parts(s, k, r, σ, t, q))

@inline bscall(s, k, r, σ, t, q) = bscall(s*exp(-q*t), k, r, σ, t)
@inline bsput(s, k, r, σ, t, q) = bsput(s*exp(-q*t), k, r, σ, t)

@inline bsprice(::BSCall, s, k, r, σ, t, q) = bscall(s, k, r, σ, t, q)
@inline bsprice(::BSPut, s, k, r, σ, t, q) = bsput(s, k, r, σ, t, q)

end # module
