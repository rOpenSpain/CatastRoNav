# ATOM INSPIRE: list cadastral parcel download URLs

Creates a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) of
URLs provided by the Cadastre of Navarre ATOM INSPIRE service for
downloading cadastral parcels by municipality.

## Usage

``` r
catrnav_atom_get_parcels_db_all(
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Source

[SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)

## Arguments

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

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with the following columns. Returns
[`NULL`](https://rdrr.io/r/base/NULL.html) if the data cannot be
retrieved.

- `munic`: Municipality name and cadastral code.

- `url`: ATOM URL for the corresponding municipality.

- `date`: Reference timestamp of the data in UTC.

## See also

[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md)
downloads cadastral parcels for a municipality listed in this index.

[`catrnav_atom_search_munic()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_search_munic.md)
finds municipality names and cadastral codes.

Query ATOM INSPIRE services:
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md),
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md),
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md),
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md),
[`catrnav_atom_search_munic()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_search_munic.md)

Browse ATOM municipal indexes:
[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md),
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md)

Work with cadastral parcels:
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md),
[`catrnav_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_parcels.md),
[`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wms_get_layer.md)

## Examples

``` r
catrnav_atom_get_parcels_db_all()
#> # A tibble: 342 × 3
#>    munic                            url                      date               
#>    <chr>                            <chr>                    <dttm>             
#>  1 001 Abáigar                      https://filescartografi… 2026-06-30 13:45:03
#>  2 002 Abárzuza / Abartzuza         https://filescartografi… 2026-06-30 13:45:03
#>  3 003 Abaurregaina / Abaurrea Alta https://filescartografi… 2026-06-30 13:45:03
#>  4 004 Abaurrepea / Abaurrea Baja   https://filescartografi… 2026-06-30 13:45:03
#>  5 005 Aberin                       https://filescartografi… 2026-06-30 13:45:03
#>  6 006 Ablitas                      https://filescartografi… 2026-06-30 13:45:03
#>  7 007 Adiós                        https://filescartografi… 2026-06-30 13:45:03
#>  8 008 Aguilar de Codés             https://filescartografi… 2026-06-30 13:45:03
#>  9 009 Aibar / Oibar                https://filescartografi… 2026-06-30 13:45:03
#> 10 010 Altsasu / Alsasua            https://filescartografi… 2026-06-30 13:45:03
#> # ℹ 332 more rows
```
