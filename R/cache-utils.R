#' Set your \pkg{CatastRoNav} cache directory
#'
#' @description
#' Configures the cache directory used by \pkg{CatastRoNav}. Use
#' `Sys.getenv("CATASTRONAV_CACHE_DIR")` or
#' [catrnav_detect_cache_dir()] to inspect the current path.
#'
#' @details
#' By default, when no `cache_dir` is set, \pkg{CatastRoNav} uses a directory
#' inside [base::tempdir()]. Files in this directory are temporary and are
#' removed when the \R session ends. To persist a cache across \R sessions, use
#' `catrnav_set_cache_dir(cache_dir, install = TRUE)`. This writes the chosen
#' path to a configuration file under
#' `tools::R_user_dir("CatastRoNav", "config")`.
#'
#' @param overwrite A logical value indicating whether to overwrite an existing
#'   `CATASTRONAV_CACHE_DIR` value.
#' @inheritParams CatastRo::catr_set_cache_dir cache_dir install verbose
#'
#' @return
#' `catrnav_set_cache_dir()` invisibly returns the cache path as a character
#' string. It is primarily called for its side effect.
#'
#' @section Caching strategies:
#'
#' Source files are cached after download. \pkg{CatastRoNav} implements the
#' following caching options:
#'
#' - For occasional use, rely on the default [tempdir()]-based cache without
#'   installing a persistent path.
#' - Modify the cache for a single session by setting
#'   `catrnav_set_cache_dir(cache_dir = "a/path/here")`.
#' - For reproducible workflows, install a persistent cache with
#'   `catrnav_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`.
#'   This cache is kept across \R sessions.
#' - To cache specific files elsewhere, use the `cache_dir` argument in the
#'   corresponding function.
#'
#' Cached files can occasionally become corrupt. In that case, download the
#' data again by setting `update_cache = TRUE` in the corresponding function.
#'
#' If a download fails, use `verbose = TRUE` to inspect the request and
#' [catrnav_detect_cache_dir()] to identify the active cache path.
#'
#' @note
#' The configuration location has moved from
#' `rappdirs::user_config_dir("CatastRoNav", "R")` to
#' `tools::R_user_dir("CatastRoNav", "config")`. Existing configuration files
#' are migrated automatically. A migration message is shown only once.
#'
#' @inherit CatastRo::catr_set_cache_dir seealso
#'
#' @family cache_utilities
#' @rdname catrnav_set_cache_dir
#' @encoding UTF-8
#' @export
#' @examples
#'
#' # Caution! This modifies your current state.
#' \dontrun{
#' my_cache <- catrnav_detect_cache_dir()
#'
#' example_cache <- file.path(tempdir(), "example", "cache")
#' catrnav_set_cache_dir(example_cache)
#'
#' catrnav_detect_cache_dir()
#'
#' # Restore the initial cache.
#' catrnav_set_cache_dir(my_cache)
#' identical(my_cache, catrnav_detect_cache_dir())
#' }
catrnav_set_cache_dir <- function(
  cache_dir = NULL,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
) {
  validate_flag(overwrite, "overwrite")
  validate_flag(install, "install")
  validate_flag(verbose, "verbose")

  if (isFALSE(cache_dir)) {
    cache_dir <- NULL
  } else {
    cache_dir <- ensure_null(cache_dir)
  }

  if (is.null(cache_dir)) {
    if (verbose) {
      cli::cli_alert_info(paste0(
        "Using a temporary cache directory (see {.fn base::tempdir}). ",
        "Set {.arg cache_dir} to a path to make the cache persistent."
      ))
    }
    cache_dir <- file.path(tempdir(), "CatastRoNav")
    is_temp <- TRUE
    install <- FALSE
  } else {
    is_temp <- FALSE
  }

  if (!is.character(cache_dir) || length(cache_dir) != 1L || is.na(cache_dir)) {
    cli::cli_abort("{.arg cache_dir} must be a single {.cls character} value.")
  }
  cache_dir <- create_cache_dir(cache_dir)
  make_msg(
    "info",
    verbose,
    "{.pkg CatastRoNav} cache directory is {.path ",
    cache_dir,
    "}."
  )

  # nocov start
  if (install) {
    config_dir <- tools::R_user_dir("CatastRoNav", "config")
    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE)
    }

    catastronav_file <- file.path(config_dir, "CATASTRONAV_CACHE_DIR")

    if (!file.exists(catastronav_file) || overwrite) {
      writeLines(cache_dir, con = catastronav_file)
    } else {
      cli::cli_abort(c(
        "A {.arg cache_dir} value is already configured.",
        "Set {.arg overwrite} to {.code TRUE} to replace it."
      ))
    }
    # nocov end
  } else {
    make_msg(
      "info",
      verbose && !is_temp,
      "To reuse this cache directory in future sessions, ",
      "set {.arg install} to {.code TRUE}."
    )
  }

  Sys.setenv(CATASTRONAV_CACHE_DIR = cache_dir)
  invisible(cache_dir)
}


