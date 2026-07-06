test_that("WFS bounding boxes preserve output CRS", {
  expect_snapshot(error = TRUE, get_sf_from_bbox(c(1, 2, 3, 4)))
  expect_snapshot(error = TRUE, get_sf_from_bbox(c(1, 2, 3, 4), srs = ""))

  bbox <- wfs_bbox(c(-1, 40, 0, 41), srs = 4326)

  expect_equal(bbox$outcrs, sf::st_crs(4326))
  expect_equal(bbox$incrs, 25830)

  # On Mercator

  bbox2 <- wfs_bbox(-c(10, 0, 10, 10), 3847)
  expect_equal(bbox2$outcrs, sf::st_crs(3847))
  expect_equal(bbox2$incrs, 25830)

  # With sf object
  sfobj <- sf::st_sfc(sf::st_point(c(3, 35)), crs = 4326)
  sfobj <- sf::st_transform(sfobj, 3035)
  sfobj <- sf::st_buffer(sfobj, 1000)
  bbox_lau <- wfs_bbox(sfobj)

  expect_equal(bbox_lau$outcrs, sf::st_crs(sfobj))
  expect_equal(bbox_lau$incrs, 25830)
})

test_that("WFS queries omit empty optional arguments", {
  bbox <- list(bbox = "1,2,3,4", incrs = 25830)

  query <- wfs_build_bbox_query("CP:CadastralParcel", bbox)
  expect_false("count" %in% names(query))

  query_with_count <- wfs_build_bbox_query(
    "CP:CadastralParcel",
    bbox,
    count = 10
  )
  expect_identical(query_with_count$count, 10)
})

test_that("WFS helpers handle failed and empty responses", {
  local_mocked_bindings(inspire_wfs_get_fun = function(...) NULL)
  expect_null(wfs_read_bbox_query(
    c(-1, 40, 0, 41),
    path = "services/CP/wfs",
    typenames = "CP:CadastralParcel"
  ))

  response <- tempfile(fileext = ".gml")
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
  expect_snapshot(wfs_get_bbox(large, limit_km2 = 1))
})
