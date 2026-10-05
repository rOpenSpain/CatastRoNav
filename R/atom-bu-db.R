#' ATOM INSPIRE: list building download URLs
#'
#' @description
#' Creates a [tibble][tibble::tbl_df] of URLs provided by the Cadastre of
#' Navarre ATOM INSPIRE service for downloading buildings by municipality.
#'
#' @inheritParams catrnav_atom_get_address_db_all
#'
#' @inherit catrnav_atom_get_address_db_all return
#'
#' @inherit catrnav_atom_get_address_db_all source
#'
#' @seealso
#' [catrnav_atom_get_buildings()] downloads buildings for a municipality
#' listed in this index.
#'
#' ```{r child = "man/chunks/atom-search-links.Rmd"}
#' ```
#'
#' @family atom_services
#' @family atom_indexes
#' @family buildings
#'
#' @rdname catrnav_atom_get_buildings_db
#'
#' @export
#' @encoding UTF-8
#'
#' @examplesIf run_example()
#' catrnav_atom_get_buildings_db_all()
catrnav_atom_get_buildings_db_all <- function(
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  warn_deprecated_cache(
    cache,
    "CatastRoNav::catrnav_atom_get_buildings_db_all(cache)"
  )

  catrnav_atom_read_db_all(
    api_entry = paste0(
      "https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/",
      "2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_2_BU/",
      "Buildings_ServiceATOM_Navarra.xml"
    ),
    title_prefix = "Download INSPIRE buildings of the municipality ",
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
