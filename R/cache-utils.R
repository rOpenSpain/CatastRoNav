#' Set your \pkg{CatastRoNav} cache directory
#'
#' @description
#' Configures the cache directory used by \pkg{CatastRoNav}. Use
#' [Sys.getenv()] with `"CATASTRONAV_CACHE_DIR"` or
#' [catrnav_detect_cache_dir()] to inspect the current path.
#'
#' @details
#' By default, when no `cache_dir` is set, \pkg{CatastRoNav} uses a
#' directory inside [base::tempdir()]. Files in this directory are temporary
#' and are removed when the \R session ends. To persist a cache across \R
#' sessions, use
#' `catrnav_set_cache_dir(cache_dir, install = TRUE)`. This writes the chosen
#' path to a configuration file under
#' [tools::R_user_dir()] with `"CatastRoNav"` and `"config"`.
#'
#' @inheritParams CatastRo::catr_set_cache_dir cache_dir install verbose
#' @param overwrite A logical value indicating whether to overwrite an existing
#'   `CATASTRONAV_CACHE_DIR` value.
#'
#' @returns `catrnav_set_cache_dir()` returns a [character][base::character]
#'   string containing the cache path, invisibly. This function is primarily
#'   called for its side effects.
#'
#' @section Caching strategies:
#'
#' Source files are always cached after download. \pkg{CatastRoNav} implements
#' the following caching options:
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
#' data again by setting `update_cache = TRUE` in an ATOM or WMS function.
#' ATOM downloads check the file size with a HEAD request and report downloads
#' larger than 20 MB before fetching the body. Failed ATOM updates preserve
#' the previous cached file. WFS queries reuse their cached response until the
#' cache is cleared.
#'
#' ATOM indexes are stored in `databases`, municipal downloads in `atom_ad`,
#' `atom_bu` or `atom_cp` and WFS responses in `wfs_inspire_cache`.
#'
#' The ATOM `cache` argument is deprecated and no longer changes caching.
#' Use a temporary `cache_dir` when downloads should last only for a session.
#' @section HTTP settings:
#' ATOM downloads and WFS queries use the `catastronav_timeout` and
#' `catastronav_ssl_verify` options. If unset, the `CATASTRONAV_TIMEOUT` and
#' `CATASTRONAV_SSL_VERIFY` environment variables are used, followed by the
#' `catastro_timeout` and `catastro_ssl_verify` options. The defaults are
#' 300 seconds and enabled SSL verification. WFS queries apply these settings
#' only for the request and restore the previous \CRANpkg{CatastRo} options.
#' WMS request settings are passed to [mapSpain::esp_get_tiles()] through
#' the `options` argument of [catrnav_wms_get_layer()].
#'
#' If a download fails, use `verbose = TRUE` to inspect the request and
#' [catrnav_detect_cache_dir()] to identify the active cache path.
#'
#' @note
#' The configuration location has moved from
#' `rappdirs::user_config_dir("CatastRoNav", "R")` to
#' [tools::R_user_dir()] with `"CatastRoNav"` and `"config"`. Existing
#' configuration files are migrated automatically. A migration message is shown
#' only once.
#'
#' @seealso
#' [tools::R_user_dir()] determines the persistent configuration directory.
#' [base::tempdir()] provides the default temporary cache directory.
#' [catrnav_atom_get_address()], [catrnav_atom_get_buildings()] and
#' [catrnav_atom_get_parcels()] cache municipal downloads.
#' [catrnav_wfs_get_address_bbox()], [catrnav_wfs_get_buildings_bbox()] and
#' [catrnav_wfs_get_parcels_bbox()] cache spatial queries.
#' [catrnav_wms_get_layer()] caches map images.
#'
#' @family cache_utilities
#'
#' @rdname catrnav_set_cache_dir
#'
#' @export
#' @encoding UTF-8
#'
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
    cli::cli_abort("{.arg cache_dir} must be {.type character} of length one.")
  }
  cache_dir <- create_cache_dir(cache_dir)
  make_msg(
    "info",
    verbose,
    "{.pkg CatastRoNav} cache directory is {.path ",
    cache_dir,
    "}."
  )

  if (install) {
    config_dir <- catrnav_user_config_dir()
    if (!dir.exists(config_dir)) {
      dir.create(config_dir, recursive = TRUE)
    }

    catastronav_file <- file.path(config_dir, "CATASTRONAV_CACHE_DIR")

    if (!file.exists(catastronav_file) || overwrite) {
      writeLines(cache_dir, con = catastronav_file)
    } else {
      cli::cli_abort(c(
        "A {.arg cache_dir} value is already configured.",
        "i" = "Set {.arg overwrite} to {.code TRUE} to replace it."
      ))
    }
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

#' @returns `catrnav_detect_cache_dir()` returns a [character][base::character]
#'   string containing the cache path used in the current session.
#'
#' @rdname catrnav_set_cache_dir
#'
#' @export
#' @encoding UTF-8
#'
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
#' - Deletes the \pkg{CatastRoNav} configuration directory when
#'   `config = TRUE`
#'   (`tools::R_user_dir("CatastRoNav", "config")`).
#' - Deletes the `cache_dir` directory and its contents when
#'   `cached_data = TRUE`.
#' - Clears the `CATASTRONAV_CACHE_DIR` environment variable.
#'
#' @details
#' With `config = TRUE` and `cached_data = TRUE`, this function resets the
#' cache state as if you had never used \pkg{CatastRoNav}.
#'
#' @inheritParams CatastRo::catr_clear_cache cached_data verbose
#' @param config A logical value indicating whether to delete the
#'   \pkg{CatastRoNav} configuration directory.
#'
#' @returns [`NULL`][base::NULL], invisibly. This function is called for its
#'   side effects.
#'
#' @seealso
#' [catrnav_detect_cache_dir()] identifies the active cache path before
#' deletion. [catrnav_set_cache_dir()] configures a new cache afterward.
#'
#' @family cache_utilities
#'
#' @rdname catrnav_clear_cache
#'
#' @export
#' @encoding UTF-8
#'
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

  config_dir <- catrnav_user_config_dir()
  data_dir <- detect_cache_dir_muted()

  if (config && dir.exists(config_dir)) {
    status <- catrnav_unlink(config_dir, recursive = TRUE, force = TRUE)
    if (status != 0L || dir.exists(config_dir)) {
      cli::cli_inform(c(
        "!" = paste0(
          "Could not completely delete cache configuration at ",
          "{.path {config_dir}}."
        ),
        "i" = "Check file permissions and close programs using these files."
      ))
    } else if (verbose) {
      cli::cli_alert_success(
        "Deleted the {.pkg CatastRoNav} cache configuration."
      )
    }
  }

  if (cached_data && dir.exists(data_dir)) {
    size <- file.size(list.files(data_dir, recursive = TRUE, full.names = TRUE))
    size <- sum(size, na.rm = TRUE)
    class(size) <- class(object.size("a"))
    size <- format(size, units = "auto")

    status <- catrnav_unlink(data_dir, recursive = TRUE, force = TRUE)
    if (status != 0L || dir.exists(data_dir)) {
      cli::cli_inform(c(
        "!" = "Could not completely delete cached data at {.path {data_dir}}.",
        "i" = "Check file permissions and close programs using these files."
      ))
    } else if (verbose) {
      cli::cli_alert_success(paste0(
        "Deleted {.pkg CatastRoNav} cached data from ",
        "{.path {data_dir}} ({.val {size}})."
      ))
    }
  }

  Sys.setenv(CATASTRONAV_CACHE_DIR = "")

  # Return invisibly after clearing the cache state.
  invisible()
}

# Internal functions ----------------------------------------------------------

detect_cache_dir_muted <- function() {
  migrate_cache()

  # Read the cache path from the environment variable.
  getvar <- Sys.getenv("CATASTRONAV_CACHE_DIR")

  if (is.null(getvar) || is.na(getvar) || !nzchar(getvar)) {
    # Read the cache path from the configuration file.
    cache_config <- file.path(
      catrnav_user_config_dir(),
      "CATASTRONAV_CACHE_DIR"
    )

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
    } else {
      # Use the default cache location.
      cache_dir <- catrnav_set_cache_dir(overwrite = TRUE, verbose = FALSE)
      cache_dir
    }
  } else {
    getvar
  }
}

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

catrnav_user_config_dir <- function() {
  tools::R_user_dir("CatastRoNav", "config")
}

migrate_cache <- function(
  old = rappdirs::user_config_dir("CatastRoNav", "R"),
  new = catrnav_user_config_dir()
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
      cli::cli_alert_success(paste0(
        "The {.pkg CatastRoNav} cache configuration migrated successfully for ",
        "version {.val 0.1.0} or later. See the {.topic Note} section in ",
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

catrnav_unlink <- function(...) {
  unlink(...)
}
