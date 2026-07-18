#' WMS INSPIRE: download georeferenced map images
#'
#' @description
#' Downloads georeferenced map images from the Cadastre of Navarre WMS service.
#' This function wraps [mapSpain::esp_get_tiles()].
#'
#' @param what WMS layer to download. See **Layers and styles**.
#' @param styles Style to apply to the selected WMS layer. See
#'   **Layers and styles**.
#' @inheritParams catrnav_wfs_get_address_bbox
#' @inheritParams catrnav_atom_get_address_db_all
#' @inheritParams mapSpain::esp_get_tiles
#' @inheritDotParams mapSpain::esp_get_tiles res:mask
#'
#' @return
#' A [`SpatRaster`][terra::rast] with three RGB or four RGBA layers, or `NULL`
#' when the request cannot be completed. See [terra::RGB()].
#'
#' @section Bounding box:
#' When `x` is a numeric vector, make sure that `srs` matches the coordinate
#' values. When `x` is an [`sf`][sf::st_sf] or `sfc` object, `srs` is ignored.
#'
#' The query uses [EPSG:3857](https://epsg.io/3857), Web Mercator, then
#' transforms the image back to the input CRS. If the image appears distorted,
#' provide a spatial object as `x` or set `srs` to the CRS of the requested
#' image.
#'
#' @section Layers and styles:
#'
#' ## Layers
#' The `what` argument selects one of the following API layers:
#' - `"parcel"`: `CP.CadastralParcel`.
#' - `"building"`: `BU.Building`.
#' - `"address"`: `AD.Address`.
#'
#' ## Styles
#' The WMS service provides different styles for each layer (`what` argument).
#' Available styles include:
#' - `"parcel"`: `"default"` and `"ELFCadastre"`.
#' - `"building"`: `"default"`.
#' - `"address"`: `"default"`.
#'
#' @source
#' [SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)
#'
#' @seealso
#' - [mapSpain::esp_get_tiles()] downloads map tiles.
#' - [terra::RGB()] identifies RGB channels.
#' - [terra::plotRGB()] and [tidyterra::geom_spatraster_rgb()] plot RGB rasters.
#'
#' @family wms
#' @family addresses
#' @family buildings
#' @family parcels
#' @encoding UTF-8
#' @export
#'
#' @examplesIf run_example()
#' \donttest{
#' bu <- catrnav_wms_get_layer(
#'   c(-1.646812, 42.814528, -1.638036, 42.820320),
#'   srs = 4326,
#'   what = "building"
#' )
#'
#' library(mapSpain)
#' library(ggplot2)
#' library(tidyterra)
#'
#' ggplot() +
#'   geom_spatraster_rgb(data = bu)
#'
#' # Parcels
#' parc <- catrnav_wms_get_layer(
#'   c(-1.646812, 42.814528, -1.638036, 42.820320),
#'   srs = 4326,
#'   what = "parcel"
#' )
#'
#' ggplot() +
#'   geom_spatraster_rgb(data = parc)
#' }
catrnav_wms_get_layer <- function(
  x,
  srs = 4326,
  what = c("building", "parcel", "address"),
  styles = c("default", "ELFCadastre"),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  crop = FALSE,
  options = NULL,
  ...
) {
  x <- ensure_null(x)
  bbox_res <- get_sf_from_bbox(x, srs)
  cache_dir <- create_cache_dir(cache_dir)

  if (!is_online_fun()) {
    cli::cli_alert_danger("No internet connection detected.")
    cli::cli_alert("Returning {.val NULL} because the request cannot run.")
    return(NULL)
  }

  # Map the requested value to a WMS layer name.

  what <- match_arg_pretty(what) # nolint: object_usage_linter
  styles <- match_arg_pretty(styles) # nolint: object_usage_linter

  if (all(what != "parcel", styles != "default")) {
    cli::cli_abort("Layer {.str {what}} only supports style {.str default}.")
  }

  base_url <- "https://inspire.navarra.es/services/"
  endpoint <- switch(what,
    "building" = "BU/wms?",
    "parcel" = "CP/wms?",
    "address" = "AD/wms?"
  )

  layer <- switch(what,
    "building" = "BU:Building",
    "parcel" = "CP:CadastralParcel",
    "address" = "AD:Address"
  )

  if (styles == "default") {
    styles <- switch(what,
      "building" = "BU:Building.Default",
      "parcel" = "CP:CP.CadastralParcel.Default",
      "address" = "AD:Address.Default"
    )
  } else {
    styles <- "CP:CP.CadastralParcel.ELFCadastre"
  }

  # Create the provider.
  type <- mapSpain::esp_make_provider(
    id = paste0("CatastroNav_", what),
    q = paste0(base_url, endpoint),
    service = "WMS",
    version = "1.3.0",
    crs = "EPSG:3857",
    layers = layer,
    styles = styles,
    transparent = TRUE
  )

  # Query the WMS service.

  out <- esp_get_tiles_fun(
    x = bbox_res,
    type = type,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = verbose,
    options = options,
    ...
  )

  if (is.null(out)) {
    cli::cli_alert_danger("The WMS request failed.")
    cli::cli_alert("Returning {.val NULL} because the request failed.")
    return(NULL)
  }

  if (crop) {
    out <- terra::crop(out, bbox_res)
  }

  out
}

#' Wrap `mapSpain::esp_get_tiles()` for testing
#'
#' @noRd
esp_get_tiles_fun <- function(...) {
  mapSpain::esp_get_tiles(...)
}
