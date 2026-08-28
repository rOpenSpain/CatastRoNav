#' Decide whether an example should run
#'
#' @description
#' Determines whether an example should run based on CRAN status and network
#' availability.
#'
#' @details
#' Returns `FALSE` on CRAN or when offline.
#'
#' @inherit CatastRo::run_example return
#'
#' @keywords internal
#' @export
#' @encoding UTF-8
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
#' @return A logical value, `TRUE` if running on CRAN and `FALSE` otherwise.
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
