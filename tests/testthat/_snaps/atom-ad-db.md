# Test offline atom_ad_db

    Code
      fend <- catrnav_atom_get_address_db_all(cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# Test 404 all

    Code
      fend <- catrnav_atom_get_address_db_all(cache_dir = cdir)
    Message
      x HTTP error 404 (Not Found): <https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_3_AD/Addresses_ServiceATOM_Navarra.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRoNav/issues>.
      > Returning "NULL" because the download failed.

