#' ATOM INSPIRE: download all addresses for a municipality
#'
#' @description
#' Downloads spatial data for all addresses in a municipality using the ATOM
#' INSPIRE service provided by the Cadastre of Navarre.
#'
#' @details
#' Empty, missing or non-scalar values of `munic` produce an error before
#' any download is attempted. Returns `NULL` if no municipality matches `munic`.
#' Municipal ZIP archives are read directly without extracting their contents
#' to disk.
#'
#' @inheritParams catrnav_atom_get_address_db_all
#' @param munic A single municipality name, partial name or cadastral code.
#'   Accepts a character string or numeric code. Use
#'   [catrnav_atom_search_munic()] to search for available municipalities.
#'
#' @inherit CatastRo::catr_atom_get_address return
#'
#' @inherit catrnav_atom_get_address_db_all source
#'
#' @seealso
#' [catrnav_atom_get_address_db_all()] lists available municipal downloads.
#' [catrnav_wfs_get_address_bbox()] retrieves addresses within a bounding box
#' instead of downloading a complete municipal dataset.
#'
#' ```{r child = "man/chunks/atom-cache-links.Rmd"}
#' ```
#'
#' @family atom_services
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
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRoNav::catrnav_atom_get_address(cache)")

  munic <- validate_scalar_arg(munic)

  catrnav_atom_read_munic(
    munic = munic,
    db_getter = catrnav_atom_get_address_db_all,
    db_name = "catrnav_atom_get_address_db_all",
    subdir = "atom_ad",
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
