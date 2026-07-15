#' ATOM INSPIRE: download all buildings for a municipality
#'
#' @description
#' Downloads spatial data for all buildings in a municipality using the ATOM
#' INSPIRE service provided by the Cadastre of Navarre.
#'
#' @inheritParams catrnav_atom_get_address
#' @inherit catrnav_atom_get_address return
#'
#' @inherit catrnav_atom_get_address source
#'
#' @family atom
#' @family buildings
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example() && requireNamespace("ggplot2", quietly = TRUE)
#'
#' s <- catrnav_atom_get_buildings("Iruña")
#'
#' library(ggplot2)
#'
#' ggplot(s) +
#'   geom_sf() +
#'   labs(
#'     title = "Buildings",
#'     subtitle = "Pamplona / Iruña"
#'   )
catrnav_atom_get_buildings <- function(
  munic,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  catrnav_atom_read_munic(
    munic = munic,
    db_getter = catrnav_atom_get_buildings_db_all,
    db_name = "catrnav_atom_get_buildings_db_all",
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
