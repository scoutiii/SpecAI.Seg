load_all()
library(SpecAI.Seg)

ip <- get_data("indianpines")

grad_c <- calc_grad(ip, "cos")
plot(grad_c, log = TRUE)

grad_6 <- calc_grad(ip, "cos", 6)
plot(grad_6, log = TRUE)

grad_c_2 <- rcmg_cos(ip$img, 1)
grad_6_2 <- rcmg_cos(ip$img, 3)
all(grad_c_2 == grad_6_2)
