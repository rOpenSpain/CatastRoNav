# WMS INSPIRE: download georeferenced map images

Downloads georeferenced map images from the Cadastre of Navarre WMS
service. This function wraps
[`mapSpain::esp_get_tiles()`](https://ropenspain.github.io/mapSpain/reference/esp_get_tiles.html).

## Usage

``` r
catrnav_wms_get_layer(
  x,
  srs = 4326,
  what = c("building", "parcel", "address"),
  styles = c("default", "ELFCadastre"),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE,
  crop = FALSE,
  options = NULL,
  ...
)
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

- what:

  WMS layer to download. See **Layers and styles**.

- styles:

  Style to apply to the selected WMS layer. See **Layers and styles**.

- update_cache:

  Logical. Should the cached file be refreshed? Defaults to `FALSE`.
  When set to `TRUE`, it forces a new download.

- cache_dir:

  Path to a cache directory. On `NULL`, the function stores cached files
  in a temporary directory (see
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- verbose:

  Logical. If `TRUE`, displays informational messages.

- crop:

  Logical. If `TRUE`, crop results to the specified `x` extent. If `x`
  is an [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object
  with one `POINT`, `crop` is set to `FALSE`. See
  [`terra::crop()`](https://rspatial.github.io/terra/reference/crop.html).

- options:

  A named list containing additional options to pass to the query.

- ...:

  Arguments passed on to
  [`mapSpain::esp_get_tiles`](https://ropenspain.github.io/mapSpain/reference/esp_get_tiles.html)

  `res`

  :   Character string or number. Only valid for WMS providers.
      Resolution (in pixels) of the final tile.

  `bbox_expand`

  :   Number. Expansion percentage of the bounding box of `x`.

  `transparent`

  :   Logical. Whether to use a transparent background, if supported.

  `mask`

  :   Logical. `TRUE` to mask the result to `x`. See
      [`terra::mask()`](https://rspatial.github.io/terra/reference/mask.html).

## Value

A [`SpatRaster`](https://rspatial.github.io/terra/reference/rast.html)
with three RGB or four RGBA layers, or `NULL` when the request cannot be
completed. See
[`terra::RGB()`](https://rspatial.github.io/terra/reference/RGB.html).

## Bounding box

When `x` is a numeric vector, make sure that `srs` matches the
coordinate values. When `x` is an
[`sf`](https://r-spatial.github.io/sf/reference/sf.html) or `sfc`
object, `srs` is ignored.

The query uses [EPSG:3857](https://epsg.io/3857), Web Mercator, then
transforms the image back to the input CRS. If the image appears
distorted, provide a spatial object as `x` or set `srs` to the CRS of
the requested image.

## Layers and styles

### Layers

The `what` argument selects one of the following API layers:

- `"parcel"`: `CP.CadastralParcel`.

- `"building"`: `BU.Building`.

- `"address"`: `AD.Address`.

### Styles

The WMS service provides different styles for each layer (`what`
argument). Available styles include:

- `"parcel"`: `"default"` and `"ELFCadastre"`.

- `"building"`: `"default"`.

- `"address"`: `"default"`.

## See also

- [`mapSpain::esp_get_tiles()`](https://ropenspain.github.io/mapSpain/reference/esp_get_tiles.html)
  downloads map tiles.

- [`terra::RGB()`](https://rspatial.github.io/terra/reference/RGB.html)
  identifies RGB channels.

- [`terra::plotRGB()`](https://rspatial.github.io/terra/reference/plotRGB.html)
  and
  [`tidyterra::geom_spatraster_rgb()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster_rgb.html)
  plot RGB rasters.

Work with cadastral addresses:
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md),
[`catrnav_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_address.md)

Work with cadastral buildings:
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md),
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md),
[`catrnav_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_buildings.md)

Work with cadastral parcels:
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md),
[`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md),
[`catrnav_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_parcels.md)

## Examples

``` r
# \donttest{
bu <- catrnav_wms_get_layer(
  c(-1.646812, 42.814528, -1.638036, 42.820320),
  srs = 4326,
  what = "building"
)

library(mapSpain)
library(ggplot2)
library(tidyterra)
#> 
#> Attaching package: ‘tidyterra’
#> The following object is masked from ‘package:stats’:
#> 
#>     filter

ggplot() +
  geom_spatraster_rgb(data = bu)
#> ! `data` has 4 layers. Selecting layers 1, 2, and 3.


# Parcels
parc <- catrnav_wms_get_layer(
  c(-1.646812, 42.814528, -1.638036, 42.820320),
  srs = 4326,
  what = "parcel"
)

ggplot() +
  geom_spatraster_rgb(data = parc)
#> ! `data` has 4 layers. Selecting layers 1, 2, and 3.

# }
```
