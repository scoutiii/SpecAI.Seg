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

test_that("Watershed functions as expected", {
  # Create an empty matrix
  circle_matrix <- matrix(0, nrow = 100, ncol = 100)

  # Define circle parameters
  radius <- 100 / 4
  center_x <- 100 / 2
  center_y <- 100 / 2

  # Fill in the matrix with 1s for the circle
  for (i in 1:n) {
    for (j in 1:n) {
      distance_from_center <- sqrt((i - center_x)^2 + (j - center_y)^2)
      if (distance_from_center <= radius) {
        circle_matrix[i, j] <- 1
      }
    }
  }

  # The segmented version of a white circle on a black background should
  # be the same

  seg <- suppressWarnings(watershed_hsi(circle_matrix))

  expect_true(all(seg == circle_matrix))
  expect_error(watershed_hsi("String"))
  expect_error(watershed_hsi(NULL))

})
