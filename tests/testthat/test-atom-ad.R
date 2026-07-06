test_that("Test offline", {
  skip_on_cran()
  skip_if_offline()

  local_mocked_bindings(is_online_fun = function(...) {
    FALSE
  })

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(
    fend <- catrnav_atom_get_address("Pamplona", cache_dir = cdir)
  )
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

  expect_snapshot(fend <- catrnav_atom_get_address("Olite", cache_dir = cdir))
  expect_null(fend)

  local_mocked_bindings(is_404 = function(...) {
    FALSE
  })
  unlink(cdir, recursive = TRUE, force = TRUE)
  # Otherwise work
  expect_silent(fend <- catrnav_atom_get_address("Olite", cache_dir = cdir))
  expect_gt(nrow(fend), 20)
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
