
test_that("stars argument coercers work", {
  skip_if_not_installed("stars")

  obj <- stars::st_as_stars(sf::st_bbox(c(xmin = 0, xmax = 1, ymin = 0, ymax = 1)))
  expect_error(
    as_qgis_argument(obj),
    "Can't convert 'stars' object"
  )

  tmp_file <- expect_match(
    suppressWarnings(as_qgis_argument(obj, qgis_argument_spec(qgis_type = "layer"))),
    "\\.tif$"
  )
  expect_is(tmp_file, "qgis_tempfile_arg")
  unlink(tmp_file)

  # also check stars_proxy
  obj <- stars::read_stars(
    system.file("longlake/longlake.tif", package = "qgisprocess"),
    proxy = TRUE
  )
  expect_equal(
    fs::path_abs(as_qgis_argument(obj, qgis_argument_spec(qgis_type = "layer"))),
    fs::path_abs(system.file("longlake/longlake.tif", package = "qgisprocess"))
  )
})


test_that("stars result coercers work", {
  skip_if_not_installed("stars")

  expect_is(
    stars::st_as_stars(
      structure(
        system.file("longlake/longlake.tif", package = "qgisprocess"),
        class = "qgis_outputRaster"
      )
    ),
    "stars"
  )

  expect_is(
    stars::st_as_stars(
      structure(
        system.file("longlake/longlake.tif", package = "qgisprocess"),
        class = "qgis_outputLayer"
      )
    ),
    "stars"
  )

  expect_is(
    stars::st_as_stars(
      structure(
        list(
          OUTPUT = structure(
            system.file("longlake/longlake.tif", package = "qgisprocess"),
            class = "qgis_outputRaster"
          )
        ),
        class = "qgis_result"
      )
    ),
    "stars"
  )
})
