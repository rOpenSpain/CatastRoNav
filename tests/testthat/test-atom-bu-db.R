test_that("building ATOM index returns NULL when offline", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(is_online_fun = function(...) FALSE)
  cdir <- withr::local_tempdir(pattern = "catrnav-bu-db-offline-")

  expect_snapshot(result <- catrnav_atom_get_buildings_db_all(cache_dir = cdir))
  expect_null(result)
})

test_that("building ATOM index handles HTTP 404 responses", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(is_404 = function(...) TRUE)
  cdir <- withr::local_tempdir(pattern = "catrnav-bu-db-404-")

  expect_snapshot(result <- catrnav_atom_get_buildings_db_all(cache_dir = cdir))
  expect_null(result)
})

test_that("building ATOM index can be downloaded", {
  skip_on_cran()
  skip_if_offline()
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  expect_message(catrnav_atom_get_buildings_db_all(
    verbose = TRUE,
    cache_dir = cdir
  ))
})
