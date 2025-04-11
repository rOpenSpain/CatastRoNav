test_that("ATOM Addresses", {
  skip_on_cran()
  skip_if_offline()

  expect_message(catrnav_atom_get_address("xyxghx"))

  s <- catrnav_atom_get_address("061", verbose = TRUE)

  expect_s3_class(s, "sf")
})
