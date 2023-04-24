test_that("rcmg euclidean works", {
  t_data <- array(c(
    1, 1, 1, 1, 1,
    1, 1, 2, 1, 1,
    1, 1, 1, 1, 1
  ), dim = c(3, 5, 1))
  grad <- rcmg_euclid(t_data)
  expect_equal(grad[1, 1], 0)
  expect_equal(grad[2, 3], 1)
})

test_that("rcmg cosine works", {
  t_data <- array(c(
    1, 1, 1, 1, 1,
    1, 1, 2, 1, 1,
    1, 1, 1, 1, 1,
    0, 0, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 0, 0
  ), dim = c(3, 5, 2))
  grad <- rcmg_cos(t_data)
  expect_true(grad[1, 1] == 0)
  expect_true(grad[2, 3] != 0)
})
