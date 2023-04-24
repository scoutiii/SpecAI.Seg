#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace Rcpp;


//' Get neighborhood of a pixel in a 3D image
//'
//' This function returns the neighborhood of a pixel in a 3D image. Returns the
//' 8 neighboring (plus center pixel) for the pixel at row and col. The input
//' \code{img} is a three-dimensional array containing the image data.
//'
//' @param row An integer representing the row index of the pixel of interest.
//' @param col An integer representing the column index of the pixel of interest.
//' @param img A cube object containing the image data.
//'
//' @return A matrix representing the neighborhood of the pixel of interest.
//'
//' @export
//' @name get_neigh
//'
//' @examples
//' img <- array(1:27, dim = c(3, 3, 3))
//' get_neigh(2, 2, img)
//'
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


// Compute pairwise distances between rows of a matrix using a specified
// distance function
//
// @param X A numeric matrix
// @param dist_func A pointer to a distance function that takes two row vectors
//   and returns a double
//
// @return A symmetric n x n matrix of pairwise distances between rows of X
arma::mat pairwise_distances(const arma::mat& X,
                             double (*dist_func)(const arma::rowvec&, const arma::rowvec&)) {
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
//
// Calculates the euclidean distance between two row vectors.
//
// @param x A row vector.
// @param y A row vector.
// @return The euclidean distance between \code{x} and \code{y}.
double euclidean_distance(const arma::rowvec& x, const arma::rowvec& y) {
  return arma::norm(x - y, 2);
}


// Define the euclidean distance function
//
// @param x a row vector
// @param y a row vector
// @return the euclidean distance between \code{x} and \code{y}
double cosine_distance(const arma::rowvec& x, const arma::rowvec& y) {
  double dot_prod = arma::dot(x, y);
  double norm_x = arma::norm(x, 2);
  double norm_y = arma::norm(y, 2);
  return 1 - dot_prod / (norm_x * norm_y);
}


// Calculate the pairwise Euclidean distances between rows of a matrix
//
// @param X a matrix
// @return a matrix of pairwise Euclidean distances
arma::mat pairwise_euclidean(const arma::mat& X) {
  return pairwise_distances(X, euclidean_distance);
}


// Define the cosine distance function
//
// @param x a row vector
// @param y a row vector
// @return the cosine distance between x and y
arma::mat pairwise_cosine(const arma::mat& X) {
  return pairwise_distances(X, cosine_distance);
}


//' Calculates RCMG using Euclidean distance
//'
//' For every pixel, find the RCMG where the 8 neighboring pixels make up the
//' pairwise distance matrix, and r is the number of pairs of pixels to remove.
//' Don't set r larger than 3.
//'
//' @param img A 3D cube containing the image data
//' @param r An integer specifying the radius of the rolling window
//'
//' @return A matrix containing the Euclidean distances of the pixels
//'
//' @export
//' @name rcmg_euclid
// [[Rcpp::export]]
arma::mat rcmg_euclid(const arma::cube& img, int r=1) {
  int n = (int)img.n_rows;
  int m = (int)img.n_cols;
  arma::mat grad = arma::zeros<arma::mat>(n, m);

  #pragma omp parallel for
  for (int row=0; row<n; row++) {
    for (int col=0; col<m; col++) {
      arma::mat neighs = get_neigh(row, col, img);
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
      grad(row, col) = dists.max();
    }
  }

  return(grad);
}


//' Calculates RCMG using Euclidean distance
//'
//' For every pixel, find the RCMG where the 8 neighboring pixels make up the
//' pairwise distance matrix, and r is the number of pairs of pixels to remove.
//' Don't set r larger than 3.
//'
//' @param img A 3D cube containing the image data
//' @param r An integer specifying the radius of the rolling window
//'
//' @return A matrix containing the Euclidean distances of the pixels
//'
//' @export
//' @name rcmg_cos
// [[Rcpp::export]]
arma::mat rcmg_cos(const arma::cube& img, int r=1) {
  int n = (int)img.n_rows;
  int m = (int)img.n_cols;
  arma::mat grad = arma::zeros<arma::mat>(n, m);

  #pragma omp parallel for
  for (int row=0; row<n; row++) {
    for (int col=0; col<m; col++) {
      arma::mat neighs = get_neigh(row, col, img);
      arma::mat dists = pairwise_cosine(neighs);
      for (int i=0; i<r; i++) {
        int max_index = (int)dists.index_max();
        int max_row = max_index / (int)dists.n_cols;
        int max_col = max_index % (int)dists.n_cols;
        for (int j=0; j<(int)dists.n_rows; j++) {
          dists(j, max_col) = 0.0;
          dists(max_row, j) = 0.0;
        }
      }
      grad(row, col) = dists.max();
    }
  }

  return(grad);
}
