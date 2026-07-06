withr::local_options(
  list(catastronav_ssl_verify = 0, catastronav_timeout = 600),
  .local_envir = testthat::teardown_env()
)
