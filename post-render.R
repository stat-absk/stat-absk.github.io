# Runs after every `quarto render` (see post-render in _quarto.yml).
# Quarto empties docs/ on each build, so files GitHub Pages needs but Quarto
# doesn't generate get recreated here.
out <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR", "docs")
file.create(file.path(out, ".nojekyll"))   # stop GitHub Pages running Jekyll
cat("post-render: wrote", file.path(out, ".nojekyll"), "\n")
