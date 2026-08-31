test_that("HTTP configuration reads environment variables", {
  withr::local_options(list(
    catastronav_ssl_verify = NULL,
    catastronav_timeout = NULL,
    catastro_ssl_verify = NULL,
    catastro_timeout = NULL
  ))
  withr::local_envvar(c(
    CATASTRONAV_SSL_VERIFY = "0",
    CATASTRONAV_TIMEOUT = "600"
  ))

  expect_equal(catrnav_ssl_verify(), 0)
  expect_equal(catrnav_timeout(), 600)

  withr::local_envvar(c(
    CATASTRONAV_SSL_VERIFY = NA,
    CATASTRONAV_TIMEOUT = NA
  ))
  expect_equal(catrnav_ssl_verify(), 1L)
  expect_equal(catrnav_timeout(), 300)

  withr::local_envvar(c(
    CATASTRONAV_SSL_VERIFY = "invalid",
    CATASTRONAV_TIMEOUT = "invalid"
  ))
  expect_equal(catrnav_ssl_verify(), 1L)
  expect_equal(catrnav_timeout(), 300)
})

test_that("HTTP configuration gives options precedence over environment", {
  withr::local_options(list(
    catastronav_ssl_verify = 1L,
    catastronav_timeout = 30
  ))
  withr::local_envvar(c(
    CATASTRONAV_SSL_VERIFY = "0",
    CATASTRONAV_TIMEOUT = "600"
  ))

  expect_equal(catrnav_ssl_verify(), 1L)
  expect_equal(catrnav_timeout(), 30)
})

test_that("HTTP configuration falls back to CatastRo options", {
  withr::local_options(list(
    catastronav_ssl_verify = NULL,
    catastronav_timeout = NULL,
    catastro_ssl_verify = 0,
    catastro_timeout = 120
  ))
  withr::local_envvar(c(
    CATASTRONAV_SSL_VERIFY = NA,
    CATASTRONAV_TIMEOUT = NA
  ))

  expect_equal(catrnav_ssl_verify(), 0)
  expect_equal(catrnav_timeout(), 120)
})

test_that("downloads apply HTTP environment settings", {
  withr::local_options(list(
    catastronav_ssl_verify = NULL,
    catastronav_timeout = NULL,
    catastro_ssl_verify = NULL,
    catastro_timeout = NULL
  ))
  withr::local_envvar(c(
    CATASTRONAV_SSL_VERIFY = "0",
    CATASTRONAV_TIMEOUT = "600"
  ))

  seen <- NULL
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    req_perform_fun = function(req, path, ...) {
      seen <<- req$options
      writeLines("ok", path)
      httr2::response(status_code = 200)
    }
  )

  cache_dir <- withr::local_tempdir(pattern = "catrnav-envvar-")
  result <- download_url(
    "https://example.com/envvar.txt",
    cache_dir = cache_dir,
    verbose = FALSE
  )

  expect_type(result, "character")
  expect_equal(seen$ssl_verifypeer, 0)
  expect_equal(seen$timeout_ms, 600000)
})

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
    transform = function(x) {
      x <- gsub(cache_dir, "<cache-dir>", x, fixed = TRUE)
      gsub('"[0-9]+ bytes"', '"<n> bytes"', x)
    }
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
