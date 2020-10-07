
#' @rdname as_qgis_argument
#' @export
as_qgis_argument.sf <- function(x, qgis_type) {
  if (qgis_type != "source") {
    stop(glue::glue("Can't use 'sf' objects for QGIS arguments with type '{ qgis_type }'"), call. = FALSE)
  }

  path <- tempfile(fileext = ".gpkg")
  sf::write_sf(x, path)
  structure(path, class = "qgis_tempfile")
}