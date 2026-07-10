# cache configuration can be installed and overwritten

    Code
      catrnav_set_cache_dir(other_cache_dir, install = TRUE, verbose = FALSE)
    Condition
      Error in `catrnav_set_cache_dir()`:
      ! A `cache_dir` value is already configured.
      Set `overwrite` to `TRUE` to replace it.

# catrnav_set_cache_dir() validates arguments

    Code
      catrnav_set_cache_dir(cache_dir = 1, verbose = FALSE)
    Condition
      Error in `catrnav_set_cache_dir()`:
      ! `cache_dir` must be a single <character> value.

---

    Code
      catrnav_set_cache_dir(overwrite = NA, verbose = FALSE)
    Condition
      Error in `validate_flag()`:
      ! `overwrite` must be `TRUE` or `FALSE`.

---

    Code
      catrnav_set_cache_dir(cache_dir = tempdir(), install = c(TRUE, FALSE), verbose = FALSE)
    Condition
      Error in `validate_flag()`:
      ! `install` must be `TRUE` or `FALSE`.

---

    Code
      catrnav_set_cache_dir(verbose = NA)
    Condition
      Error in `validate_flag()`:
      ! `verbose` must be `TRUE` or `FALSE`.

# catrnav_clear_cache() validates arguments

    Code
      catrnav_clear_cache(config = NA)
    Condition
      Error in `validate_flag()`:
      ! `config` must be `TRUE` or `FALSE`.

---

    Code
      catrnav_clear_cache(cached_data = NA)
    Condition
      Error in `validate_flag()`:
      ! `cached_data` must be `TRUE` or `FALSE`.

---

    Code
      catrnav_clear_cache(verbose = NA)
    Condition
      Error in `validate_flag()`:
      ! `verbose` must be `TRUE` or `FALSE`.

