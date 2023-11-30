test_that("ATOM Cadastral Parcels", {
  skip_on_cran()
  skip_if_offline()

  expect_message(catrnav_atom_get_parcels("xyxghx"))

  s <- catrnav_atom_get_parcels("061", verbose = TRUE)

  expect_s3_class(s, "sf")
})
