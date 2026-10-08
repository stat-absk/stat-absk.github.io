# The raster favicons, from images/favicon.svg (one gate of five).
#
#   Rscript R/make_favicon.R
#
# Writes images/favicon.png (64 px, for browsers that ignore SVG icons) and
# images/apple-touch-icon.png (180 px). The SVG stays the source.

library(magick)

svg <- "images/favicon.svg"
write_png <- function(path, size) {
  img <- image_read_svg(svg, width = size, height = size)
  image_write(img, path, format = "png")
  cat("wrote", path, size, "px", file.size(path), "bytes\n")
}
write_png("images/favicon.png", 64)
write_png("images/apple-touch-icon.png", 180)
