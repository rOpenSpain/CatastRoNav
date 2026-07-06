# Decide whether an example should run

Determines whether an example should run based on CRAN status and
network availability.

## Usage

``` r
run_example()
```

## Value

Logical. `TRUE` if examples should run, `FALSE` otherwise.

## Details

Returns `FALSE` on CRAN or when offline.

## Examples

``` r
run_example()
#> [1] TRUE
```
