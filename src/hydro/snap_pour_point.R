library(purrr)
get_opt <- function(perc, value, dist, lon, lat, ...) {
    perc_min = min(perc)
    ind = which.min(dist)
    # if (perc_min > 0.9) {
    listk(lon, lat, flowaccu = value, flowaccu_perc = perc, dist) %>% map(~ .[ind])
}

#' snap_pour_point
#' @param lst_accu List of FlowAccu DataFrame returned by julia
#' @param shp shapefile table returned by julia
#' 
#' @return
#' flag
#' - `0`: bad
#' - `1`: margin
#' - `9`: good
#' @export
snap_pour_point <- function(lst_accu, shp) {
    df = map(lst_accu, ~.x) %>% melt_list("basin") %>% data.table()
    df[, perc := value / max(value), .(basin)]
    df[, dist := sqrt(I^2 + J^2)]
    df2 = df[perc > 0.1]
    df2$basin %<>% as.integer()

    basins <- names(lst_accu) %<>% as.numeric()
    # if perc_min > 0.7, then get min(dist)
    basins_adj = df2[, .(perc_min = min(perc)), .(basin)][perc_min >= 0.9]$basin # 1
    basins_margin = df[, max(value), .(basin)][V1 < 1e4]$basin
    basins_margin = intersect(basins_adj, basins_margin) # 2
    basins_good = setdiff(basins_adj, basins_margin)
    basins_bad = setdiff(basins, basins_adj)

    cat(sprintf("[ok] good: %d, margin: %d \n", length(basins_good), length(basins_margin)))

    st_final = df2[basin %in% basins_adj, get_opt(perc, value, dist, lon, lat), .(basin)]
    st_final$flag = 9
    st_final[basin %in% basins_margin, flag := 1]
    ind = match(basins, st_final$basin)
    st_final = st_final[ind, ]
    st_final$basin = names(lst_accu) %>% as.numeric()

    st_final$lon[basins_bad] <- shp$lon[basins_bad]
    st_final$lat[basins_bad] <- shp$lat[basins_bad]
    shp = data.table(shp[, 1:12]) %>% cbind(st_final[, -1])
    shp
}
# 刚好落在累积流上的站点微乎其微, 长江流域只有3个站点
# {
#     # load("N:/github/geo-julia/GeoArrays.jl/flowaccu.rda")
# }
