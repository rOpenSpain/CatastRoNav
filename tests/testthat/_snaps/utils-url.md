# download_url() handles offline sessions

    Code
      result <- download_url(atom_test_url, cache_dir = cache_dir, verbose = FALSE)
    Message
      x No internet connection detected.
      Returning `NULL` because the request cannot run.

# download_url() handles transport failures

    Code
      result <- download_url("https://example.com/data.xml", cache_dir = cache_dir,
        verbose = FALSE)
    Message
      x The download request could not be completed.
      ! Simulated transport failure.
      Returning `NULL` because the download failed.

# download_url() reuses cached files

    Code
      result <- download_url(atom_test_url, cache_dir = cache_dir, verbose = TRUE)
    Message
      i Using cache directory '<cache-dir>'.
      v Using cached file '<cache-dir>/CadastralParcels_ServiceATOM_Navarra.xml'.

# download_url() handles HTTP errors

    Code
      result <- download_url(atom_test_url, cache_dir = cache_dir, update_cache = TRUE,
        verbose = FALSE)
    Message
      x HTTP error 404 (Not Found): <https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_1_CP/CadastralParcels_ServiceATOM_Navarra.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRoNav/issues>.
      Returning `NULL` because the download failed.

# download_url() reports cached refreshes and downloads

    Code
      result <- download_url(atom_test_url, cache_dir = cache_dir, update_cache = TRUE,
        verbose = TRUE)
    Message
      i Using cache directory '<cache-dir>'.
      ! Refreshing cached file.
      i Downloading <https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_1_CP/CadastralParcels_ServiceATOM_Navarra.xml>.
      v Downloaded file to '<cache-dir>/CadastralParcels_ServiceATOM_Navarra.xml'.

# failed refreshes preserve cached files and remove partial data

    Code
      result <- download_url("https://example.com/data.xml", cache_dir = cache_dir,
        update_cache = TRUE, verbose = FALSE)
    Message
      x The download request could not be completed.
      ! Simulated transport failure.
      Returning `NULL` because the download failed.

# HTTP errors preserve cached files and remove partial data

    Code
      result <- download_url("https://example.com/data.xml", cache_dir = cache_dir,
        update_cache = TRUE, verbose = FALSE)
    Message
      x HTTP error 500 (Internal Server Error): <https://example.com/data.xml>.
      ! If this looks like a package bug, open an issue at <https://github.com/ropenspain/CatastRoNav/issues>.
      Returning `NULL` because the download failed.

# HEAD transport failures preserve the cache without downloading

    Code
      result <- download_url("https://example.com/data.xml", cache_dir = cache_dir,
        update_cache = TRUE, verbose = FALSE)
    Message
      x The download request could not be completed.
      ! Simulated HEAD failure.
      Returning `NULL` because the download failed.

# large downloads report their size before fetching the body

    Code
      result <- download_url("https://example.com/data.xml", cache_dir = cache_dir,
        verbose = FALSE)
    Message
      ! Download size is 21 Mb.

