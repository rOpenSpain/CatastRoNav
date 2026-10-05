#' ATOM INSPIRE: search for municipalities
#'
#' @description
#' Searches for a municipality by name or cadastral code in the Cadastre of
#' Navarre ATOM index.
#'
#' @inheritParams catrnav_atom_get_address_db_all
#' @inheritParams catrnav_atom_get_address munic
#'
#' @returns A [tibble][tibble::tbl_df] with the municipality name and cadastral
#'   code. Returns [`NULL`][base::NULL] if no match is found or the data cannot
#'   be retrieved.
#'
#' @seealso
#' [catrnav_atom_get_address_db_all()] provides the index used by this search.
#' [catrnav_atom_get_buildings_db_all()] and [catrnav_atom_get_parcels_db_all()]
#' list downloads for the other data types. Use the selected name or cadastral
#' code with [catrnav_atom_get_address()], [catrnav_atom_get_buildings()] or
#' [catrnav_atom_get_parcels()] to download a complete municipal dataset.
#'
#' @family atom_services
#' @family search_tools
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf run_example()
#' catrnav_atom_search_munic("Pamplona")
#'
#' # Search using a numeric cadastral code.
#' catrnav_atom_search_munic(201)
catrnav_atom_search_munic <- function(
  munic,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(cache, "CatastRoNav::catrnav_atom_search_munic(cache)")

  munic <- validate_scalar_arg(munic)
  validate_cache_args(update_cache, cache_dir, verbose)

  all <- catrnav_atom_get_address_db_all(
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )
  if (is.null(all)) {
    return(NULL)
  }

  matches <- catrnav_atom_match_munic(all, munic)
  if (is.null(matches)) {
    return(NULL)
  }

  result <- matches[, "munic", drop = FALSE]
  result$catrcode <- sub("\\s.*$", "", result$munic)
  dplyr::as_tibble(result)
}
