#' Watershed for HSI
#'
#' Run the watershed algorithm on the gradient of an HSI image.
#'
#' @param grad The gradient of an HSI image, typically returned by one of
#' the RCMG functions.
#' @param tolerance The tolerance to be used by the watershed algorithm.
#' @param ext A smoothing parameter to be used in the watershed algorithm
#'
#' @return A segmented image built from the gradient, in the form of a matrix.
#' @export
watershed_SpecAI <- function(grad, tolerance = 0.01, ext = 200){
  # Get rid of some of the gradient noise
  grad[grad<quantile(grad, seq(0, 1, 0.05))[15]] <- 0
  # Use watershed algorithm
  seg <- EBImage::watershed(grad, tolerance = tolerance, ext = ext)
  return(seg)
}

#' Mark boundaries for HSI
#'
#' Find the boundaries of a segmented image
#'
#' @param seg The segmented image, typically returned from watershed_SpecAI.
#' @param img_rgb The image to be marked up, with RGB channels.
#' @param col A vector of colors representing (R, G, B) values.
#'
#' @return The image with boundaries marked.
#' @export
mark_boundaries <- function(seg, img_rgb, col = c(1, 1, 0)){
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

  for(i in seq_along(col)){
    img_rgb[,,i][bound3] <- col[i]
  }
  return(img_rgb)

}

