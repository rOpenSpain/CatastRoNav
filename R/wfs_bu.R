#' Download buildings of Navarre in spatial format
#'
#' @description
#' Get the spatial data of buildings by bounding box.
#'
#' @param x See **Details**. It could be:
#'   - A numeric vector of length 4 with the coordinates that defines
#'     the bounding box: `c(xmin, ymin, xmax, ymax)`.
#'   - A `sf/sfc` object, as provided by the \CRANpkg{sf} package.
#' @param srs SRS/CRS to use on the query. See **Details**.
#' @param verbose Logical, displays information. Useful for debugging, default
#'   is `FALSE`.
#' @param count integer, indicating the maximum number of features to return.
#'   The default value `NULL` does not pass this parameter to the query,
#'   and the maximum number of features would be determined by the default value
#'   of the API service (5,000 in this case).
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
#' bu <- catrnav_wfs_get_buildings_bbox(downtown, srs = 4326)
#'
#' library(ggplot2)
#'
#' ggplot(bu) +
#'   geom_sf()
#' }
#'
#' @seealso [CatastRo::catr_wfs_get_buildings_bbox()]
catrnav_wfs_get_buildings_bbox <- function(
  x,
  srs,
  verbose = FALSE,
  count = NULL
) {
  # Switch to stored queries
  stored_query <- "BU:Building"

  bbox_res <- wfs_bbox(x, srs)

  res <- wfs_api_query(
    entry = "BU/wfs?",
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
