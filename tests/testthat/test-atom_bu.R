test_that("ATOM Buildings", {
  skip_on_cran()
  skip_if_offline()

  expect_message(catrnav_atom_get_buildings("xyxghx"))

  s <- catrnav_atom_get_buildings("061", verbose = TRUE)

  expect_s3_class(s, "sf")
})
