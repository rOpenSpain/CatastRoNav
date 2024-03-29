catrnav_wfs_get_url <- function(host = "https://inspire.navarra.es/services/",
                                entry,
                                params) {
  # Clean empty params
  params <- params[lengths(params) != 0]

  # Adjust params
  q <- paste0(names(params), "=", params, collapse = "&")


  # Full url
  full_url <- paste0(host, entry, q)

  return(full_url)
}

catrnav_wfs_check <- function(path) {
  # Check if it is valid
  lines <- suppressWarnings(readLines(path, n = 20))

  if (any(grepl("<gml", lines))) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

#' Handle WFS queries
#'
#' Prepare a WFS query and returns a list with information of the result
#'
#' @param entry Entry point of the API
#' @param ... Query parameters
#' @param ... Wheter to display additional info on call
#'
#' @returns A list indicating the path to the tempfile, if it is a sf
#' object and in case of error a message to display
#'
#' @noRd
wfs_api_query <- function(entry, ..., verbose = TRUE) {
  arguments <- list(...)

  # Handle SRS. Is optional but if provided check
  srs <- arguments$SRSNAME

  if (!is.null(srs)) {
    arguments$SRSNAME <- paste0("EPSG:", srs)
  }

  # Prepare URL
  # Get URl
  api_entry <- catrnav_wfs_get_url(
    entry = entry,
    params = arguments
  )


  # Filename
  filename <- paste0(basename(tempfile()), ".gml")

  path <- catr_hlp_dwnload(
    api_entry, filename,
    cache_dir = tempdir(),
    verbose = verbose, update_cache = FALSE,
    cache = TRUE
  )

  # Check
  is_sf <- catrnav_wfs_check(path)

  # Prepare outlist

  outlist <- list(
    is_sf = is_sf,
    path = path
  )

  if (!is_sf) {
    m <- unlist(xml2::as_list(xml2::read_xml(path)))

    outlist$m <- m
  }
  return(outlist)
}
wfs_results <- function(res, verbose) {
  # Check result
  if (res$is_sf) {
    out <- st_read_layers_encoding(res$path, verbose)
    out <- sf::st_make_valid(out)

    unlink(res$path, force = TRUE)
    return(out)
  } else {
    message("Malformed query: ", res$m)
    unlink(res$path, force = TRUE)
    return(invisible(NULL))
  }
}

wfs_bbox <- function(bbox, srs) {
  result <- list()

  # Use bbox of a spatial object. The API fails on geografic coord ¿?
  if (inherits(bbox, "sf") || inherits(bbox, "sfc")) {
    # Convert to 25830 (opinionated)
    bbox_new <- sf::st_transform(bbox, 25830)

    # Get bbox values
    values <- as.double(sf::st_bbox(bbox_new))

    result$bbox <- paste0(values, collapse = ",")
    result$outcrs <- sf::st_crs(bbox)
    result$incrs <- 25830
  } else {
    # Convert to sf
    bbox_new <- get_sf_from_bbox(bbox, srs)
    result$outcrs <- sf::st_crs(bbox_new)
    bbox_new <- sf::st_transform(bbox_new, 25830)
    result$incrs <- 25830

    # Get bbox values
    values <- as.double(sf::st_bbox(bbox_new))

    result$bbox <- paste0(values, collapse = ",")
  }

  return(result)
}

get_sf_from_bbox <- function(bbox, srs) {
  if (inherits(bbox, "sf") || inherits(bbox, "sfc")) {
    return(bbox)
  }

  # Sanity check
  if (!(is.numeric(bbox) && length(bbox) == 4)) {
    stop("bbox should be a vector of 4 numbers.", call. = FALSE)
  }

  if (missing(srs)) stop("Please provide a srs value", call. = FALSE)

  # Create template for a spatial bbox
  template_sf <- sf::st_sfc(sf::st_point(c(0, 0)))
  template_bbox <- sf::st_bbox(template_sf)

  # Create the spatial object
  bbox_new <- bbox
  class(bbox_new) <- class(template_bbox)

  bbox_new <- sf::st_as_sfc(bbox_new)
  bbox_new <- sf::st_set_crs(bbox_new, srs)

  return(bbox_new)
}