#' @return
#' `catrnav_detect_cache_dir()` returns the cache path used in the current
#' session.
#'
#' @rdname catrnav_set_cache_dir
#' @encoding UTF-8
#' @export
#' @examples
#'
#' catrnav_detect_cache_dir()
catrnav_detect_cache_dir <- function() {
  cache <- detect_cache_dir_muted()
  cli::cli_alert_info("{.path {cache}}")
  cache
}

#' Clear your \pkg{CatastRoNav} cache directory
#'
#' @description
#' Use this function with caution. It clears cached data and configuration,
#' specifically:
#'
#' - Deletes the \pkg{CatastRoNav} configuration directory
#'   (`tools::R_user_dir("CatastRoNav", "config")`).
#' - Deletes the `cache_dir` directory.
#' - Clears the `CATASTRONAV_CACHE_DIR` environment variable.
#'
#' @details
#' This function resets the cache state as if you had never used
#' \pkg{CatastRoNav}.
#'
#' @param config A logical value indicating whether to delete the
#'   \pkg{CatastRoNav} configuration directory.
#' @inheritParams CatastRo::catr_clear_cache cached_data verbose
#'
#' @return `NULL`, invisibly. This function is called for its side effects.
#'
#' @inherit CatastRo::catr_clear_cache seealso
#'
#' @family cache_utilities
#' @rdname catrnav_clear_cache
#' @encoding UTF-8
#' @export
#' @examples
#'
#' # Caution! This modifies your current state.
#' \dontrun{
#' my_cache <- catrnav_detect_cache_dir()
#'
#' example_cache <- file.path(tempdir(), "example", "cache")
#' catrnav_set_cache_dir(example_cache, verbose = FALSE)
#'
#' catrnav_clear_cache(verbose = TRUE)
#'
#' # Restore the initial cache.
#' catrnav_set_cache_dir(my_cache)
#' identical(my_cache, catrnav_detect_cache_dir())
#' }
catrnav_clear_cache <- function(
  config = FALSE,
  cached_data = TRUE,
  verbose = FALSE
) {
  validate_flag(config, "config")
  validate_flag(cached_data, "cached_data")
  validate_flag(verbose, "verbose")

  migrate_cache()

  config_dir <- tools::R_user_dir("CatastRoNav", "config")
  data_dir <- detect_cache_dir_muted()

  # nocov start
  if (config && dir.exists(config_dir)) {
    unlink(config_dir, recursive = TRUE, force = TRUE)
    if (verbose) {
      cli::cli_alert_warning(
        "Deleted the {.pkg CatastRoNav} cache configuration."
      )
    }
  }
  # nocov end

  if (cached_data && dir.exists(data_dir)) {
    size <- file.size(list.files(data_dir, recursive = TRUE, full.names = TRUE))
    size <- sum(size, na.rm = TRUE)
    class(size) <- class(object.size("a"))
    size <- format(size, units = "auto")

    unlink(data_dir, recursive = TRUE, force = TRUE)
    if (verbose) {
      cli::cli_alert_warning(paste0(
        "Deleted {.pkg CatastRoNav} cached data from ",
        "{.path {data_dir}} ({.val {size}})."
      ))
    }
  }

  Sys.setenv(CATASTRONAV_CACHE_DIR = "")

  # Reset cache directory.
  invisible()
}

