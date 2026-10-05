test_that("WFS bounding boxes preserve output CRS", {
  expect_snapshot(error = TRUE, get_sf_from_bbox(c(1, 2, 3, 4)))
  expect_snapshot(error = TRUE, get_sf_from_bbox(c(1, 2, 3, 4), srs = ""))

  bbox <- wfs_bbox(c(-1, 40, 0, 41), srs = 4326)

  expect_equal(bbox$outcrs, sf::st_crs(4326))
  expect_identical(bbox$incrs, 25830)

  # On Mercator

  bbox2 <- wfs_bbox(-c(10, 0, 10, 10), 3847)
  expect_equal(bbox2$outcrs, sf::st_crs(3847))
  expect_identical(bbox2$incrs, 25830)

  # With sf object
  sfobj <- sf::st_sfc(sf::st_point(c(3, 35)), crs = 4326)
  sfobj <- sf::st_transform(sfobj, 3035)
  sfobj <- sf::st_buffer(sfobj, 1000)
  bbox_lau <- wfs_bbox(sfobj)

  expect_equal(bbox_lau$outcrs, sf::st_crs(sfobj))
  expect_identical(bbox_lau$incrs, 25830)
})

test_that("spatial bounding boxes are preserved and converted", {
  spatial <- sf::st_sfc(sf::st_point(c(-1, 40)), crs = 4326)

  expect_identical(get_sf_from_bbox(spatial), spatial)

  numeric <- get_sf_from_bbox(c(-1, 40, 0, 41), srs = 4326)
  expect_s3_class(numeric, "sfc")
  expect_equal(sf::st_crs(numeric), sf::st_crs(4326))
})

test_that("WFS bounding boxes validate numeric inputs", {
  expect_snapshot(error = TRUE, wfs_get_bbox("1234", srs = 4326))
  expect_snapshot(error = TRUE, wfs_get_bbox(c(1, 2, 3), srs = 4326))
  expect_snapshot(error = TRUE, wfs_get_bbox(c(1, 2, 3, Inf), srs = 4326))
})

test_that("WFS queries omit empty optional arguments", {
  bbox <- list(bbox = "1,2,3,4", incrs = 25830)

  query <- wfs_build_bbox_query("CP:CadastralParcel", bbox)
  expect_named(
    query,
    c("version", "service", "request", "typenames", "bbox", "SRSNAME")
  )

  query_with_count <- wfs_build_bbox_query(
    "CP:CadastralParcel",
    bbox,
    count = 10
  )
  expect_identical(query_with_count$count, 10)
})

test_that("empty WFS responses retain cached files", {
  local_mocked_bindings(inspire_wfs_get_fun = function(...) NULL)
  expect_null(wfs_read_bbox_query(
    c(-1, 40, 0, 41),
    path = "services/CP/wfs",
    typenames = "CP:CadastralParcel"
  ))

  response <- withr::local_tempfile(fileext = ".gml")
  writeLines("not spatial data", response)
  local_mocked_bindings(
    inspire_wfs_get_fun = function(...) response,
    read_geo_file_sf = function(...) NULL
  )
  expect_null(wfs_read_bbox_query(
    c(-1, 40, 0, 41),
    path = "services/CP/wfs",
    typenames = "CP:CadastralParcel"
  ))
  expect_all_true(file.exists(response))
})

test_that("successful WFS responses retain cached files", {
  response <- withr::local_tempfile(fileext = ".gml")
  writeLines("spatial response", response)
  source <- sf::st_sf(
    id = 1L,
    geometry = sf::st_sfc(sf::st_point(c(500000, 4700000)), crs = 25830)
  )
  local_mocked_bindings(
    inspire_wfs_get_fun = function(...) response,
    read_geo_file_sf = function(...) source
  )

  result <- wfs_read_bbox_query(
    c(-1, 40, 0, 41),
    srs = 4326,
    path = "services/CP/wfs",
    typenames = "CP:CadastralParcel"
  )

  expect_s3_class(result, "sf")
  expect_equal(sf::st_crs(result), sf::st_crs(4326))
  expect_all_true(file.exists(response))
})

test_that("WFS queries use the Navarre cache and preserve response files", {
  cache_dir <- withr::local_tempdir()
  withr::local_envvar(CATASTRONAV_CACHE_DIR = cache_dir)
  response <- file.path(cache_dir, "response.gml")
  writeLines("spatial response", response)
  source <- sf::st_sf(
    geometry = sf::st_sfc(sf::st_point(c(500000, 4700000)), crs = 25830)
  )
  seen <- NULL
  local_mocked_bindings(
    inspire_wfs_get_fun = function(cache_dir, ...) {
      seen <<- cache_dir
      response
    },
    read_geo_file_sf = function(...) source
  )

  result <- catrnav_wfs_get_parcels_bbox(c(-1, 40, 0, 41))
  expect_identical(seen, cache_dir)
  expect_equal(sf::st_crs(result), sf::st_crs(4326))
  expect_all_true(file.exists(response))
})

test_that("WFS requests scope Navarre HTTP options to the delegated call", {
  withr::local_options(list(
    catastronav_timeout = NULL,
    catastronav_ssl_verify = NULL,
    catastro_timeout = 120,
    catastro_ssl_verify = 1L
  ))
  withr::local_envvar(c(
    CATASTRONAV_TIMEOUT = "30",
    CATASTRONAV_SSL_VERIFY = "0"
  ))
  seen <- NULL
  local_mocked_bindings(catrnav_inspire_wfs_get = function(...) {
    seen <<- options()[c("catastro_timeout", "catastro_ssl_verify")]
    "response.gml"
  })

  expect_identical(inspire_wfs_get_fun(), "response.gml")
  expect_equal(seen, list(catastro_timeout = 30, catastro_ssl_verify = 0))
  expect_identical(getOption("catastro_timeout"), 120)
  expect_identical(getOption("catastro_ssl_verify"), 1L)

  local_mocked_bindings(catrnav_inspire_wfs_get = function(...) {
    cli::cli_abort("Simulated WFS failure.")
  })
  expect_error(inspire_wfs_get_fun(), class = "rlang_error")
  expect_identical(getOption("catastro_timeout"), 120)
  expect_identical(getOption("catastro_ssl_verify"), 1L)
})

test_that("WFS bounding boxes report invalid CRS and configured limits", {
  no_crs <- sf::st_sfc(sf::st_polygon(list(rbind(
    c(0, 0),
    c(1, 0),
    c(1, 1),
    c(0, 1),
    c(0, 0)
  ))))
  expect_snapshot(error = TRUE, wfs_get_bbox(no_crs))

  large <- sf::st_set_crs(no_crs, 4326)
  expect_snapshot(result <- wfs_get_bbox(large, limit_km2 = 1))
  expect_s3_class(result, "bbox")
  expect_length(result, 4L)
  expect_all_true(is.finite(result))
})
