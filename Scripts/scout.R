load_all()
library(SpecAI.Seg)

ip <- get_data("indianpines")

grad <- calc_grad(ip)
grad_c <- calc_grad(ip, "cos")


grad <- rcmg_euclid(ip$img)
seg <- watershed_hsi(grad)
