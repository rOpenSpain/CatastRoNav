atom_test_url <- paste0(
  "https://filescartografia.navarra.es/2_CARTOGRAFIA_TEMATICA/",
  "2_7_CATASTRO/2_7_3_INSPIRE_ATOM/2_7_3_1_CP/",
  "CadastralParcels_ServiceATOM_Navarra.xml"
)

local_mock_http_error <- function(
  status_code = 404L,
  url = atom_test_url,
  .env = parent.frame()
) {
  testthat::local_mocked_bindings(
    is_online_fun = function(...) TRUE,
    req_perform_fun = function(...) {
      httr2::response(status_code = status_code, url = url)
    },
    .env = .env
  )
}
