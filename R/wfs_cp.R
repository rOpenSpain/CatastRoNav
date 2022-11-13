#' Download Cadastral Parcels of Navarre
#'
#' @description
#' Get the spatial data of cadastral parcels by bounding box.
#'
#' @inheritParams catrnav_wfs_get_buildings_bbox
#'
#' @seealso [sf::st_bbox()]
#'
#' @return A `sf` object.
#' @source [SITNA – Catastro de Navarra](https://sitna.navarra.es/geoportal/)
#'
#' @details
#'
#' When `x` is a numeric vector, make sure that the `srs` matches the
#' coordinate values. Additionally, when the `srs` correspond to a geographic
#' reference system (4326, 4258), the function queries the bounding box on
#' [EPSG:25830](https://epsg.io/25830) - ETRS89 / UTM zone 30N. The result is
#' provided always in the SRS provided in `srs`.
#'
#' When `x` is a `sf` object, the value `srs` is ignored. The query is
#' performed using [EPSG:25830](https://epsg.io/25830) (ETRS89 / UTM zone 30N)
#' and the spatial object is projected back to the SRS of the initial object.
#'
#' @export
#'
#' @examples
#' \donttest{
#' downtown <- c(-1.646812, 42.814528, -1.638036, 42.820320)
#'
#' cp <- catrnav_wfs_get_parcels_bbox(downtown, srs = 4326)
#'
#' library(ggplot2)
#'
#' ggplot(cp) +
#'   geom_sf()
#' }
#'
#' @seealso [CatastRo::catr_wfs_get_parcels_bbox()]
catrnav_wfs_get_parcels_bbox <- function(x, srs, verbose = FALSE) {
  # Switch to stored queries
  stored_query <- "CP:CadastralParcel"

  bbox_res <- wfs_bbox(x, srs)

  res <- wfs_api_query(
    entry = "CP/wfs?",
    verbose = verbose,
    # WFS service
    version = "2.0.0",
    service = "WFS",
    request = "getfeature",
    typenames = stored_query,
    # Stored query
    bbox = bbox_res$bbox,
    SRSNAME = bbox_res$incrs
  )

  out <- wfs_results(res, verbose)

  if (!is.null(out)) {
    # Transform back to the desired srs
    out <- sf::st_transform(out, bbox_res$outcrs)
  }
  return(out)
}
