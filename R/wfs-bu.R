#' WFS INSPIRE: retrieve buildings
#'
#' @description
#' Retrieves spatial building data from the Cadastre of Navarre WFS INSPIRE
#' service. `catrnav_wfs_get_buildings_bbox()` retrieves features within the
#' supplied bounding box. See **Bounding box**.
#'
#' @inheritParams catrnav_wfs_get_address_bbox x srs verbose count
#'
#' @inherit catrnav_wfs_get_address_bbox return
#'
#' @inheritSection catrnav_wfs_get_address_bbox API limits
#' @inheritSection catrnav_wfs_get_address_bbox Bounding box
#'
#' @inherit catrnav_atom_get_address_db_all source
#'
#' @seealso
#' [catrnav_atom_get_buildings()] downloads all buildings for a municipality.
#' [catrnav_wms_get_layer()] retrieves a georeferenced map image rather than
#' individual spatial features.
#'
#' @family wfs
#' @family buildings
#'
#' @rdname catrnav_wfs_get_buildings
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf run_example() && requireNamespace("ggplot2", quietly = TRUE)
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
