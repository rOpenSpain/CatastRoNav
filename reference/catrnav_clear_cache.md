# Clear your CatastRoNav cache directory

Use this function with caution. It clears cached data and configuration,
specifically:

- Deletes the CatastRoNav configuration directory
  (`tools::R_user_dir("CatastRoNav", "config")`).

- Deletes the `cache_dir` directory.

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

  Logical. If `TRUE`, displays informational messages.

## Value

`NULL`, invisibly. This function is called for its side effects.

## Details

This function resets the cache state as if you had never used
CatastRoNav.

## See also

Manage the local cache:
[`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)

## Examples

``` r

# Caution! This modifies your current state.
# \dontrun{
my_cache <- catrnav_detect_cache_dir()
#> ℹ /tmp/RtmpVrzaEV/CatastRoNav

example_cache <- file.path(tempdir(), "example", "cache")
catrnav_set_cache_dir(example_cache, verbose = FALSE)

catrnav_clear_cache(verbose = TRUE)
#> ! Deleted CatastRoNav cached data from /tmp/RtmpVrzaEV/example/cache ("0 bytes").

# Restore the initial cache.
catrnav_set_cache_dir(my_cache)
#> ℹ CatastRoNav cache directory is /tmp/RtmpVrzaEV/CatastRoNav.
#> ℹ To reuse this cache directory in future sessions, set `install` to `TRUE`.
identical(my_cache, catrnav_detect_cache_dir())
#> ℹ /tmp/RtmpVrzaEV/CatastRoNav
#> [1] TRUE
# }
```
