import Statistics: quantile

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

function r_summary(x::AbstractArray; digits=2)
    probs = [0, 0.25, 0.5, 0.75, 1]
    x2 = filter(!isnan, x)
    n_nan = length(x) - length(x2)
    # u = mean(x2);
    r = quantile(x2, probs)
    insert!(r, 4, mean(x2))
    r = round.(r, digits=digits)
    # @show r
    printstyled("Min\t 1st.Qu\t Median\t Mean\t 3rd.Qu\t Max\t NA's\n"; color=:blue)
    printstyled("$(r[1])\t $(r[2])\t $(r[3])\t $(r[4])\t $(r[5])\t $(r[6])\t $(n_nan)\n"; color=:blue)
    nothing
end

cbind  = hcat
rbind  = vcat
# cbind! = hcat!
# rbind! = vcat!
# hcat! not defined


export cbind, rbind, 
    r_summary, 
    seq_along, seq, Range, aggregate
