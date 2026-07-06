test_that("Check error", {
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
  expect_snapshot(
    offline <- catrnav_wms_get_layer(bbox, cache_dir = cdir)
  )
  expect_null(offline)

  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    esp_get_tiles_fun = function(...) NULL
  )
  # mapSpain returns NULL when its download receives an HTTP error such as 404.
  expect_snapshot(
    not_found <- catrnav_wms_get_layer(bbox, cache_dir = cdir)
  )
  expect_null(not_found)
})

test_that("WMS options are passed to mapSpain", {
  received <- NULL
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
    esp_get_tiles_fun = function(..., options = NULL) {
      received <<- options
      tile
    }
  )

  result <- catrnav_wms_get_layer(
    c(-1, -1, 1, 1),
    options = list(version = "1.1.0")
  )

  expect_s4_class(result, "SpatRaster")
  expect_identical(received, list(version = "1.1.0"))
})

test_that("Check tiles", {
  skip_on_cran()
  skip_if_offline()
  cdir <- withr::local_tempdir(pattern = "testthat_ex")
  obj <- catrnav_wms_get_layer(
    c(-1.646812, 42.814528, -1.638036, 42.820320),
    srs = 4326,
    cache_dir = cdir
  )

  expect_s4_class(obj, "SpatRaster")

  # test crop
  objcrop <- catrnav_wms_get_layer(
    c(-1.646812, 42.814528, -1.638036, 42.820320),
    srs = 4326,
    crop = TRUE,
    cache_dir = cdir
  )

  expect_true(terra::nrow(obj) > terra::nrow(objcrop))
  expect_true(terra::has.RGB(obj))

  # Convert to spatial object
  bbox <- get_sf_from_bbox(c(-1.646812, 42.814528, -1.638036, 42.820320), 4326)
  expect_s3_class(bbox, "sfc")

  obj2 <- catrnav_wms_get_layer(bbox, cache_dir = cdir)

  expect_s4_class(obj2, "SpatRaster")

  # With styles
  obj3 <- catrnav_wms_get_layer(
    c(-1.646812, 42.814528, -1.638036, 42.820320),
    srs = 4326,
    what = "parcel",
    styles = "ELFCadastre",
    cache_dir = cdir
  )

  expect_s4_class(obj3, "SpatRaster")

  obj3 <- catrnav_wms_get_layer(
    c(-1.646812, 42.814528, -1.638036, 42.820320),
    srs = 4326,
    what = "parcel",
    styles = "default",
    cache_dir = cdir
  )

  expect_s4_class(obj3, "SpatRaster")

  obj3 <- catrnav_wms_get_layer(
    c(-1.646812, 42.814528, -1.638036, 42.820320),
    srs = 4326,
    what = "address",
    styles = "default",
    cache_dir = cdir
  )

  expect_s4_class(obj3, "SpatRaster")

  # test with sf
  test_sf <- sf::st_sf(
    id = 1,
    geometry = sf::st_sfc(sf::st_point(c(-1.642, 42.817)), crs = 4326)
  )

  obj3 <- catrnav_wms_get_layer(
    test_sf,
    srs = 999999999999,
    what = "address",
    styles = "default",
    cache_dir = cdir
  )

  expect_s4_class(obj3, "SpatRaster")
})
