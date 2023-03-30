get_data <- function(name, folder = "./HSI_Data/", verbose = TRUE) {
  name <- tolower(name)
  data_names <- tolower(names(image_details))
  ind <- which(data_names == name)
  if (length(ind) == 0) {
    stop(paste(name, "is not an available dataset"))
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
  gt <- readMat(save_gt)

  # clipping the image
  q25 <- quantile(as.numeric(img_clipped), probs = 0.025)
  q9975 <- quantile(as.numeric(img_clipped), probs = 0.9975)
  img_clipped[img_clipped > q9975] <- q9975
  img_clipped[img_clipped < q25] <- q25


  # scale image to [0,1]
  img <- (img_clipped - min(img_clipped)) / (max(img_clipped) - min(img_clipped))

  formatted_data <- list(
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
            class = "HSI_data")
}
