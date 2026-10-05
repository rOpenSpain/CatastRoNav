# ATOM INSPIRE: download all buildings for a municipality

Downloads spatial data for all buildings in a municipality using the
ATOM INSPIRE service provided by the Cadastre of Navarre.

## Usage

``` r
catrnav_atom_get_buildings(
  munic,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Source

[SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)

## Arguments

- munic:

  A single municipality name, partial name or cadastral code. Accepts a
  character string or numeric code. Use
  [`catrnav_atom_search_munic()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_search_munic.md)
  to search for available municipalities.

- cache:

  **\[deprecated\]** This argument is no longer supported because
  results are always cached.

- update_cache:

  Logical. Whether to refresh the cached file. Defaults to `FALSE`.

- cache_dir:

  Path to a cache directory. If `NULL`, uses the configured cache or a
  directory inside
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html). See
  [`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md).

- verbose:

  Logical. Whether to display informational messages.

## Value

An [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.
Returns [`NULL`](https://rdrr.io/r/base/NULL.html) if the data cannot be
retrieved.

## Details

Empty, missing or non-scalar values of `munic` produce an error before
any download is attempted. Returns `NULL` if no municipality matches
`munic`. Municipal ZIP archives are read directly without extracting
their contents to disk.

## See also

[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md)
lists available municipal downloads.
[`catrnav_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_buildings.md)
retrieves buildings within a bounding box instead of downloading a
complete municipal dataset.

[`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)
configures the download cache and
[`catrnav_clear_cache()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_clear_cache.md)
removes cached downloads.

Query ATOM INSPIRE services:
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md),
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md),
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md),
[`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md),
[`catrnav_atom_search_munic()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_search_munic.md)

Work with cadastral buildings:
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md),
[`catrnav_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_buildings.md),
[`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wms_get_layer.md)

## Examples

``` r

s <- catrnav_atom_get_buildings("Iru<U+00F1>a")
#> ! No municipality matched the pattern "Iru<U+00F1>a".
#> ℹ Check available municipalities with `catrnav_atom_get_buildings_db_all()`.

library(ggplot2)

ggplot(s) +
  geom_sf() +
  labs(
    title = "Buildings",
    subtitle = "Pamplona / Iru<U+00F1>a"
  )
```
