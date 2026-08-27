test_that("download_url() handles offline sessions", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)
  cache_dir <- withr::local_tempdir(pattern = "catrnav-offline-")

  expect_snapshot(
    result <- download_url(
      atom_test_url,
      cache_dir = cache_dir,
      verbose = FALSE
    )
  )
  expect_null(result)
  expect_length(list.files(cache_dir), 0L)
})

test_that("download_url() handles uncached offline sessions", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)

  expect_snapshot(
    result <- download_url(atom_test_url, cache = FALSE, verbose = FALSE)
  )
  expect_null(result)
})

test_that("download_url() handles transport failures", {
  cache_dir <- withr::local_tempdir(pattern = "catrnav-transport-")
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    req_perform_fun = function(...) {
      stop("Simulated transport failure.", call. = FALSE)
    }
  )

  expect_snapshot(
    result <- download_url(
      "https://example.com/data.xml",
      cache_dir = cache_dir,
      verbose = FALSE
    )
  )
  expect_null(result)
  expect_length(list.files(cache_dir), 0L)
})

test_that("download_url() reuses cached files", {
  cache_dir <- withr::local_tempdir(pattern = "catrnav-cache-")
  cached_file <- file.path(cache_dir, basename(atom_test_url))
  writeLines("cached", cached_file)
  local_mocked_bindings(is_online_fun = function(...) {
    testthat::fail("A cached file should not require a network request.")
  })

  expect_snapshot(
    result <- download_url(
      atom_test_url,
      cache_dir = cache_dir,
      verbose = TRUE
    ),
    transform = \(x) gsub(cache_dir, "<cache-dir>", x, fixed = TRUE)
  )
  expect_identical(result, cached_file)
  expect_identical(readLines(result), "cached")
})

test_that("download_url() handles HTTP errors", {
  cache_dir <- withr::local_tempdir(pattern = "catrnav-404-")
  local_mock_http_error()

  expect_snapshot(
    result <- download_url(
      atom_test_url,
      cache_dir = cache_dir,
      update_cache = TRUE,
      verbose = FALSE
    )
  )
  expect_null(result)
  expect_length(list.files(cache_dir), 0L)
})

test_that("download_url() reports cached refreshes and downloads", {
  cache_dir <- withr::local_tempdir(pattern = "catrnav-refresh-")
  cached_file <- file.path(cache_dir, basename(atom_test_url))
  writeLines("cached", cached_file)
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    req_perform_fun = function(req, path) {
      writeLines("fresh", path)
      httr2::response(status_code = 200L, url = atom_test_url)
    }
  )

  expect_snapshot(
    result <- download_url(
      atom_test_url,
      cache_dir = cache_dir,
      update_cache = TRUE,
      verbose = TRUE
    ),
    transform = \(x) gsub(cache_dir, "<cache-dir>", x, fixed = TRUE)
  )
  expect_identical(result, cached_file)
  expect_identical(readLines(result), "fresh")
})

test_that("download_url() downloads and refreshes cached files", {
  skip_on_cran()
  skip_if_offline()
  cache_dir <- withr::local_tempdir(pattern = "catrnav-download-")

  expect_message(
    result <- download_url(
      atom_test_url,
      cache_dir = cache_dir,
      verbose = TRUE
    ),
    "Downloaded file"
  )
  expect_true(file.exists(result))

  expect_message(
    refreshed <- download_url(
      atom_test_url,
      cache_dir = cache_dir,
      update_cache = TRUE,
      verbose = TRUE
    ),
    "Refreshing cached file"
  )
  expect_identical(refreshed, result)
  expect_true(file.exists(refreshed))
})
