test_that("building ATOM data returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)
  cdir <- withr::local_tempdir(pattern = "catrnav-bu-offline-")

  expect_snapshot(result <- catrnav_atom_get_buildings("061", cache_dir = cdir))
  expect_null(result)
})

test_that("building ATOM data handles HTTP 404 responses", {
  local_mock_http_error()
  cdir <- withr::local_tempdir(pattern = "catrnav-bu-404-")

  expect_snapshot(result <- catrnav_atom_get_buildings("061", cache_dir = cdir))
  expect_null(result)
})

test_that("building ATOM data can be downloaded", {
  skip_on_cran()
  skip_if_offline()

  expect_snapshot(catrnav_atom_get_buildings("xyxghx", cache = FALSE))

  s <- catrnav_atom_get_buildings("061", verbose = TRUE, cache = FALSE)

  expect_s3_class(s, "sf")
  expect_gt(nrow(s), 0L)
  expect_gt(ncol(sf::st_drop_geometry(s)), 0L)
  expect_false(is.na(sf::st_crs(s)))
  expect_all_true(sf::st_is_valid(s))
  expect_true(attr(s, "sf_column") %in% names(s))
})
