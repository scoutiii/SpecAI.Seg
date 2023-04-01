#include <Rcpp.h>
using namespace Rcpp;

//' @export
// [[Rcpp::export]]
NumericMatrix get_neigh(int row, int col, List img) {
  NumericMatrix temp = img[0];
  int u = std::max(row-1, 0);
  int d = std::min(row+1, temp.nrow()-1);
  int l = std::max(col-1, 0);
  int r = std::min(col+1, temp.ncol()-1);
  NumericMatrix res((d-u+1) * (r-l+1), img.length());

  int ind = 0;
  for (int i=u; i<=d; i++) {
    for (int j=l; j<=r; j++) {
      for (int k=0; k<img.length(); k++) {
        NumericMatrix temp = img[k];
        res(ind, k) = temp(i, j);
      }
      ind++;
    }
  }

  return(res);
}


