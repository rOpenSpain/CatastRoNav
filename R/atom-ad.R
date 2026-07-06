#' ATOM INSPIRE: download all addresses for a municipality
#'
#' @description
#' Downloads spatial data for all addresses in a municipality using the ATOM
#' INSPIRE service provided by the Cadastre of Navarre.
#'
#' @param munic Municipality name, partial name or cadastral code. Use
#'   [catrnav_atom_search_munic()] to search for available municipalities.
#' @param cache A logical value indicating whether to use cached files. Defaults
#'   to `TRUE`.
#'
#' @inheritParams CatastRo::catr_atom_get_address update_cache cache_dir verbose
#' @return An [`sf`][sf::st_sf] object, or `NULL` if the data cannot be
#'   retrieved.
#'
#' @source
#' [SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)
#'
#' @family atom
#' @family addresses
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#'
#' s <- catrnav_atom_get_address("Tudela")
#'
#' library(ggplot2)
#'
#' ggplot(s) +
#'   geom_sf() +
#'   labs(
#'     title = "Addresses",
#'     subtitle = "Tudela"
#'   )
catrnav_atom_get_address <- function(
  munic,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  catrnav_atom_read_munic(
    munic = munic,
    db_getter = catrnav_atom_get_address_db_all,
    db_name = "catrnav_atom_get_address_db_all",
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
