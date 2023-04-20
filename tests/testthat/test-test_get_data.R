test_that("get_data", {

  # Testing get_data() function valid and invalid input
  expect_error(get_data("invalid_input"))
  expect_error(get_data("botswana", verbose = "invalid_input"))
  expect_error(get_data("PaviaC", clip_p = 2.5))
  expect_no_error(ip <- get_data("IndianPines", verbose = FALSE))

  ip_data <- get_data("indianpines")
  expect_equal("IndianPines", ip_data$name)
  expect_equal(4205000, length(ip_data$img_clipped))
  expect_equal(c(145, 145, 200), dim(ip_data$img_raw))
  expect_equal(7457, max(ip_data$img_clipped))
  expect_equal(1002, min(ip_data$img_clipped))


  # Add test cases that only verify certain values for indian pines.
  # Check name, check dimensions, check max/min values (can be hard coded)


  # Testing correct class output
  expect_equal("HSI_data", class(ip))
  unlink("./HSI_Data/", TRUE, TRUE)
})
