# ATOM INSPIRE: Download all the cadastral parcels of a municipality

Get the spatial data of all the cadastral parcels belonging to a single
municipality using the INSPIRE ATOM service.

## Usage

``` r
catrnav_atom_get_parcels(
  munic,
  cache = TRUE,
  update_cache = FALSE,
  cache_dir = NULL,
  verbose = FALSE
)
```

## Arguments

- munic:

  Municipality to extract, It can be a part of a string or the cadastral
  code. See
  [catrnav_atom_get_parcels_db_all](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md).

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

A [`sf`](https://r-spatial.github.io/sf/reference/sf.html) object.

## References

[SITNA – Catastro de Navarra](https://geoportal.navarra.es/es/inspire)

## See also

Other ATOM:
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md),
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md),
[`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md),
[`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md)

Other parcels:
[`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md),
[`catrnav_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_parcels_bbox.md)

## Examples

``` r
# \donttest{

s <- catrnav_atom_get_parcels("Iruña")

library(ggplot2)

ggplot(s) +
  geom_sf() +
  labs(
    title = "Cadastral Zoning",
    subtitle = "Pamplona / Iruña"
  )

# }
```
