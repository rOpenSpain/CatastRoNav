#' Download and cache a file from a URL
#'
#' @param url Character string containing the URL to download.
#' @param name Character string specifying the destination file name.
#' @param cache_dir Character string specifying the cache directory.
#' @param update_cache Logical. Whether to refresh the cached file.
#' @param cache Logical. Whether to cache the downloaded file.
#' @param verbose Logical. Whether to display informational messages.
#'
#' @return A character string containing the downloaded file path. Returns
#'   `NULL` if the download fails.
#'
#' @noRd
download_url <- function(
  url,
  name = basename(url),
  cache_dir = NULL,
  update_cache = FALSE,
  cache = TRUE,
  verbose = TRUE
) {
  url <- gsub("^http:", "https:", url)
  url <- URLencode(url)

  if (isFALSE(cache)) {
    cache_dir <- tempdir()
  } else {
    cache_dir <- create_cache_dir(cache_dir)
  }

  file_local <- file.path(cache_dir, name)
  file_on_cache <- file.exists(file_local)

  if (isTRUE(cache) && isFALSE(update_cache) && file_on_cache) {
    make_msg(
      "success",
      verbose,
      "Using cached file {.file ",
      file_local,
      "}."
    )
    return(file_local)
  }

  if (isTRUE(cache) && file_on_cache) {
    make_msg("warning", verbose, "Refreshing cached file.")
  }

  make_msg("info", verbose, "Downloading {.url ", url, "}.")

  if (!is_online_fun()) {
    cli::cli_alert_danger("No internet connection detected.")
    cli::cli_alert("Returning {.val NULL} because the request cannot run.")
    return(NULL)
  }

  req <- httr2::request(url)
  req <- httr2::req_error(req, is_error = function(resp) {
    FALSE
  })
  req <- httr2::req_options(
    req,
    ssl_verifypeer = getOption(
      "catastronav_ssl_verify",
      getOption("catastro_ssl_verify", 1L)
    )
  )
  req <- httr2::req_timeout(
    req,
    getOption("catastronav_timeout", getOption("catastro_timeout", 300))
  )
  req <- httr2::req_retry(req, max_tries = 3)

  if (verbose) {
    req <- httr2::req_progress(req)
  }

  if (is_404()) {
    req <- httr2::req_url(
      req,
      "https://ropenspain.github.io/CatastRoNav/fake_url"
    )
    file_local <- tempfile(fileext = ".txt")
  }

  resp <- tryCatch(
    req_perform_fun(req, path = file_local),
    error = function(cnd) {
      unlink(file_local, force = TRUE)
      cli::cli_alert_danger("Download failed for {.url {url}}.")
      cli::cli_alert("Returning {.val NULL}: {conditionMessage(cnd)}")
      NULL
    }
  )

  if (is.null(resp)) {
    return(NULL)
  }

  if (httr2::resp_is_error(resp)) {
    unlink(file_local, force = TRUE)
    status <- httr2::resp_status(resp) # nolint
    description <- httr2::resp_status_desc(resp) # nolint
    cli::cli_alert_danger(
      "HTTP error {.val {status}} ({description}): {.url {url}}."
    )
    cli::cli_alert_warning(paste0(
      "If this looks like a package bug, open an issue at ",
      "{.url https://github.com/ropenspain/CatastRoNav/issues}."
    ))
    cli::cli_alert("Returning {.val NULL} because the download failed.")
    return(NULL)
  }

  if (verbose) {
    size <- file.size(file_local)
    class(size) <- class(object.size("a"))
    cli::cli_alert_success(
      paste0(
        "Downloaded file to {.file {file_local}} ",
        "({format(size, units = 'auto')})."
      )
    )
  }

  file_local
}

req_perform_fun <- function(...) {
  httr2::req_perform(...)
}

#' Wrap `httr2::is_online()` for testing
#'
#' @noRd
is_online_fun <- function(...) {
  httr2::is_online()
}

#' Report a simulated HTTP 404 response for testing
#'
#' @noRd
is_404 <- function(...) {
  FALSE
}
