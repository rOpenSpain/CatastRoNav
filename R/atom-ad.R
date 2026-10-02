#' ATOM INSPIRE: download all addresses for a municipality
#'
#' @description
#' Downloads spatial data for all addresses in a municipality using the ATOM
#' INSPIRE service provided by the Cadastre of Navarre.
#'
#' @inheritParams catrnav_atom_get_address_db_all cache update_cache
#' @inheritParams catrnav_atom_get_address_db_all cache_dir verbose
#'
#' @param munic A municipality name, partial name or cadastral code. Use
#'   [catrnav_atom_search_munic()] to search for available municipalities.
#'
#' @returns An [`sf`][sf::st_sf] object, or `NULL` if the data cannot be
#'   retrieved. Returns `NA` invisibly if no municipality matches `munic`.
#'
#' @inherit catrnav_atom_get_address_db_all source
#'
#' @seealso
#' [catrnav_atom_get_address_db_all()] lists available municipal downloads.
#' [catrnav_wfs_get_address_bbox()] retrieves addresses within a bounding box
#' instead of downloading a complete municipal dataset.
#'
#' @family atom
#' @family addresses
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf run_example() && requireNamespace("ggplot2", quietly = TRUE)
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
