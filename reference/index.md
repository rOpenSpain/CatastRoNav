# Package index

## Retrieve cadastral data

Download complete municipal datasets, query features within a selected
area or retrieve georeferenced cadastral map images.

### Complete municipal datasets

Download all addresses, buildings or cadastral parcels for a
municipality through the INSPIRE ATOM service. Use
[`catrnav_atom_search_munic()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_search_munic.md)
to find municipality names and codes.

- [`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md)
  : ATOM INSPIRE: download all addresses for a municipality
- [`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md)
  : ATOM INSPIRE: download all buildings for a municipality
- [`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md)
  : ATOM INSPIRE: download all cadastral parcels for a municipality

### ATOM download catalogs

Inspect available municipalities, download URLs and data reference
timestamps before retrieving complete datasets.

- [`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md)
  : ATOM INSPIRE: list address download URLs
- [`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md)
  : ATOM INSPIRE: list building download URLs
- [`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md)
  : ATOM INSPIRE: list cadastral parcel download URLs

### Features within a bounding box

Query addresses, buildings or cadastral parcels through the INSPIRE WFS
service. Results are returned as `sf` objects from the **sf** package.

- [`catrnav_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_address.md)
  : WFS INSPIRE: retrieve addresses
- [`catrnav_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_buildings.md)
  : WFS INSPIRE: retrieve buildings
- [`catrnav_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_parcels.md)
  : WFS INSPIRE: retrieve cadastral parcels

### Georeferenced map images

Download cadastral map images through WMS as `SpatRaster` objects from
the **terra** package. Use the spatial objects returned by WFS queries
to define the map extent.

- [`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wms_get_layer.md)
  : WMS INSPIRE: download georeferenced map images

## Find municipalities

Search the ATOM index by municipality name or cadastral code before
downloading a complete municipal dataset.

- [`catrnav_atom_search_munic()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_search_munic.md)
  : ATOM INSPIRE: search for municipalities

## Configure and inspect CatastRoNav

Manage downloaded files and access package-level documentation.

### Cache management

Configure, inspect and clear the local cache used by **CatastRoNav**.

- [`catrnav_clear_cache()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_clear_cache.md)
  :

  Clear your CatastRoNav cache directory

- [`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)
  [`catrnav_detect_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)
  :

  Set your CatastRoNav cache directory

### Package overview

Read the package overview and follow links to the main workflows.

- [`CatastRoNav`](https://ropenspain.github.io/CatastRoNav/reference/CatastRoNav-package.md)
  [`CatastRoNav-package`](https://ropenspain.github.io/CatastRoNav/reference/CatastRoNav-package.md)
  : CatastRoNav: Interface to the 'INSPIRE' Services of the Cadastre of
  Navarre
