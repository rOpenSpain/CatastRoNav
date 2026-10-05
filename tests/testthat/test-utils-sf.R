test_that("read_geo_file_sf() reads and filters spatial layers", {
  source <- system.file("shape/nc.shp", package = "sf")

  result <- read_geo_file_sf(source, layer_hint = "^nc$", verbose = FALSE)

  expect_s3_class(result, "sf")
  expect_all_true(sf::st_is_valid(result))
  expect_all_true(validUTF8(names(result)))
})

test_that("read_geo_file_sf() handles missing spatial inputs", {
  expect_snapshot(result <- read_geo_file_sf(character()))
  expect_null(result)
})

test_that("sanitize_sf() preserves the geometry column", {
  geometry <- sf::st_sfc(sf::st_point(c(0, 0)), crs = 4326)
  field <- "municipio_\u00f1"
  value <- "Pamplona / Iru\u00f1a"
  Encoding(field) <- "UTF-8"
  Encoding(value) <- "UTF-8"
  source <- sf::st_sf(
    label = value,
    shape = geometry,
    sf_column_name = "shape"
  )
  names(source)[1] <- field

  result <- sanitize_sf(source)

  expect_s3_class(result, "sf")
  expect_identical(attr(result, "sf_column"), "shape")
  expect_all_true(sf::st_is_valid(result))
  expect_all_true(validUTF8(names(result)))
  expect_all_true(validUTF8(result[[field]]))
  expect_identical(names(result)[1], field)
  expect_identical(result[[field]], value)
  expect_identical(Encoding(names(result)[1]), "UTF-8")
  expect_identical(Encoding(result[[field]]), "UTF-8")
})

test_that("read_geo_file_sf() reads matching files from ZIP archives", {
  source_dir <- system.file("shape", package = "sf")
  source_files <- list.files(source_dir, pattern = "^nc\\.", full.names = TRUE)
  archive_dir <- withr::local_tempdir(pattern = "catrnav-zip-")
  file.copy(source_files, archive_dir)
  archive <- file.path(archive_dir, "nc.zip")
  withr::local_dir(archive_dir)
  zip(archive, basename(source_files))

  result <- read_geo_file_sf(archive, hint = "nc.shp")

  expect_s3_class(result, "sf")
  expect_all_true(sf::st_is_valid(result))
})

test_that("read_geo_file_sf() handles missing ZIP members", {
  archive_dir <- withr::local_tempdir(pattern = "catrnav-empty-zip-")
  writeLines("not spatial", file.path(archive_dir, "README.txt"))
  archive <- file.path(archive_dir, "data.zip")
  withr::local_dir(archive_dir)
  zip(archive, "README.txt")

  expect_snapshot(result <- read_geo_file_sf(archive, hint = "missing.shp"))
  expect_null(result)
})

test_that("read_geo_file_sf() handles invalid large files", {
  source <- withr::local_tempfile(fileext = ".gml")
  connection <- file(source, open = "wb")
  seek(connection, where = 21 * 1024^2)
  writeBin(as.raw(0), connection)
  close(connection)

  expect_snapshot(
    error = TRUE,
    read_geo_file_sf(source),
    transform = function(x) {
      sub(
        "Cannot open data source .*",
        "Cannot open data source <source.gml>",
        x
      )
    }
  )
})

test_that("read_geo_file_sf() handles missing layers and read errors", {
  source <- system.file("shape/nc.shp", package = "sf")

  expect_snapshot(
    no_layer <- read_geo_file_sf(source, layer_hint = "^missing$")
  )
  expect_null(no_layer)

  expect_snapshot(
    error = TRUE,
    suppressWarnings(
      read_geo_file_sf(source, query = "SELECT * FROM missing")
    )
  )
})

test_that("read_geo_file_sf() handles sources without layers", {
  local_mocked_bindings(st_layers_fun = function(...) list(name = character()))
  expect_snapshot(result <- read_geo_file_sf("empty.gpkg"))
  expect_null(result)
})

test_that("spatial validation identifies the public caller", {
  cnd <- tryCatch(catrnav_wms_get_layer(c(1, 2)), error = identity)
  expect_s3_class(cnd, "rlang_error")
  expect_identical(conditionCall(cnd), quote(catrnav_wms_get_layer(c(1, 2))))
  cnd <- tryCatch(catrnav_wfs_get_parcels_bbox(c(1, 2)), error = identity)
  expect_s3_class(cnd, "rlang_error")
  expect_identical(
    conditionCall(cnd),
    quote(catrnav_wfs_get_parcels_bbox(c(1, 2)))
  )
})
