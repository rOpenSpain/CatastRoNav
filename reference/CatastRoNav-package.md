# CatastRoNav: Interface to the 'INSPIRE' Services of the Cadastre of Navarre

Provides access to public spatial data from the Cadastre of Navarre
through its 'INSPIRE' ATOM feeds, Web Feature Service and Web Map
Service endpoints provided by the Government of Navarre through the
Sistema de Información Territorial de Navarra ('SITNA'). Supports
complete municipal dataset downloads, bounding box feature queries and
georeferenced map image downloads for addresses, buildings and cadastral
parcels.

## See also

- [`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md),
  [`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md)
  and
  [`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md)
  download complete municipal datasets.

- [`catrnav_atom_get_address_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address_db.md),
  [`catrnav_atom_get_buildings_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings_db.md)
  and
  [`catrnav_atom_get_parcels_db_all()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels_db.md)
  list municipal download URLs.

- [`catrnav_atom_search_munic()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_search_munic.md)
  searches for available municipalities.

- [`catrnav_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_address.md),
  [`catrnav_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_buildings.md)
  and
  [`catrnav_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_parcels.md)
  query features within a bounding box.

- [`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wms_get_layer.md)
  downloads georeferenced map images.

- [`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md),
  [`catrnav_detect_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)
  and
  [`catrnav_clear_cache()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_clear_cache.md)
  configure, inspect and clear the local cache.

- The [package website](https://ropenspain.github.io/CatastRoNav/)
  provides articles and the complete reference index.

- Browse the [source code](https://github.com/rOpenSpain/CatastRoNav) or
  [report an issue](https://github.com/rOpenSpain/CatastRoNav/issues).

## Author

**Maintainer**: Diego Hernangómez <diego.hernangomezherrero@gmail.com>
([ORCID](https://orcid.org/0000-0001-8457-4658)) \[copyright holder\]

Authors:

- Diego Hernangómez <diego.hernangomezherrero@gmail.com>
  ([ORCID](https://orcid.org/0000-0001-8457-4658)) \[copyright holder\]

Other contributors:

- Francisco J. Goerlich ([ORCID](https://orcid.org/0000-0003-1626-525X))
  \[contributor\]

- Gobierno de Navarra ([ROR](https://ror.org/025qq4838)) (Provider of
  cadastral data and INSPIRE services through SITNA) \[data
  contributor\]
