# Set your CatastRoNav cache directory

Configures the cache directory used by CatastRoNav. Use
`Sys.getenv("CATASTRONAV_CACHE_DIR")` or `catrnav_detect_cache_dir()` to
inspect the current path.

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

  Path to a cache directory. On `NULL`, the function stores cached files
  in a temporary directory (see
  [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html)).

- overwrite:

  A logical value indicating whether to overwrite an existing
  `CATASTRONAV_CACHE_DIR` value.

- install:

  Logical. If `TRUE`, installs the key on your local machine for use in
  future sessions. Defaults to `FALSE`. If `cache_dir` is `FALSE`, this
  argument is set to `FALSE` automatically.

- verbose:

  Logical. If `TRUE`, displays informational messages.

## Value

`catrnav_set_cache_dir()` invisibly returns the cache path as a
character string. It is primarily called for its side effect.

`catrnav_detect_cache_dir()` returns the cache path used in the current
session.

## Details

By default, when no `cache_dir` is set, CatastRoNav uses a directory
inside [`base::tempdir()`](https://rdrr.io/r/base/tempfile.html). Files
in this directory are temporary and are removed when the R session ends.
To persist a cache across R sessions, use
`catrnav_set_cache_dir(cache_dir, install = TRUE)`. This writes the
chosen path to a configuration file under
`tools::R_user_dir("CatastRoNav", "config")`.

## Note

The configuration location has moved from
`rappdirs::user_config_dir("CatastRoNav", "R")` to
`tools::R_user_dir("CatastRoNav", "config")`. Existing configuration
files are migrated automatically. A migration message is shown only
once.

## Caching strategies

Source files are cached after download. CatastRoNav implements the
following caching options:

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
data again by setting `update_cache = TRUE` in the corresponding
function.

If a download fails, use `verbose = TRUE` to inspect the request and
`catrnav_detect_cache_dir()` to identify the active cache path.

## See also

Manage the local cache:
[`catrnav_clear_cache()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_clear_cache.md)

## Examples

``` r

# Caution! This modifies your current state.
# \dontrun{
my_cache <- catrnav_detect_cache_dir()
#> ℹ /tmp/Rtmpwzxe65/CatastRoNav

example_cache <- file.path(tempdir(), "example", "cache")
catrnav_set_cache_dir(example_cache)
#> ℹ CatastRoNav cache directory is /tmp/Rtmpwzxe65/example/cache.
#> ℹ To reuse this cache directory in future sessions, set `install` to `TRUE`.

catrnav_detect_cache_dir()
#> ℹ /tmp/Rtmpwzxe65/example/cache
#> [1] "/tmp/Rtmpwzxe65/example/cache"

# Restore the initial cache.
catrnav_set_cache_dir(my_cache)
#> ℹ CatastRoNav cache directory is /tmp/Rtmpwzxe65/CatastRoNav.
#> ℹ To reuse this cache directory in future sessions, set `install` to `TRUE`.
identical(my_cache, catrnav_detect_cache_dir())
#> ℹ /tmp/Rtmpwzxe65/CatastRoNav
#> [1] TRUE
# }

catrnav_detect_cache_dir()
#> ℹ /tmp/Rtmpwzxe65/CatastRoNav
#> [1] "/tmp/Rtmpwzxe65/CatastRoNav"
```
