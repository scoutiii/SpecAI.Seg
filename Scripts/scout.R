# load_all()
library(SpecAI.Seg)

ip <- get_data("indianpines")

grad <- calc_grad(ip)
plot(grad)
plot(grad, log=TRUE)
