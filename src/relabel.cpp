#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

using namespace Rcpp;

//' Relabels segmentation
//'
//' Relabels segmentation map starting the labeling at 1.
//'
//' @param seg a segmentation matrix to relabel.
//'
//' @return relabeled matrix.
//'
//' @export
//' @name relabel_seg
//'
// [[Rcpp::export]]
arma::mat relabel_seg(arma::mat seg) {
  int n_row = (int)seg.n_rows;
  int n_col = (int)seg.n_cols;
  arma::mat new_mat(n_row, n_col);
  for (int r=0; r<n_row; r++) {
    for (int c=0; r<n_col; c++) {
      new_mat(r, c) = 0;
    }
  }

  new_mat(0, 0) = 1;
  int next_lab = 2;
  for (int r=0; r<n_row; r++) {
    for (int c=0; c<n_col; c++) {
      if (new_mat(r, c) == 0) {
        // if ((r-1 >= 0) && (seg(r-1, c) == seg(r, c)) && (new_mat(r-1, c) != 0)) {
        //   new_mat(r, c) = new_mat(r-1, c);
        // }
        // else if ((r+1 < n_row) && (seg(r+1, c) == seg(r, c)) && (new_mat(r+1, c) != 0)) {
        //   new_mat(r, c) = new_mat(r+1, c);
        // }
        // else if ((c-1 >= 0) && (seg(r, c-1) == seg(r, c)) && (new_mat(r, c-1) != 0)) {
        //   new_mat(r, c) = new_mat(r, c-1);
        // }
        // else if ((c+1 < n_col) && (seg(r, c+1) == seg(r, c)) && (new_mat(r, c+1) != 0)) {
        //   new_mat(r, c) = new_mat(r, c+1);
        // } else {
        //   new_mat(r, c) = next_lab;
        //   next_lab += 1;
        // }
        new_mat(r, c) = next_lab;
        next_lab += 1;
      }


      if ((r-1 >= 0) && (seg(r-1, c) == seg(r, c)) && (new_mat(r-1, c) == 0)) {
        new_mat(r-1, c) = new_mat(r, c);
      }
      if ((r+1 < n_row) && (seg(r+1, c) == seg(r, c)) && (new_mat(r+1, c) == 0)) {
        new_mat(r+1, c) = new_mat(r, c);
      }
      if ((c-1 >= 0) && (seg(r, c-1) == seg(r, c)) && (new_mat(r, c-1) == 0)) {
        new_mat(r, c-1) = new_mat(r, c);
      }
      if ((c+1 < n_col) && (seg(r, c+1) == seg(r, c)) && (new_mat(r, c+1) == 0)) {
        new_mat(r, c+1) = new_mat(r, c);
      }
    }
  }

  return(new_mat);
}
