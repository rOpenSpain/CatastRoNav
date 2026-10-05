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

# read_geo_file_sf() handles invalid large files

    Code
      read_geo_file_sf(source)
    Message
      ! Reading a large spatial file ("21 Mb").
    Output
      Cannot open data source <source.gml>
    Condition
      Error:
      ! Open failed.

# read_geo_file_sf() handles missing layers and read errors

    Code
      no_layer <- read_geo_file_sf(source, layer_hint = "^missing$")
    Message
      ! No spatial layers found.

---

    Code
      suppressWarnings(read_geo_file_sf(source, query = "SELECT * FROM missing"))
    Condition
      Error:
      ! Query execution failed, cannot open layer.

# read_geo_file_sf() handles sources without layers

    Code
      result <- read_geo_file_sf("empty.gpkg")
    Message
      ! No spatial layers found.

