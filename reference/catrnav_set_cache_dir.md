# Set your CatastRoNav cache directory

Configures the cache directory used by CatastRoNav. Use
[`Sys.getenv()`](https://rdrr.io/r/base/Sys.getenv.html) with
`"CATASTRONAV_CACHE_DIR"` or `catrnav_detect_cache_dir()` to inspect the
current path.

## Usage

``` r
catrnav_set_cache_dir(
  cache_dir = NULL,
  overwrite = FALSE,
  install = FALSE,
  verbose = TRUE
)

catrnav_detect_cache_dir()
```

## Arguments

- cache_dir:

  Path to a cache directory. If `NULL` or `FALSE`, the function stores
  cached files in a temporary directory. See
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html).

- overwrite:

  A logical value indicating whether to overwrite an existing
  `CATASTRONAV_CACHE_DIR` value.

- install:

  Logical. Whether to store the path locally for use in future sessions.
  Defaults to `FALSE`.

- verbose:

  Logical. Whether to display informational messages.

## Value

`catrnav_set_cache_dir()` returns a
[character](https://rdrr.io/r/base/character.html) string containing the
cache path, invisibly. This function is primarily called for its side
effects.

`catrnav_detect_cache_dir()` returns a
[character](https://rdrr.io/r/base/character.html) string containing the
cache path used in the current session.

## Details

By default, when no `cache_dir` is set, CatastRoNav uses a directory
inside [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html). Files
in this directory are temporary and are removed when the R session ends.
To persist a cache across R sessions, use
`catrnav_set_cache_dir(cache_dir, install = TRUE)`. This writes the
chosen path to a configuration file under
[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) with
`"CatastRoNav"` and `"config"`.

## Note

The configuration location has moved from
`rappdirs::user_config_dir("CatastRoNav", "R")` to
[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) with
`"CatastRoNav"` and `"config"`. Existing configuration files are
migrated automatically. A migration message is shown only once.

## Caching strategies

Source files are always cached after download. CatastRoNav implements
the following caching options:

- For occasional use, rely on the default
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html)-based cache
  without installing a persistent path.

- Modify the cache for a single session by setting
  `catrnav_set_cache_dir(cache_dir = "a/path/here")`.

- For reproducible workflows, install a persistent cache with
  `catrnav_set_cache_dir(cache_dir = "a/path/here", install = TRUE)`.
  This cache is kept across R sessions.

- To cache specific files elsewhere, use the `cache_dir` argument in the
  corresponding function.

Cached files can occasionally become corrupt. In that case, download the
data again by setting `update_cache = TRUE` in an ATOM or WMS function.
ATOM downloads check the file size with a HEAD request and report
downloads larger than 20 MB before fetching the body. Failed ATOM
updates preserve the previous cached file. WFS queries reuse their
cached response until the cache is cleared.

ATOM indexes are stored in `databases`, municipal downloads in
`atom_ad`, `atom_bu` or `atom_cp` and WFS responses in
`wfs_inspire_cache`.

The ATOM `cache` argument is deprecated and no longer changes caching.
Use a temporary `cache_dir` when downloads should last only for a
session.

## HTTP settings

ATOM downloads and WFS queries use the `catastronav_timeout` and
`catastronav_ssl_verify` options. If unset, the `CATASTRONAV_TIMEOUT`
and `CATASTRONAV_SSL_VERIFY` environment variables are used, followed by
the `catastro_timeout` and `catastro_ssl_verify` options. The defaults
are 300 seconds and enabled SSL verification. WFS queries apply these
settings only for the request and restore the previous
[CatastRo](https://CRAN.R-project.org/package=CatastRo) options. WMS
request settings are passed to
[`mapSpain::esp_get_tiles()`](https://ropenspain.github.io/mapSpain/reference/esp_get_tiles.html)
through the `options` argument of
[`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wms_get_layer.md).

If a download fails, use `verbose = TRUE` to inspect the request and
`catrnav_detect_cache_dir()` to identify the active cache path.

## See also

[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) determines
the persistent configuration directory.
[`base::tempdir()`](https://rdrr.io/r/base/tempfile.html) provides the
default temporary cache directory.
[`catrnav_atom_get_address()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_address.md),
[`catrnav_atom_get_buildings()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_buildings.md)
and
[`catrnav_atom_get_parcels()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_atom_get_parcels.md)
cache municipal downloads.
[`catrnav_wfs_get_address_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_address.md),
[`catrnav_wfs_get_buildings_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_buildings.md)
and
[`catrnav_wfs_get_parcels_bbox()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wfs_get_parcels.md)
cache spatial queries.
[`catrnav_wms_get_layer()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_wms_get_layer.md)
caches map images.

Manage the local cache:
[`catrnav_clear_cache()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_clear_cache.md)

## Examples

``` r

# Caution! This modifies your current state.
# \dontrun{
my_cache <- catrnav_detect_cache_dir()
#> ℹ /tmp/RtmpWLRnNQ/CatastRoNav

example_cache <- file.path(tempdir(), "example", "cache")
catrnav_set_cache_dir(example_cache)
#> ℹ CatastRoNav cache directory is /tmp/RtmpWLRnNQ/example/cache.
#> ℹ To reuse this cache directory in future sessions, set `install` to `TRUE`.

catrnav_detect_cache_dir()
#> ℹ /tmp/RtmpWLRnNQ/example/cache
#> [1] "/tmp/RtmpWLRnNQ/example/cache"

# Restore the initial cache.
catrnav_set_cache_dir(my_cache)
#> ℹ CatastRoNav cache directory is /tmp/RtmpWLRnNQ/CatastRoNav.
#> ℹ To reuse this cache directory in future sessions, set `install` to `TRUE`.
identical(my_cache, catrnav_detect_cache_dir())
#> ℹ /tmp/RtmpWLRnNQ/CatastRoNav
#> [1] TRUE
# }

catrnav_detect_cache_dir()
#> ℹ /tmp/RtmpWLRnNQ/CatastRoNav
#> [1] "/tmp/RtmpWLRnNQ/CatastRoNav"
```
