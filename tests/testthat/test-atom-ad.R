test_that("address ATOM data returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(
    result <- catrnav_atom_get_address("Pamplona", cache_dir = cdir)
  )
  expect_null(result)

  local_mocked_bindings(is_online_fun = function(...) httr2::is_online())
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("address ATOM data handles HTTP 404 responses", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  local_mock_http_error(url = atom_test_url)

  expect_snapshot(result <- catrnav_atom_get_address("Olite", cache_dir = cdir))
  expect_null(result)
})

test_that("address ATOM data can be downloaded", {
  skip_on_cran()
  skip_if_offline()
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  expect_snapshot(catrnav_atom_get_address("xyxghx", cache_dir = cdir))

  expect_message(
    s <- catrnav_atom_get_address("061", verbose = TRUE, cache_dir = cdir),
    "Retrieving information for"
  )
  expect_s3_class(s, "sf")
})
