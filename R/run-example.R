#' Decide whether an example should run
#'
#' @description
#' Determines whether an example should run based on CRAN status and network
#' availability.
#'
#' @details
#' Returns `FALSE` on CRAN or when offline.
#'
#' @returns A [logical][base::logical] value, `TRUE` if online and not running
#'   on CRAN, `FALSE` otherwise.
#'
#' @keywords internal
#'
#' @export
#' @encoding UTF-8
#'
#' @examples
#' run_example()
run_example <- function() {
  if (!is_online_fun()) {
    return(FALSE)
  }
  if (on_cran()) {
    return(FALSE)
  }

  TRUE
}

#' Check whether code is running on CRAN
#'
#' @returns A [logical][base::logical] value, `TRUE` if running on CRAN,
#'   `FALSE` otherwise.
#'
#' @noRd
on_cran <- function(is_interactive = interactive()) {
  env <- Sys.getenv("NOT_CRAN")
  if (identical(env, "")) {
    !is_interactive
  } else {
    !isTRUE(as.logical(env))
  }
}
