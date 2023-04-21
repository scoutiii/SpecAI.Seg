#' Wraps RCMG calculation
#'
#' By default, if data is HSI_data, it will calculate gradient for data$img.
#' For more control, you can pass in an array of 3 dimensions.
#' Support Euclidean or Cosine distance for type.
#'
#' @param data HSI_data or array to calculate gradient of.
#' @param type "euclidean" or "cos".
#' @param r how many pairs of pixels to remove.
#'
#' @return Appropriate RCMG gradient
#' @export
#'
#' @examples
#' \dontrun{
#' grad <- calc_grad(data)
#' grad_c <- calc_grad(data$img_raw, "cos", 2)
#' }
calc_grad <- function(data, type = "euclidean", r = 1) {
  if (!any(methods::is(data) %in% c("HSI_data", "array"))) {
    stop("Data must be of class HSI_data or array")
  }
  type <- tolower(type)
  if (!any(type %in% c("euclidean", "cos"))) {
    stop("Type must be either 'euclidean' or 'cos'")
  }
  if (r >= 7) {
    stop("R must be less than 7")
  }
  if (any(methods::is(data) == "array")) {
    if (length(dim(data)) != 3) {
      stop("For data as array, must have length(dim(data)) == 3")
    }
  }

  if (any(methods::is(data) == "HSI_data")) {
    img <- data$img
  } else {
    img <- data
  }

  if (type == "euclidean") {
    grad <- rcmg_euclid(img, r)
  } else {
    grad <- rcmg_cos(img, r)
  }

  class(grad) <- append(class(grad), "HSI_grad")
  grad
}

#' Watershed for HSI
#'
#' Run the watershed algorithm on the gradient of an HSI image.
#'
#' @param grad The gradient of an HSI image, typically returned by one of
#' the RCMG functions.
#' @param tolerance The tolerance to be used by the watershed algorithm.
#' @param ext A smoothing parameter to be used in the watershed algorithm
#' @param ... passed to calc_grad and EBImage::watershed
#'
#' @return A segmented image built from the gradient, in the form of a matrix.
#' @export
watershed_hsi <- function(grad, tolerance = 0.01, ext = 200, ...) {
  if (methods::is(grad) %in% c("HSI_data")) {
    grad <- calc_grad(grad, ...)
  }
  if (!any(methods::is(grad) %in% c("matrix", "HSI_grad"))) {
    stop("grad must be a matrix, HSI_data, or HSI_grad")
  }

  # Get rid of some of the gradient noise
  grad[grad < stats::quantile(grad, seq(0, 1, 0.05))[15]] <- 0
  # Use watershed algorithm
  seg <- EBImage::watershed(grad, tolerance = tolerance, ext = ext, ...)
  return(seg)
}

#' Mark boundaries for HSI
#'
#' Find the boundaries of a segmented image
#'
#' @param seg The segmented image, typically returned from watershed_SpecAI.
#' @param img_rgb The image to be marked up, with RGB channels, or an HSI_data.
#' @param col A vector of colors representing (R, G, B) values.
#'
#' @return The image with boundaries marked.
#' @export
mark_boundaries <- function(seg, img_rgb, col = c(1, 1, 0)) {
  if (methods::is(img_rgb) == "HSI_data") {
    img_rgb <- img_rgb$img_rgb
  }

  # Standardize the segmented image, necessary for the dilation function
  img2 <- (seg - min(seg)) / (max(seg) - min(seg))

  # Use a small brush for the kernel used in erosion and dilation
  kern <- EBImage::makeBrush(3, shape = "diamond")

  # Dilate the image
  bound1 <- EBImage::dilate(img2, kern = kern)

  # Erode the image
  bound2 <- EBImage::erode(img2, kern = kern)

  # Find boundaries by marking where the dilated and eroded images are not equal
  bound3 <- bound2 != bound1

  for (i in seq_along(col)) {
    img_rgb[, , i][bound3] <- col[i]
  }
  return(img_rgb)
}
