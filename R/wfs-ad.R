#' WFS INSPIRE: retrieve addresses
#'
#' @description
#' Retrieves spatial address data from the Cadastre of Navarre WFS INSPIRE
#' service. [catrnav_wfs_get_address_bbox()] retrieves features within the
#' supplied bounding box. See **Bounding box**.
#'
#' @details
#' Responses are cached in the `wfs_inspire_cache` subdirectory of the
#' [catrnav_set_cache_dir()] cache. Repeated queries reuse the cached file.
#' Clear the cache with [catrnav_clear_cache()] to download fresh results.
#'
#' @inheritParams CatastRo::catr_wfs_get_address_bbox x verbose
#' @param srs The CRS to use for the query. Defaults to `4326`. See **Bounding
#'   box**.
#' @param count A positive whole number specifying the maximum number of
#'   features to return. If `NULL`, the service default applies.
#'
#' @inherit CatastRo::catr_wfs_get_address_bbox return
#'
#' @section API limits:
#' The service returns a maximum of 5,000 features by default. Use `count` to
#' request a smaller result.
#' @section Bounding box:
#' ```{r child = "man/chunks/spatdet.Rmd"}
#' ```
#'
#' @inherit catrnav_atom_get_address_db_all source
#'
#' @seealso
#' [catrnav_atom_get_address()] downloads all addresses for a municipality.
#'
#' ```{r child = "man/chunks/wfs-map-links.Rmd"}
#' ```
#'
#' @family wfs_services
#' @family addresses
#'
#' @rdname catrnav_wfs_get_address
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf run_example() && requireNamespace("ggplot2", quietly = TRUE)
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
