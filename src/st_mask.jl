# using

function st_mask!(ga::AbstractGeoArray, mask::AbstractGeoArray)
  # arr = zeros(T, size(mask)..., ntime)
  ind = findall(.!(mask.A)) # 只保留为true的部分
  ntime = size(ga, 3)

  for i = 1:ntime
    x = @views ga.A[:, :, i]
    x[ind] .= NaN
  end
end


export st_mask!
