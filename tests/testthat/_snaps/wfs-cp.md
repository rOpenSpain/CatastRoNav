# parcel WFS validates bounding boxes

    Code
      catrnav_wfs_get_parcels_bbox(x = "1234")
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must be a numeric vector or an <sf> or <sfc> object.

---

    Code
      catrnav_wfs_get_parcels_bbox(c("1234", "a", "3", "4"))
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must be a numeric vector or an <sf> or <sfc> object.

---

    Code
      catrnav_wfs_get_parcels_bbox(c(1, 2, 3))
    Condition
      Error in `validate_vector_with_srs()`:
      ! `x` must have length 4, not 3.

