#' Plot image gradient
#'
#' @param x HSI_grad object
#' @param y not used
#' @param ... can include log to plot on the log_10 scale
#'
#' @return Nothing
#' @export
plot.HSI_grad <- function(x, y, ...) {
  args <- list(...)
  if ("log" %in% names(args)) {
    l <- args[["log"]]
    stopifnot(is.logical(l))
    if (l) {
      x <- log(x)
    }
  }

  grad <- (x - min(x)) / (max(x) - min(x))
  ggmap::ggimage(grad)
}

#' Plot segmentation
#'
#' @param x HSI_seg object
#' @param y HSI_data object which was used to create HSI_seg
#' @param ... not used yet
#'
#' @return nothing
#' @export
#'
#' @examples
plot.HSI_seg <- function(x, y, ...) {
  # Check to make sure y is an HSI_data

  # Use marked image to mark the segment boundaries

  # Plot marked image

}


#' Plot false color image
#'
#' @param x HSI_data
#' @param y not used
#' @param ... not used
#'
#' @return nothing
#' @export
#'
#' @examples
plot.HSI_data <- function(x, y, ...) {
  ggmap::ggimage(x$img_rgb)
}
