test_that("gradient wrapper", {
  t_data <- array(c(1, 1, 1, 1, 1,
                    1, 1, 2, 1, 1,
                    1, 1, 1, 1, 1), dim=c(3, 5, 1))
  b_data <- array(c(1, 2, 3, 4), dim = c(1, 1, 1, 1))
  t_hsi <- structure(list(img = t_data), class="HSI_data")

  expect_no_error(calc_grad(t_hsi))
  expect_no_error(calc_grad(t_data))
  expect_no_error(calc_grad(t_data, "cos"))

  expect_error(calc_grad(NULL))
  expect_error(calc_grad(t_hsi, "nah"))
  expect_error(calc_grad(t_data, r=100))
  expect_error(calc_grad(b_data))
})
