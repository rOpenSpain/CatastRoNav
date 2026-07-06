#' Decide whether an example should run
#'
#' @description
#' Determine whether an example should run based on CRAN status and network
#' availability.
#'
#' @details
#' Returns `FALSE` on CRAN or when offline.
#'
#' @inherit CatastRo::run_example return
#'
#' @keywords internal
#' @encoding UTF-8
#' @export
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
#' @return Logical. `TRUE` if running on CRAN, `FALSE` otherwise.
#'
#' @noRd
on_cran <- function() {
  env <- Sys.getenv("NOT_CRAN")
  if (identical(env, "")) {
    !interactive()
  } else {
    !isTRUE(as.logical(env))
  }
}
