#' Download addresses of Navarre in spatial format
#'
#' @description
#' Get the spatial data of addresses by bounding box.
#'
#' @inheritParams catrnav_wfs_get_buildings_bbox
#'
#' @seealso [sf::st_bbox()]
#'
#' @return A [`sf`][sf::st_sf] object.
#' @source
#' [SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)
#'
#' @details
#'
#' ```{r child = "man/chunks/spatdet.Rmd"}
#' ```
#'
#' @export
#'
#' @examples
#' \donttest{
#' downtown <- c(-1.646812, 42.814528, -1.638036, 42.820320)
#'
#' ad <- catrnav_wfs_get_address_bbox(downtown, srs = 4326)
#'
#' library(ggplot2)
#'
#' ggplot(ad) +
#'   geom_sf()
#' }
#'
#' @seealso [CatastRo::catr_wfs_get_address_bbox()]
catrnav_wfs_get_address_bbox <- function(x, srs, verbose = FALSE,
                                         count = NULL) {
  # Switch to stored queries
  stored_query <- "AD:Address"

  bbox_res <- wfs_bbox(x, srs)

  res <- wfs_api_query(
    entry = "AD/wfs?",
    verbose = verbose,
    # WFS service
    version = "2.0.0",
    service = "WFS",
    request = "getfeature",
    typenames = stored_query,
    count = count,
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
