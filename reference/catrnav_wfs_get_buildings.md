# WFS INSPIRE: retrieve buildings

Retrieves spatial building data from the Cadastre of Navarre WFS INSPIRE
service. `catrnav_wfs_get_buildings_bbox()` retrieves features within
the supplied bounding box. See **Bounding box**.

## Usage

``` r
catrnav_wfs_get_buildings_bbox(x, srs = 4326, verbose = FALSE, count = NULL)
```

## Source

[SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)

## Arguments

- x:

  See **Bounding box**. Can be one of:

  - A numeric vector of length 4 with the coordinates that define the
    bounding box: `c(xmin, ymin, xmax, ymax)`.

  - A `sf/sfc` object, as provided by the
    [sf](https://CRAN.R-project.org/package=sf) package.

- srs:

  CRS to use for the query. Defaults to `4326`. See **Bounding box**.

- verbose:

  Logical. If `TRUE`, displays informational messages.

- count:

  Positive whole number specifying the maximum number of features to
  return. If `NULL`, the service default applies.

## Value

An [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object, or
`NULL` if the data cannot be retrieved.

## API limits

The service returns a maximum of 5,000 features by default. Use `count`
to request a smaller result.

## Bounding box

When `x` is a numeric vector, make sure that `srs` matches the
coordinate values. The function queries the bounding box in
[EPSG:25830](https://epsg.io/25830), ETRS89 / UTM zone 30N, then
transforms the result back to `srs`.

When `x` is an [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
or `sfc` object, `srs` is ignored. The object's bounding box is used for
the query and the result is transformed back to the input CRS. See
[`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html).

## See also

Query data from the WFS INSPIRE service:
[`catrnav_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_address.md),
[`catrnav_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_parcels.md)

Work with cadastral buildings:
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md),
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md),
[`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wms_get_layer.md)

## Examples

``` r
downtown <- c(-1.646812, 42.814528, -1.638036, 42.820320)

bu <- catrnav_wfs_get_buildings_bbox(downtown, srs = 4326)
#> ✖ HTTP error 400 (Bad Request): <https://inspire.navarra.es/services/BU/wfs?version=2.0.0&service=WFS&request=getfeature&typenames=BU:Building&bbox=610617.766512854,4741106.72145066,611345.573637764,4741761.4626862&srsname=EPSG:25830>.
#> ! If this looks like a package bug, please open an issue at <https://github.com/ropenspain/CatastRo/issues>
#> → Returning "NULL" because the download failed.

library(ggplot2)

ggplot(bu) +
  geom_sf()
```
