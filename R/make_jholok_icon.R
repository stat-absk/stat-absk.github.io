# The Jholok app icon as a PNG for the site, from the app's own Icon Composer
# bundle (Jholok/AppIcon.icon): its ground gradient and its four layers, in the
# platform's rounded square. Icon Composer's glass and lighting are left out.
#
#   Rscript R/make_jholok_icon.R [path/to/AppIcon.icon]
#
# Run from the site root. Writes images/jholok/appicon.png at 512 x 512.

library(magick)

bundle <- commandArgs(trailingOnly = TRUE)[1]
if (is.na(bundle)) bundle <- "../AI_Jobs/Jholok/Jholok/AppIcon.icon"
spec <- jsonlite::fromJSON(file.path(bundle, "icon.json"), simplifyVector = FALSE)

# The light appearance's ground: a vertical gradient, top to 70% of the height.
fill <- spec[["fill-specializations"]][[1]]$value
hex <- function(s) {
  v <- as.numeric(strsplit(sub("^extended-srgb:", "", s), ",")[[1]][1:3])
  sprintf("#%02X%02X%02X", round(v[1] * 255), round(v[2] * 255), round(v[3] * 255))
}
from <- hex(fill[["linear-gradient"]][[1]]); to <- hex(fill[["linear-gradient"]][[2]])
stop <- fill$orientation$stop$y

# Each layer's drawing, its gradient ids made unique so they can share one SVG.
layer_names <- unlist(lapply(spec$groups, function(g) lapply(g$layers, `[[`, "image-name")))
layers <- vapply(seq_along(layer_names), function(i) {
  svg <- paste(readLines(file.path(bundle, "Assets", layer_names[i]), warn = FALSE), collapse = "")
  inner <- sub("^.*?<svg[^>]*>(.*)</svg>\\s*$", "\\1", svg)
  gsub("(id=\"|url\\(#)g", sprintf("\\1g%d", i), inner)
}, "")

svg <- sprintf(paste0(
  '<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">',
  '<defs><linearGradient id="ground" x1="0" y1="0" x2="0" y2="%s">',
  '<stop offset="0" stop-color="%s"/><stop offset="1" stop-color="%s"/></linearGradient>',
  '<clipPath id="shape"><rect width="1024" height="1024" rx="229"/></clipPath></defs>',
  '<g clip-path="url(#shape)"><rect width="1024" height="1024" fill="url(#ground)"/>%s</g></svg>'),
  stop, from, to, paste(layers, collapse = ""))

tmp <- tempfile(fileext = ".svg"); writeLines(svg, tmp)
dir.create("images/jholok", showWarnings = FALSE, recursive = TRUE)
image_write(image_read_svg(tmp, width = 512, height = 512), "images/jholok/appicon.png", format = "png")
cat("wrote images/jholok/appicon.png from", length(layers), "layers\n")
