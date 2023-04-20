
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SpecAI.Seg

<!-- badges: start -->
<!-- badges: end -->

The goal of SpecAI.Seg is to bring hyperspectral image (HSI)
segmentation to R. This package is based of the Python
[SpecAI.Seg](https://github.com/lanl/SpecAI.Seg) on
[PyPI](https://pypi.org/project/SpecAI.Seg/). The original SpecAI.Seg
package contains more functionality than this package, but this R
package contains most of the basic functionality. We provide the ability
to download a set of common HSI, namely Indian Pines, Salinas, Pavia
University, Pavia Center, Botswana, and Kennedy Space Center. More
information on these datasets can be found
[here](https://www.ehu.eus/ccwintco/index.php?title=Hyperspectral_Remote_Sensing_Scenes).

## Installation

You can install the development version of SpecAI.Seg from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("scoutiii/SpecAI.Seg")
```

Note that we use the Watershed segmentation algorithm from the
[EBImage](https://bioconductor.org/packages/release/bioc/html/EBImage.html)
package from Bioconductor. For this reason be sure to have the
[BiocManager](https://www.bioconductor.org/install/) package installed,
which can be done with:

``` r
install.packages("BiocManager")
```

After installing BiocManager, try to install the SpecAI.Seg package
using devtools. If it still fails try also installing the EBImage
package manually with:

``` r
BiocManager::install("EBImage")
```

Note that if you are using macOS with the M1 chip, you will likely not
be able to install bioconductor, and will not be able to use this
package. Some resources can be found
[here](https://support.bioconductor.org/p/9137290/).

## Example

Here is a basic example of using watershed segmentation on the Indian
Pines image. First, we can download the image with:

``` r
library(SpecAI.Seg)
## basic example code

ip <- get_data("indianpines")
#> Reading in pre-downloaded data...
# plot(ip)
```

You can then generate the watershed segmentation using:

``` r
seg <- watershed_hsi(ip)
# plot(seg, ip)
```
