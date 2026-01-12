# Download buildings of Navarre in spatial format

Get the spatial data of buildings by bounding box.

## Usage

``` r
catrnav_wfs_get_buildings_bbox(x, srs, verbose = FALSE, count = NULL)
```

## Source

[SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)

## Arguments

- x:

  See **Details**. It could be:

  - A numeric vector of length 4 with the coordinates that defines the
    bounding box: `c(xmin, ymin, xmax, ymax)`.

  - A `sf/sfc` object, as provided by the
    [sf](https://CRAN.R-project.org/package=sf) package.

- srs:

  SRS/CRS to use on the query. See **Details**.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

- count:

  integer, indicating the maximum number of features to return. The
  default value `NULL` does not pass this parameter to the query, and
  the maximum number of features would be determined by the default
  value of the API service (5,000 in this case).

## Value

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## Details

When `x` is a numeric vector, make sure that the `srs` matches the
coordinate values. Additionally, when the `srs` correspond to a
geographic reference system (4326, 4258), the function queries the
bounding box on [EPSG:25830](https://epsg.io/25830) - ETRS89 / UTM zone
30N. The result is provided always in the SRS provided in `srs`.

When `x` is a [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
object, the value `srs` is ignored. The query is performed using
[EPSG:25830](https://epsg.io/25830) (ETRS89 / UTM zone 30N) and the
spatial object is projected back to the SRS of the initial object.

## See also

[`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html)

[`CatastRo::catr_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRo/reference/catr_wfs_get_buildings.html)

## Examples

``` r
# \donttest{
downtown <- c(-1.646812, 42.814528, -1.638036, 42.820320)

bu <- catrnav_wfs_get_buildings_bbox(downtown, srs = 4326)

library(ggplot2)

ggplot(bu) +
  geom_sf()

# }
```
