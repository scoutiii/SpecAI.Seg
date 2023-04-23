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
plot.HSI_seg <- function(x, y, ...) {
  # Check to make sure y is an HSI_data
  if (!any(methods::is(y) %in% c("HSI_data"))) {
    stop("y variable must be of class HSI_data")
  }

  # Use marked image to mark the segment boundaries
  marked <- mark_boundaries(x, y)

  # Plot marked image
  ggmap::ggimage(marked)

}


#' Plot false color image
#'
#' @param x HSI_data
#' @param y not used
#' @param ... not used
#'
#' @return nothing
#' @export
plot.HSI_data <- function(x, y, ...) {
  ggmap::ggimage(x$img_rgb)
}


#' Get Summary of the data
#'
#' @param object HSI_data
#' @param ... not used
#'
#' @return nothing
#' @export
summary.HSI_data <- function(object, ...){
  cat("The Data name is", object$name, '\n')
  cat("This image is", dim(object$img_raw)[1], "x",
      as.character(dim(object$img_raw)[2])
      , "pixels with", as.character(dim(object$img_raw)[3]),
      "layers.", '\n')
  cat("The RGB bands are: ", object$rgb_bands, '\n')
  cat("The gt levels are: \n")
  levels <- seq_along(object$label_values)
  paste(levels-1, object$label_values)
  #Match with $label_values
}
