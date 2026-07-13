# ATOM INSPIRE: list building download URLs

Creates a table of URLs provided by the Cadastre of Navarre ATOM INSPIRE
service for downloading buildings by municipality.

## Usage

``` r
catrnav_atom_get_buildings_db_all(
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Source

[SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)

## Arguments

- cache:

  A logical value indicating whether to use cached files. Defaults to
  `TRUE`.

- update_cache:

  Logical. Should the cached file be refreshed? Defaults to `FALSE`.
  When set to `TRUE`, it forces a new download.

- cache_dir:

  Path to a cache directory. On `NULL`, the function stores cached files
  in a temporary directory (see
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

A [tibble](https://dplyr.tidyverse.org/reference/defunct.html) with the
requested information in the following columns:

- `munic`: Municipality name and cadastral code.

- `url`: ATOM URL for the corresponding municipality.

- `date`: Reference date of the data.

## See also

Download data from the ATOM INSPIRE service:
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md),
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md),
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md),
[`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md),
[`catrnav_atom_search_munic()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_search_munic.md)

Work with cadastral buildings:
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md),
[`catrnav_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_buildings.md),
[`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wms_get_layer.md)

## Examples

``` r
catrnav_atom_get_buildings_db_all()
#> # A tibble: 281 × 3
#>    munic                            url                               date      
#>    <chr>                            <chr>                             <date>    
#>  1 001 Abáigar                      https://filescartografia.navarra… 2026-06-30
#>  2 002 Abárzuza / Abartzuza         https://filescartografia.navarra… 2026-06-30
#>  3 003 Abaurregaina / Abaurrea Alta https://filescartografia.navarra… 2026-06-30
#>  4 004 Abaurrepea / Abaurrea Baja   https://filescartografia.navarra… 2026-06-30
#>  5 005 Aberin                       https://filescartografia.navarra… 2026-06-30
#>  6 006 Ablitas                      https://filescartografia.navarra… 2026-06-30
#>  7 007 Adiós                        https://filescartografia.navarra… 2026-06-30
#>  8 008 Aguilar de Codés             https://filescartografia.navarra… 2026-06-30
#>  9 009 Aibar / Oibar                https://filescartografia.navarra… 2026-06-30
#> 10 010 Altsasu / Alsasua            https://filescartografia.navarra… 2026-06-30
#> # ℹ 271 more rows
```
