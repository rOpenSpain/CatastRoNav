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

test_that("municipality readers reject invalid names", {
  expect_snapshot(
    error = TRUE,
    catrnav_atom_read_munic(
      NA_character_,
      db_getter = function(...) NULL,
      db_name = "db"
    )
  )
})

test_that("ATOM parsing retries without an explicit encoding", {
  calls <- 0L
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
    calls <<- calls + 1L
    if (calls == 1L) {
      stop("Encoding failed.")
    }
    feed
  })

  result <- catr_read_atom("feed.xml")

  expect_identical(calls, 2L)
  expect_identical(result$title, "001 Municipality")
})

test_that("ATOM XML can be read without an explicit encoding", {
  source <- tempfile(fileext = ".xml")
  writeLines("<feed></feed>", source)

  expect_type(read_atom_xml(source), "list")
})

test_that("municipality readers handle temporary extracted data", {
  archive <- tempfile(fileext = ".zip")
  writeBin(raw(), archive)
  db <- function(...) {
    dplyr::tibble(
      munic = "201 Pamplona / Iruña",
      url = "https://example.com/data.zip",
      date = as.Date("2026-01-01")
    )
  }
  expected <- sf::st_sf(
    id = 1L,
    geometry = sf::st_sfc(sf::st_point(c(0, 0)), crs = 4326)
  )
  local_mocked_bindings(
    download_url = function(...) archive,
    unzip = function(...) invisible(),
    read_geo_file_sf = function(...) expected
  )

  result <- catrnav_atom_read_munic(
    "Pamplona",
    db_getter = db,
    db_name = "db",
    cache = FALSE
  )
  expect_identical(result, expected)
})
