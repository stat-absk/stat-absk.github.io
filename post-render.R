# Runs after every `quarto render` (see post-render in _quarto.yml).
# Quarto empties docs/ on each build, so everything GitHub Pages needs but Quarto
# doesn't generate is recreated here:
#   1. docs/.nojekyll, so Pages serves the site as-is.
#   2. Image derivatives. Originals stay untouched in images/; for each raster
#      image a page uses, this writes WebP (and AVIF where the build's
#      ImageMagick can) at two widths beside it in docs/, then rewrites the
#      page's <img> into a <picture> that lazy-loads the right one, with
#      width and height set so nothing shifts while it arrives.

out <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR", "docs")
file.create(file.path(out, ".nojekyll"))
cat("post-render: wrote", file.path(out, ".nojekyll"), "\n")

library(magick)
library(xml2)

# ── What the build can write ─────────────────────────────────────────────────
# AVIF needs libheif in ImageMagick; a machine without it writes WebP only and
# says so, rather than failing the build.
can_write <- function(format) {
  tryCatch({
    image_write(image_blank(4, 4, "black"), tempfile(fileext = paste0(".", format)), format = format)
    TRUE
  }, error = function(e) FALSE)
}
formats <- c(if (can_write("avif")) "avif", "webp")
if (!"avif" %in% formats) cat("post-render: this ImageMagick cannot write AVIF; WebP only\n")

# ── Display widths ───────────────────────────────────────────────────────────
# Each image is served at the width the page draws it and at twice that, for
# dense screens. Anything not listed is served at its own width and half of it.
display_width <- function(src) {
  w <- c(
    "images/profile.jpg"            = 300,   # the hero portrait, at its largest
    "images/singlebell/appicon.png" = 104,   # the app icon in the SingleBell opening
    "images/workbench/"             = 1180   # browser windows, full measure
  )
  hit <- names(w)[startsWith(src, names(w))]
  if (length(hit)) return(unname(w[hit[1]]))
  if (startsWith(src, "images/singlebell/")) return(200)  # a phone, as .shots and .shot-right draw it
  NA
}

# ── Derivatives ──────────────────────────────────────────────────────────────
derivative_path <- function(src, width, format) {
  vapply(width, function(w) sub("\\.[^.]+$", sprintf("-%d.%s", w, format), src), character(1))
}

make_derivatives <- function(src) {
  original <- file.path(out, src)
  if (!file.exists(original)) return(NULL)
  img <- image_read(original)
  info <- image_info(img)
  base <- display_width(src)
  if (is.na(base)) base <- info$width
  widths <- unique(pmin(c(base, 2 * base), info$width))
  for (w in widths) {
    scaled <- if (w < info$width) image_resize(img, paste0(w, "x")) else img
    for (fmt in formats) {
      target <- file.path(out, derivative_path(src, w, fmt))
      if (!file.exists(target)) {
        quality <- if (fmt == "avif") 55 else 80
        image_write(scaled, target, format = fmt, quality = quality)
      }
    }
  }
  list(width = info$width, height = info$height, widths = widths)
}

# ── Rewriting the page ───────────────────────────────────────────────────────
rewrite_images <- function(page) {
  doc <- read_html(page, encoding = "UTF-8")
  imgs <- xml_find_all(doc, "//main//img[not(contains(@class,'navbar-logo'))]")
  changed <- FALSE
  for (img in imgs) {
    src <- xml_attr(img, "src")
    if (is.na(src) || grepl("^(https?:|data:|/)", src) || !grepl("\\.(png|jpe?g)$", src, ignore.case = TRUE)) next
    d <- make_derivatives(src)
    if (is.null(d)) next

    # The <picture>: one <source> per format, densest width marked 2x.
    picture <- xml_add_sibling(img, "picture", .where = "before")
    for (fmt in formats) {
      srcset <- paste(sprintf("%s %dx", derivative_path(src, d$widths, fmt), seq_along(d$widths)), collapse = ", ")
      xml_add_child(picture, "source", type = paste0("image/", fmt), srcset = srcset)
    }
    # The original stays as the fallback, now with its box declared.
    xml_set_attr(img, "width", as.character(d$width))
    xml_set_attr(img, "height", as.character(d$height))
    xml_set_attr(img, "loading", "lazy")
    xml_set_attr(img, "decoding", "async")
    xml_add_child(picture, img)
    xml_remove(img)
    changed <- TRUE
  }
  if (changed) write_html(doc, page, options = c("format", "no_declaration"))
  changed
}

pages <- list.files(out, pattern = "\\.html$", full.names = TRUE)   # top level only: the site's pages
done <- vapply(pages, rewrite_images, logical(1))
cat("post-render: images rewritten on", sum(done), "page(s); formats:", paste(formats, collapse = ", "), "\n")
