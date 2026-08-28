test_that("WMS requests validate layer and style arguments", {
  expect_snapshot(
    error = TRUE,
    catrnav_wms_get_layer(
      c(760926, 4019259, 761155, 4019366),
      srs = 25829,
      what = "aa"
    )
  )
  expect_snapshot(
    error = TRUE,
    catrnav_wms_get_layer(
      c(760926, 4019259, 761155, 4019366),
      srs = 25829,
      styles = "a"
    )
  )
  expect_snapshot(
    error = TRUE,
    catrnav_wms_get_layer(
      c(760926, 4019259, 761155, 4019366),
      srs = 25829,
      styles = "ELFCadastre"
    )
  )
  expect_snapshot(
    error = TRUE,
    catrnav_wms_get_layer(
      c(760926, 4019259, 761155, 4019366),
      srs = 25829,
      what = "address",
      styles = "ELFCadastre"
    )
  )
})

test_that("WMS requests handle offline sessions and 404 responses", {
  bbox <- c(-1.646812, 42.814528, -1.638036, 42.820320)
  cdir <- withr::local_tempdir(pattern = "catrnav-wms-")

  local_mocked_bindings(is_online_fun = function(...) FALSE)
  expect_snapshot(offline <- catrnav_wms_get_layer(bbox, cache_dir = cdir))
  expect_null(offline)

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    esp_get_tiles_fun = function(...) NULL
  )
  # mapSpain returns NULL when its download receives an HTTP error such as 404.
  expect_snapshot(not_found <- catrnav_wms_get_layer(bbox, cache_dir = cdir))
  expect_null(not_found)
})

test_that("WMS providers map layers, styles and options", {
  env <- new.env(parent = emptyenv())
  env$received <- NULL
  cache_dir <- withr::local_tempdir(pattern = "catrnav-wms-provider-")
  tile <- terra::rast(
    nrows = 1,
    ncols = 1,
    nlyrs = 3,
    xmin = -1,
    xmax = 1,
    ymin = -1,
    ymax = 1,
    crs = "EPSG:4326"
  )

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    esp_get_tiles_fun = function(x, type, ..., options = NULL) {
      env$received <- list(
        x = x,
        type = type,
        options = options,
        dots = list(...)
      )
      tile
    }
  )

  result <- catrnav_wms_get_layer(
    c(-1, -1, 1, 1),
    cache_dir = cache_dir,
    options = list(version = "1.1.0")
  )
  building <- env$received

  expect_s4_class(result, "SpatRaster")
  expect_identical(building$options, list(version = "1.1.0"))
  expect_identical(building$type$id, "CatastroNav_building")
  expect_match(building$type$q, "services/BU/wms?", fixed = TRUE)
  expect_match(building$type$q, "layers=BU:Building", fixed = TRUE)
  expect_match(building$type$q, "styles=BU:Building.Default", fixed = TRUE)

  catrnav_wms_get_layer(
    c(-1, -1, 1, 1),
    what = "parcel",
    styles = "ELFCadastre",
    cache_dir = cache_dir
  )
  parcel <- env$received$type

  expect_identical(parcel$id, "CatastroNav_parcel")
  expect_match(parcel$q, "services/CP/wms?", fixed = TRUE)
  expect_match(parcel$q, "layers=CP:CadastralParcel", fixed = TRUE)
  expect_match(
    parcel$q,
    "styles=CP:CP.CadastralParcel.ELFCadastre",
    fixed = TRUE
  )

  catrnav_wms_get_layer(
    c(-1, -1, 1, 1),
    what = "address",
    cache_dir = cache_dir
  )
  address <- env$received$type

  expect_identical(address$id, "CatastroNav_address")
  expect_match(address$q, "services/AD/wms?", fixed = TRUE)
  expect_match(address$q, "layers=AD:Address", fixed = TRUE)
  expect_match(address$q, "styles=AD:Address.Default", fixed = TRUE)
})

test_that("WMS tiles can be downloaded and cropped", {
  skip_on_cran()
  skip_if_offline()
  muffle_extent_warning <- function(code) {
    withCallingHandlers(code, warning = function(cnd) {
      if (grepl("[rast] unknown extent", conditionMessage(cnd), fixed = TRUE)) {
        invokeRestart("muffleWarning")
      }
    })
  }
  cdir <- withr::local_tempdir(pattern = "testthat_ex")
  obj <- muffle_extent_warning(catrnav_wms_get_layer(
    c(-1.646812, 42.814528, -1.638036, 42.820320),
    srs = 4326,
    cache_dir = cdir
  ))

  expect_s4_class(obj, "SpatRaster")
  expect_gt(terra::nlyr(obj), 2L)
  expect_true(terra::has.RGB(obj))
  expect_true(terra::same.crs(obj, "EPSG:4326"))
  expect_all_true(is.finite(as.vector(terra::ext(obj))))

  objcrop <- muffle_extent_warning(catrnav_wms_get_layer(
    c(-1.646812, 42.814528, -1.638036, 42.820320),
    srs = 4326,
    crop = TRUE,
    cache_dir = cdir
  ))

  expect_s4_class(objcrop, "SpatRaster")
  expect_gt(terra::nrow(obj), terra::nrow(objcrop))
  expect_true(terra::same.crs(objcrop, obj))
})
