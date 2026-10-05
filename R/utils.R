make_msg <- function(type = "generic", verbose, ..., .envir = parent.frame()) {
  cli_abort_if_not(
    "{.arg verbose} must be {.code TRUE} or {.code FALSE}." = is.logical(
      verbose
    ) &&
      length(verbose) == 1L &&
      !is.na(verbose),
    .envir = .envir
  )

  if (!verbose) {
    return(invisible())
  }

  fun <- switch(type,
    danger = cli::cli_alert_danger,
    info = cli::cli_alert_info,
    success = cli::cli_alert_success,
    warning = cli::cli_alert_warning,
    cli::cli_alert
  )
  fun(paste0(...), .envir = .envir)
  invisible()
}

validate_flag <- function(value, arg) {
  cli_abort_if_not(
    "{.arg {arg}} must be {.code TRUE} or {.code FALSE}." = is.logical(value) &&
      length(value) == 1L &&
      !is.na(value)
  )
  invisible(value)
}

match_arg_pretty <- function(arg, choices, call = parent.frame()) {
  arg_name <- as.character(substitute(arg)) # nolint

  if (missing(choices)) {
    sys_par <- sys.parent()
    formal_args <- formals(sys.function(sys_par))
    choices <- eval(
      formal_args[[as.character(substitute(arg))]],
      envir = sys.frame(sys_par)
    )
  }
  choices <- as.character(choices)

  if (is.null(arg)) {
    return(choices[1L])
  }

  arg <- as.character(arg)

  if (identical(arg, choices)) {
    return(arg[1])
  }

  lmatch <- match(arg, choices)
  # Build a hint for approximate matches.
  aproxmatch <- pmatch(arg, choices)[1]

  if (length(arg) > 1 || is.na(lmatch)) {
    # Create the error message.
    if (length(choices) == 1) {
      msg <- paste0("{.str ", choices, "}")
    } else {
      l_choices <- length(choices)
      msg <- paste(sprintf("{.str %s}", choices[-l_choices]), collapse = ", ")
      msg <- paste0(msg, " or {.str ", choices[l_choices], "}")
      # Prefix the message with "one of".
      msg <- paste0("one of ", msg)
    }

    msg <- paste0(msg, ", not ")
    bad_arg <- paste(sprintf("{.str %s}", arg), collapse = " or ")
    msg <- paste0(msg, bad_arg, ".")

    # Suggest an approximate match.
    reg_msg <- NULL
    if (!is.na(aproxmatch)) {
      aprox <- choices[aproxmatch]
      aprox_val <- paste(sprintf("{.str %s}", aprox), collapse = " or ")
      reg_msg <- paste0("Did you mean ", aprox_val, "?")
    }

    cli::cli_abort(
      c(paste0("{.arg {arg_name}} must be ", msg), "i" = reg_msg),
      call = call
    )
  }

  choices[lmatch]
}

ensure_null <- function(x) {
  x_initial <- x
  x <- as.vector(x)
  x[is.null(x)] <- NA
  x[is.na(x)] <- NA
  x[nchar(as.character(x)) == 0] <- NA
  if (all(is.na(x))) {
    return(NULL)
  }

  x_initial
}

validate_non_empty_arg <- function(
  arg,
  call = parent.frame(1),
  arg_name = as.character(substitute(arg))
) {
  if (missing(arg)) {
    cli::cli_abort("{.arg {arg_name}} cannot be missing.", call = call)
  }

  is_empty <- is.null(arg) ||
    length(arg) == 0L ||
    (is.atomic(arg) && anyNA(arg)) ||
    (is.character(arg) && !all(nzchar(trimws(arg))))

  if (is_empty) {
    cli::cli_abort("{.arg {arg_name}} cannot be empty.", call = call)
  }

  arg
}

validate_scalar_arg <- function(arg, call = parent.frame(1)) {
  arg_name <- as.character(substitute(arg)) # nolint
  arg <- validate_non_empty_arg(arg, call = call, arg_name = arg_name)

  if (!((is.character(arg) || is.numeric(arg)) && length(arg) == 1L)) {
    cli::cli_abort(
      "{.arg {arg_name}} must be a single string or number.",
      call = call
    )
  }

  arg
}

validate_cache_args <- function(update_cache, cache_dir, verbose) {
  validate_flag(update_cache, "update_cache")
  validate_flag(verbose, "verbose")

  valid_cache_dir <- is.null(cache_dir)
  if (!valid_cache_dir) {
    valid_cache_dir <- is.character(cache_dir) &&
      length(cache_dir) == 1L &&
      !is.na(cache_dir) &&
      nzchar(cache_dir)
  }

  if (!valid_cache_dir) {
    cli::cli_abort(
      "{.arg cache_dir} must be {.code NULL} or a non-empty character value."
    )
  }
  invisible()
}

warn_deprecated_cache <- function(cache, what) {
  if (lifecycle::is_present(cache)) {
    lifecycle::deprecate_warn(
      when = "1.1.0",
      what = what,
      details = "Results are always cached.",
      user_env = parent.frame(2)
    )
  }
}

validate_wfs_args <- function(verbose, count) {
  validate_flag(verbose, "verbose")

  valid_count <- is.null(count)
  if (!valid_count) {
    valid_count <- is.numeric(count) &&
      length(count) == 1L &&
      !is.na(count) &&
      is.finite(count) &&
      count >= 1 &&
      count %% 1 == 0
  }

  if (!valid_count) {
    cli::cli_abort(
      "{.arg count} must be {.code NULL} or a positive whole number."
    )
  }
  invisible()
}

validate_vector_with_srs <- function(
  x,
  srs,
  expected_length,
  call = parent.frame()
) {
  if (!is.numeric(x)) {
    cli::cli_abort(
      "{.arg x} must be a numeric vector or an {.cls sf} or {.cls sfc} object.",
      call = call
    )
  }
  if (length(x) != expected_length) {
    cli::cli_abort(
      paste0(
        "{.arg x} must have length {.val {expected_length}}, not ",
        "{.val {length(x)}}."
      ),
      call = call
    )
  }
  if (anyNA(x) || !all(is.finite(x))) {
    cli::cli_abort(
      "{.arg x} must contain only finite, non-missing values.",
      call = call
    )
  }
  if (is.null(srs) || length(srs) == 0L || anyNA(srs)) {
    cli::cli_abort(
      "Provide {.arg srs} when {.arg x} is a numeric vector.",
      call = call
    )
  }

  invisible()
}

# Adapted from https://github.com/r-lib/cli/issues/672.
cli_abort_if_not <- function(
  ...,
  .call = .envir,
  .envir = parent.frame(),
  .frame = .envir
) {
  for (i in seq_len(...length())) {
    condition <- ...elt(i)
    message <- ...names()[i]

    if (is.null(message) || is.na(message) || !nzchar(message)) {
      cli::cli_abort(
        "All conditions supplied to {.fun cli_abort_if_not} must be named.",
        call = .call,
        .envir = .envir,
        .frame = .frame
      )
    }

    condition_is_true <- is.logical(condition) &&
      length(condition) > 0L &&
      !anyNA(condition) &&
      all(condition)

    if (!condition_is_true) {
      cli::cli_abort(message, call = .call, .envir = .envir, .frame = .frame)
    }
  }
  invisible(NULL)
}
