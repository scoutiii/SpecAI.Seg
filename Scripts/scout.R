load_all()

get_data <- function(name, folder="./HSI_Data/", timeout=-1) {
  old_timeout <- getOption("timeout")
  if (old_timeout != timeout) {
    options(timeout=timeout)
  }

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
  save_dir = paste0(folder, name, "/")
  if (!dir.exists(save_dir)) {
    dir.create(save_dir)
  }

  save_img <- paste0(save_dir, data_info$img)
  download.file(data_info$urls[1], save_img)

  save_gt <- paste0(save_dir, data_info$gt)
  download.file(data_info$urls[2], save_gt)

  options(timeout=old_timeout)
}

get_data("botswana")
