test_that("parcel ATOM data returns NULL when offline", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(is_online_fun = function(...) FALSE)
  cdir <- withr::local_tempdir(pattern = "catrnav-cp-offline-")

  expect_snapshot(
    result <- catrnav_atom_get_parcels("061", cache_dir = cdir)
  )
  expect_null(result)
})

test_that("parcel ATOM data handles HTTP 404 responses", {
  skip_on_cran()
  skip_if_offline()
  local_mocked_bindings(is_404 = function(...) TRUE)
  cdir <- withr::local_tempdir(pattern = "catrnav-cp-404-")

  expect_snapshot(
    result <- catrnav_atom_get_parcels("061", cache_dir = cdir)
  )
  expect_null(result)
})

test_that("parcel ATOM data can be downloaded", {
  skip_on_cran()
  skip_if_offline()

  expect_snapshot(catrnav_atom_get_parcels("xyxghx", cache = FALSE))

  s <- catrnav_atom_get_parcels("061", verbose = TRUE, cache = FALSE)

  expect_s3_class(s, "sf")
})
