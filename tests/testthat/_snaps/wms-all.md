# WMS requests validate layer and style arguments

    Code
      catrnav_wms_get_layer(c(760926, 4019259, 761155, 4019366), srs = 25829, what = "aa")
    Condition
      Error:
      ! `what` must be one of "building", "parcel" or "address", not "aa".

---

    Code
      catrnav_wms_get_layer(c(760926, 4019259, 761155, 4019366), srs = 25829, styles = "a")
    Condition
      Error:
      ! `styles` must be one of "default" or "ELFCadastre", not "a".

---

    Code
      catrnav_wms_get_layer(c(760926, 4019259, 761155, 4019366), srs = 25829, styles = "ELFCadastre")
    Condition
      Error in `catrnav_wms_get_layer()`:
      ! Layer "building" only supports style "default".

---

    Code
      catrnav_wms_get_layer(c(760926, 4019259, 761155, 4019366), srs = 25829, what = "address",
      styles = "ELFCadastre")
    Condition
      Error in `catrnav_wms_get_layer()`:
      ! Layer "address" only supports style "default".

# WMS requests handle offline sessions and 404 responses

    Code
      offline <- catrnav_wms_get_layer(bbox, cache_dir = cdir)
    Message
      x No internet connection detected.
      > Returning "NULL" because the request cannot run.

---

    Code
      not_found <- catrnav_wms_get_layer(bbox, cache_dir = cdir)
    Message
      x The WMS request failed.
      > Returning "NULL" because the request failed.

