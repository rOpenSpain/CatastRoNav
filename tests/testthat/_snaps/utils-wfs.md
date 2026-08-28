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

# WFS bounding boxes validate numeric inputs

    Code
      wfs_get_bbox("1234", srs = 4326)
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must be a numeric vector or an <sf> or <sfc> object.

---

    Code
      wfs_get_bbox(c(1, 2, 3), srs = 4326)
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must have length 4, not 3.

---

    Code
      wfs_get_bbox(c(1, 2, 3, Inf), srs = 4326)
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must contain only finite, non-missing values.

# WFS bounding boxes report invalid CRS and configured limits

    Code
      wfs_get_bbox(no_crs)
    Condition
      Error in `wfs_get_bbox()`:
      ! `srs` must identify a valid coordinate reference system.

---

    Code
      result <- wfs_get_bbox(large, limit_km2 = 1)
    Message
      ! The configured WFS limit is 1 km². The query covers 12392.7 km².
      i The request may fail. Consider using a smaller area in `x`.

