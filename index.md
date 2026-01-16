# CatastRoNav

**CatastRoNav** is a package that provide access to different API
services of the [Cadastre of
Navarre](https://geoportal.navarra.es/es/idena). With **CatastRoNav** it
is possible to download spatial objects as buildings or cadastral
parcels.

## Installation

You can install the developing version of **CatastRoNav** using the
[r-universe](https://ropenspain.r-universe.dev/CatastRoNav):

``` r
# Install CatastRoNav in R:
install.packages("CatastRoNav",
  repos = c(
    "https://ropenspain.r-universe.dev",
    "https://cloud.r-project.org"
  )
)
```

Alternatively, you can install the developing version of **CatastRoNav**
with:

``` r
remotes::install_github("rOpenSpain/CatastRoNav", dependencies = TRUE)
```

## Usage

The WFS service allows to download vector objects of specific cadastral
elements. The result is provided as `sf` objects (See [**sf**
package](https://r-spatial.github.io/sf/)).

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

![](reference/figures/README-wfs-1.png)

## Citation

Hernangómez D (2026). *CatastRoNav: Interface to the API Catastro de
Navarra*.
[doi:10.5281/zenodo.6366407](https://doi.org/10.5281/zenodo.6366407),
<https://ropenspain.github.io/CatastRoNav/>.

A BibTeX entry for LaTeX users is:

``` R
@Manual{R-catastronav,
  title = {{CatastRoNav}: Interface to the {API} {Catastro} de {Navarra}},
  author = {Diego Hernangómez},
  year = {2026},
  version = {0.1.0.9000},
  doi = {10.5281/zenodo.6366407},
  url = {https://ropenspain.github.io/CatastRoNav/},
  abstract = {Access public spatial data available under the INSPIRE directive. Tools for downloading references, buildings and addresses of properties on Navarre (Spain).},
}
```

## See also

The package [CatastRo](https://CRAN.R-project.org/package=CatastRo)
provides similar functionalities for Spain excluding the Basque Country
and Navarre.

## Terms and conditions of use

Data provided by the Government of Navarre under [Creative Commons
Attribution (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).
The service is provided “as is”, and without guarantee of any kind,
implicit or explicit.

Data source: [SITNA – Government of
Navarre](https://geoportal.navarra.es/es/inspire)
