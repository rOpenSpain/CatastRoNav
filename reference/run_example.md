# Decide whether an example should run

Determines whether an example should run based on CRAN status and
network availability.

## Usage

``` r
run_example()
```

## Value

A [logical](https://rdrr.io/r/base/logical.html) value, `TRUE` if online
and not running on CRAN, `FALSE` otherwise.

## Details

Returns `FALSE` on CRAN or when offline.

## Examples

``` r
run_example()
#> [1] TRUE
```
