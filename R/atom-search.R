#' ATOM INSPIRE: search for municipalities
#'
#' @description
#' Search for a municipality by name or cadastral code in the Cadastre of
#' Navarre ATOM index.
#'
#' @inheritParams catrnav_atom_get_address
#'
#' @return A [tibble][dplyr::tbl_df] with the municipality name and cadastral
#'   code. Returns `NULL` if no match is found.
#'
#' @family atom
#' @family search
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' catrnav_atom_search_munic("Pamplona")
catrnav_atom_search_munic <- function(
  munic,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  validate_non_empty_arg(munic)
  validate_cache_args(cache, update_cache, cache_dir, verbose)

  all <- catrnav_atom_get_address_db_all(
    cache = cache,
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
