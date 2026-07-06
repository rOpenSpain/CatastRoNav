# parcel ATOM data returns NULL when offline

    Code
      result <- catrnav_atom_get_parcels("061", cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# parcel ATOM data handles HTTP 404 responses

    Code
      result <- catrnav_atom_get_parcels("061", cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_1_CP/CadastralParcels_ServiceATOM_Navarra.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRoNav/issues>.
      > Returning "NULL" because the download failed.

# parcel ATOM data can be downloaded

    Code
      catrnav_atom_get_parcels("xyxghx", cache = FALSE)
    Message
      ! No municipality matched pattern "xyxghx".
      i Check available municipalities with `catrnav_atom_get_parcels_db_all()`.

