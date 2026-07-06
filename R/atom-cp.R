#' ATOM INSPIRE: download all cadastral parcels for a municipality
#'
#' @description
#' Retrieve spatial data for all cadastral parcels in a municipality using the
#' ATOM INSPIRE service provided by the Cadastre of Navarre.
#'
#' @inheritParams catrnav_atom_get_address
#' @inherit catrnav_atom_get_address references return
#'
#' @family atom
#' @family parcels
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#'
#' s <- catrnav_atom_get_parcels("Iruña")
#'
#' library(ggplot2)
#'
#' ggplot(s) +
#'   geom_sf() +
#'   labs(
#'     title = "Cadastral Zoning",
#'     subtitle = "Pamplona / Iruña"
#'   )
catrnav_atom_get_parcels <- function(
  munic,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  catrnav_atom_read_munic(
    munic = munic,
    db_getter = catrnav_atom_get_parcels_db_all,
    db_name = "catrnav_atom_get_parcels_db_all",
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
