test_that("address ATOM data returns NULL when offline", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)

  cdir <- withr::local_tempdir(pattern = "testthat_ex1")
  expect_snapshot(
    result <- catrnav_atom_get_address("Pamplona", cache_dir = cdir)
  )
  expect_null(result)
})

test_that("address ATOM data handles HTTP 404 responses", {
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")
  local_mock_http_error(url = atom_test_url)

  expect_snapshot(result <- catrnav_atom_get_address("Olite", cache_dir = cdir))
  expect_null(result)
})

test_that("address ATOM data reports unknown municipalities", {
  index <- dplyr::tibble(
    munic = "061 El Busto",
    url = "https://example.com/address.zip",
    date = as.Date("2026-01-01")
  )
  local_mocked_bindings(
    catrnav_atom_get_address_db_all = function(...) index
  )

  expect_snapshot(result <- catrnav_atom_get_address("xyxghx"))
  expect_null(result)
})

test_that("address ATOM data can be downloaded", {
  skip_on_cran()
  skip_if_offline()
  cdir <- withr::local_tempdir(pattern = "testthat_ex2")

  expect_message(
    s <- catrnav_atom_get_address("061", verbose = TRUE, cache_dir = cdir),
    "Retrieving information for"
  )
  expect_s3_class(s, "sf")
  expect_gt(nrow(s), 0L)
  expect_gt(ncol(sf::st_drop_geometry(s)), 0L)
  expect_false(is.na(sf::st_crs(s)))
  expect_all_true(sf::st_is_valid(s))
  expect_true(attr(s, "sf_column") %in% names(s))
})

test_that("catrnav_atom_get_address() deprecates cache", {
  withr::local_options(lifecycle_verbosity = "warning")
  local_mocked_bindings(catrnav_atom_read_munic = function(...) NULL)

  expect_warning(
    result <- catrnav_atom_get_address("061", cache = FALSE),
    class = "lifecycle_warning_deprecated"
  )
  expect_null(result)
})

test_that("address downloads reject invalid municipalities before requests", {
  local_mocked_bindings(catrnav_atom_read_munic = function(...) {
    testthat::fail("Invalid inputs must not trigger a request.")
  })

  expect_snapshot(error = TRUE, catrnav_atom_get_address())
  expect_error(catrnav_atom_get_address(NULL), class = "rlang_error")
  expect_error(catrnav_atom_get_address(NA), class = "rlang_error")
  expect_error(catrnav_atom_get_address("  "), class = "rlang_error")
  expect_error(catrnav_atom_get_address(c("201", "061")), class = "rlang_error")
  expect_error(catrnav_atom_get_address(TRUE), class = "rlang_error")
})

test_that("address downloads accept numeric municipality codes", {
  seen <- NULL
  local_mocked_bindings(
    catrnav_atom_get_address_db_all = function(...) {
      dplyr::tibble(munic = "201 Pamplona / Iruña", url = "municipality.zip")
    },
    download_url = function(url, ...) {
      seen <<- url
      NULL
    }
  )

  expect_null(catrnav_atom_get_address(201))
  expect_identical(seen, "municipality.zip")
})
