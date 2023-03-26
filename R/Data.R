get_data <- function(name) {
  name <- tolower(name)
  for (i in 1:length(image_details)) {
    if (grepl(name, tolower(image_details[[i]]$img_key))) {
      url <- image_details[[i]]$url[1]
      filename <- paste0(name, ".jpg") # save the file with the name
      download.file(url, filename)
    }
  }
}
