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

  skip_on_cran()
  skip_if_offline()

  expect_message(catrnav_atom_get_parcels_db_all(verbose = TRUE))

  expect_true(dir.exists(testdir))

  expect_message(catrnav_clear_cache(config = FALSE, verbose = TRUE))

  # Confirm that the cache directory was deleted.
  expect_false(dir.exists(testdir))

  # Restore the original cache.
  expect_message(catrnav_set_cache_dir(current, verbose = TRUE))
  expect_silent(catrnav_set_cache_dir(current, verbose = FALSE))
  expect_equal(current, Sys.getenv("CATASTRONAV_CACHE_DIR"))
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

test_that("cache configuration is restored after a simulated restart", {
  skip_on_cran()
  withr::local_envvar(CATASTRONAV_CACHE_DIR = NA)

  cache_config <- file.path(
    tools::R_user_dir("CatastRoNav", "config"),
    "CATASTRONAV_CACHE_DIR"
  )
  config_existed <- file.exists(cache_config)
  config_value <- if (config_existed) {
    readLines(cache_config, warn = FALSE)
  } else {
    NULL
  }

  withr::defer({
    unlink(cache_config)
    if (config_existed) {
      dir.create(dirname(cache_config), recursive = TRUE, showWarnings = FALSE)
      writeLines(config_value, cache_config)
    }
  })

  if (config_existed) {
    catrnav_clear_cache(cached_data = FALSE, config = TRUE)
    expect_false(file.exists(cache_config))
  }

  first <- detect_cache_dir_muted()
  created <- create_cache_dir()
  second <- detect_cache_dir_muted()

  expect_identical(first, file.path(tempdir(), "CatastRoNav"))
  expect_identical(first, created)
  expect_identical(first, second)
  expect_true(nzchar(Sys.getenv("CATASTRONAV_CACHE_DIR")))
})

test_that("legacy cache configuration is migrated once", {
  skip_on_cran()
  withr::local_envvar(CATASTRONAV_CACHE_DIR = NA)

  old <- rappdirs::user_config_dir("CatastRoNav", "R")
  new <- tools::R_user_dir("CatastRoNav", "config")
  old_file <- file.path(old, "CATASTRONAV_CACHE_DIR")
  old_lowercase <- file.path(old, "catastronav_cache_dir")
  new_file <- file.path(new, "CATASTRONAV_CACHE_DIR")

  old_values <- lapply(c(old_file, old_lowercase, new_file), function(path) {
    if (file.exists(path)) readLines(path, warn = FALSE) else NULL
  })

  withr::defer({
    unlink(c(old_file, old_lowercase, new_file))
    paths <- c(old_file, old_lowercase, new_file)
    for (i in seq_along(paths)) {
      if (!is.null(old_values[[i]])) {
        dir.create(dirname(paths[i]), recursive = TRUE, showWarnings = FALSE)
        writeLines(old_values[[i]], paths[i])
      }
    }
  })

  unlink(c(old_file, old_lowercase, new_file))
  dir.create(old, recursive = TRUE, showWarnings = FALSE)
  writeLines(tempdir(), old_file)

  expect_message(
    detected <- detect_cache_dir_muted(),
    "cache configuration migrated"
  )
  expect_silent(detected_again <- detect_cache_dir_muted())

  expect_identical(detected, tempdir())
  expect_identical(detected, detected_again)
  expect_identical(Sys.getenv("CATASTRONAV_CACHE_DIR"), detected)
  expect_false(file.exists(old_file))
  expect_true(file.exists(new_file))

  unlink(new_file)
  dir.create(old, recursive = TRUE, showWarnings = FALSE)
  writeLines(tempdir(), old_lowercase)
  Sys.setenv(CATASTRONAV_CACHE_DIR = "")

  expect_message(
    lowercase_detected <- detect_cache_dir_muted(),
    "cache configuration migrated"
  )
  expect_identical(lowercase_detected, tempdir())
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
