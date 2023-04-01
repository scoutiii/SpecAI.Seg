load_all()
library(SpecAI.Seg)

data <- get_data("indianpines")

img_to_list <- function(img) {
  res = list()
  for (i in seq_len(dim(img)[3])) {
    res[i] = list(img[, , i])
  }
  res
}

img <- img_to_list(data$img)
test <- get_neigh(0, 0, img)
