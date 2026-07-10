# catrnav_atom_search_munic() handles missing matches

    Code
      result <- catrnav_atom_search_munic("missing")
    Message
      ! No municipality matched pattern "missing".

# catrnav_atom_search_munic() returns NULL when offline

    Code
      result <- catrnav_atom_search_munic("Pamplona", cache = FALSE, verbose = FALSE)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# catrnav_atom_search_munic() returns NULL after HTTP errors

    Code
      result <- catrnav_atom_search_munic("Pamplona", cache = FALSE, update_cache = TRUE,
        verbose = FALSE)
    Message
      x HTTP error 404 (Not Found): <https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_3_AD/Addresses_ServiceATOM_Navarra.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRoNav/issues>.
      > Returning "NULL" because the download failed.

# catrnav_atom_search_munic() downloads and filters matches

    Code
      c <- catrnav_atom_search_munic("XXX", cache_dir = cdir)
    Message
      ! No municipality matched pattern "XXX".

