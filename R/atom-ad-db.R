#' ATOM INSPIRE: list address download URLs
#'
#' @description
#' Creates a table of URLs provided by the Cadastre of Navarre ATOM INSPIRE
#' service for downloading addresses by municipality.
#'
#' @param cache A logical value indicating whether to use cached files. Defaults
#'   to `TRUE`.
#'
#' @inheritParams CatastRo::catr_atom_get_address_db_all -cache -to
#'
#' @return
#' A [tibble][dplyr::tbl_df] with the requested information in the following
#' columns:
#' - `munic`: Municipality name and cadastral code.
#' - `url`: ATOM URL for the corresponding municipality.
#' - `date`: Reference date of the data.
#'
#' @source
#' [SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)
#'
#' @family atom
#' @family addresses
#' @rdname catrnav_atom_get_address_db
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' catrnav_atom_get_address_db_all()
catrnav_atom_get_address_db_all <- function(
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  catrnav_atom_read_db_all(
    api_entry = paste0(
      "https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/",
      "2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_3_AD/",
      "Addresses_ServiceATOM_Navarra.xml"
    ),
    title_prefix = "Download INSPIRE addresses of the municipality ",
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose
  )
}
