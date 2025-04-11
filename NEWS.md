# CatastRoNav (development version)

-   Adding ATOM capabilities for buildings and addresses (#11, #12) by
    \@fgoerlich. New functions:
    -   `catrnav_atom_get_address()`
    -   `catrnav_atom_get_address_db_all()`
    -   `catrnav_atom_get_buildings()`
    -   `catrnav_atom_get_buildings_db_all()`

# CatastRoNav 0.1.0

-   Improve condition handling.
-   Add a `count` parameter that allows to set the maximum number of features to
    be returned.
-   **New features**;
    -   Support for ATOM on cadastral parcels added, see
        `catrnav_atom_get_parcels()`. Other ATOM capabilities to be added when
        the Cadastre of Navarra make them available.
    -   New caching system, see `catrnav_set_cache_dir()` and
        `catrnav_detect_cache_dir()`.
    -   New dependency: **rappdirs** .

# CatastRoNav 0.0.2

-   Make \CRANpkg{sf} objects valid with `sf::st_make_valid()`.

# CatastRoNav 0.0.1

-   Initial release.

# CatastRoNav 0.0.0.9000

**This is a pre-release**

-   Added a `NEWS.md` file to track changes to the package.
-   Add DOI: <https://doi.org/10.5281/zenodo.6366407>
