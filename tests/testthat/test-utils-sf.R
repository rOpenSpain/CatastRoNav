test_that("read_geo_file_sf() reads and filters spatial layers", {
  source <- system.file("shape/nc.shp", package = "sf")

  result <- read_geo_file_sf(
    source,
    layer_hint = "^nc$",
    verbose = FALSE
  )

  expect_s3_class(result, "sf")
  expect_true(all(sf::st_is_valid(result)))
  expect_true(all(validUTF8(names(result))))
})

test_that("read_geo_file_sf() handles missing spatial inputs", {
  expect_snapshot(result <- read_geo_file_sf(character()))
  expect_null(result)
})

test_that("sanitize_sf() preserves the geometry column", {
  geometry <- sf::st_sfc(sf::st_point(c(0, 0)), crs = 4326)
  source <- sf::st_sf(
    label = "Pamplona",
    shape = geometry,
    sf_column_name = "shape"
  )

  result <- sanitize_sf(source)

  expect_s3_class(result, "sf")
  expect_identical(attr(result, "sf_column"), "shape")
  expect_true(sf::st_is_valid(result))
  expect_true(all(validUTF8(names(result))))
})

test_that("read_geo_file_sf() reads matching files from ZIP archives", {
  source_dir <- system.file("shape", package = "sf")
  source_files <- list.files(
    source_dir,
    pattern = "^nc\\.",
    full.names = TRUE
  )
  archive_dir <- withr::local_tempdir(pattern = "catrnav-zip-")
  file.copy(source_files, archive_dir)
  archive <- file.path(archive_dir, "nc.zip")
  old <- setwd(archive_dir)
  withr::defer(setwd(old))
  zip(archive, basename(source_files))

  result <- read_geo_file_sf(archive, hint = "nc.shp")

  expect_s3_class(result, "sf")
  expect_true(all(sf::st_is_valid(result)))
})

test_that("read_geo_file_sf() handles missing ZIP members", {
  archive_dir <- withr::local_tempdir(pattern = "catrnav-empty-zip-")
  writeLines("not spatial", file.path(archive_dir, "README.txt"))
  archive <- file.path(archive_dir, "data.zip")
  old <- setwd(archive_dir)
  withr::defer(setwd(old))
  zip(archive, "README.txt")

  expect_snapshot(
    result <- read_geo_file_sf(archive, hint = "missing.shp")
  )
  expect_null(result)
})

test_that("read_geo_file_sf() handles invalid large files", {
  source <- tempfile(fileext = ".gml")
  connection <- file(source, open = "wb")
  seek(connection, where = 21 * 1024^2)
  writeBin(as.raw(0), connection)
  close(connection)

  expect_message(
    result <- read_geo_file_sf(source),
    "Reading a large spatial file"
  )
  expect_null(result)
})

test_that("read_geo_file_sf() handles missing layers and read errors", {
  source <- system.file("shape/nc.shp", package = "sf")

  expect_snapshot(
    no_layer <- read_geo_file_sf(source, layer_hint = "^missing$")
  )
  expect_null(no_layer)

  expect_snapshot(
    unreadable <- read_geo_file_sf(
      source,
      query = "SELECT * FROM missing"
    )
  )
  expect_null(unreadable)
})
