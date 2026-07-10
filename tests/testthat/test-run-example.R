test_that("run_example() is false when offline", {
  local_mocked_bindings(is_online_fun = function(...) FALSE)

  expect_false(run_example())
})

test_that("run_example() is true when online", {
  local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    on_cran = function(...) FALSE
  )

  expect_true(run_example())
})

test_that("run_example() is false on CRAN", {
  skip_on_cran()

  withr::local_envvar(c(NOT_CRAN = "false"))
  local_mocked_bindings(is_online_fun = function(...) TRUE)

  expect_true(on_cran())
  expect_false(run_example())
})

test_that("on_cran() falls back to interactive()", {
  skip_on_cran()

  withr::local_envvar(c(NOT_CRAN = ""))

  expect_identical(on_cran(), !interactive())
})

test_that("run_example() is true outside CRAN", {
  withr::local_envvar(c(NOT_CRAN = "true"))
  local_mocked_bindings(is_online_fun = function(...) TRUE)

  expect_false(on_cran())
  expect_true(run_example())
})
