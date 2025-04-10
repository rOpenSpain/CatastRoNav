#' ATOM INSPIRE: Reference database for ATOM buildings
#'
#' @description
#' Create a database containing the urls provided in the INSPIRE ATOM service
#' for extracting Buildings.
#'
#' @source
#' [SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)
#'
#' @family ATOM
#' @family buildings
#'
#' @inheritParams catrnav_set_cache_dir
#'
#' @param cache A logical whether to do caching. Default is `TRUE`. See
#'   **About caching** section on [catrnav_set_cache_dir()].
#'
#' @param update_cache A logical whether to update cache. Default is `FALSE`.
#'  When set to `TRUE` it would force a fresh download of the source file.
#'
#' @rdname catrnav_atom_get_buildings_db
#' @export
#'
#' @return
#' A [tibble][tibble::tibble] with the information requested:
#'   - `munic`: Name of the municipality.
#'   - `url`: url for downloading information of the corresponding municipality.
#'   - `date`: Reference date of the data.
#'
#' @examples
#' \donttest{
#' catrnav_atom_get_buildings_db_all()
#' }
catrnav_atom_get_buildings_db_all <- function(cache = TRUE,
                                              update_cache = FALSE,
                                              cache_dir = NULL,
                                              verbose = FALSE) {
  api_entry <- paste0(
    "https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/",
    "2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_2_BU/",
    "Buildings_ServiceATOM_Navarra.xml"
  )


  filename <- basename(api_entry)

  path <- catr_hlp_dwnload(
    api_entry, filename, cache_dir,
    verbose, update_cache, cache
  )


  tbl <- catr_read_atom(path)
  names(tbl) <- c("munic", "url", "date")
  return(tbl)
}
