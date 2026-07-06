# make_msg() validates and emits messages

    Code
      make_msg("info", TRUE, "Informative message.")
    Message
      i Informative message.

---

    Code
      make_msg("info", NA, "Invalid message.")
    Condition
      Error:
      ! `verbose` must be `TRUE` or `FALSE`.

# cli_abort_if_not() validates named conditions

    Code
      cli_abort_if_not(`A named condition failed.` = FALSE)
    Condition
      Error:
      ! A named condition failed.

---

    Code
      cli_abort_if_not(TRUE)
    Condition
      Error:
      ! All conditions supplied to `cli_abort_if_not()` must be named.

# validate_non_empty_arg() rejects missing arguments

    Code
      wrapper()
    Condition
      Error in `wrapper()`:
      ! `arg` cannot be missing.

# shared validators report invalid values

    Code
      validate_cache_args(TRUE, FALSE, cache_dir = 1, verbose = FALSE)
    Condition
      Error in `validate_cache_args()`:
      ! `cache_dir` must be `NULL` or a non-empty character value.

---

    Code
      validate_wfs_args(FALSE, count = 0)
    Condition
      Error in `validate_wfs_args()`:
      ! `count` must be `NULL` or a positive whole number.

---

    Code
      validate_vector_with_srs(c(1, NA), 4326, expected_length = 2L)
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must contain only finite, non-missing values.

# Pretty match

    Code
      my_fun("error here")
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "error here".

---

    Code
      my_fun(c("an", "error"))
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "an" or "error".

---

    Code
      my_fun("5")
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "5".
      i Did you mean "5000"?

---

    Code
      my_fun("00")
    Condition
      Error:
      ! `arg_one` must be one of "10", "1000", "3000" or "5000", not "00".

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` must be "20", not "1" or "2".

---

    Code
      my_fun3("3")
    Condition
      Error:
      ! `an_arg` must be one of "30" or "20", not "3".
      i Did you mean "30"?

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` must be "20", not "1" or "2".

