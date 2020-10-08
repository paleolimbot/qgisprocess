
#' Access algorithm results
#'
#' @param x An object returned by [qgis_run_algorithm()].
#' @param which The name or index of an output.
#' @param default A default value if the output does not exist.
#'
#' @export
#'
is_qgis_result <- function(x) {
  inherits(x, "qgis_result")
}

#' @rdname is_qgis_result
#' @export
qgis_result_clean <- function(x) {
  args_chr <- as.character(x$.args[vapply(x$.args, is.character, logical(1))])
  unlink(args_chr, is_qgis_tmp_file(args_chr))
  invisible(x)
}

#' @rdname is_qgis_result
#' @export
qgis_output <- function(x, which, default = qgis_error_output_does_not_exist(x, which)) {
  if (is.numeric(which) && (which %in% seq_along(x))) {
    x[[which]]
  } else if (which %in% names(x)) {
    x[[which]]
  } else {
    default
  }
}

#' @rdname is_qgis_result
#' @export
qgis_error_output_does_not_exist <- function(x, which) {
  available_outputs <- glue::glue_collapse(
    paste0("'", setdiff(names(x), c(".args", ".processx_result")), "'"),
    sep = ", ", last = " and "
  )

  abort(glue("Result has no output '{ which }'.\nAvailable outputs are { available_outputs }"))
}

#' @rdname is_qgis_result
#' @export
qgis_result_stdout <- function(x) {
  x$.processx_result$stdout
}

#' @rdname is_qgis_result
#' @export
qgis_result_stderr <- function(x) {
  x$.processx_result$stderr
}

#' @rdname is_qgis_result
#' @export
qgis_result_args <- function(x) {
  x$.args
}

#' @export
print.qgis_result <- function(x, ...) {
  cat("<Result of `qgis_run_algorithm()`>\n")
  cat("See `qgis_result_stout(x)`, `qgis_result_stderr(x)`, and/or `qgis_result_args()`.\n")
  cat("Output:\n")
  print(x[!(names(x) %in% c(".args", ".processx_result"))], ...)
  invisible(x)
}