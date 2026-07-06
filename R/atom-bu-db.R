#' ATOM INSPIRE: list building download URLs
#'
#' @description
#' Creates a table of URLs provided by the Cadastre of Navarre ATOM INSPIRE
#' service for downloading buildings by municipality.
#'
#' @inheritParams catrnav_atom_get_address_db_all
#' @inherit catrnav_atom_get_address_db_all return
#'
#' @inherit catrnav_atom_get_address_db_all source
#'
#' @family atom
#' @family buildings
#' @rdname catrnav_atom_get_buildings_db
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' catrnav_atom_get_buildings_db_all()
catrnav_atom_get_buildings_db_all <- function(
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  catrnav_atom_read_db_all(
    api_entry = paste0(
      "https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/",
      "2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_2_BU/",
      "Buildings_ServiceATOM_Navarra.xml"
    ),
    title_prefix = "Download INSPIRE buildings of the municipality ",
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
