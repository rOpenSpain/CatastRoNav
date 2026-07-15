test_that("cache directory can be set and cleared", {
  # Preserve the current cache directory.
  current <- detect_cache_dir_muted()
  withr::defer(catrnav_set_cache_dir(current, verbose = FALSE))

  # Set a temporary cache directory.
  expect_message(catrnav_set_cache_dir(verbose = TRUE))
  testdir <- expect_silent(catrnav_set_cache_dir(
    file.path(current, "testthat"),
    verbose = FALSE
  ))
  expect_message(detected <- catrnav_detect_cache_dir())
  expect_identical(detected, testdir)

  # Clear cached data.
  expect_silent(catrnav_clear_cache(config = FALSE, verbose = FALSE))
  # Confirm that the cache directory was deleted.
  expect_false(dir.exists(testdir))

  # Reset the cache to exercise verbose deletion.
  testdir <- file.path(tempdir(), "CatastRo", "testthat")
  expect_message(catrnav_set_cache_dir(testdir))
  writeLines("cached", file.path(testdir, "cached-file.txt"))

  expect_true(dir.exists(testdir))

  expect_message(catrnav_clear_cache(config = FALSE, verbose = TRUE))

  # Confirm that the cache directory was deleted.
  expect_false(dir.exists(testdir))

  # Restore the original cache.
  expect_message(catrnav_set_cache_dir(current, verbose = TRUE))
  expect_silent(catrnav_set_cache_dir(current, verbose = FALSE))
  expect_identical(current, Sys.getenv("CATASTRONAV_CACHE_DIR"))
  expect_true(dir.exists(current))
})

test_that("cache helpers create and reuse directories", {
  cache_dir <- withr::local_tempdir(pattern = "catrnav-cache-")
  nested <- file.path(cache_dir, "nested")

  expect_identical(create_cache_dir(nested), nested)
  expect_true(dir.exists(nested))

  withr::local_envvar(CATASTRONAV_CACHE_DIR = nested)
  expect_identical(detect_cache_dir_muted(), nested)
  expect_identical(create_cache_dir(), nested)
})

test_that("cache configuration can be installed and overwritten", {
  config_parent <- withr::local_tempdir(pattern = "catrnav-config-")
  config_dir <- file.path(config_parent, "config")
  cache_dir <- withr::local_tempdir(pattern = "catrnav-cache-")
  other_cache_dir <- withr::local_tempdir(pattern = "catrnav-cache-")
  local_mocked_bindings(catrnav_user_config_dir = function() config_dir)

  expect_silent(catrnav_set_cache_dir(
    cache_dir,
    install = TRUE,
    verbose = FALSE
  ))

  config_file <- file.path(config_dir, "CATASTRONAV_CACHE_DIR")
  expect_identical(readLines(config_file, warn = FALSE), cache_dir)

  expect_snapshot(
    error = TRUE,
    catrnav_set_cache_dir(
      other_cache_dir,
      install = TRUE,
      verbose = FALSE
    )
  )

  expect_silent(catrnav_set_cache_dir(
    other_cache_dir,
    install = TRUE,
    overwrite = TRUE,
    verbose = FALSE
  ))
  expect_identical(readLines(config_file, warn = FALSE), other_cache_dir)
})

test_that("cache configuration can be restored after a simulated restart", {
  config_dir <- withr::local_tempdir(pattern = "catrnav-config-")
  cache_dir <- withr::local_tempdir(pattern = "catrnav-cache-")
  config_file <- file.path(config_dir, "CATASTRONAV_CACHE_DIR")
  writeLines(cache_dir, config_file)

  local_mocked_bindings(catrnav_user_config_dir = function() config_dir)
  withr::local_envvar(CATASTRONAV_CACHE_DIR = NA)

  expect_identical(detect_cache_dir_muted(), cache_dir)
  expect_identical(Sys.getenv("CATASTRONAV_CACHE_DIR"), cache_dir)
})

test_that("invalid cache configuration falls back to a temporary cache", {
  config_dir <- withr::local_tempdir(pattern = "catrnav-config-")
  config_file <- file.path(config_dir, "CATASTRONAV_CACHE_DIR")
  local_mocked_bindings(catrnav_user_config_dir = function() config_dir)
  withr::local_envvar(CATASTRONAV_CACHE_DIR = NA)

  writeLines(character(), config_file)
  empty <- detect_cache_dir_muted()
  expect_identical(empty, file.path(tempdir(), "CatastRoNav"))

  Sys.setenv(CATASTRONAV_CACHE_DIR = "")
  writeLines(c("one", "two"), config_file)
  multiple <- detect_cache_dir_muted()
  expect_identical(multiple, file.path(tempdir(), "CatastRoNav"))
})

