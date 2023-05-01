library(SpecAI.Seg)

#Get Data and Summary of data (Kyle)
ip <- get_data("indianpines")
names(ip)
get_all_data()

# Summarize (Eric)
class(ip)
summary(ip)
plot(ip)
plot(ip, plot_gt=TRUE)

ggmap::ggimage(ip$gt)
ggmap::ggimage(ip$gt == 10)
ip$label_values[11]  # NOTE: gt levels starts at 0

# Gradient (Scout)
if (FALSE) {
  grad_e <- calc_grad(ip)
  bm <- bench::mark(calc_grad(ip))
}
bm

class(grad_e)
plot(grad_e)
plot(grad_e, log = TRUE)

#Watershed itself (Zac)
seg <- watershed_hsi(grad_e, tolerance = 1, ext = 200)
marked_img <- mark_boundaries(seg, ip$img_rgb, c(1, 1, 0))

class(seg)
plot(seg, ip)
