test_that("BBOX Check errors", {
  expect_error(catrnav_wfs_get_parcels_bbox(x = "1234"))
  expect_error(catrnav_wfs_get_parcels_bbox(c("1234", "a", "3", "4")))
  expect_error(catrnav_wfs_get_parcels_bbox(c(1, 2, 3)))
  expect_error(catrnav_wfs_get_parcels_bbox(c(1, 2, 3, 4)))
})


test_that("BBOX Check projections", {
  skip_on_cran()

  expect_null(catrnav_wfs_get_parcels_bbox(
    c(760926, 4019259, 761155, 4019366),
    srs = 25829
  ))

  expect_message(catrnav_wfs_get_parcels_bbox(
    c(
      1071071,
      4747924,
      1071171,
      4748024
    ),
    srs = 25829,
    verbose = TRUE
  ))

  obj <- catrnav_wfs_get_parcels_bbox(
    c(1071071, 4747924, 1071171, 4748024),
    srs = 25829,
    count = 10
  )

  expect_true(sf::st_crs(obj) == sf::st_crs(25829))
  expect_true(nrow(obj) == 10)

  # test conversion
  testconv <- get_sf_from_bbox(obj[1, ])
  expect_identical(obj[1, ], testconv)

  # Convert to spatial object

  bbox <- get_sf_from_bbox(
    c(1071071, 4747924, 1071171, 4748024),
    25829
  )
  expect_s3_class(bbox, "sfc")

  obj2 <- catrnav_wfs_get_parcels_bbox(bbox)
  expect_true(sf::st_crs(obj2) == sf::st_crs(25829))

  # Transform object to geographic coords
  bbox2 <- sf::st_transform(obj2[1, ], 4326)
  expect_true(sf::st_is_longlat(bbox2))
  expect_s3_class(bbox2, "sf")

  obj3 <- catrnav_wfs_get_parcels_bbox(bbox2)

  expect_true(sf::st_is_longlat(obj3))
  expect_true(sf::st_crs(obj3) == sf::st_crs(4326))

  # BBox with coordinates

  vec <- as.double(sf::st_bbox(obj3[1, ]))

  obj4 <- catrnav_wfs_get_parcels_bbox(vec, srs = 4326)

  expect_true(sf::st_is_longlat(obj4))
  expect_true(sf::st_crs(obj4) == sf::st_crs(4326))
})
