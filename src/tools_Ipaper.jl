function seq_along(x)
    1:length(x[:])
end

function seq(from, to, by = 1)
    from:by:to
end

export seq_along, seq
