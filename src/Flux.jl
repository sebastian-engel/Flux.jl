module Flux

# Zero Flux Given

using Base: tail
using Statistics, Random, LinearAlgebra
using Zygote, MacroTools, Juno, Reexport
using MacroTools: @forward
@reexport using NNlib
using Zygote: Params, @adjoint, gradient, pullback, @nograd

export gradient

export Chain, Dense, Maxout, RNN, LSTM, GRU, SamePad, Conv, CrossCor, ConvTranspose,
       AdaptiveMaxPool, AdaptiveMeanPool, GlobalMaxPool, GlobalMeanPool, MaxPool,
       MeanPool, flatten, DepthwiseConv, Dropout, AlphaDropout, LayerNorm, BatchNorm,
       InstanceNorm, GroupNorm, SkipConnection, params, fmap, cpu, gpu, f32, f64,
       testmode!, trainmode!, Join, Split, Parallel, Nop

include("optimise/Optimise.jl")
using .Optimise
using .Optimise: @epochs
export Descent, ADAM, Momentum, Nesterov, RMSProp,
  ADAGrad, AdaMax, ADADelta, AMSGrad, NADAM,
  ADAMW, RADAM, InvDecay, ExpDecay, WeightDecay,
  ClipValue, ClipNorm


using CUDA
const use_cuda = Ref(false)

include("utils.jl")
include("zeros.jl")
include("onehot.jl")
include("functor.jl")

include("layers/stateless.jl")
include("layers/basic.jl")
include("layers/conv.jl")
include("layers/recurrent.jl")
include("layers/normalise.jl")
include("layers/structure.jl")

include("data/Data.jl")

include("losses/Losses.jl")
using .Losses # TODO: stop importing Losses in Flux's namespace in v0.12 

include("deprecations.jl")

include("cuda/cuda.jl")

function __init__()
  use_cuda[] = CUDA.functional() # Can be overridden after load with `Flux.use_cuda[] = false`
  if CUDA.functional()
    if !CUDA.has_cudnn()
      @warn "CUDA.jl found cuda, but did not find libcudnn. Some functionality will not be available."
    end
  end
end

end # module
