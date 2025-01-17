export clplatea

function clplatea(;
  n::Int = default_nvar,
  type::Type{T} = Float64,
  wght = -0.1,
  kwargs...,
) where {T}
  p = max(floor(Int, sqrt(n)), 3)
  p * p != n && @warn("clplatea: number of variables adjusted from $n to $(p*p)")
  n = p * p
  hp2 = (1 // 2) * p^2
  function f(x; p = p, hp2 = hp2, wght = wght)
    return (eltype(x)(wght) * x[p + (p - 1) * p]) +
           sum(
             sum(
               1 // 2 * (x[i + (j - 1) * p] - x[i + (j - 2) * p])^2 +
               hp2 * (x[i + (j - 1) * p] - x[i + (j - 2) * p])^4 for j = 2:p
             ) for i = 2:p
           ) +
           sum(1 // 2 * (x[2 + (j - 1) * p])^2 + hp2 * (x[2 + (j - 1) * p])^4 for j = 2:p) +
           sum(
             sum(
               1 // 2 * (x[i + (j - 1) * p] - x[i - 1 + (j - 1) * p])^2 +
               hp2 * (x[i + (j - 1) * p] - x[i - 1 + (j - 1) * p])^4 for j = 2:p
             ) for i = 3:p
           )
  end
  x0 = zeros(T, n)
  return ADNLPModels.ADNLPModel(f, x0, name = "clplatea"; kwargs...)
end
