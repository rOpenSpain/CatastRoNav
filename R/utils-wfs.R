#' Run a Navarre WFS bounding box query
#'
#' @param path WFS endpoint path.
#' @param typenames WFS feature type.
#' @inheritParams catrnav_wfs_get_buildings_bbox
#'
#' @return An `sf` object or `NULL` when the request fails.
#'
#' @noRd
wfs_read_bbox_query <- function(
  x,
  srs = 4326,
  path,
  typenames,
  verbose = FALSE,
  count = NULL
) {
  srs <- ensure_null(srs)
  count <- ensure_null(count)
  validate_wfs_args(verbose, count)

  bbox_res <- wfs_bbox(x, srs)

  query <- wfs_build_bbox_query(typenames, bbox_res, count)

  file_local <- inspire_wfs_get_fun(
    hostname = "inspire.navarra.es",
    path = path,
    query = query,
    verbose = verbose
  )

  if (is.null(file_local)) {
    return(NULL)
  }

  on.exit(unlink(file_local, force = TRUE), add = TRUE)

  out <- read_geo_file_sf(file_local, verbose)
  if (is.null(out)) {
    return(NULL)
  }

  sf::st_transform(out, bbox_res$outcrs)
}

inspire_wfs_get_fun <- function(...) {
  CatastRo::inspire_wfs_get(...)
}

wfs_build_bbox_query <- function(typenames, bbox, count = NULL) {
  count <- ensure_null(count)
  query <- list(
    version = "2.0.0",
    service = "WFS",
    request = "getfeature",
    typenames = typenames,
    bbox = bbox$bbox,
    SRSNAME = bbox$incrs
  )
  if (!is.null(count)) {
    query$count <- count
  }
  query
}

wfs_bbox <- function(bbox, srs = NULL) {
  srs <- ensure_null(srs)

  if (inherits(bbox, "sf") || inherits(bbox, "sfc")) {
    outcrs <- sf::st_crs(bbox)
  } else {
    outcrs <- sf::st_crs(srs)
  }

  bbox_new <- wfs_get_bbox(
    x = bbox,
    srs = srs,
    srs_dest = 25830,
    limit_km2 = getOption("catastronav_wfs_limit_km2", Inf)
  )

  list(
    bbox = paste(as.double(bbox_new), collapse = ","),
    outcrs = outcrs,
    incrs = 25830
  )
}

#' Prepare a bounding box for a WFS query
#'
#' @noRd
wfs_get_bbox <- function(x, srs = NULL, srs_dest = 25830, limit_km2 = Inf) {
  srs <- ensure_null(srs)

  if (!(inherits(x, "sf") || inherits(x, "sfc"))) {
    validate_vector_with_srs(x, srs, 4L)

    sfobj <- x
    class(sfobj) <- "bbox"
    sfobj <- sf::st_as_sfc(sfobj)
    sfobj <- sf::st_set_crs(sfobj, srs)
  } else {
    sfobj <- sf::st_as_sfc(sf::st_bbox(x))
  }

  if (is.na(sf::st_crs(sfobj))) {
    cli::cli_abort(
      "{.arg srs} must identify a valid coordinate reference system."
    )
  }

  sfobj <- sf::st_transform(sfobj, srs_dest)

  area <- sf::st_area(sf::st_transform(sfobj, 3857))
  area <- round(as.double(area) / 1000000, 1)

  if (area > limit_km2) {
    cli::cli_alert_warning(paste0(
      "The configured WFS limit is {.val {limit_km2}} km\u00b2. ",
      "The query covers {.val {area}} km\u00b2."
    ))
    cli::cli_alert_info(
      "The request may fail. Consider using a smaller area in {.arg x}."
    )
  }

  sf::st_bbox(sfobj)
}
