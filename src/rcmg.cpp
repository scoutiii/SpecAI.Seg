#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace Rcpp;


//' @export
// [[Rcpp::export]]
arma::mat get_neigh(int row, int col, arma::cube img) {
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
}


// Define the pairwise_distance function
arma::mat pairwise_distances(const arma::mat& X, double (*dist_func)(const arma::rowvec&, const arma::rowvec&)) {
  int n = X.n_rows;
  arma::mat D(n, n);
  for (int i = 0; i < n; i++) {
    for (int j = i+1; j < n; j++) {
      double d = dist_func(X.row(i), X.row(j));
      D(i,j) = d;
      D(j,i) = d;
    }
    D(i,i) = 0;
  }
  return D;
}

// Define the euclidean distance function
double euclidean_distance(const arma::rowvec& x, const arma::rowvec& y) {
  return arma::norm(x - y, 2);
}

// Define the cosine distance function
double cosine_distance(const arma::rowvec& x, const arma::rowvec& y) {
  double dot_prod = arma::dot(x, y);
  double norm_x = arma::norm(x, 2);
  double norm_y = arma::norm(y, 2);
  return 1 - dot_prod / (norm_x * norm_y);
}

arma::mat pairwise_euclidean(const arma::mat& X) {
  return pairwise_distances(X, euclidean_distance);
}

arma::mat pairwise_cosine(const arma::mat& X) {
  return pairwise_distances(X, cosine_distance);
}

//' @export
// [[Rcpp::export]]
arma::mat rcmg_euclid(const arma::cube& img, int r=1) {
  int n = (int)img.n_rows;
  int m = (int)img.n_cols;
  arma::mat grad = arma::zeros<arma::mat>(n, m);

  #pragma omp parallel for
  for (int r=0; r<n; r++) {
    for (int c=0; c<m; c++) {
      arma::mat neighs = get_neigh(r, c, img);
      arma::mat dists = pairwise_euclidean(neighs);
      for (int i=0; i<r; i++) {
        arma::uword max_index = dists.index_max();
        arma::uword max_row = max_index / dists.n_cols;
        arma::uword max_col = max_index % dists.n_cols;
        for (arma::uword j=0; j<dists.n_rows; j++) {
          dists(j, max_col) = 0;
        }
        for (arma::uword j=0; j<dists.n_cols; j++) {
          dists(max_row, j) = 0;
        }
      }
      grad(r, c) = dists.max();
    }
  }

  return(grad);
}


//' @export
// [[Rcpp::export]]
arma::mat rcmg_cos(const arma::cube& img, int r=1) {
  int n = (int)img.n_rows;
  int m = (int)img.n_cols;
  arma::mat grad = arma::zeros<arma::mat>(n, m);

  #pragma omp parallel for
  for (int r=0; r<n; r++) {
    for (int c=0; c<m; c++) {
      arma::mat neighs = get_neigh(r, c, img);
      arma::mat dists = pairwise_cosine(neighs);
      for (int i=0; i<r; i++) {
        arma::uword max_index = dists.index_max();
        arma::uword max_row = max_index / dists.n_cols;
        arma::uword max_col = max_index % dists.n_cols;
        for (arma::uword j=0; j<dists.n_rows; j++) {
          dists(j, max_col) = 0;
        }
        for (arma::uword j=0; j<dists.n_cols; j++) {
          dists(max_row, j) = 0;
        }
      }
      grad(r, c) = dists.max();
    }
  }

  return(grad);
}