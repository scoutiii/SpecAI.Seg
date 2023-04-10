test_that("get_data", {

  # Testing get_data() function valid and invalid input
  expect_error(get_data("invalid_input"))
  expect_error(get_data("botswana", verbose = "invalid_input"))
  expect_error(get_data("PaviaC", clip_p = 2.5))
  expect_no_error(get_data("IndianPines"))
  expect_no_error(get_data("SALINAS"))


  # Testing get_all_data() function
  expect_no_error(get_all_data())

  # Testing correct class output
  expect_equal("HSI_data", class(get_data("PaviaU")))
})
