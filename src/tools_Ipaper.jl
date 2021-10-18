function seq_along(x)
    1:length(x[:])
end

function seq(from, to, by = 1)
    from:by:to
end

function aggregate(x::AbstractArray{T, 1}, by::AbstractArray{T2, 1}, FUN::Function = mean) where {
    T<:Real, T2<:Real }
    
    grps = unique(by)
    # vals = ones(length(grps));
    vals = []
    @views for grp in grps
        val = FUN(x[by .== grp])
        push!(vals, val)
    end
    Dict(grps .=> vals)
end

export seq_along, seq, aggregate
