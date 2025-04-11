test_that("Test atom ad", {
  skip_on_cran()
  skip_if_offline()

  expect_message(catrnav_atom_get_address_db_all(
    verbose = TRUE,
    cache_dir = tempdir()
  ))
})
