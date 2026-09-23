# stat-absk.github.io

Personal website of Abhishek Bhattacharjee — built with [Quarto](https://quarto.org),
published with GitHub Pages at <https://stat-absk.github.io>.

## Building

Open `Github_Page.Rproj` in RStudio and press **Render**, or from the terminal:

```bash
quarto render
```

Rendered output goes to `docs/`, which is what GitHub Pages serves. Render before
committing, then push — the site updates within a minute.

## Design

One design language across the pages and the slide decks. `styles-dark.scss` and
`styles-light.scss` define the two appearances (chalk on slate, ink on paper); `_type.scss`,
`_palette-wiring.scss` and `_signature.scss` hold the shared faces, strengths and rules,
including the full-screen layout: a page opens with one screen that holds its name, then
level-two sections run as edge-to-edge bands with the section name in a left column.
`_signature-reveal.scss` is the same system as a reveal.js theme; each deck in `slides/`
is rendered in its own repository with an identical copy of that file next to its `.qmd`,
so a change here must be copied there and the deck re-rendered.
