# The site's faces folded into the deck theme, as data URIs.
#
#   Rscript R/deck_fonts.R      (R/fetch_fonts.R runs it after a fetch)
#
# Run from the site root. A deck is one self-contained HTML file, and Pandoc
# resolves a theme's url() against Quarto's compiled stylesheet deep inside
# the deck's support folder, so a font beside the theme is never found. Here
# each WOFF2 in fonts/ is written into _extensions/chalk/chalk-reveal.scss
# between the two marker lines, base64-encoded; the decks then carry their
# faces with no file of their own. Licences travel in _extensions/chalk/licences/.

theme <- "_extensions/chalk/chalk-reveal.scss"
begin <- "// ── fonts: written by R/deck_fonts.R, do not edit ──"
end   <- "// ── end fonts ──"

faces <- data.frame(
  family = c("Literata", "Literata", "Atkinson Hyperlegible Next", "Atkinson Hyperlegible Mono"),
  style  = c("normal", "italic", "normal", "normal"),
  weight = c("400 600", "400", "400 500", "400"),
  file   = c("literata-normal.woff2", "literata-italic.woff2",
             "atkinsonhyperlegiblenext-normal.woff2", "atkinsonhyperlegiblemono-normal.woff2")
)

font_face <- function(family, style, weight, file) {
  path <- file.path("fonts", file)
  data <- jsonlite::base64_enc(readBin(path, "raw", file.size(path)))
  sprintf('@font-face { font-family: "%s"; font-style: %s; font-weight: %s; font-display: swap;\n  src: url("data:font/woff2;base64,%s") format("woff2"); }',
          family, style, weight, gsub("\n", "", data))
}

blocks <- unlist(Map(font_face, faces$family, faces$style, faces$weight, faces$file))
lines  <- readLines(theme)
from   <- match(begin, lines); to <- match(end, lines)
if (is.na(from) || is.na(to)) stop("marker lines not found in ", theme)
writeLines(c(lines[seq_len(from)], blocks, lines[to:length(lines)]), theme)

dir.create("_extensions/chalk/licences", showWarnings = FALSE)
file.copy(list.files("fonts", "^OFL-.*\\.txt$", full.names = TRUE), "_extensions/chalk/licences", overwrite = TRUE)
cat("wrote", nrow(faces), "faces into", theme, "\n")
