# CatastRoNav 1.0.0

- The package is now licensed under GPL-2. Data from the Government of
  Navarre remain available under CC BY 4.0.
- User-facing messages now use **cli** for consistent, informative output.
- This refactor was completed with AI assistance and reviewed by the package
  maintainer.
- Network requests now use **httr2** with retries. Use
  `options(catastronav_timeout = 300)` to set the timeout and
  `options(catastronav_ssl_verify = 1L)` to control SSL verification. These
  settings fall back to `catastro_timeout` and `catastro_ssl_verify`,
  respectively. Requests now detect offline sessions before downloading and
  failed requests return `NULL` instead of stopping execution.
- Spatial files now use the same UTF-8 normalization strategy as **CatastRo**,
  removing the **stringi** dependency and avoiding lossy transliteration.
- Spatial results now have valid geometries, UTF-8 metadata and normalized CRS
  definitions when an EPSG code is available.
- The minimum supported R version is now 4.1.0.
- Added ATOM capabilities for buildings and addresses (#11, #12) by \@fgoerlich.
  New functions:
  - `catrnav_atom_get_address()`
  - `catrnav_atom_get_address_db_all()`
  - `catrnav_atom_get_buildings()`
  - `catrnav_atom_get_buildings_db_all()`
- Added WMS INSPIRE support with `catrnav_wms_get_layer()` using **mapSpain**
  and **terra**. It retrieves address, building and cadastral parcel layers,
  supports the `ELFCadastre` parcel style and accepts additional **mapSpain**
  request settings through `options`. Offline or failed requests return `NULL`.
- Adapted the vignette to Quarto.
- `catrnav_atom_get_address()`, `catrnav_atom_get_buildings()` and
  `catrnav_atom_get_parcels()` now select the closest municipality when a
  pattern matches multiple names and report the alternatives. Calls with
  `cache = FALSE` use temporary files and invalid arguments produce informative
  errors.
- `catrnav_atom_search_munic()` now searches the ATOM index by municipality name
  or cadastral code and returns all matches ordered by proximity.
- `catrnav_clear_cache()` now validates its arguments and reports the size of
  deleted cached data when `verbose = TRUE`.
- `catrnav_detect_cache_dir()` now reports the active cache directory.
- `catrnav_set_cache_dir()` now defaults `cache_dir` to `NULL`, validates its
  arguments and stores persistent configuration under `tools::R_user_dir()`.
  Existing configuration is migrated automatically from the previous location
  and is reliably restored in later sessions. Set `cache_dir = FALSE` to use a
  nonpersistent temporary cache even when `install = TRUE`.
- `catrnav_wfs_get_address_bbox()`, `catrnav_wfs_get_buildings_bbox()` and
  `catrnav_wfs_get_parcels_bbox()` now default `srs` to `4326`, validate
  bounding boxes, CRS values and `count` and use `CatastRo::inspire_wfs_get()`
  for requests. Set `options(catastronav_wfs_limit_km2 = ...)` to warn when a
  query exceeds a chosen area in square kilometers. The default `Inf` disables
  this warning.
- `run_example()` now determines whether network-dependent examples should run
  based on CRAN status and network availability.

# CatastRoNav 0.1.0

- Improved condition handling.
- Added a `count` argument that sets the maximum number of features to be
  returned.
- **New features:**
  - Added support for ATOM cadastral parcels. See `catrnav_atom_get_parcels()`.
    Other ATOM capabilities to be added when the Cadastre of Navarre makes them
    available.
  - Added a caching system. See `catrnav_set_cache_dir()` and
    `catrnav_detect_cache_dir()`.
  - Added the **rappdirs** dependency.

# CatastRoNav 0.0.2

- Made `sf` objects valid with `sf::st_make_valid()`.

# CatastRoNav 0.0.1

- Initial release.

# CatastRoNav 0.0.0.9000

**This is a pre-release.**

- Added a `NEWS.md` file to track changes to the package.
- Added DOI: <https://doi.org/10.5281/zenodo.6366407>.
