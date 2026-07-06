#' WFS INSPIRE: retrieve cadastral parcels
#'
#' @description
#' Retrieves spatial cadastral parcel data from the Cadastre of Navarre WFS
#' INSPIRE service. `catrnav_wfs_get_parcels_bbox()` retrieves features within
#' the supplied bounding box. See **Bounding box**.
#'
#' @inheritParams catrnav_wfs_get_address_bbox
#' @inherit catrnav_wfs_get_address_bbox return
#' @inheritSection catrnav_wfs_get_address_bbox API limits
#' @inheritSection catrnav_wfs_get_address_bbox Bounding box
#'
#' @inherit catrnav_wfs_get_address_bbox source
#'
#' @family wfs
#' @family parcels
#' @rdname catrnav_wfs_get_parcels
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' downtown <- c(-1.646812, 42.814528, -1.638036, 42.820320)
#'
#' cp <- catrnav_wfs_get_parcels_bbox(downtown, srs = 4326)
#'
#' library(ggplot2)
#'
#' ggplot(cp) +
#'   geom_sf()
catrnav_wfs_get_parcels_bbox <- function(
  x,
  srs = 4326,
  verbose = FALSE,
  count = NULL
) {
  wfs_read_bbox_query(
    x = x,
    srs = srs,
    path = "services/CP/wfs",
    typenames = "CP:CadastralParcel",
    verbose = verbose,
    count = count
  )
}
