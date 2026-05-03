# Clear your CatastRoNav cache dir

**Use this function with caution**. This function clears your cached
data and configuration, specifically:

- Deletes the CatastRoNav config directory
  (`rappdirs::user_config_dir("CatastRoNav", "R")`).

- Deletes the `cache_dir` directory.

- Deletes the values stored on `Sys.getenv("CATASTRONAV_CACHE_DIR")`.

## Usage

``` r
catrnav_clear_cache(config = FALSE, cached_data = TRUE, verbose = FALSE)
```

## Arguments

- config:

  If `TRUE`, deletes the configuration folder of CatastRoNav.

- cached_data:

  If `TRUE`, deletes `cache_dir` and all its contents.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

Invisible. This function is called for its side effects.

## Details

This is an overkill function that is intended to reset your status as if
you had never installed or used CatastRoNav.

## See also

Other cache utilities:
[`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)

## Examples

``` r

# Don't run this! It will modify your current state
# \dontrun{
catrnav_clear_cache(verbose = TRUE)
#> CatastRoNav cached data deleted: /tmp/RtmpgrGSXN/CatastRoNav
# }

Sys.getenv("CATASTRONAV_CACHE_DIR")
#> [1] ""
```
