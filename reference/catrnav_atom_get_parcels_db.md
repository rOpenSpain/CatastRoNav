# ATOM INSPIRE: Reference database for ATOM cadastral parcels

Create a database containing the urls provided in the INSPIRE ATOM
service for extracting Cadastral Parcels.

## Usage

``` r
catrnav_atom_get_parcels_db_all(
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

  A logical whether to do caching. Default is `TRUE`. See **About
  caching** section on
  [`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md).

- update_cache:

  A logical whether to update cache. Default is `FALSE`. When set to
  `TRUE` it would force a fresh download of the source file.

- cache_dir:

  A path to a cache directory. On missing value the function would store
  the cached files on a temporary dir (See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
information requested:

- `munic`: Name of the municipality.

- `url`: url for downloading information of the corresponding
  municipality.

- `date`: Reference date of the data.

## See also

Other ATOM:
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md),
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md),
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md),
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md)

Other parcels:
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md),
[`catrnav_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_parcels_bbox.md)

## Examples

``` r
# \donttest{
catrnav_atom_get_parcels_db_all()
#> # A tibble: 342 × 3
#>    munic                            url                               date      
#>    <chr>                            <chr>                             <date>    
#>  1 001 Abáigar                      https://filescartografia.navarra… 2025-12-31
#>  2 002 Abárzuza / Abartzuza         https://filescartografia.navarra… 2025-12-31
#>  3 003 Abaurregaina / Abaurrea Alta https://filescartografia.navarra… 2025-12-31
#>  4 004 Abaurrepea / Abaurrea Baja   https://filescartografia.navarra… 2025-12-31
#>  5 005 Aberin                       https://filescartografia.navarra… 2025-12-31
#>  6 006 Ablitas                      https://filescartografia.navarra… 2025-12-31
#>  7 007 Adiós                        https://filescartografia.navarra… 2025-12-31
#>  8 008 Aguilar de Codés             https://filescartografia.navarra… 2025-12-31
#>  9 009 Aibar / Oibar                https://filescartografia.navarra… 2025-12-31
#> 10 010 Altsasu / Alsasua            https://filescartografia.navarra… 2025-12-31
#> # ℹ 332 more rows
# }
```
