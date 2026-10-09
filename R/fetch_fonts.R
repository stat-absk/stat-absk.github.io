# The site's three faces, fetched as subset WOFF2 and wired into _fonts.scss.
#
#   Rscript R/fetch_fonts.R
#
# Run from the site root. Asks Google Fonts for the exact faces the site uses,
# takes the latin-subset WOFF2 files it serves (already subset, so no font
# tooling is needed here), saves them under fonts/ with each family's licence,
# and writes _fonts.scss: one @font-face per file, font-display: swap. The
# files are committed, so the site serves them itself and makes no request to
# Google at read time. Re-run only to change the faces; the budget is 200 KB.

families <- c(
  "Literata:ital,wght@0,400;0,600;1,400",
  "Atkinson+Hyperlegible+Next:wght@400;500",
  "Atkinson+Hyperlegible+Mono"
)
licences <- c(
  literata                 = "https://raw.githubusercontent.com/google/fonts/main/ofl/literata/OFL.txt",
  atkinsonhyperlegiblenext = "https://raw.githubusercontent.com/google/fonts/main/ofl/atkinsonhyperlegiblenext/OFL.txt",
  atkinsonhyperlegiblemono = "https://raw.githubusercontent.com/google/fonts/main/ofl/atkinsonhyperlegiblemono/OFL.txt"
)

dir.create("fonts", showWarnings = FALSE)

# A modern browser's user agent, so the CSS names WOFF2 files with unicode-range.
ua <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"
css_url <- paste0("https://fonts.googleapis.com/css2?", paste0("family=", families, collapse = "&"), "&display=swap")
css <- paste(readLines(url(css_url, headers = c("User-Agent" = ua)), warn = FALSE), collapse = "\n")

# Each block is "/* subset */ @font-face { ... }". Keep the latin ones.
blocks <- regmatches(css, gregexpr("/\\* ([a-z-]+) \\*/\\s*@font-face \\{[^}]*\\}", css))[[1]]
latin  <- blocks[grepl("^/\\* latin \\*/", blocks)]
field  <- function(block, name) sub(paste0(".*", name, ": ([^;]+);.*"), "\\1", block)

faces <- unique(data.frame(
  family = gsub("'", "", field(latin, "font-family")),
  style  = field(latin, "font-style"),
  weight = field(latin, "font-weight"),
  url    = sub(".*url\\(([^)]+)\\).*", "\\1", latin),
  stringsAsFactors = FALSE
))

# One file per family and style; the variable file carries every weight it lists.
faces$file <- with(faces, sprintf("%s-%s.woff2", gsub(" ", "", tolower(family)), style))
for (i in seq_len(nrow(faces))) {
  path <- file.path("fonts", faces$file[i])
  if (!file.exists(path)) download.file(faces$url[i], path, mode = "wb", quiet = TRUE)
}
for (nm in names(licences)) {
  path <- file.path("fonts", paste0("OFL-", nm, ".txt"))
  if (!file.exists(path)) download.file(licences[[nm]], path, quiet = TRUE)
}

# The weights each file covers, as a range for the variable files.
rules <- vapply(split(faces, faces$file), function(f) {
  w <- as.integer(f$weight)
  weight <- if (length(w) > 1) paste(min(w), max(w)) else as.character(w)
  sprintf(
    "@font-face {\n  font-family: \"%s\";\n  font-style: %s;\n  font-weight: %s;\n  font-display: swap;\n  src: url(\"/fonts/%s\") format(\"woff2\");\n}",
    f$family[1], f$style[1], weight, f$file[1]
  )
}, character(1))

writeLines(c(
  "// Written by R/fetch_fonts.R — do not edit by hand. The faces are served from",
  "// fonts/ with their licences; font-display: swap so text is never invisible.",
  "", rules
), "_fonts.scss")

sizes <- file.size(file.path("fonts", unique(faces$file)))
cat(sprintf("%-40s %6.1f KB\n", unique(faces$file), sizes / 1024), sep = "")
cat(sprintf("total %.1f KB (budget 200 KB)\n", sum(sizes) / 1024))

# ── The same faces as static TTF, for Typst and R ────────────────────────────
# The web serves WOFF2; the CV's PDF (Typst) and the social card (ragg) need
# TTF files, and Typst cannot instance a variable font, so these are the
# static cuts from the families' own repositories (the same OFL licence). They
# live in fonts/ttf/, never on the web.
statics <- c(
  "https://raw.githubusercontent.com/googlefonts/literata/main/fonts/ttf/Literata-Regular.ttf",
  "https://raw.githubusercontent.com/googlefonts/literata/main/fonts/ttf/Literata-Italic.ttf",
  "https://raw.githubusercontent.com/googlefonts/literata/main/fonts/ttf/Literata-SemiBold.ttf",
  "https://raw.githubusercontent.com/googlefonts/atkinson-hyperlegible-next/main/fonts/ttf/AtkinsonHyperlegibleNext-Regular.ttf",
  "https://raw.githubusercontent.com/googlefonts/atkinson-hyperlegible-next/main/fonts/ttf/AtkinsonHyperlegibleNext-Medium.ttf"
)
dir.create("fonts/ttf", showWarnings = FALSE)
for (u in statics) {
  path <- file.path("fonts/ttf", basename(u))
  if (!file.exists(path)) download.file(u, path, mode = "wb", quiet = TRUE)
}
ttfs <- list.files("fonts/ttf", pattern = "\\.ttf$")
cat(sprintf("%-40s %7.0f KB\n", ttfs, file.size(file.path("fonts/ttf", ttfs)) / 1024), sep = "")

# The deck theme carries the same faces inside itself.
source("R/deck_fonts.R")
