test_that("municipality matching handles cadastral codes and aliases", {
  all <- dplyr::tibble(
    munic = c("202 Pamplona Norte", "201 Pamplona / Iruña", "061 El Busto"),
    url = c("url-1", "url-2", "url-3"),
    date = as.Date("2026-01-01")
  )

  by_name <- catrnav_atom_match_munic(all, "Pamplona")
  expect_identical(by_name$munic[1], "201 Pamplona / Iruña")

  by_alias <- catrnav_atom_match_munic(all, "Iruña")
  expect_identical(by_alias$munic, "201 Pamplona / Iruña")

  by_code <- catrnav_atom_match_munic(all, "061")
  expect_identical(by_code$munic, "061 El Busto")
})

test_that("municipality selection reports ambiguous matches", {
  all <- dplyr::tibble(
    munic = c("201 Pamplona / Iruña", "202 Pamplona Norte"),
    url = c("url-1", "url-2"),
    date = as.Date("2026-01-01")
  )

  expect_snapshot(
    selected <- catrnav_atom_select_munic(
      all,
      "Pamplona",
      db_name = "catrnav_atom_get_address_db_all",
      verbose = TRUE
    )
  )
  expect_identical(selected$munic, "201 Pamplona / Iruña")
})

test_that("ATOM database readers propagate download failures", {
  local_mocked_bindings(download_url = function(...) NULL)

  expect_null(catrnav_atom_read_db_all("https://example.com/feed.xml", "x"))
})

test_that("municipality readers propagate unavailable data", {
  null_db <- function(...) NULL
  expect_null(catrnav_atom_read_munic(
    "Pamplona",
    db_getter = null_db,
    db_name = "null_db"
  ))

  db <- function(...) {
    dplyr::tibble(
      munic = "201 Pamplona / Iruña",
      url = "https://example.com/data.zip",
      date = as.Date("2026-01-01")
    )
  }
  local_mocked_bindings(download_url = function(...) NULL)

  expect_null(catrnav_atom_read_munic(
    "Pamplona",
    db_getter = db,
    db_name = "db"
  ))
})

test_that("ATOM parsing retries without an explicit encoding", {
  env <- new.env(parent = emptyenv())
  env$encodings <- list()
  feed <- list(
    feed = list(
      entry = list(
        content = list(
          div = list(
            ul = list(
              li = list(
                a = structure(
                  list("001 Municipality"),
                  href = "https://example.com/data.zip"
                )
              )
            )
          )
        ),
        updated = "2026-01-01"
      )
    )
  )
  local_mocked_bindings(read_atom_xml = function(file, encoding = NULL) {
    env$encodings <- append(env$encodings, list(encoding))
    if (!is.null(encoding)) {
      stop("Encoding failed.", call. = FALSE)
    }
    feed
  })

  result <- catr_read_atom("feed.xml")

  expect_identical(env$encodings, list("UTF-8", NULL))
  expect_identical(result$title, "001 Municipality")
})

test_that("ATOM XML can be read without an explicit encoding", {
  source <- withr::local_tempfile(fileext = ".xml")
  writeLines("<feed></feed>", source)

  expect_type(read_atom_xml(source), "list")
})

test_that("municipality downloads read cached archives directly", {
  cache_dir <- withr::local_tempdir()
  archive <- file.path(cache_dir, "data.zip")
  writeBin(raw(), archive)
  all <- dplyr::tibble(
    munic = "201 Pamplona / Iruña",
    url = "https://example.com/data.zip"
  )
  expected <- sf::st_sf(
    id = 1L,
    geometry = sf::st_sfc(sf::st_point(c(0, 0)), crs = 4326)
  )
  seen <- list()
  local_mocked_bindings(
    download_url = function(url, subdir, update_cache, ...) {
      seen$subdir <<- subdir
      seen$update_cache <<- update_cache
      archive
    },
    read_geo_file_sf = function(file_local, hint, ...) {
      seen$file <<- file_local
      seen$hint <<- hint
      expected
    }
  )

  result <- catrnav_atom_read_munic(
    "Pamplona",
    db_getter = function(...) all,
    db_name = "db",
    subdir = "atom_cp",
    cache_dir = cache_dir,
    update_cache = TRUE
  )
  expect_identical(result, expected)
  expect_identical(seen$subdir, "atom_cp")
  expect_all_true(seen$update_cache)
  expect_identical(seen$file, archive)
  expect_identical(seen$hint, "\\.gml$")
  expect_identical(list.files(cache_dir), "data.zip")
})

test_that("ATOM indexes retain timestamps in UTC across local time zones", {
  withr::local_timezone("Pacific/Honolulu")
  local_mocked_bindings(read_atom_xml = function(...) {
    list(
      feed = list(
        entry = list(
          content = list(
            div = list(
              ul = list(
                li = list(
                  a = structure(
                    list("001 Municipality"),
                    href = "https://example.com/data.zip"
                  )
                )
              )
            )
          ),
          updated = "2026-01-01T12:30:00Z"
        )
      )
    )
  })

  result <- catr_read_atom("feed.xml")
  expect_identical(result$date, as.POSIXct("2026-01-01 12:30:00", tz = "UTC"))
})

test_that("ATOM timestamps with offsets are converted to UTC", {
  local_mocked_bindings(read_atom_xml = function(...) {
    list(
      feed = list(
        entry = list(
          content = list(
            div = list(
              ul = list(
                li = list(
                  a = structure(
                    list("001 Municipality"),
                    href = "https://example.com/data.zip"
                  )
                )
              )
            )
          ),
          updated = "2026-01-01T12:30:00+02:00"
        )
      )
    )
  })

  result <- catr_read_atom("feed.xml")
  expect_identical(result$date, as.POSIXct("2026-01-01 10:30:00", tz = "UTC"))
})
