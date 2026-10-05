#' ATOM INSPIRE: download all cadastral parcels for a municipality
#'
#' @description
#' Downloads spatial data for all cadastral parcels in a municipality using the
#' ATOM INSPIRE service provided by the Cadastre of Navarre.
#'
#' @inherit catrnav_atom_get_address details
#'
#' @inheritParams catrnav_atom_get_address munic
#' @inheritParams catrnav_atom_get_address_db_all
#'
#' @inherit catrnav_atom_get_address return
#'
#' @inherit catrnav_atom_get_address_db_all source
#'
#' @seealso
#' [catrnav_atom_get_parcels_db_all()] lists available municipal downloads.
#' [catrnav_wfs_get_parcels_bbox()] retrieves cadastral parcels within a
#' bounding box instead of downloading a complete municipal dataset.
#'
#' ```{r child = "man/chunks/atom-cache-links.Rmd"}
#' ```
#'
#' @family atom_services
#' @family parcels
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf run_example() && requireNamespace("ggplot2", quietly = TRUE)
#'
#' s <- catrnav_atom_get_parcels("Iru<U+00F1>a")
#'
#' library(ggplot2)
#'
#' ggplot(s) +
#'   geom_sf() +
#'   labs(
#'     title = "Cadastral Zoning",
#'     subtitle = "Pamplona / Iru<U+00F1>a"
#'   )
catrnav_atom_get_parcels <- function(
  munic,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRoNav::catrnav_atom_get_parcels(cache)")

  munic <- validate_scalar_arg(munic)

  catrnav_atom_read_munic(
    munic = munic,
    db_getter = catrnav_atom_get_parcels_db_all,
    db_name = "catrnav_atom_get_parcels_db_all",
    subdir = "atom_cp",
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
