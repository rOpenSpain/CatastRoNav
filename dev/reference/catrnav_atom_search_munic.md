# ATOM INSPIRE: search for municipalities

Searches for a municipality by name or cadastral code in the Cadastre of
Navarre ATOM index.

## Usage

``` r
catrnav_atom_search_munic(
  munic,
  cache = deprecated(),
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Arguments

- munic:

  A single municipality name, partial name or cadastral code. Accepts a
  character string or numeric code. Use `catrnav_atom_search_munic()` to
  search for available municipalities.

- cache:

  **\[deprecated\]** This argument is no longer supported because
  results are always cached.

- update_cache:

  Logical. Whether to refresh the cached file. Defaults to `FALSE`.

- cache_dir:

  Path to a cache directory. If `NULL`, uses the configured cache or a
  directory inside
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html). See
  [`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_set_cache_dir.md).

- verbose:

  Logical. Whether to display informational messages.

## Value

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html)
with the municipality name and cadastral code. Returns
[`NULL`](https://rdrr.io/r/base/NULL.html) if no match is found or the
data cannot be retrieved.

## See also

[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_address_db.md)
provides the index used by this search.
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_buildings_db.md)
and
[`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_parcels_db.md)
list downloads for the other data types. Use the selected name or
cadastral code with
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_buildings.md)
or
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_parcels.md)
to download a complete municipal dataset.

Query ATOM INSPIRE services:
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_address_db.md),
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_buildings.md),
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_buildings_db.md),
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_parcels.md),
[`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/dev/reference/catrnav_atom_get_parcels_db.md)

## Examples

``` r
catrnav_atom_search_munic("Pamplona")
#> # A tibble: 1 × 2
#>   munic                catrcode
#>   <chr>                <chr>   
#> 1 201 Pamplona / Iruña 201     

# Search using a numeric cadastral code.
catrnav_atom_search_munic(201)
#> # A tibble: 1 × 2
#>   munic                catrcode
#>   <chr>                <chr>   
#> 1 201 Pamplona / Iruña 201     
```
