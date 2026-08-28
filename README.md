# Personal website — Quarto + RStudio + GitHub Pages

A Quarto website: home/about, CV, and a notes section. Edited in RStudio,
rendered to `docs/`, served by GitHub Pages.

```
_quarto.yml        site config: title, navbar, theme, output dir   <- start here
index.qmd          home / about page
cv.qmd             positions, education, publications, service
stuff.qmd          notes listing (reads posts/ automatically)
posts/
  _metadata.yml    settings shared by every post
  welcome/index.qmd
  tidy-penguins/index.qmd      a post that actually runs R
styles.scss        theme tweaks; design tokens at the top
post-render.R      recreates docs/.nojekyll after each render
images/            favicon + profile picture (both placeholders — replace)
files/             put cv.pdf and other downloads here
docs/              RENDERED SITE — committed, this is what Pages serves
_freeze/           cached R results so old posts don't re-run
```

## Quarto lives inside RStudio

Quarto is not on your `PATH`, but RStudio bundles it (v1.9.38), so **Render** in
RStudio just works. To use it from the Terminal too, add this to `~/.zshrc`:

```bash
echo 'export PATH="/Applications/RStudio.app/Contents/Resources/app/quarto/bin:$PATH"' >> ~/.zshrc
```

Or install the standalone CLI from <https://quarto.org/docs/get-started/>.

## Editing it

1. Open `Github_Page.Rproj` in RStudio.
2. Edit any `.qmd`.
3. Press **Render** (or ⌘⇧K). For live reload while writing, use the **Build**
   tab → **Render Website**, or run `quarto preview` in the Terminal.
4. Commit and push. Pages redeploys in about a minute.

### Before the first publish — replace these placeholders

| Placeholder | Where | Replace with |
| --- | --- | --- |
| `YOUR-SCHOLAR-ID`, `YOUR-HANDLE` | `index.qmd` | Scholar / LinkedIn links (or delete those lines) |
| `images/profile.svg` | `index.qmd` | a real photo, e.g. `images/profile.jpg` |

Find them all with:

```bash
grep -rn "YOUR-SCHOLAR-ID\|YOUR-HANDLE\|\[Your role\]" --include="*.qmd" .
```

Your email `stat.absk@gmail.com` is in `_quarto.yml` and `index.qmd` as a mailto
link. It will be public — delete those two lines if you'd rather it weren't.

## Adding a post

```bash
mkdir -p posts/my-new-post
```

Create `posts/my-new-post/index.qmd`:

``` yaml
---
title: "The title"
description: "One line for the notes listing."
date: 2026-09-01
categories: [rstats, notes]
---
```

Render — the Stuff listing picks it up automatically. Keep images in the post's own
folder. To show thumbnails on the listing, add `image` to the `fields:` list in
`stuff.qmd` and give each post an `image:` in its front matter.

## Publishing to GitHub Pages

**1. Create the repo.** <https://github.com/new>. To get the short URL
`https://stat-absk.github.io/`, name the repo **exactly**
`stat-absk.github.io`. Make it **Public**. Don't add a README.

**2. Push.**

```bash
git remote add origin https://github.com/stat-absk/stat-absk.github.io.git && git push -u origin main
```

**3. Turn on Pages.** Repo → **Settings** → **Pages** → Source: **Deploy from a
branch**, branch **main**, folder **/docs** → Save.

A minute later the site is live. Note the trailing detail: if you use a *project*
repo (`github.io/my-site/`) rather than the `username.github.io` one, set
`site-url` in `_quarto.yml` to the full URL including the repo path.

## Updating

```bash
git add . && git commit -m "New post" && git push
```

Always **render before committing** — `docs/` is the published site, so an
unrendered change won't appear online.

### Why `docs/` is committed

The alternative is a GitHub Action that installs R and every package on each
push. That's fragile for R-heavy posts. Rendering locally means the site you see
is exactly the site that ships. `_freeze/` is committed for the same reason:
computed results are cached, so old posts don't re-run.
