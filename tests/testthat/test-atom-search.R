test_that("catrnav_atom_search_munic() returns ordered matches", {
  all <- dplyr::tibble(
    munic = c("201 Pamplona / Iruña", "202 Pamplona Norte", "061 El Busto"),
    url = c("url-1", "url-2", "url-3"),
    date = as.Date("2026-01-01")
  )
  local_mocked_bindings(catrnav_atom_get_address_db_all = function(...) all)

  result <- catrnav_atom_search_munic("Pamplona")

  expect_s3_class(result, "tbl_df")
  expect_named(result, c("munic", "catrcode"))
  expect_identical(result$munic[1], "201 Pamplona / Iruña")
  expect_identical(result$catrcode, c("201", "202"))
})

test_that("catrnav_atom_search_munic() handles missing matches", {
  all <- dplyr::tibble(
    munic = "061 El Busto",
    url = "url",
    date = as.Date("2026-01-01")
  )
  local_mocked_bindings(catrnav_atom_get_address_db_all = function(...) all)

  expect_snapshot(result <- catrnav_atom_search_munic("missing"))
  expect_null(result)
})

test_that("catrnav_atom_search_munic() propagates unavailable indexes", {
  local_mocked_bindings(catrnav_atom_get_address_db_all = function(...) NULL)

  expect_null(catrnav_atom_search_munic("Pamplona"))
})

test_that("catrnav_atom_search_munic() returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)

  expect_snapshot(
    result <- catrnav_atom_search_munic(
      "Pamplona",
      cache = FALSE,
      verbose = FALSE
    )
  )
  expect_null(result)
})

test_that("catrnav_atom_search_munic() returns NULL after HTTP errors", {
  local_mock_http_error()

  expect_snapshot(
    result <- catrnav_atom_search_munic(
      "Pamplona",
      cache = FALSE,
      update_cache = TRUE,
      verbose = FALSE
    )
  )
  expect_null(result)
})

test_that("catrnav_atom_search_munic() downloads and filters matches", {
  skip_on_cran()
  skip_if_offline()
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  a <- catrnav_atom_search_munic("ona", cache_dir = cdir)
  expect_gt(nrow(a), 1)

  # Try more restrictive
  b <- catrnav_atom_search_munic("Pamplona", cache_dir = cdir)

  expect_s3_class(a, "tbl_df")
  expect_gt(nrow(a), nrow(b))

  # Try with no result

  expect_snapshot(c <- catrnav_atom_search_munic("XXX", cache_dir = cdir))
  expect_null(c)
})
