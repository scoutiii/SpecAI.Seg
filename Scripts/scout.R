<<<<<<< Updated upstream
# load_all()
library(SpecAI.Seg)

ip <- get_data("indianpines")
all <- get_all_data()
=======
load_all(".")
library(ggplot2)
library(magick)

data <- get_data("indianpines")

grad <- rcmg_euclid(data$img)
to_plot <- replicate(3, grad)
to_plot <- (to_plot - min(to_plot)) / (max(to_plot) - min(to_plot))
ggmap::ggimage(to_plot)

grad <- rcmg_cos(data$img)
to_plot <- replicate(3, grad)
to_plot <- (to_plot - min(to_plot)) / (max(to_plot) - min(to_plot))
ggmap::ggimage(to_plot)
>>>>>>> Stashed changes