test_that("cache configuration can be cleared", {
  config_dir <- withr::local_tempdir(pattern = "catrnav-config-")
  cache_dir <- withr::local_tempdir(pattern = "catrnav-cache-")
  writeLines("configured", file.path(config_dir, "CATASTRONAV_CACHE_DIR"))

  local_mocked_bindings(catrnav_user_config_dir = function() config_dir)
  withr::local_envvar(CATASTRONAV_CACHE_DIR = cache_dir)

  expect_message(catrnav_clear_cache(
    config = TRUE,
    cached_data = FALSE,
    verbose = TRUE
  ))

  expect_false(dir.exists(config_dir))
  expect_identical(Sys.getenv("CATASTRONAV_CACHE_DIR"), "")
})

test_that("cache configuration defaults after a simulated restart", {
  config_dir <- withr::local_tempdir(pattern = "catrnav-config-")
  local_mocked_bindings(catrnav_user_config_dir = function() config_dir)
  withr::local_envvar(CATASTRONAV_CACHE_DIR = NA)

  first <- detect_cache_dir_muted()
  created <- create_cache_dir()
  second <- detect_cache_dir_muted()

  expect_identical(first, file.path(tempdir(), "CatastRoNav"))
  expect_identical(first, created)
  expect_identical(first, second)
  expect_true(nzchar(Sys.getenv("CATASTRONAV_CACHE_DIR")))
})

test_that("legacy cache configuration is migrated once", {
  old <- withr::local_tempdir(pattern = "catrnav-old-config-")
  new <- withr::local_tempdir(pattern = "catrnav-new-config-")
  local_mocked_bindings(catrnav_user_config_dir = function() new)
  withr::local_envvar(CATASTRONAV_CACHE_DIR = NA)

  old_file <- file.path(old, "CATASTRONAV_CACHE_DIR")
  old_lowercase <- file.path(old, "catastronav_cache_dir")
  new_file <- file.path(new, "CATASTRONAV_CACHE_DIR")

  writeLines(tempdir(), old_file)

  expect_message(
    migrate_cache(old = old, new = new),
    "cache configuration migrated"
  )

  expect_identical(readLines(new_file, warn = FALSE), tempdir())
  expect_identical(Sys.getenv("CATASTRONAV_CACHE_DIR"), tempdir())
  expect_false(file.exists(old_file))
  expect_true(file.exists(new_file))

  unlink(new_file)
  dir.create(old, recursive = TRUE)
  writeLines(tempdir(), old_lowercase)
  Sys.setenv(CATASTRONAV_CACHE_DIR = "")

  expect_message(
    migrate_cache(old = old, new = new),
    "cache configuration migrated"
  )
  expect_identical(readLines(new_file, warn = FALSE), tempdir())
  expect_identical(Sys.getenv("CATASTRONAV_CACHE_DIR"), tempdir())
  expect_false(file.exists(old_lowercase))
  expect_true(file.exists(new_file))
})

test_that("migration removes obsolete configuration directories", {
  old <- withr::local_tempdir(pattern = "catrnav-old-config-")
  new <- withr::local_tempdir(pattern = "catrnav-new-config-")
  writeLines("obsolete", file.path(old, "CATASTRONAV_CACHE_DIR"))
  writeLines(tempdir(), file.path(new, "CATASTRONAV_CACHE_DIR"))

  expect_silent(migrate_cache(old = old, new = new))
  expect_false(dir.exists(old))
})

test_that("cache_dir = FALSE uses a nonpersistent temporary cache", {
  withr::local_envvar(CATASTRONAV_CACHE_DIR = NA)

  expect_message(
    cache_dir <- catrnav_set_cache_dir(
      cache_dir = FALSE,
      install = TRUE,
      verbose = TRUE
    ),
    "temporary cache directory"
  )

  expect_identical(cache_dir, file.path(tempdir(), "CatastRoNav"))
  expect_identical(Sys.getenv("CATASTRONAV_CACHE_DIR"), cache_dir)
})

test_that("catrnav_user_config_dir() wraps tools::R_user_dir()", {
  expect_identical(
    catrnav_user_config_dir(),
    tools::R_user_dir("CatastRoNav", "config")
  )
})

test_that("catrnav_set_cache_dir() validates arguments", {
  expect_snapshot(
    error = TRUE,
    catrnav_set_cache_dir(cache_dir = 1, verbose = FALSE)
  )
  expect_snapshot(
    error = TRUE,
    catrnav_set_cache_dir(overwrite = NA, verbose = FALSE)
  )
  expect_snapshot(
    error = TRUE,
    catrnav_set_cache_dir(
      cache_dir = tempdir(),
      install = c(TRUE, FALSE),
      verbose = FALSE
    )
  )
  expect_snapshot(error = TRUE, catrnav_set_cache_dir(verbose = NA))
})

test_that("catrnav_clear_cache() validates arguments", {
  expect_snapshot(error = TRUE, catrnav_clear_cache(config = NA))
  expect_snapshot(error = TRUE, catrnav_clear_cache(cached_data = NA))
  expect_snapshot(error = TRUE, catrnav_clear_cache(verbose = NA))
})
