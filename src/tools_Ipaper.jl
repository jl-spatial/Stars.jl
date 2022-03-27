function seq_along(x)
    1:length(x[:])
end

function seq(from, to, by = 1)
    from:by:to
end

function Range(x::AbstractArray{<:Real}) 
    minimum(x), maximum(x)
end


function meshgrid(x::AbstractArray{T,1}, y::AbstractArray{T,1}) where T <: Real 
    X = x .* ones(1, length(y))
    Y = ones(length(x)) .* y'
    X, Y
end


cbind  = hcat
rbind  = vcat
# cbind! = hcat!
# rbind! = vcat!
# hcat! not defined


export cbind, rbind, 
    seq_along, seq, Range, aggregate
