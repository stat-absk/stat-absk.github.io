# Page weights, measured from docs/ before a push.
#
#   Rscript R/check_budgets.R
#
# For each page in docs/, adds up the HTML and every local file a browser would
# fetch for it: stylesheets, scripts, and the 1x image a <picture> would choose
# (or the plain <img> where there is no <picture>). Fonts under docs/fonts are
# reported once. Text (HTML, CSS, JS) is counted gzip-compressed, as Pages
# serves it; images and fonts are counted as they are. A budget that is
# exceeded is printed with a mark and the script exits non-zero, so it can
# gate a push.

library(xml2)

served_size <- function(path) {
  if (grepl("\\.(html|css|js|json|svg|xml)$", path)) {
    length(memCompress(readBin(path, "raw", file.size(path)), "gzip"))
  } else file.size(path)
}

out <- "docs"
budgets <- c(                     # bytes; from UPGRADE-TRACKER.md
  "singlebell.html" = 1000 * 1024,
  fonts             = 200 * 1024
)

local_path <- function(href) {
  href <- sub("[?#].*$", "", href)
  if (!nzchar(href) || grepl("^(https?:|//|data:|mailto:)", href)) return(NA_character_)
  file.path(out, sub("^\\./", "", href))
}

page_weight <- function(page) {
  doc <- read_html(page, encoding = "UTF-8")
  refs <- c(
    xml_attr(xml_find_all(doc, "//link[@rel='stylesheet']"), "href"),
    xml_attr(xml_find_all(doc, "//script[@src]"), "src"),
    # The 1x candidate of each <picture>'s first <source>, else the <img> itself.
    vapply(xml_find_all(doc, "//picture"), function(p) {
      s <- xml_find_first(p, ".//source")
      if (!inherits(s, "xml_missing")) sub(" .*$", "", strsplit(xml_attr(s, "srcset"), ",")[[1]][1])
      else xml_attr(xml_find_first(p, ".//img"), "src")
    }, character(1)),
    xml_attr(xml_find_all(doc, "//img[not(ancestor::picture)]"), "src")
  )
  paths <- unique(na.omit(vapply(refs, local_path, character(1))))
  paths <- paths[file.exists(paths)]
  sum(vapply(c(page, paths), served_size, numeric(1)))
}

pages <- list.files(out, pattern = "\\.html$")
weights <- vapply(file.path(out, pages), page_weight, numeric(1))
names(weights) <- pages

fonts <- list.files(file.path(out, "fonts"), recursive = TRUE, full.names = TRUE)
font_weight <- if (length(fonts)) sum(file.size(fonts)) else 0

fmt_kb <- function(b) sprintf("%7.0f KB", b / 1024)
over <- character(0)
cat("Page weights as served (gzip text + local CSS, JS, 1x images):\n")
for (p in names(sort(weights, decreasing = TRUE))) {
  mark <- ""
  if (!is.na(budgets[p]) && weights[p] > budgets[p]) { mark <- "  <- over budget"; over <- c(over, p) }
  cat(sprintf("  %-22s %s%s\n", p, fmt_kb(weights[p]), mark))
}
mark <- if (font_weight > budgets["fonts"]) "  <- over budget" else ""
if (font_weight > budgets["fonts"]) over <- c(over, "fonts")
cat(sprintf("  %-22s %s%s\n", "fonts/", fmt_kb(font_weight), mark))

if (length(over)) {
  cat("\nOver budget:", paste(over, collapse = ", "), "\n")
  quit(status = 1)
}
cat("\nAll budgets met.\n")
