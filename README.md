

<!-- README.md is generated from README.qmd. Please edit that file -->

# CatastRoNav <a href="https://ropenspain.github.io/CatastRoNav/"><img src="man/figures/logo.png" alt="CatastRoNav website" align="right" height="139"/></a>

<!-- badges: start -->

[![rOS-badge](https://ropenspain.github.io/rostemplate/reference/figures/ropenspain-badge.svg)](https://ropenspain.es/)
[![CatastRoNav status
badge](https://ropenspain.r-universe.dev/badges/CatastRoNav)](https://ropenspain.r-universe.dev/CatastRoNav)
[![R-CMD-check](https://github.com/rOpenSpain/CatastRoNav/actions/workflows/roscron-check-standard.yaml/badge.svg)](https://github.com/rOpenSpain/CatastRoNav/actions/workflows/roscron-check-standard.yaml)
[![codecov](https://codecov.io/gh/rOpenSpain/CatastRoNav/branch/main/graph/badge.svg)](https://app.codecov.io/gh/rOpenSpain/CatastRoNav)
[![DOI](https://img.shields.io/badge/DOI-10.5281/zenodo.6366407-blue)](https://doi.org/10.5281/zenodo.6366407)
[![Project-Status:Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

<!-- badges: end -->

**CatastRoNav** provides access to services from the [Cadastre of
Navarre](https://geoportal.navarra.es/es/idena). With **CatastRoNav**,
you can retrieve addresses, buildings and cadastral parcels through its
INSPIRE ATOM and WFS services, and download georeferenced images through
its WMS service.

## Installation

You can install the development version of **CatastRoNav** from
[r-universe](https://ropenspain.r-universe.dev/CatastRoNav):

``` r
# Install CatastRoNav from r-universe.
install.packages(
  "CatastRoNav",
  repos = c(
    "https://ropenspain.r-universe.dev",
    "https://cloud.r-project.org"
  )
)
```

Alternatively, install the development version from GitHub with the
**pak** package:

``` r
pak::pak("rOpenSpain/CatastRoNav")
```

## Package API

Functions in **CatastRoNav** are organized by source service. Function
names follow the `catrnav_*service*_*description*` convention.

### INSPIRE services

**CatastRoNav** retrieves cadastral data from the Cadastre of Navarre
through three INSPIRE services:

#### ATOM service

The ATOM service downloads complete municipal datasets for addresses,
buildings and cadastral parcels. Download functions return `sf` objects
from the **sf** package. Index and search functions return tibbles.

These functions use the `catrnav_atom_get_*()` prefix.

#### WFS service

The WFS service retrieves cadastral features within a supplied bounding
box. Results are returned as `sf` objects from the
[**sf**](https://r-spatial.github.io/sf/) package. For full municipal
downloads, prefer the ATOM service.

These functions use the `catrnav_wfs_get_*()` prefix.

#### WMS service

The WMS service downloads georeferenced map images for addresses,
buildings and cadastral parcels. `catrnav_wms_get_layer()` returns a
`SpatRaster` object from the **terra** package.

#### Terms and conditions of use

Data are provided by the Government of Navarre under the [Creative
Commons Attribution 4.0 International (CC BY
4.0)](https://creativecommons.org/licenses/by/4.0/) license. The service
is provided “as is” without warranties of any kind, either express or
implied.

Data source: [SITNA – Government of
Navarre](https://geoportal.navarra.es/es/inspire).

## Examples

### Retrieve features with the WFS service

``` r
library(CatastRoNav)
library(ggplot2)

wfs_get_buildings <- catrnav_wfs_get_buildings_bbox(
  c(-1.652563, 42.478016, -1.646919, 42.483333),
  srs = 4326
)
# Plot the buildings.
ggplot(wfs_get_buildings) +
  geom_sf() +
  ggtitle("Olite, Navarre")
```

<img src="man/figures/README-wfs-1.png" style="width:100.0%"
alt="Buildings retrieved with CatastRoNav in Olite" />

## Cache management

Downloaded files are cached locally. Use `catrnav_detect_cache_dir()` to
inspect the active cache, `catrnav_set_cache_dir()` to configure it and
`catrnav_clear_cache()` to remove cached data.

## Citation

<p>

Hernangómez D (2026). <em>CatastRoNav: Interface to the INSPIRE Services
of the Cadastre of Navarre</em>.
<a href="https://doi.org/10.5281/zenodo.6366407">doi:10.5281/zenodo.6366407</a>.
<a href="https://ropenspain.github.io/CatastRoNav/">https://ropenspain.github.io/CatastRoNav/</a>.
</p>

A BibTeX entry for LaTeX users is:

    @Manual{R-catastronav,
      title = {{CatastRoNav}: Interface to the INSPIRE Services of the Cadastre of Navarre},
      year = {2026},
      version = {1.0.0},
      author = {Diego Hernangómez},
      doi = {10.5281/zenodo.6366407},
      url = {https://ropenspain.github.io/CatastRoNav/},
      abstract = {Provides access to public spatial data from the Cadastre of Navarre through its INSPIRE Atom feeds, Web Feature Service and Web Map Service endpoints. Supports complete municipal dataset downloads, bounding box feature queries and georeferenced map image downloads for addresses, buildings and cadastral parcels.},
    }

## Contributing

See the [source code and issue
tracker](https://github.com/rOpenSpain/CatastRoNav) on GitHub.

## See also

The [**CatastRo**](https://CRAN.R-project.org/package=CatastRo) package
provides similar functionality for the rest of Spain, excluding the
Basque Country and Navarre.
