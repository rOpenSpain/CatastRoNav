catr_read_atom <- function(file, encoding = "UTF-8") {
  # Encoding error sometimes, thanks @dr_xeo
  feed <- try(
    xml2::as_list(xml2::read_xml(
      file,
      options = "NOCDATA",
      encoding = encoding
    )),
    silent = TRUE
  )

  # On error try without encoding
  if (inherits(feed, "try-error")) {
    feed <- xml2::as_list(xml2::read_xml(file, options = "NOCDATA"))
  }

  # Prepare data
  feed <- feed$feed
  feed <- feed[names(feed) == "entry"]

  tbl_all <- lapply(feed, function(x) {
    x[names(x) != ""]
    base <- x$content$div$ul$li$a
    title <- base[[1]]
    url <- unlist(attr(base, "href"))
    date <- as.POSIXct(unlist(x$updated))
    data.frame(
      title = trimws(title),
      url = trimws(url),
      date = as.Date(date)
    )
  })

  tbl_all <- dplyr::bind_rows(tbl_all)
  tbl_all <- dplyr::as_tibble(tbl_all)

  tbl_all
}
