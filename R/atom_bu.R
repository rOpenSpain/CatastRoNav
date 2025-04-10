#' ATOM INSPIRE: Download all the cadastral buildings of a municipality
#'
#' @description
#' Get the spatial data of all the cadastral buildings belonging to a single
#' municipality using the INSPIRE ATOM service.
#'
#' @references
#' [SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)
#'
#' @family ATOM
#' @family buildings
#'
#' @export
#' @return A [`sf`][sf::st_sf] object.
#'
#' @inheritParams catrnav_atom_get_buildings_db_all
#' @param munic Municipality to extract, It can be a part of a string or the
#'   cadastral code. See [catrnav_atom_get_buildings_db_all].
#' @examples
#' \donttest{
#'
#' s <- catrnav_atom_get_buildings("Iruña")
#'
#' library(ggplot2)
#'
#' ggplot(s) +
#'   geom_sf() +
#'   labs(
#'     title = "Cadastral Zoning",
#'     subtitle = "Pamplona / Iruña"
#'   )
#' }
catrnav_atom_get_buildings <- function(munic,
                                       cache = TRUE,
                                       update_cache = FALSE,
                                       cache_dir = NULL,
                                       verbose = FALSE) {
  all <- catrnav_atom_get_buildings_db_all(
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )

  findmunic <- grep(munic, all$munic, ignore.case = TRUE)[1]

  if (is.na(findmunic)) {
    message(
      "No Municipality found for ", munic,
      ". Check available municipalities with catrnav_atom_get_buildings_db_all()"
    )
    return(invisible(NA))
  }
  m <- all[findmunic, ]

  if (verbose) {
    message("Selecting ", m$munic)
  }

  # Download from url
  api_entry <- m$url[1]

  filename <- basename(api_entry)


  path <- catr_hlp_dwnload(
    api_entry, filename, cache_dir,
    verbose, update_cache, cache
  )

  # To a new directory
  # Get cached dir
  cache_dir <- catrnav_hlp_cachedir(cache_dir)

  unlist(strsplit(filename, ".", fixed = TRUE))[1]

  exdir <- file.path(
    cache_dir,
    unlist(strsplit(filename, ".", fixed = TRUE))[1]
  )

  if (!dir.exists(exdir)) dir.create(exdir, recursive = TRUE)
  unzip(path, exdir = exdir, junkpaths = TRUE, overwrite = TRUE)


  # Guess what to read
  files <- list.files(exdir, full.names = TRUE, pattern = ".gml$")
  sfobj <- st_read_layers_encoding(files, verbose)

  return(sfobj)
}
