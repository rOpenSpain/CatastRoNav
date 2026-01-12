# Changelog

## CatastRoNav (development version)

- Adding ATOM capabilities for buildings and addresses
  ([\#11](https://github.com/rOpenSpain/CatastRoNav/issues/11),
  [\#12](https://github.com/rOpenSpain/CatastRoNav/issues/12)) by
  [@fgoerlich](https://github.com/fgoerlich). New functions:
  - [`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md)
  - [`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md)
  - [`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md)
  - [`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md)

## CatastRoNav 0.1.0

- Improve condition handling.
- Add a `count` parameter that allows to set the maximum number of
  features to be returned.
- **New features**;
  - Support for ATOM on cadastral parcels added, see
    [`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md).
    Other ATOM capabilities to be added when the Cadastre of Navarra
    make them available.
  - New caching system, see
    [`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)
    and
    [`catrnav_detect_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md).
  - New dependency: **rappdirs** .

## CatastRoNav 0.0.2

- Make objects valid with
  [`sf::st_make_valid()`](https://r-spatial.github.io/sf/reference/valid.html).

## CatastRoNav 0.0.1

- Initial release.

## CatastRoNav 0.0.0.9000

**This is a pre-release**

- Added a `NEWS.md` file to track changes to the package.
- Add DOI: <https://doi.org/10.5281/zenodo.6366407>
