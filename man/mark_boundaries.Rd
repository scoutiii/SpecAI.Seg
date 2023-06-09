% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Watershed.R
\name{mark_boundaries}
\alias{mark_boundaries}
\title{Mark boundaries for HSI}
\usage{
mark_boundaries(seg, img_rgb, col = c(1, 1, 0))
}
\arguments{
\item{seg}{The segmented image, typically returned from watershed_SpecAI.}

\item{img_rgb}{The image to be marked up, with RGB channels, or an HSI_data.}

\item{col}{A vector of colors representing (R, G, B) values between 0 and 1.}
}
\value{
The image with boundaries marked.
}
\description{
Find the boundaries of a segmented image
}
