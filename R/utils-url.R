download_url <- function(
  url,
  name = basename(url),
  cache_dir = NULL,
  subdir = NULL,
  update_cache = FALSE,
  verbose = TRUE
) {
  cache_dir <- create_cache_dir(cache_dir)
  if (!is.null(subdir)) {
    cache_dir <- create_cache_dir(file.path(cache_dir, subdir))
  }

  # Create and normalize the destination file path.
  file_local <- file.path(cache_dir, name)
  file_local <- gsub("//", "/", file_local, fixed = TRUE)

  msg <- "Using cache directory {.path {cache_dir}}."
  make_msg("info", verbose, msg)

  # Check whether the file already exists.
  fileoncache <- file.exists(file_local)

  # Return the cached file unless a refresh is requested.
  if (isFALSE(update_cache) && fileoncache) {
    msg <- "Using cached file {.file {file_local}}."
    make_msg("success", verbose, msg)

    return(file_local)
  }

  if (fileoncache) {
    make_msg("warning", verbose, "Refreshing cached file.")
  }

  msg <- "Downloading {.url {url}}."
  make_msg("info", verbose, msg)

  req <- httr2::request(url)
  req <- httr2::req_error(req, is_error = catrnav_never_error)

  req <- httr2::req_options(req, ssl_verifypeer = catrnav_ssl_verify())

  req <- httr2::req_timeout(req, catrnav_timeout())
  req <- httr2::req_retry(req, max_tries = 3)
  if (verbose) {
    req <- httr2::req_progress(req)
  }

  if (!is_online_fun()) {
    cli::cli_alert_danger("No internet connection detected.")
    cli::cli_inform("Returning {.code NULL} because the request cannot run.")
    return(NULL)
  }

  # Use HEAD to determine whether to report the download size.
  get_header <- httr2::req_method(req, "HEAD")
  getsize <- tryCatch(
    req_perform_fun(get_header),
    httr2_failure = function(cnd) {
      report_request_failure(cnd, "download")
      NULL
    }
  )
  if (is.null(getsize)) {
    return(NULL)
  }

  size_dwn <- as.numeric(httr2::resp_header(getsize, "content-length", 0))
  class(size_dwn) <- class(object.size("a"))
  thr <- 20 * (1024^2)
  if (size_dwn > thr) {
    sz_dwn <- paste0(format(size_dwn, units = "auto"), ".")
    make_msg("warning", TRUE, "Download size is ", sz_dwn)
    req <- httr2::req_progress(req)
  }

  file_download <- tempfile(pattern = "download-", tmpdir = cache_dir)
  on.exit(unlink(file_download, force = TRUE), add = TRUE)

  resp <- tryCatch(
    req_perform_fun(req, path = file_download),
    httr2_failure = function(cnd) {
      report_request_failure(cnd, "download")
      NULL
    }
  )
  if (is.null(resp)) {
    return(NULL)
  }

  if (httr2::resp_is_error(resp)) {
    report_http_error(
      url,
      httr2::resp_status(resp),
      httr2::resp_status_desc(resp)
    )
    cli::cli_inform("Returning {.code NULL} because the download failed.")
    return(NULL)
  }
  replace_cached_file(file_download, file_local)
  msg <- "Downloaded file to {.file {file_local}}."
  make_msg("success", verbose, msg)

  file_local
}

replace_cached_file <- function(download, target) {
  if (suppressWarnings(catrnav_file_rename(download, target))) {
    return(invisible(target))
  }

  if (!file.exists(target)) {
    cli::cli_abort("Could not install the downloaded file {.file {target}}.")
  }

  backup <- tempfile(pattern = "cache-backup-", tmpdir = dirname(target))
  if (!catrnav_file_rename(target, backup)) {
    cli::cli_abort("Could not preserve the cached file {.file {target}}.")
  }

  restore_backup <- TRUE
  on.exit(
    {
      if (restore_backup && file.exists(backup)) {
        catrnav_file_rename(backup, target)
      }
    },
    add = TRUE
  )

  if (!catrnav_file_rename(download, target)) {
    cli::cli_abort("Could not install the downloaded file {.file {target}}.")
  }

  restore_backup <- FALSE
  unlink(backup, force = TRUE)
  invisible(target)
}

# nocov start
catrnav_file_rename <- function(...) {
  file.rename(...)
}
# nocov end

req_perform_fun <- function(...) {
  httr2::req_perform(...)
}

is_online_fun <- function(...) {
  httr2::is_online()
}

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

catrnav_ssl_verify <- function() {
  catrnav_http_config(
    "catastronav_ssl_verify",
    "CATASTRONAV_SSL_VERIFY",
    getOption("catastro_ssl_verify", 1L)
  )
}

catrnav_timeout <- function() {
  catrnav_http_config(
    "catastronav_timeout",
    "CATASTRONAV_TIMEOUT",
    getOption("catastro_timeout", 300)
  )
}

catrnav_never_error <- function(...) {
  FALSE
}

report_http_error <- function(
  url,
  status_code = 404,
  status_desc = "Not Found"
) {
  cli::cli_alert_danger(c(
    "HTTP error {.val {status_code}} ({status_desc}):",
    " {.url {url}}."
  ))
  cli::cli_alert_warning(paste0(
    "If this looks like a package bug, open an issue at ",
    "{.url https://github.com/ropenspain/CatastRoNav/issues}."
  ))
}

report_request_failure <- function(cnd, type) {
  request_type <- if (identical(type, "request")) {
    "request"
  } else {
    paste(type, "request")
  }
  cli::cli_alert_danger(paste0(
    "The ",
    request_type,
    " could not be completed."
  ))
  cli::cli_alert_warning("{conditionMessage(cnd)}")
  cli::cli_inform("Returning {.code NULL} because the {type} failed.")
}
