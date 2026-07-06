# download_url() handles offline sessions

    Code
      result <- download_url(atom_test_url, cache_dir = cache_dir, verbose = FALSE)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# download_url() handles uncached offline sessions

    Code
      result <- download_url(atom_test_url, cache = FALSE, verbose = FALSE)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

# download_url() handles transport failures

    Code
      result <- download_url("https://example.com/data.xml", cache_dir = cache_dir,
        verbose = FALSE)
    Message
      x Download failed for <https://example.com/data.xml>.
      > Returning "NULL". Reason: Simulated transport failure.

