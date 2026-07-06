# WFS bounding boxes preserve output CRS

    Code
      get_sf_from_bbox(c(1, 2, 3, 4))
    Condition
      Error in `validate_vector_with_srs()`:
      ! Provide `srs` when `x` is a numeric vector.

---

    Code
      get_sf_from_bbox(c(1, 2, 3, 4), srs = "")
    Condition
      Error in `validate_vector_with_srs()`:
      ! Provide `srs` when `x` is a numeric vector.

# WFS bounding boxes report invalid CRS and configured limits

    Code
      wfs_get_bbox(no_crs)
    Condition
      Error in `wfs_get_bbox()`:
      ! `srs` must identify a valid coordinate reference system.

---

    Code
      wfs_get_bbox(large, limit_km2 = 1)
    Message
      ! The configured WFS limit is 1 km². The query covers 12392.7 km².
      i The request may fail. Consider using a smaller area in `x`.
    Output
          xmin     ymin     xmax     ymax 
      833927.9      0.0 945464.3 110801.8 

