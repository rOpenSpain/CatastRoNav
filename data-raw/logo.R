library(CatastRoNav)
library(sf)
library(dplyr)
library(nominatimlite)

# Use Pamplona

# Coord Plaza del Azoguejo: To Point
top <- geo_lite_sf("Plaza del Castillo, Pamplona") %>%
  st_transform(st_crs(25830))

# Create spatial hexagon
hex <- function(x, center, size) {
  angle_deg <- 60 * x - 30
  angle_rad <- pi / 180 * angle_deg
  x <- center[1, 1] + size * cos(angle_rad)
  y <- center[1, 2] + size * sin(angle_rad)

  return(c(x, y))
}
hex_pol <- lapply(1:7,
  hex,
  center = st_coordinates(top), # Center coords
  size = 500 # Side lenght (meters)
) %>%
  # Convert to spatial polygon
  unlist() %>%
  matrix(ncol = 2, byrow = TRUE) %>%
  list() %>%
  st_polygon() %>%
  st_sfc() %>%
  st_set_crs(st_crs(top))

# Get Buildings
pamplona <- top %>%
  st_buffer(1000) %>%
  catrnav_wfs_get_buildings_bbox()


finalpols <- st_intersection(pamplona, hex_pol)
plot(finalpols$geometry)


library(ggplot2)

pal <- colorRampPalette(c("#da291c", "#da291c", "white"))


p <- ggplot(finalpols) +
  geom_sf(aes(fill = value),
    col = "white",
    size = 0.01,
    show.legend = FALSE,
    alpha = 1
  ) +
  scale_fill_gradientn(
    colors = pal(7),
    na.value = pal(7)[6]
  ) +
  theme_void()



p


library(hexSticker)

cols <- pal(7)
text <- colorspace::darken(cols[1], 0.9)


sysfonts::font_add("noto",
  regular = "data-raw/NotoSerif-Regular.ttf",
  bold = "data-raw/NotoSerif-Bold.ttf"
)

showtext::showtext_auto()

sticker(p,
  package = "CatastRoNav",
  p_family = "noto",
  p_fontface = "bold",
  s_width = 2.1,
  s_height = 2.1,
  s_x = 1,
  s_y = 0.95,
  p_color = text,
  p_size = 19.5,
  p_y = 1,
  h_fill = "white",
  h_color = text,
  filename = "data-raw/logo.png",
)
