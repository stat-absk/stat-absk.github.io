# The 1200 x 630 social card for singlebell.qmd, drawn from the current store frame.
#
#   Rscript R/make_social_card.R
#
# Run from the site root. Reads images/singlebell/home.png (the 600 x 1303 site
# frame) and appicon.png, and writes social-card.png beside them. The card wears
# the site's own palette (_palette-wiring.scss: ground, writing, accent), not the
# app's, because it is the site's card; the phone inside it is the app as it is.
#
# Type: the site's own faces, from the static TTFs in fonts/ttf (see
# R/fetch_fonts.R), registered for this session.

library(grid)
library(ragg)
library(magick)
library(systemfonts)

here <- "images/singlebell"
ground  <- "#131A17"; writing <- "#F2F3EA"; muted <- "#B8BDB5"; accent <- "#E9D592"
W <- 1200; H <- 630

# Registered from the repo's files unless the system already has the family.
use_font <- function(family, ...) tryCatch(register_font(family, ...), error = function(e) invisible(NULL))
use_font("Literata", plain = "fonts/ttf/Literata-Regular.ttf", italic = "fonts/ttf/Literata-Italic.ttf",
         bold = "fonts/ttf/Literata-SemiBold.ttf")
use_font("Atkinson Hyperlegible Next", plain = "fonts/ttf/AtkinsonHyperlegibleNext-Regular.ttf",
         bold = "fonts/ttf/AtkinsonHyperlegibleNext-Medium.ttf")
serif <- "Literata"
sans  <- "Atkinson Hyperlegible Next"

# Grid measures from the top-left, as the layout is written. At 72 dpi a big
# point is a pixel.
px   <- function(x) unit(x, "bigpts")
top  <- function(y) px(H - y)
text <- function(label, x, y, size, col, family, weight = "plain") {
  grid.text(label, x = px(x), y = top(y), just = c("left", "top"),
            gp = gpar(fontfamily = family, fontsize = size, col = col, fontface = weight))
}

agg_png(file.path(here, "social-card.png"), width = W, height = H, units = "px", res = 72, background = ground)
grid.newpage()

# The icon, at the size the page's hero draws it. appicon.png carries the
# platform's shape and glass rim in its alpha, so it is placed by that.
icon <- image_read(file.path(here, "appicon.png")) |> image_resize("112x112")
grid.raster(as.raster(icon), x = px(92), y = top(82), width = px(112), height = px(112), just = c("left", "top"))

text("SingleBell", 88, 214, 104, writing, serif)
text("A kettlebell practice app for iPhone.",   92, 332, 30, muted, sans)
text("The day's practice, dealt each morning.", 92, 374, 30, muted, sans)
text("No account · no analytics · collects nothing", 92, 458, 30, accent, sans, "bold")

# The phone: the site's home frame, scaled to sit on the right and run off the
# foot, clipped to the phone's corner and edged in a slate rim.
frame <- image_read(file.path(here, "home.png"))
pw <- 310; ph <- round(image_info(frame)$height * pw / image_info(frame)$width)
frame <- image_resize(frame, paste0(pw, "x"))
x <- 782; y <- 30; r <- 44
rim <- viewport(x = px(x), y = top(y), width = px(pw + 8), height = px(ph + 8), just = c("left", "top"),
                clip = roundrectGrob(r = px(r + 4)))
pushViewport(rim)
grid.rect(gp = gpar(fill = "#343A37", col = NA))
popViewport()
screen <- viewport(x = px(x + 4), y = top(y + 4), width = px(pw), height = px(ph), just = c("left", "top"),
                   clip = roundrectGrob(r = px(r)))
pushViewport(screen)
grid.raster(as.raster(frame), width = unit(1, "npc"), height = unit(1, "npc"), interpolate = TRUE)
popViewport()

invisible(dev.off())
cat("wrote", file.path(here, "social-card.png"), W, "x", H, "with", serif, "/", sans, "\n")
