test_that("parcel ATOM data returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)
  cdir <- withr::local_tempdir(pattern = "catrnav-cp-offline-")

  expect_snapshot(result <- catrnav_atom_get_parcels("061", cache_dir = cdir))
  expect_null(result)
})

test_that("parcel ATOM data handles HTTP 404 responses", {
  local_mock_http_error()
  cdir <- withr::local_tempdir(pattern = "catrnav-cp-404-")

  expect_snapshot(result <- catrnav_atom_get_parcels("061", cache_dir = cdir))
  expect_null(result)
})

test_that("parcel ATOM data reports unknown municipalities", {
  index <- dplyr::tibble(
    munic = "061 El Busto",
    url = "https://example.com/parcel.zip",
    date = as.Date("2026-01-01")
  )
  local_mocked_bindings(
    catrnav_atom_get_parcels_db_all = function(...) index
  )

  expect_snapshot(result <- catrnav_atom_get_parcels("xyxghx"))
  expect_null(result)
})

test_that("parcel ATOM data can be downloaded", {
  skip_on_cran()
  skip_if_offline()

  s <- catrnav_atom_get_parcels(
    "061",
    verbose = TRUE,
    cache_dir = withr::local_tempdir()
  )

  expect_s3_class(s, "sf")
  expect_gt(nrow(s), 0L)
  expect_gt(ncol(sf::st_drop_geometry(s)), 0L)
  expect_false(is.na(sf::st_crs(s)))
  expect_all_true(sf::st_is_valid(s))
  expect_true(attr(s, "sf_column") %in% names(s))
})

test_that("catrnav_atom_get_parcels() deprecates cache", {
  withr::local_options(lifecycle_verbosity = "warning")
  local_mocked_bindings(catrnav_atom_read_munic = function(...) NULL)

  expect_warning(
    result <- catrnav_atom_get_parcels("061", cache = FALSE),
    class = "lifecycle_warning_deprecated"
  )
  expect_null(result)
})

test_that("parcels downloads reject invalid municipalities before requests", {
  local_mocked_bindings(catrnav_atom_read_munic = function(...) {
    testthat::fail("Invalid inputs must not trigger a request.")
  })

  expect_snapshot(error = TRUE, catrnav_atom_get_parcels())
  expect_error(catrnav_atom_get_parcels(NULL), class = "rlang_error")
  expect_error(catrnav_atom_get_parcels(NA), class = "rlang_error")
  expect_error(catrnav_atom_get_parcels("  "), class = "rlang_error")
  expect_error(catrnav_atom_get_parcels(c("201", "061")), class = "rlang_error")
  expect_error(catrnav_atom_get_parcels(TRUE), class = "rlang_error")
})

test_that("parcels downloads accept numeric municipality codes", {
  seen <- NULL
  local_mocked_bindings(
    catrnav_atom_get_parcels_db_all = function(...) {
      dplyr::tibble(munic = "201 Pamplona / Iruña", url = "municipality.zip")
    },
    download_url = function(url, ...) {
      seen <<- url
      NULL
    }
  )

  expect_null(catrnav_atom_get_parcels(201))
  expect_identical(seen, "municipality.zip")
})
