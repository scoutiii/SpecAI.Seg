#' Get data function
#'
#' Downloads HSI data, can be indianpines, salinas, paviau (university),
#' paviac (center), ksc (Kennedy Space Center), botswana
#'
#' @param name image name to be downloaded
#' @param folder folder to send output to
#' @param verbose boolean determining if user wants function messages
#' @param clip_p percentile to clip the image to
#'
#' @return HSI_data object
#'
#' @examples
#' \dontrun{
#'   bots <- get_data("botswana")
#'   pu <- get_data("PaviaU", verbose = FALSE, clip_p = .9950)
#' }
#'
#' @export
get_data <- function(name, folder = "./HSI_Data/", verbose = TRUE,
                     clip_p = .9975) {
  name <- tolower(name)
  data_names <- tolower(names(image_details))
  ind <- which(data_names == name)
  if (length(ind) == 0) {
    stop(paste(name, "is not an available dataset"))
  }
  if (clip_p > 1 || clip_p < 0) {
    stop("clip_p must be between 0 and 1")
  }
  if (!is.logical(verbose)) {
    stop("verbose must be a boolean")
  }
  data_info <- image_details[[which(data_names == name)]]
  name <- names(image_details)[ind]

  if (!dir.exists(folder)) {
    dir.create(folder)
  }

  save_dir <- paste0(folder, name, "/")
  if (!dir.exists(save_dir)) {
    if (verbose) {
      message("Downloading data...")
    }
    dir.create(save_dir)
    save_img <- paste0(save_dir, data_info$img)
    curl::curl_download(data_info$urls[1], save_img, quiet = !verbose)
    save_gt <- paste0(save_dir, data_info$gt)
    curl::curl_download(data_info$urls[2], save_gt, quiet = !verbose)
  } else {
    if (verbose) {
      message("Reading in pre-downloaded data...")
    }
    save_img <- paste0(save_dir, data_info$img)
    save_gt <- paste0(save_dir, data_info$gt)
  }

  img_raw <- R.matlab::readMat(save_img)
  img_raw <- img_raw[[data_info$img_key]]
  img_clipped <- img_raw
  img_clipped <- unlist(img_clipped)
  gt <- R.matlab::readMat(save_gt)

  # clipping the image
  q25 <- stats::quantile(as.numeric(img_clipped), probs = 1 - clip_p)
  q9975 <- stats::quantile(as.numeric(img_clipped), probs = clip_p)
  img_clipped[img_clipped > q9975] <- q9975
  img_clipped[img_clipped < q25] <- q25


  # scale image to [0,1]
  mx <- max(img_clipped)
  mn <- min(img_clipped)
  img <- (img_clipped - mn) / (mx - mn)

  formatted_data <- list(
    name = name,
    img_raw = img_raw,
    img_clipped = array(img_clipped, dim = dim(img_raw)),
    img = img,
    gt = gt[[data_info$gt_key]],
    label_values = data_info$label_values,
    ignored_labels = data_info$ignored_labels,
    rgb_bands = data_info$rgb_bands,
    img_rgb = img[, , data_info$rgb_bands]
  )

  structure(formatted_data,
    class = "HSI_data"
  )
}


#' Get all data function
#'
#' Downloads HSI data for all 6 images
#'
#' @param ... Passed to get_data
#'
#' @examples
#' \dontrun{
#'   get_all_data(verbose = FALSE)
#' }
#'
#' @export
get_all_data <- function(...) {
  image_list <- c(
    "PaviaC", "Salinas", "PaviaU", "KSC", "IndianPines", "Botswana"
  )
  for (image in image_list) {
    message(paste0("Beginning download of: ", image))
    # Just run the downloaded portion of the code here instead of the whole func
    get_data(image, ...)
  }
}
