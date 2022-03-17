
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CatastRoNav <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->
<!-- badges: end -->

**CatastRoNav** is a package that provide access to different API
services of the [Cadastre of
Navarre](https://idena.navarra.es/portal/servicios?lang=en). With
**CatastRoNav** it is possible to download spatial objects as buildings
or cadastral parcels.

## Installation

You can install the developing version of **CatastRoNav** using the
[r-universe](https://ropenspain.r-universe.dev/ui#builds):

``` r
# Enable this universe
options(repos = c(
  ropenspain = "https://ropenspain.r-universe.dev",
  CRAN = "https://cloud.r-project.org"
))
install.packages("CatastRoNav")
```

Alternatively, you can install the developing version of **CatastRoNav**
with:

``` r
library(remotes)
install_github("rOpenSpain/CatastRoNav", dependencies = TRUE)
```

## Usage

The WFS service allows to download vector objects of specific cadastral
elements. The result is provided as `sf` objects (See **sf** package).

``` r
library(CatastRoNav)
library(ggplot2)

wfs_get_buildings <- catrnav_wfs_get_buildings_bbox(
  c(-1.652563, 42.478016, -1.646919, 42.483333),
  srs = 4326
)
# Map
ggplot(wfs_get_buildings) +
  geom_sf() +
  ggtitle("Olite, Navarra")
```

<img src="man/figures/README-wfs-1.png" width="100%" />

## Citation

To cite ‘CatastRoNav’ in publications use:

Hernangómez D (2022). *CatastRoNav: Interface to the API Catastro de
Navarra*.

A BibTeX entry for LaTeX users is:

    @Manual{R-catastronav,
      title = {{CatastRoNav}: Interface to the {API} Catastro de Navarra},
      author = {Diego Hernangómez},
      year = {2022},
      version = {0.0.0.9000},
      abstract = {Access public spatial data available under the 'INSPIRE' directive. Tools for downloading references, buildings and addresses of properties on Navarre (Spain).},
    }

## See also

The package [CatastRo](https://CRAN.R-project.org/package=CatastRo)
provides similar functionalities for Spain excluding the Basque Country
and Navarre.

## Terms and conditions of use

Data provided by the Government of Navarre under [Creative Commons
Attribution (CC BY
4.0)](https://creativecommons.org/licenses/by/4.0/deed.en_EN). The
service is provided “as is”, and without guarantee of any kind, implicit
or explicit.

Data source: [SITNA – Government of
Navarre](https://sitna.navarra.es/geoportal/)
