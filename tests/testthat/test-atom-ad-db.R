test_that("address ATOM index returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(result <- catrnav_atom_get_address_db_all(cache_dir = cdir))
  expect_null(result)

  local_mocked_bindings(is_online_fun = function(...) httr2::is_online())
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("address ATOM index handles HTTP 404 responses", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  local_mock_http_error()

  expect_snapshot(result <- catrnav_atom_get_address_db_all(cache_dir = cdir))
  expect_null(result)
})

test_that("address ATOM index can be downloaded", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  expect_message(catrnav_atom_get_address_db_all(
    verbose = TRUE,
    cache_dir = cdir
  ))
})
