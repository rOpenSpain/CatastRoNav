# Clear your CatastRoNav cache dir

**Use this function with caution**. This function would clear your
cached data and configuration, specifically:

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

  if `TRUE`, will delete the configuration folder of CatastRoNav.

- cached_data:

  If this is set to `TRUE`, it will delete your `cache_dir` and all its
  content.

- verbose:

  Logical, displays information. Useful for debugging, default is
  `FALSE`.

## Value

Invisible. This function is called for its side effects.

## Details

This is an overkill function that is intended to reset your status as it
you would never have installed and/or used CatastRoNav.

## See also

Other cache utilities:
[`catrnav_set_cache_dir()`](https://ropenspain.github.io/CatastRoNav/reference/catrnav_set_cache_dir.md)

## Examples

``` r
# Don't run this! It would modify your current state
# \dontrun{
catrnav_clear_cache(verbose = TRUE)
#> CatastRoNav cached data deleted: C:\Users\RUNNER~1\AppData\Local\Temp\RtmpaKNSrc/CatastRoNav
# }

Sys.getenv("CATASTRONAV_CACHE_DIR")
#> [1] ""
```
