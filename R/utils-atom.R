catr_read_atom <- function(file, encoding = "UTF-8") {
  # Retry without an explicit encoding if parsing fails.
  feed <- try(read_atom_xml(file, encoding), silent = TRUE)

  if (inherits(feed, "try-error")) {
    feed <- read_atom_xml(file)
  }

  # Keep only feed entries.
  feed <- feed$feed
  feed <- feed[names(feed) == "entry"]

  tbl_all <- lapply(feed, function(x) {
    x[nzchar(names(x))]
    base <- x$content$div$ul$li$a
    title <- base[[1]]
    url <- unlist(attr(base, "href"))
    date <- as.POSIXct(unlist(x$updated))
    data.frame(title = trimws(title), url = trimws(url), date = as.Date(date))
  })

  tbl_all <- dplyr::bind_rows(tbl_all)
  tbl_all <- dplyr::as_tibble(tbl_all)

  tbl_all
}

read_atom_xml <- function(file, encoding = NULL) {
  if (is.null(encoding)) {
    xml <- xml2::read_xml(file, options = "NOCDATA")
  } else {
    xml <- xml2::read_xml(file, options = "NOCDATA", encoding = encoding)
  }
  xml2::as_list(xml)
}

catrnav_atom_read_db_all <- function(
  api_entry,
  title_prefix,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  validate_cache_args(cache, update_cache, cache_dir, verbose)

  path <- download_url(
    url = api_entry,
    name = basename(api_entry),
    cache_dir = cache_dir,
    verbose = verbose,
    update_cache = update_cache,
    cache = cache
  )

  if (is.null(path)) {
    return(NULL)
  }

  tbl <- catr_read_atom(path)
  names(tbl) <- c("munic", "url", "date")
  tbl$munic <- gsub(title_prefix, "", tbl$munic, fixed = TRUE)
  tbl
}

catrnav_atom_read_munic <- function(
  munic,
  db_getter,
  db_name,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  validate_cache_args(cache, update_cache, cache_dir, verbose)

  if (
    !is.character(munic) ||
      length(munic) != 1L ||
      is.na(munic) ||
      !nzchar(munic)
  ) {
    cli::cli_abort("{.arg munic} must be a non-empty character value.")
  }

  all <- db_getter(
    cache = cache,
    update_cache = update_cache,
    cache_dir = cache_dir,
    verbose = FALSE
  )

  if (is.null(all)) {
    return(NULL)
  }

  selected <- catrnav_atom_select_munic(
    all = all,
    munic = munic,
    db_name = db_name,
    verbose = verbose
  )
  if (is.null(selected)) {
    return(invisible(NA))
  }

  api_entry <- selected$url[1]
  filename <- basename(api_entry)
  path <- download_url(
    url = api_entry,
    name = filename,
    cache_dir = cache_dir,
    verbose = verbose,
    update_cache = update_cache,
    cache = cache
  )

  if (is.null(path)) {
    return(NULL)
  }

  if (isFALSE(cache)) {
    cache_dir <- tempdir()
  } else {
    cache_dir <- create_cache_dir(cache_dir)
  }
  exdir <- file.path(cache_dir, sub("\\..*$", "", filename))
  if (!dir.exists(exdir)) {
    dir.create(exdir, recursive = TRUE)
  }

  unzip(path, exdir = exdir, junkpaths = TRUE, overwrite = TRUE)

  files <- list.files(exdir, full.names = TRUE, pattern = "\\.gml$")
  read_geo_file_sf(files, verbose)
}

#' Select a municipality from an ATOM index
#'
#' @noRd
catrnav_atom_select_munic <- function(all, munic, db_name, verbose = FALSE) {
  candidates <- catrnav_atom_match_munic(all, munic)
  if (is.null(candidates)) {
    cli::cli_alert_info("Check available municipalities with {.fn {db_name}}.")
    return(NULL)
  }

  if (nrow(candidates) > 1L) {
    cli::cli_alert_info(
      "Found {.val {nrow(candidates)}} municipalities matching {.str {munic}}."
    )
    cli::cli_alert_success("Using closest match {.str {candidates$munic[1]}}.")
    cli::cli_alert_info("Other matches:")

    bullets <- paste0("{.str ", candidates$munic[-1], "}")
    names(bullets) <- rep(" ", length(bullets))
    cli::cli_bullets(bullets)
  }

  selected <- candidates[1, , drop = FALSE]
  make_msg(
    "info",
    verbose,
    "Retrieving information for {.str {selected$munic}}."
  )
  selected
}

#' Match municipalities in an ATOM index
#'
#' @noRd
catrnav_atom_match_munic <- function(all, munic) {
  validate_non_empty_arg(munic)

  matches <- grep(munic, all$munic, ignore.case = TRUE)

  if (length(matches) == 0L) {
    cli::cli_alert_warning("No municipality matched pattern {.str {munic}}.")
    return(NULL)
  }

  candidates <- all[matches, , drop = FALSE]
  distances <- vapply(
    candidates$munic,
    function(label) {
      label <- sub("^\\S+\\s+", "", label)
      aliases <- trimws(strsplit(label, "/", fixed = TRUE)[[1]])
      min(as.vector(adist(munic, aliases)))
    },
    numeric(1)
  )
  candidates <- candidates[order(distances), , drop = FALSE]

  candidates
}
