# Screenshots of the live site at three widths in both appearances.
#
#   Rscript R/screenshots.R [base-url] [out-dir]
#
# Defaults: https://stat-absk.github.io and screenshots/. For each page, at
# 390, 768 and 1440 px, with the reader's system set to light and to dark, a
# full-page PNG named <page>-<width>-<appearance>.png. The checks Action runs
# it after each deploy and keeps the folder as an artefact; it also runs
# locally against `quarto preview` or any static server over docs/.
# Headless Chrome through chromote, so the tooling stays in R.

library(chromote)

args  <- commandArgs(trailingOnly = TRUE)
base  <- if (length(args) >= 1) sub("/$", "", args[1]) else "https://stat-absk.github.io"
out   <- if (length(args) >= 2) args[2] else "screenshots"
pages <- c(home = "/", cv = "/cv.html", work = "/work.html", notes = "/notes.html", singlebell = "/singlebell.html")
widths <- c(390, 768, 1440)
schemes <- c("light", "dark")

dir.create(out, showWarnings = FALSE, recursive = TRUE)
b <- ChromoteSession$new()

for (scheme in schemes) {
  for (w in widths) {
    # A phone width is a phone: a mobile viewport. One pixel per CSS pixel keeps
    # the artefact light.
    mobile <- w < 768
    b$Emulation$setDeviceMetricsOverride(width = w, height = 900, deviceScaleFactor = 1, mobile = mobile)
    b$Emulation$setEmulatedMedia(features = list(list(name = "prefers-color-scheme", value = scheme),
                                                 list(name = "prefers-reduced-motion", value = "reduce")))
    for (name in names(pages)) {
      # A fresh load each time: the site keeps the reader's toggle in storage,
      # which would otherwise override the emulated system appearance.
      b$Runtime$evaluate("try { localStorage.clear(); sessionStorage.clear(); } catch (e) {}")
      p <- b$Page$loadEventFired(wait_ = FALSE)
      b$Page$navigate(paste0(base, pages[[name]]), wait_ = FALSE)
      b$wait_for(p)
      b$Runtime$evaluate("document.fonts.ready.then(() => true)", awaitPromise = TRUE)
      Sys.sleep(0.4)   # lazy pictures settle
      file <- file.path(out, sprintf("%s-%d-%s.png", name, w, scheme))
      # The whole page, not the viewport: measure it, then capture beyond the fold.
      h <- b$Runtime$evaluate("Math.ceil(document.documentElement.scrollHeight)")$result$value
      shot <- b$Page$captureScreenshot(format = "png", captureBeyondViewport = TRUE,
                                        clip = list(x = 0, y = 0, width = w, height = h, scale = 1))
      writeBin(jsonlite::base64_dec(shot$data), file)
      cat(file, "\n")
    }
  }
}
b$close()
