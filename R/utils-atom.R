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
    updated <- sub("Z$", "+0000", unlist(x$updated))
    updated <- sub("([+-][0-9]{2}):([0-9]{2})$", "\\1\\2", updated)
    date <- as.POSIXct(
      updated,
      tz = "UTC",
      tryFormats = c(
        "%Y-%m-%dT%H:%M:%OS%z",
        "%Y-%m-%dT%H:%M:%OS",
        "%Y-%m-%d %H:%M:%OS",
        "%Y-%m-%d"
      )
    )
    data.frame(title = trimws(title), url = trimws(url), date = date)
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
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  validate_cache_args(update_cache, cache_dir, verbose)

  path <- download_url(
    url = api_entry,
    name = basename(api_entry),
    cache_dir = cache_dir,
    subdir = "databases",
    verbose = verbose,
    update_cache = update_cache
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
  subdir,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
) {
  validate_cache_args(update_cache, cache_dir, verbose)

  all <- db_getter(
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
    return(NULL)
  }

  api_entry <- selected$url[1]
  filename <- basename(api_entry)
  path <- download_url(
    url = api_entry,
    name = filename,
    cache_dir = cache_dir,
    subdir = subdir,
    verbose = verbose,
    update_cache = update_cache
  )

  if (is.null(path)) {
    return(NULL)
  }

  read_geo_file_sf(path, verbose = verbose, hint = "\\.gml$")
}

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
    cli::cli_alert_success(
      "Using the closest match {.str {candidates$munic[1]}}."
    )
    cli::cli_alert_info("Other matches:")

    bullets <- paste0("{.str ", candidates$munic[-1], "}")
    names(bullets) <- rep("*", length(bullets))
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

catrnav_atom_match_munic <- function(all, munic) {
  munic <- as.character(munic)

  matches <- grep(munic, all$munic, ignore.case = TRUE)

  if (length(matches) == 0L) {
    cli::cli_alert_warning(
      "No municipality matched the pattern {.str {munic}}."
    )
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
