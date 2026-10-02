# Package index

## Find municipalities

Search by municipality name or cadastral code before downloading data.

- [`catrnav_atom_search_munic()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_search_munic.md)
  : ATOM INSPIRE: search for municipalities

## Download municipal datasets

Use the ATOM service to retrieve complete municipal datasets for
addresses, buildings and cadastral parcels.

### Explore download URLs

List available municipalities, download URLs and data reference dates.

- [`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md)
  : ATOM INSPIRE: list address download URLs
- [`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md)
  : ATOM INSPIRE: list building download URLs
- [`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md)
  : ATOM INSPIRE: list cadastral parcel download URLs

### Download spatial features

Download all features of a selected type for one municipality as an
**sf** object.

- [`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md)
  : ATOM INSPIRE: download all addresses for a municipality
- [`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md)
  : ATOM INSPIRE: download all buildings for a municipality
- [`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md)
  : ATOM INSPIRE: download all cadastral parcels for a municipality

## Query features within a bounding box

Use the WFS service to retrieve addresses, buildings or cadastral
parcels for a selected area as an **sf** object.

- [`catrnav_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_address.md)
  : WFS INSPIRE: retrieve addresses
- [`catrnav_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_buildings.md)
  : WFS INSPIRE: retrieve buildings
- [`catrnav_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_parcels.md)
  : WFS INSPIRE: retrieve cadastral parcels

## Download map images

Use the WMS service to download georeferenced cadastral map images as a
**terra** SpatRaster object.

- [`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wms_get_layer.md)
  : WMS INSPIRE: download georeferenced map images

## Manage the cache

Configure, inspect and clear the local cache used by **CatastRoNav**.

- [`catrnav_clear_cache()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_clear_cache.md)
  :

  Clear your CatastRoNav cache directory

- [`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)
  [`catrnav_detect_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)
  :

  Set your CatastRoNav cache directory

## Package overview

Read the package overview and follow links to the main workflows.

- [`CatastRoNav`](https://ropenspain.github.io/CatastRoNav/reference/CatastRoNav-package.md)
  [`CatastRoNav-package`](https://ropenspain.github.io/CatastRoNav/reference/CatastRoNav-package.md)
  : CatastRoNav: Interface to the 'INSPIRE' Services of the Cadastre of
  Navarre
