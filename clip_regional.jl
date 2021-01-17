using GeoArrays

file = "f:/SciData/ET_products/PMLV2_v016/PMLV2_yearly_G010_v016_2001-01-01.tif"
r = GeoArrays.read(file)

# bbox(xmin, ymin, xmax, ymax) = box(xmin, ymin, xmax, ymax)
range = [70, 140, 15, 55]
rbbox = bbox(range[1], range[3], range[2], range[4])

ga2 = clip_bbox(r, rbbox)
writeRaster(ga2, "b.tif")
