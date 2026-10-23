test_that("building WFS validates bounding boxes", {
  expect_error(
    catrnav_wfs_get_buildings_bbox(c(1, 2, 3)),
    class = "rlang_error"
  )
})

test_that("building WFS uses the building service contract", {
  state <- new.env(parent = emptyenv())
  state$received <- NULL
  local_mocked_bindings(inspire_wfs_get_fun = function(...) {
    state$received <- list(...)
    NULL
  })

  result <- catrnav_wfs_get_buildings_bbox(
    c(-1, 40, 0, 41),
    srs = 4326,
    count = 10
  )

  expect_null(result)
  expect_identical(state$received$path, "services/BU/wfs")
  expect_identical(state$received$query$typenames, "BU:Building")
  expect_identical(state$received$query$count, 10)
})

test_that("building WFS downloads features", {
  skip_on_cran()
  skip_if_offline()

  result <- catrnav_wfs_get_buildings_bbox(
    c(1071071, 4747924, 1071171, 4748024),
    srs = 25829
  )

  expect_s3_class(result, "sf")
  expect_gt(nrow(result), 0L)
  expect_equal(sf::st_crs(result), sf::st_crs(25829))
  expect_all_true(sf::st_is_valid(result))
})