# Internal functions ----------------------------------------------------------

#' Detect the cache directory silently
#'
#' @noRd
detect_cache_dir_muted <- function() {
  migrate_cache()

  # Read the cache path from the environment variable.
  getvar <- Sys.getenv("CATASTRONAV_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || !nzchar(getvar)) {
    # Read the cache path from the configuration file.
    cache_config <- file.path(
      tools::R_user_dir("CatastRoNav", "config"),
      "CATASTRONAV_CACHE_DIR"
    )

    # nocov start
    if (file.exists(cache_config)) {
      cached_path <- readLines(cache_config, warn = FALSE)

      # Use the default path when the configured path is invalid.
      if (
        length(cached_path) != 1L || is.na(cached_path) || !nzchar(cached_path)
      ) {
        cache_dir <- catrnav_set_cache_dir(overwrite = TRUE, verbose = FALSE)
        return(cache_dir)
      }

      # Return the configured cache path.
      Sys.setenv(CATASTRONAV_CACHE_DIR = cached_path)
      cached_path
      # nocov end
    } else {
      # Use the default cache location.
      cache_dir <- catrnav_set_cache_dir(overwrite = TRUE, verbose = FALSE)
      cache_dir
    }
  } else {
    getvar
  }
}

#' Create `cache_dir` if it does not exist
#'
#' @inheritParams catrnav_set_cache_dir
#'
#' @noRd
create_cache_dir <- function(cache_dir = NULL) {
  # Read the configured cache directory when no path is provided.
  if (is.null(cache_dir)) {
    cache_dir <- detect_cache_dir_muted()
  }

  cache_dir <- path.expand(cache_dir)
  # Create the cache directory when needed.
  if (isFALSE(dir.exists(cache_dir))) {
    dir.create(cache_dir, recursive = TRUE)
  }
  cache_dir
}

#' Migrate the cache configuration
#'
#' @noRd
migrate_cache <- function(
  old = rappdirs::user_config_dir("CatastRoNav", "R"),
  new = tools::R_user_dir("CatastRoNav", "config")
) {
  new_file <- file.path(new, "CATASTRONAV_CACHE_DIR")
  old_files <- file.path(
    old,
    c("CATASTRONAV_CACHE_DIR", "catastronav_cache_dir")
  )

  if (file.exists(new_file)) {
    if (dir.exists(old)) {
      unlink(old, recursive = TRUE, force = TRUE)
    }
    return(invisible())
  }

  old_file <- old_files[file.exists(old_files)][1]
  if (!is.na(old_file)) {
    cache_dir <- readLines(old_file, warn = FALSE)
    if (length(cache_dir) == 1L && !is.na(cache_dir) && nzchar(cache_dir)) {
      catrnav_set_cache_dir(
        cache_dir,
        install = TRUE,
        overwrite = TRUE,
        verbose = FALSE
      )
      cli::cli_alert_success(c(
        "The {.pkg CatastRoNav} cache configuration migrated successfully for ",
        "version {.val 0.1.0} or later. See the {.strong Note} section in ",
        "{.help CatastRoNav::catrnav_set_cache_dir}."
      ))
      cli::cli_alert_info("This one-time message will not be shown again.")
    }
  }

  if (dir.exists(old)) {
    unlink(old, recursive = TRUE, force = TRUE)
  }
  invisible()
}
