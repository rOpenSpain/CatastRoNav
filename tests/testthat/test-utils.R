test_that("Check bbox work", {
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
