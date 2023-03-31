load_all()
library(SpecAI.Seg)

data <- get_data("indianpines")

library(Rcpp)

cppFunction('arma::mat get_neigh(int row, int col, arma::cube img) {
            int u = std::max(row-1, 0);
            int d = std::min(row+1, (int)img.n_rows-1);
            int l = std::max(col-1, 0);
            int r = std::min(col+1, (int)img.n_cols-1);
            arma::mat res((d-u+1) * (r-l+1), (int)img.n_slices);

            int ind = 0;
            for (int i=u; i<=d; i++) {
              for (int j=l; j<=r; j++) {
                for (int k=0; k<(int)img.n_slices; k++) {
                  res(ind, k) = img(i, j, k);
                }
                ind++;
              }
            }

            return(res);
            }',
            depends = "RcppArmadillo")

test <- get_neigh(0, 0, data$img)
