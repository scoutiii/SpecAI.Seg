

#Get Data and Summary of data

ip <- get_data("indianpines")

summary(ip)

plot(ip)

#Gradient

grad_e <- calc_grad(ip)
plot(grad_e, log = TRUE)

grad_c <- calc_grad(ip, "cos")
plot(grad_c, log = TRUE)

grad_2 <- calc_grad(ip, "cos", 2)
plot(grad_2, log = TRUE)

#Watershed itself

seg <- watershed_hsi(grad_e, tolerance = 1, ext = 200)

marked_img <- mark_boundaries(seg, ip$img_rgb, c(1, 1, 0))

ggmap::ggimage(marked_img)

plot(seg, ip)
