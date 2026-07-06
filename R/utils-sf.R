#' Read and sanitize a spatial file
#'
#' @param file_local A character string containing a local file path or URL.
#' @param verbose A logical value indicating whether to display reading
#'   information.
#' @param hint A character string used to identify files in ZIP archives.
#' @param layer_hint An optional character string used to identify layer names.
#' @param ... Additional arguments passed to [sf::read_sf()].
#'
#' @return An `sf` object or `NULL` when no spatial layer can be read.
#'
#' @noRd
read_geo_file_sf <- function(
  file_local,
  verbose = FALSE,
  hint = basename(file_local),
  layer_hint = NULL,
  ...
) {
  if (length(file_local) == 0L) {
    cli::cli_alert_warning("No spatial files found.")
    return(NULL)
  }
  file_local <- file_local[1]

  if (grepl("\\.zip$", file_local, ignore.case = TRUE)) {
    archive_files <- unzip(file_local, list = TRUE)$Name
    archive_files <- archive_files[grepl(hint, archive_files)]
    if (length(archive_files) == 0L) {
      cli::cli_alert_warning("No matching files found in the ZIP archive.")
      return(NULL)
    }
    file_local <- file.path("/vsizip/", file_local, archive_files[1])
    file_local <- gsub("//", "/", file_local, fixed = TRUE)
  }

  if (!grepl("^http", file_local) && file.exists(file_local)) {
    size <- file.size(file_local)
    if (size > 20 * (1024^2)) {
      class(size) <- class(object.size("a"))
      cli::cli_alert_warning(
        "Reading a large spatial file ({.val {format(size, units = 'auto')}})."
      )
    }
  }

  layers <- tryCatch(sf::st_layers(file_local), error = function(cnd) {
    NULL
  })

  if (is.null(layers) || length(layers$name) == 0L) {
    cli::cli_alert_warning("No spatial layers found.")
    return(NULL)
  }

  if (!is.null(layer_hint)) {
    layers <- layers[
      grepl(layer_hint, layers$name, ignore.case = TRUE), ,
      drop = FALSE
    ]
  }

  geometry_type <- unlist(layers$geomtype)
  spatial_layers <- layers$name[!is.na(geometry_type)]
  if (length(spatial_layers) == 0L) {
    cli::cli_alert_warning("No spatial layers found.")
    return(NULL)
  }

  out <- tryCatch(
    sf::read_sf(file_local, layer = spatial_layers[1], quiet = !verbose, ...),
    error = function(cnd) {
      cli::cli_alert_warning("The spatial result could not be read.")
      NULL
    }
  )

  if (is.null(out)) {
    return(NULL)
  }

  sanitize_sf(out)
}

#' Normalize an `sf` object
#'
#' @param data_sf An `sf` object.
#'
#' @return A valid `sf` object with UTF-8 metadata.
#'
#' @noRd
sanitize_sf <- function(data_sf) {
  set_utf8 <- function(x) {
    object_names <- names(x)
    Encoding(object_names) <- "UTF-8"

    to_utf8 <- function(column) {
      if (is.character(column)) {
        Encoding(column) <- "UTF-8"
      }
      column
    }

    structure(lapply(x, to_utf8), names = object_names)
  }

  geometry <- sf::st_geometry(data_sf)
  geometry_name <- attr(data_sf, "sf_column")
  data_utf8 <- set_utf8(sf::st_drop_geometry(data_sf))
  data_utf8 <- dplyr::as_tibble(data_utf8)

  data_sf <- sf::st_as_sf(data_utf8, geometry)
  names(data_sf)[names(data_sf) == "geometry"] <- geometry_name
  data_sf <- sf::st_set_geometry(data_sf, geometry_name)

  epsg <- sf::st_crs(data_sf)$epsg
  if (!is.null(epsg) && !is.na(epsg)) {
    sf::st_crs(data_sf) <- sf::st_crs(epsg)
  }

  sf::st_make_valid(data_sf)
}

get_sf_from_bbox <- function(bbox, srs = NULL) {
  srs <- ensure_null(srs)

  if (inherits(bbox, "sf") || inherits(bbox, "sfc")) {
    return(bbox)
  }

  bbox_new <- wfs_get_bbox(x = bbox, srs = srs, srs_dest = srs)
  sf::st_as_sfc(bbox_new)
}
