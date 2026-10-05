# WFS INSPIRE: retrieve cadastral parcels

Retrieves spatial cadastral parcel data from the Cadastre of Navarre WFS
INSPIRE service. `catrnav_wfs_get_parcels_bbox()` retrieves features
within the supplied bounding box. See **Bounding box**.

## Usage

``` r
catrnav_wfs_get_parcels_bbox(x, srs = 4326, verbose = FALSE, count = NULL)
```

## Source

[SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)

## Arguments

- x:

  Input defining the query area. See **Bounding box**. It can be:

  - A numeric vector of length 4 with the coordinates that define the
    bounding box: `c(xmin, ymin, xmax, ymax)`.

  - An [`sf`](https://r-spatial.github.io/sf/reference/sf.html) or
    [`sfc`](https://r-spatial.github.io/sf/reference/sfc.html) object
    from [sf](https://CRAN.R-project.org/package=sf).

- srs:

  The CRS to use for the query. Defaults to `4326`. See **Bounding
  box**.

- verbose:

  Logical. Whether to display informational messages.

- count:

  A positive whole number specifying the maximum number of features to
  return. If `NULL`, the service default applies.

## Value

An [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.
Returns [`NULL`](https://rdrr.io/r/base/NULL.html) if the data cannot be
retrieved.

## Details

Responses are cached in the `wfs_inspire_cache` subdirectory of the
[`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_set_cache_dir.md)
cache. Repeated queries reuse the cached file. Clear the cache with
[`catrnav_clear_cache()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_clear_cache.md)
to download fresh results.

## API limits

The service returns a maximum of 5,000 features by default. Use `count`
to request a smaller result.

## Bounding box

When `x` is a numeric vector, make sure that `srs` matches the
coordinate values. The function queries the bounding box in
[EPSG:25830](https://epsg.io/25830), ETRS89 / UTM zone 30N, then
transforms the result back to `srs`.

When `x` is an [`sf`](https://r-spatial.github.io/sf/reference/sf.html)
or [`sfc`](https://r-spatial.github.io/sf/reference/sfc.html) object,
`srs` is ignored. The object's bounding box is used for the query and
the result is transformed back to the input CRS. See
[`sf::st_bbox()`](https://r-spatial.github.io/sf/reference/st_bbox.html).

## See also

[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_parcels.md)
downloads all cadastral parcels for a municipality.

[`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_wms_get_layer.md)
retrieves a georeferenced map image rather than individual spatial
features.

Query WFS INSPIRE services:
[`catrnav_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_wfs_get_address.md),
[`catrnav_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_wfs_get_buildings.md)

Work with cadastral parcels:
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_parcels.md),
[`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_parcels_db.md),
[`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_wms_get_layer.md)

## Examples

``` r
downtown <- c(-1.646812, 42.814528, -1.638036, 42.820320)

cp <- catrnav_wfs_get_parcels_bbox(downtown, srs = 4326)

library(ggplot2)

ggplot(cp) +
  geom_sf()
```
