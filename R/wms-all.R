#' WMS INSPIRE: download georeferenced map images
#'
#' @description
#' Downloads georeferenced map images from the Cadastre of Navarre WMS service.
#' This function wraps [mapSpain::esp_get_tiles()].
#'
#' @details
#' Returns `NULL` if the request cannot run or no image can be retrieved.
#'
#' @inheritParams catrnav_wfs_get_address_bbox x srs verbose
#' @inheritParams catrnav_atom_get_address_db_all update_cache cache_dir
#' @inheritParams CatastRo::catr_wms_get_layer crop options
#' @inheritDotParams mapSpain::esp_get_tiles res:mask
#' @param what WMS layer to download. See **Layers and styles**.
#' @param styles Style to apply to the selected WMS layer. See
#'   **Layers and styles**.
#'
#' @returns A [`SpatRaster`][terra::rast] with three RGB or four RGBA layers.
#'   Returns [`NULL`][base::NULL] if the request cannot run or no image can be
#'   retrieved. See [terra::RGB()].
#'
#' @inheritSection CatastRo::catr_wms_get_layer Bounding box
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
#' @inherit catrnav_atom_get_address_db_all source
#'
#' @seealso
#' - [catrnav_wfs_get_address_bbox()], [catrnav_wfs_get_buildings_bbox()] and
#'   [catrnav_wfs_get_parcels_bbox()] retrieve individual spatial features
#'   within a bounding box.
#' - [catrnav_atom_get_address()], [catrnav_atom_get_buildings()] and
#'   [catrnav_atom_get_parcels()] download complete municipal vector datasets.
#' - [catrnav_set_cache_dir()] configures where downloaded images are cached.
#'   [catrnav_clear_cache()] removes cached images.
#' - [mapSpain::esp_get_tiles()] downloads map tiles.
#' - [terra::RGB()] identifies RGB channels.
#' - [terra::plotRGB()] and [tidyterra::geom_spatraster_rgb()] plot RGB rasters.
#'
#' @family wms_services
#' @family addresses
#' @family buildings
#' @family parcels
#'
#' @export
#' @encoding UTF-8
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
#' # Download cadastral parcels.
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
    cli::cli_alert("Returning {.code NULL} because the request failed.")
    return(NULL)
  }

  if (crop) {
    out <- terra::crop(out, bbox_res)
  }

  out
}

esp_get_tiles_fun <- function(...) {
  mapSpain::esp_get_tiles(...)
}
