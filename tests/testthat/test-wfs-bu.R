test_that("building WFS validates bounding boxes", {
  expect_snapshot(error = TRUE, catrnav_wfs_get_buildings_bbox(x = "1234"))
  expect_snapshot(
    error = TRUE,
    catrnav_wfs_get_buildings_bbox(c("1234", "a", "3", "4"))
  )
  expect_snapshot(error = TRUE, catrnav_wfs_get_buildings_bbox(c(1, 2, 3)))
})

test_that("building WFS uses the building service contract", {
  received <- NULL
  local_mocked_bindings(inspire_wfs_get_fun = function(...) {
    received <<- list(...)
    NULL
  })

  result <- catrnav_wfs_get_buildings_bbox(c(-1, 40, 0, 41), srs = 4326)

  expect_null(result)
  expect_identical(received$path, "services/BU/wfs")
  expect_identical(received$query$typenames, "BU:Building")
})


test_that("building WFS returns the requested CRS", {
  skip_on_cran()
  skip_if_offline()

  expect_null(catrnav_wfs_get_buildings_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  ))

  expect_message(catrnav_wfs_get_buildings_bbox(
    c(1071071, 4747924, 1071171, 4748024),
    srs = 25829,
    verbose = TRUE
  ))

  obj <- catrnav_wfs_get_buildings_bbox(
    c(1071071, 4747924, 1071171, 4748024),
    srs = 25829,
    count = 10
  )

  expect_equal(sf::st_crs(obj), sf::st_crs(25829))
  expect_identical(nrow(obj), 10L)

  # test conversion
  testconv <- get_sf_from_bbox(obj[1, ])
  expect_identical(obj[1, ], testconv)

  # Convert to spatial object

  bbox <- get_sf_from_bbox(c(1071071, 4747924, 1071171, 4748024), 25829)
  expect_s3_class(bbox, "sfc")

  obj2 <- catrnav_wfs_get_buildings_bbox(bbox)
  expect_equal(sf::st_crs(obj2), sf::st_crs(25829))

  # Transform object to geographic coords
  bbox2 <- sf::st_transform(obj2[1, ], 4326)
  expect_true(sf::st_is_longlat(bbox2))
  expect_s3_class(bbox2, "sf")

  obj3 <- catrnav_wfs_get_buildings_bbox(bbox2)

  expect_true(sf::st_is_longlat(obj3))
  expect_equal(sf::st_crs(obj3), sf::st_crs(4326))

  # BBox with coordinates

  vec <- as.double(sf::st_bbox(obj3[1, ]))

  obj4 <- catrnav_wfs_get_buildings_bbox(vec, srs = 4326)

  expect_true(sf::st_is_longlat(obj4))
  expect_equal(sf::st_crs(obj4), sf::st_crs(4326))
})
