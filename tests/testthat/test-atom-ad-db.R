test_that("Test offline atom_ad_db", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(fend <- catrnav_atom_get_address_db_all(cache_dir = cdir))
  expect_null(fend)

  local_mocked_bindings(is_online_fun = function(...) {
    httr2::is_online()
  })
  expect_identical(is_online_fun(), httr2::is_online())
})

test_that("Test 404 all", {
  skip_on_cran()
  skip_if_offline()

  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  local_mocked_bindings(is_404 = function(...) {
    TRUE
  })

  expect_snapshot(fend <- catrnav_atom_get_address_db_all(cache_dir = cdir))
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
  # Otherwise work
  expect_silent(fend <- catrnav_atom_get_address_db_all(cache_dir = cdir))
  expect_gt(nrow(fend), 20)
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
