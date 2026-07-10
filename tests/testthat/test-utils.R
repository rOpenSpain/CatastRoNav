test_that("ensure_null() normalizes empty values", {
  expect_null(ensure_null(NULL))
  expect_null(ensure_null(c(NULL, NA)))
  expect_null(ensure_null(c(NULL, NA, "")))
  expect_null(ensure_null(c("", character(0))))
  expect_identical(ensure_null(c(1, 2)), c(1, 2))
})

test_that("make_msg() validates and emits messages", {
  expect_snapshot(make_msg("info", TRUE, "Informative message."))
  expect_silent(make_msg("info", FALSE, "Hidden message."))
  expect_snapshot(error = TRUE, make_msg("info", NA, "Invalid message."))
})

test_that("cli_abort_if_not() validates named conditions", {
  expect_snapshot(
    error = TRUE,
    cli_abort_if_not("A named condition failed." = FALSE)
  )
  expect_snapshot(error = TRUE, cli_abort_if_not(TRUE))
  expect_null(cli_abort_if_not("Condition passed." = TRUE))
})

test_that("validate_non_empty_arg() rejects missing arguments", {
  wrapper <- function(arg) {
    validate_non_empty_arg(arg)
  }

  expect_snapshot(error = TRUE, wrapper())
  expect_identical(wrapper("value"), "value")
})

test_that("shared validators report invalid values", {
  expect_snapshot(
    error = TRUE,
    validate_cache_args(TRUE, FALSE, cache_dir = 1, verbose = FALSE)
  )
  expect_snapshot(error = TRUE, validate_wfs_args(FALSE, count = 0))
  expect_snapshot(
    error = TRUE,
    validate_vector_with_srs(c(1, NA), 4326, expected_length = 2L)
  )
})
test_that("match_arg_pretty() validates and normalizes arguments", {
  my_fun <- function(arg_one = c(10, 1000, 3000, 5000)) {
    match_arg_pretty(arg_one)
  }

  # OK, returns character
  expect_identical(my_fun(1000), "1000")
  expect_identical(my_fun("1000"), "1000")
  expect_identical(my_fun(NULL), "10")
  expect_identical(my_fun(), "10")
  # Some errors here
  # Single value no match
  expect_snapshot(my_fun("error here"), error = TRUE)

  # Several values no match
  expect_snapshot(my_fun(c("an", "error")), error = TRUE)

  # One value regex
  expect_snapshot(my_fun("5"), error = TRUE)
  # Several value regex
  expect_snapshot(my_fun("00"), error = TRUE)

  my_fun2 <- function(year = 20) {
    match_arg_pretty(year)
  }

  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)

  # With custom options
  my_fun3 <- function(an_arg = 20) {
    match_arg_pretty(an_arg, c("30", "20"))
  }
  expect_identical(my_fun3(), "20")
  expect_snapshot(my_fun3("3"), error = TRUE)
  # Pass more options than expected
  expect_snapshot(my_fun2(c(1, 2)), error = TRUE)
})
