#include <Rcpp.h>
#include <opencv2/opencv.hpp>
using namespace Rcpp;


// Helper function to find local minima
NumericMatrix find_local_minima(NumericMatrix gradient_image) {
  int rows = gradient_image.nrow();
  int cols = gradient_image.ncol();
  NumericMatrix local_minima(rows, cols);

  for (int i = 1; i < rows - 1; ++i) {
    for (int j = 1; j < cols - 1; ++j) {
      float center = gradient_image(i, j);
      bool is_min = true;

      // Check 8-neighborhood to determine if the current pixel is a local minimum
      for (int m = -1; m <= 1 && is_min; ++m) {
        for (int n = -1; n <= 1; ++n) {
          if (m == 0 && n == 0) continue; // Skip the center pixel

          if (gradient_image(i + m, j + n) <= center) {
            is_min = false;
            break;
          }
        }
      }

      // If the current pixel is a local minimum, set its value to 1 in the local_minima matrix
      if (is_min) {
        local_minima(i, j) = 1;
      }
    }
  }

  return local_minima;
}


// Helper functions for NumericMatrix and cv::Mat conversion
cv::Mat numericMatrixToMat(NumericMatrix nm) {
  int rows = nm.nrow();
  int cols = nm.ncol();
  cv::Mat mat(rows, cols, CV_32F);

  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      mat.at<float>(i, j) = nm(i, j);
    }
  }

  return mat;
}

NumericMatrix matToNumericMatrix(cv::Mat mat) {
  int rows = mat.rows;
  int cols = mat.cols;
  NumericMatrix nm(rows, cols);

  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      nm(i, j) = mat.at<float>(i, j);
    }
  }

  return nm;
}

// impose_markers function
// [[Rcpp::export]]
NumericMatrix impose_markers(NumericMatrix gradient_image, NumericMatrix markers) {
  NumericMatrix modified_gradient_image = clone(gradient_image);
  int rows = gradient_image.nrow();
  int cols = gradient_image.ncol();
  double high_constant = 1000000.0;

  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      if (markers(i, j) > 0) {
        modified_gradient_image(i, j) -= high_constant;
      }
    }
  }

  return modified_gradient_image;
}

// watershed function
// [[Rcpp::export]]
NumericMatrix watershed(NumericMatrix modified_gradient_image, NumericMatrix markers) {
  cv::Mat gradient_image = numericMatrixToMat(modified_gradient_image);
  cv::Mat marker_image = numericMatrixToMat(markers);
  marker_image.convertTo(marker_image, CV_32S);
  cv::watershed(gradient_image, marker_image);
  NumericMatrix labeled_image = matToNumericMatrix(marker_image);

  return labeled_image;
}

// marker_based_watershed function
// [[Rcpp::export]]
NumericMatrix marker_based_watershed(NumericMatrix gradient_image, NumericMatrix marker_image) {
  NumericMatrix modified_gradient_image = impose_markers(gradient_image, marker_image);
  NumericMatrix labeled_image = watershed(modified_gradient_image, marker_image);

  return labeled_image;
}

