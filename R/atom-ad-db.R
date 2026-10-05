#' ATOM INSPIRE: list address download URLs
#'
#' @description
#' Creates a [tibble][tibble::tbl_df] of URLs provided by the Cadastre of
#' Navarre ATOM INSPIRE service for downloading addresses by municipality.
#'
#' @inheritParams CatastRo::catr_atom_get_address_db_all cache update_cache
#' @inheritParams CatastRo::catr_set_cache_dir verbose
#' @param cache_dir Path to a cache directory. If `NULL`, uses the configured
#'   cache or a directory inside [base::tempdir()]. See
#'   [catrnav_set_cache_dir()].
#'
#' @returns A [tibble][tibble::tbl_df] with the following columns. Returns
#'   [`NULL`][base::NULL] if the data cannot be retrieved.
#' - `munic`: Municipality name and cadastral code.
#' - `url`: ATOM URL for the corresponding municipality.
#' - `date`: Reference timestamp of the data in UTC.
#'
#' @source
#' ```{r child = "man/chunks/sitna.Rmd"}
#' ```
#'
#' @seealso
#' [catrnav_atom_get_address()] downloads addresses for a municipality
#' listed in this index.
#'
#' ```{r child = "man/chunks/atom-search-links.Rmd"}
#' ```
#'
#' @family atom_services
#' @family atom_indexes
#' @family addresses
#'
#' @rdname catrnav_atom_get_address_db
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf run_example()
#' catrnav_atom_get_address_db_all()
catrnav_atom_get_address_db_all <- function(
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(
    cache,
    "CatastRoNav::catrnav_atom_get_address_db_all(cache)"
  )

  catrnav_atom_read_db_all(
    api_entry = paste0(
      "https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/",
      "2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_3_AD/",
      "Addresses_ServiceATOM_Navarra.xml"
    ),
    title_prefix = "Download INSPIRE addresses of the municipality ",
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
