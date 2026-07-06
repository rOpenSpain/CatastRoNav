#' WFS INSPIRE: download buildings
#'
#' @description
#' Retrieve spatial building data from the Cadastre of Navarre WFS INSPIRE
#' service. `catrnav_wfs_get_buildings_bbox()` retrieves objects included in
#' the provided bounding box. See **Bounding box**.
#'
#' @inheritParams catrnav_wfs_get_address_bbox
#' @inherit catrnav_wfs_get_address_bbox return references
#' @inheritSection catrnav_wfs_get_address_bbox API limits
#' @inheritSection catrnav_wfs_get_address_bbox Bounding box
#' @family wfs
#' @family buildings
#' @rdname catrnav_wfs_get_buildings
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' downtown <- c(-1.646812, 42.814528, -1.638036, 42.820320)
#'
#' bu <- catrnav_wfs_get_buildings_bbox(downtown, srs = 4326)
#'
#' library(ggplot2)
#'
#' ggplot(bu) +
#'   geom_sf()
catrnav_wfs_get_buildings_bbox <- function(
  x,
  srs = 4326,
  verbose = FALSE,
  count = NULL
) {
  wfs_read_bbox_query(
    x = x,
    srs = srs,
    path = "services/BU/wfs",
    typenames = "BU:Building",
    verbose = verbose,
    count = count
  )
}
