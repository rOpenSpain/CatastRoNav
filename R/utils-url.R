#' Download and cache a file from a URL
#'
#' @param url A character string containing the URL to download.
#' @param name A character string specifying the destination file name.
#' @param cache_dir A character string specifying the cache directory.
#' @param update_cache A logical value indicating whether to refresh the cached
#'   file.
#' @param cache A logical value indicating whether to cache the downloaded file.
#' @param verbose A logical value indicating whether to display informational
#'   messages.
#'
#' @return A character string containing the downloaded file path, or `NULL` if
#'   the download fails.
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
    make_msg("success", verbose, "Using cached file {.file ", file_local, "}.")
    return(file_local)
  }

  if (isTRUE(cache) && file_on_cache) {
    make_msg("info", verbose, "Refreshing cached file.")
  }

  make_msg("info", verbose, "Downloading {.url ", url, "}.")

  if (!is_online_fun()) {
    cli::cli_alert_danger("No internet connection detected.")
    cli::cli_alert("Returning {.code NULL} because the request cannot run.")
    return(NULL)
  }

  req <- httr2::request(url)
  req <- httr2::req_error(req, is_error = function(resp) {
    FALSE
  })
  req <- httr2::req_options(
    req,
    ssl_verifypeer = catrnav_ssl_verify()
  )
  req <- httr2::req_timeout(req, catrnav_timeout())
  req <- httr2::req_retry(req, max_tries = 3)

  if (verbose) {
    req <- httr2::req_progress(req)
  }

  resp <- tryCatch(
    req_perform_fun(req, path = file_local),
    error = function(cnd) {
      unlink(file_local, force = TRUE)
      cli::cli_alert_danger("Download failed for {.url {url}}.")
      cli::cli_alert(
        "Returning {.code NULL}. Reason: {.emph {conditionMessage(cnd)}}"
      )
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
      "HTTP error {.val {status}} ({.emph {description}}): {.url {url}}."
    )
    cli::cli_alert_warning(paste0(
      "If this looks like a package bug, open an issue at ",
      "{.url https://github.com/ropenspain/CatastRoNav/issues}."
    ))
    cli::cli_alert("Returning {.code NULL} because the download failed.")
    return(NULL)
  }

  if (verbose) {
    size <- file.size(file_local)
    class(size) <- class(object.size("a"))
    cli::cli_alert_success(paste0(
      "Downloaded file to {.file {file_local}} ",
      "({.val {format(size, units = 'auto')}})."
    ))
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

#' Get an HTTP configuration value from options or environment variables
#'
#' @noRd
catrnav_http_config <- function(option, envvar, default) {
  opt <- getOption(option, NULL)
  if (!is.null(opt)) {
    return(opt)
  }

  env <- Sys.getenv(envvar, unset = NA_character_)
  if (is.na(env) || identical(env, "")) {
    return(default)
  }

  env_num <- suppressWarnings(as.numeric(env))
  if (is.na(env_num)) {
    return(default)
  }

  env_num
}

#' Get the SSL verification setting for CatastRoNav HTTP requests
#'
#' @noRd
catrnav_ssl_verify <- function() {
  catrnav_http_config(
    "catastronav_ssl_verify",
    "CATASTRONAV_SSL_VERIFY",
    getOption("catastro_ssl_verify", 1L)
  )
}

#' Get the timeout setting for CatastRoNav HTTP requests
#'
#' @noRd
catrnav_timeout <- function() {
  catrnav_http_config(
    "catastronav_timeout",
    "CATASTRONAV_TIMEOUT",
    getOption("catastro_timeout", 300)
  )
}
