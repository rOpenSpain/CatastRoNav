# ATOM INSPIRE: search for municipalities

Searches for a municipality by name or cadastral code in the Cadastre of
Navarre ATOM index.

## Usage

``` r
catrnav_atom_search_munic(
  munic,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Arguments

- munic:

  Municipality name, partial name or cadastral code to search for.

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
municipality name and cadastral code, or `NULL` if no match is found.

## See also

Download data from the ATOM INSPIRE service:
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md),
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md),
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md),
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md),
[`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md)

## Examples

``` r
catrnav_atom_search_munic("Pamplona")
#> # A tibble: 1 × 2
#>   munic                catrcode
#>   <chr>                <chr>   
#> 1 201 Pamplona / Iruña 201     
```
