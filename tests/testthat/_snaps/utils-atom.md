# municipality selection reports ambiguous matches

    Code
      selected <- catrnav_atom_select_munic(all, "Pamplona", db_name = "catrnav_atom_get_address_db_all",
        verbose = TRUE)
    Message
      i Found 2 municipalities matching "Pamplona".
      v Using closest match "201 Pamplona / Iruña".
      i Other matches:
        "202 Pamplona Norte"
      i Retrieving information for "201 Pamplona / Iruña".

# municipality readers reject invalid names

    Code
      catrnav_atom_read_munic(NA_character_, db_getter = function(...) NULL, db_name = "db")
    Condition
      Error in `catrnav_atom_read_munic()`:
      ! `munic` must be a non-empty character value.

