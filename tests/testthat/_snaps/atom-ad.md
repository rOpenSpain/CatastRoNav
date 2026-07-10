# address ATOM data returns NULL when offline

    Code
      result <- catrnav_atom_get_address("Pamplona", cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# address ATOM data handles HTTP 404 responses

    Code
      result <- catrnav_atom_get_address("Olite", cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_3_AD/Addresses_ServiceATOM_Navarra.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRoNav/issues>.
      > Returning "NULL" because the download failed.

# address ATOM data can be downloaded

    Code
      catrnav_atom_get_address("xyxghx", cache_dir = cdir)
    Message
      ! No municipality matched pattern "xyxghx".
      i Check available municipalities with `catrnav_atom_get_address_db_all()`.

