#' WFS INSPIRE: retrieve addresses
#'
#' @description
#' Retrieves spatial address data from the Cadastre of Navarre WFS INSPIRE
#' service. `catrnav_wfs_get_address_bbox()` retrieves features within the
#' supplied bounding box. See **Bounding box**.
#'
#' @param srs CRS to use for the query. Defaults to `4326`. See **Bounding
#'   box**.
#' @param count Positive whole number specifying the maximum number of features
#'   to return. If `NULL`, the service default applies.
#'
#' @inheritParams CatastRo::catr_wfs_get_address_bbox x verbose
#' @return An [`sf`][sf::st_sf] object, or `NULL` if the data cannot be
#'   retrieved.
#'
#' @section API limits:
#' The service returns a maximum of 5,000 features by default. Use `count` to
#' request a smaller result.
#'
#' @section Bounding box:
#' ```{r child = "man/chunks/spatdet.Rmd"}
#' ```
#'
#' @source
#' [SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)
#'
#' @family wfs
#' @family addresses
#' @rdname catrnav_wfs_get_address
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' downtown <- c(-1.646812, 42.814528, -1.638036, 42.820320)
#'
#' ad <- catrnav_wfs_get_address_bbox(downtown, srs = 4326)
#'
#' library(ggplot2)
#'
#' ggplot(ad) +
#'   geom_sf()
catrnav_wfs_get_address_bbox <- function(
  x,
  srs = 4326,
  verbose = FALSE,
  count = NULL
) {
  wfs_read_bbox_query(
    x = x,
    srs = srs,
    path = "services/AD/wfs",
    typenames = "AD:Address",
    verbose = verbose,
    count = count
  )
}
