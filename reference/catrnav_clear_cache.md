# Clear your CatastRoNav cache directory

Use this function with caution. It clears cached data and configuration,
specifically:

- Deletes the CatastRoNav configuration directory when `config = TRUE`
  (`tools::R_user_dir("CatastRoNav", "config")`).

- Deletes the `cache_dir` directory and its contents when
  `cached_data = TRUE`.

- Clears the `CATASTRONAV_CACHE_DIR` environment variable.

## Usage

``` r
catrnav_clear_cache(config = FALSE, cached_data = TRUE, verbose = FALSE)
```

## Arguments

- config:

  A logical value indicating whether to delete the CatastRoNav
  configuration directory.

- cached_data:

  If `TRUE`, deletes your `cache_dir` and all its contents.

- verbose:

  Logical. Whether to display informational messages.

## Value

[`NULL`](https://rdrr.io/r/base/NULL.html), invisibly. This function is
called for its side effects.

## Details

With `config = TRUE` and `cached_data = TRUE`, this function resets the
cache state as if you had never used CatastRoNav.

## See also

[`catrnav_detect_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)
identifies the active cache path before deletion.
[`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)
configures a new cache afterward.

Manage the local cache:
[`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)

## Examples

``` r

# Caution! This modifies your current state.
# \dontrun{
my_cache <- catrnav_detect_cache_dir()
#> ℹ /tmp/RtmpshzjhQ/CatastRoNav

example_cache <- file.path(tempdir(), "example", "cache")
catrnav_set_cache_dir(example_cache, verbose = FALSE)

catrnav_clear_cache(verbose = TRUE)
#> ✔ Deleted CatastRoNav cached data from /tmp/RtmpshzjhQ/example/cache ("0 bytes").

# Restore the initial cache.
catrnav_set_cache_dir(my_cache)
#> ℹ CatastRoNav cache directory is /tmp/RtmpshzjhQ/CatastRoNav.
#> ℹ To reuse this cache directory in future sessions, set `install` to `TRUE`.
identical(my_cache, catrnav_detect_cache_dir())
#> ℹ /tmp/RtmpshzjhQ/CatastRoNav
#> [1] TRUE
# }
```
