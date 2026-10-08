# theme_chalk(): one ggplot theme and palette for the site, the decks and
# anything else published from here. A figure is drawn as a mark — writing
# and a few strokes, no box, no grid to speak of — and takes its colours from
# the page, so it follows the light and dark appearance without a second render.
#
# How the colours follow the page: the theme draws with sentinel colours, and
# chalk_inline() renders the plot to inline SVG and swaps each sentinel for the
# page's custom property (_ground.scss exposes them). Use chalk_inline() in a
# chunk with `results: asis`; use the theme alone when a PNG is wanted.

library(ggplot2)

# Sentinels: distinct, never seen on the page, replaced on output.
chalk_colours <- c(
  ink    = "#F1F2E9",   # --ink      writing at full strength
  ink2   = "#B1B2AA",   # --ink2     the detail behind the thing
  ink3   = "#81827B",   # --ink3     labels, captions
  rule   = "#3B3C36",   # --rule     a hairline
  accent = "#E8D491",   # --accent   the one thing to look at
  work   = "#7FA98E",   # work and rest: the app's phases, softened to chalk —
  rest   = "#7E95B5"    # data only, never the interface
)

theme_chalk <- function(base_size = 14, base_family = "Atkinson Hyperlegible Next") {
  c <- chalk_colours
  theme_minimal(base_size = base_size, base_family = base_family) +
    theme(
      text             = element_text(colour = c[["ink2"]]),
      plot.title       = element_text(colour = c[["ink"]], size = rel(1.1), hjust = 0, margin = margin(b = 8)),
      plot.subtitle    = element_text(colour = c[["ink3"]], size = rel(0.85), hjust = 0, margin = margin(b = 12)),
      plot.caption     = element_text(colour = c[["ink3"]], size = rel(0.75), hjust = 0),
      axis.text        = element_text(colour = c[["ink3"]], size = rel(0.8)),
      axis.title       = element_text(colour = c[["ink3"]], size = rel(0.8)),
      axis.ticks       = element_blank(),
      axis.line.x      = element_line(colour = c[["rule"]], linewidth = 0.5),
      panel.grid       = element_blank(),
      panel.grid.major.x = element_line(colour = c[["rule"]], linewidth = 0.3),
      legend.position  = "none",
      strip.text       = element_text(colour = c[["ink2"]], hjust = 0),
      plot.background  = element_rect(fill = "transparent", colour = NA),
      panel.background = element_rect(fill = "transparent", colour = NA),
      plot.margin      = margin(4, 8, 4, 0)
    )
}

# Render a plot as inline SVG whose colours are the page's. `summary` is the
# one-sentence description assistive technology reads instead of the picture.
chalk_inline <- function(plot, width = 7, height = 2.6, summary, class = "figure-chalk") {
  svg <- svglite::svgstring(width = width, height = height, bg = "transparent", standalone = FALSE, scaling = 1)
  print(plot)
  grDevices::dev.off()
  out <- as.character(svg())
  vars <- c(ink = "ink", ink2 = "ink2", ink3 = "ink3", rule = "rule", accent = "accent")
  for (nm in names(vars)) {
    out <- gsub(chalk_colours[[nm]], sprintf("var(--%s)", vars[[nm]]), out, ignore.case = TRUE)
  }
  # Work and rest stay literal colours; they are data, not interface.
  # The device's page-filling background rect goes: the figure sits on the ground.
  out <- sub("<rect width=['\"]100%['\"] height=['\"]100%['\"][^>]*/?>", "", out)
  # Drop the fixed size so the drawing fits its column; the viewBox keeps the ratio.
  out <- sub("<svg ", "<svg role=\"img\" ", out)
  out <- sub(" width='[^']*pt'", "", out)
  out <- sub(" height='[^']*pt'", "", out)
  out <- sub("<svg", sprintf("<svg aria-label=\"%s\"", gsub("\"", "&quot;", summary)), out)
  # One line, inside a raw HTML fence: the output goes through Pandoc, and a
  # blank line inside the SVG would end a Markdown raw block mid-element.
  out <- gsub("\\s*\n\\s*", " ", out)
  cat(sprintf("```{=html}\n<figure class=\"%s\">%s<figcaption class=\"visually-hidden\">%s</figcaption></figure>\n```\n", class, out, summary))
}
