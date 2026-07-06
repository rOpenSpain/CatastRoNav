# read_geo_file_sf() handles missing spatial inputs

    Code
      result <- read_geo_file_sf(character())
    Message
      ! No spatial files found.

# read_geo_file_sf() handles missing ZIP members

    Code
      result <- read_geo_file_sf(archive, hint = "missing.shp")
    Message
      ! No matching files found in the ZIP archive.

# read_geo_file_sf() handles missing layers and read errors

    Code
      no_layer <- read_geo_file_sf(source, layer_hint = "^missing$")
    Message
      ! No spatial layers found.

---

    Code
      unreadable <- read_geo_file_sf(source, query = "SELECT * FROM missing")
    Condition
      Warning in `CPL_read_ogr()`:
      GDAL Error 1: SELECT from table missing failed, no such table/featureclass.
    Message
      ! The spatial result could not be read.

