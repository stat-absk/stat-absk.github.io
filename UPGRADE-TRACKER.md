# stat-absk.github.io — Upgrade action plan and tracker

Companion to [stat-absk.github.io — Upgrade Plan.md](stat-absk.github.io%20—%20Upgrade%20Plan.md) (the review, 8 Oct 2026).
This file turns the review into decisions, requirements, and a checklist. It is the working tracker: tick items here.

Owner key: **[A]** Abhishek · **[C]** Claude · **[A→C]** Abhishek decides or writes, Claude wires it in.

---

## 1. Decisions

### Settled (8 Oct 2026)

| # | Decision | Choice | Consequence for the plan |
| --- | --- | --- | --- |
| D1 | One title everywhere | **Senior Manager, Biostatistics** | Home, page description and CV profile all use these words. The "Associate Director–equivalent" gloss stays only in the CV experience bullet, if at all. |
| D2 | Chalk marks | **SVG fallback** (straight strokes + turbulence filter) | Phase 3 does not wait on hand-drawn marks. Real marks can replace the sprite later with no other change. |
| D3 | Way to reach you | **No email published** (standing rule kept) | The "Elsewhere" line is Scholar · GitHub · LinkedIn as words. LinkedIn remains the route. The review's "Write to me" line is out of scope. |
| D4 | Navigation | **Work · Notes · CV · About** | Stuff splits into *Made* (Workbench, SingleBell) and *Notes* (talks, write-ups). The three-tab rule from Aug 2026 is superseded. Gated: the About tab ships only once About is written (see pre-mortem #2). |
| D5 | Toolchain | Quarto + GitHub Pages + R, no Python | Review already recommends staying on Quarto. The one Python file in the repo (`images/singlebell/make-social-card.py`) is replaced by R. |

### Open — needed before the phase that uses them

- [ ] **D6** Should the site still open dark when the device states no preference? *(Phase 1)* — Default assumption until answered: yes, dark, with the toggle overriding.
- [ ] **D7** Name in Bangla on the About page? *(Phase 2)* — Needs a Bengali serif subset and `lang="bn"`.
- [ ] **D8** Which six photographs for *Outside work*? *(Phase 4)*
- [ ] **D9** Keep Bootstrap or replace with one sheet under 40 KB? *(After Phase 3, by design — measure first.)*
- [ ] **D10** Does the review's "cards become ruled rows" supersede the Sept 2026 homepage cards you picked from prototypes? *(Phase 3)* — Prototype C from that session (the editorial index) is already the ruled-row layout; the plan assumes yes and reuses it.

---

## 2. Baseline — what the site is today (spec-miner)

Facts checked against the repo on 8 Oct 2026. The review's measurements hold.

| Claim in the review | Evidence | Verified |
| --- | --- | --- |
| Title disagrees between pages | `index.qmd:19` "Associate Director"; `cv.qmd:14,34` "Senior Manager, Biostatistics (Associate Director–equivalent)" | Yes |
| Measure runs 88–95 characters | `_signature.scss:83` `p { max-width: 46rem; }` at 17 px sans | Yes |
| Body is 1600 px | `_quarto.yml:61` `body-width: 1600px` | Yes |
| External links open new windows | `_quarto.yml:70` `link-external-newwindow: true` | Yes |
| SingleBell screenshots ~6 MB | `images/singlebell/` 6.5 MB; seven PNGs 0.7–1.0 MB each; `appicon.png` 295 KB | Yes |
| Portrait 151 KB at 800 px | `images/profile.jpg` 148 KB, 800×800 | Yes |
| `posts/` configured and empty | `posts/_metadata.yml` only | Yes |
| No DOI links on publications | `grep -c doi.org cv.qmd` → 0 | Yes |
| `_signature.scss` is 800 lines | `wc -l` → 800 | Yes |
| Site always opens dark | `_quarto.yml` theme lists `dark` first; no `respect-user-color-scheme` | Yes |
| Reduce Motion shortens rather than removes | `_signature.scss` `prefers-reduced-motion` block sets 200 ms durations | Yes |
| Grain overlays everything | `_signature.scss` `body::after` at `z-index: 9999` | Yes |
| Not in the review | `images/singlebell/make-social-card.py` — Python in an all-R repo | Added as task |
| Toolchain | Quarto 1.9.38 (RStudio-bundled), `execute: freeze: auto`, `post-render.R` writes `.nojekyll`, Pages serves `main:/docs` | — |

### Behaviours to preserve (EARS)

- The site shall publish no email address and no phone number. *(standing rule, D3)*
- The site shall load no analytics and no third-party script. *(review: "Nothing is tracked")*
- The site shall render from `docs/` on `main`; every push shall be preceded by a local `quarto render`. *(deploy contract)*
- Where the reader has Reduce Transparency or Increase Contrast set, the site shall keep answering them as it does now (`_signature.scss` accessibility block).
- The large name on Home shall keep collapsing into the bar as the reader scrolls past it (`#quarto-header.has-hero` script in `_quarto.yml`).
- The band layout shall keep the section name in the left column; the column gains content (dates, notes) rather than being replaced.
- All code in the repository shall be R, SCSS, Lua (Quarto shortcodes) or YAML. *(D5)*

---

## 3. Requirements (feature-forge)

Numbered by phase so the tracker in §6 can point at them. EARS form.

### Phase 1 — Repair

- **FR-1.1** The site shall use the words "Senior Manager, Biostatistics" for the current role on Home, in the site description, and in the CV profile. *(D1)*
- **FR-1.2** When a device states a light or dark preference, the site shall open in that appearance; when the reader toggles, the toggle shall win for the session. *(D6 sets the no-preference default)*
- **FR-1.3** The site shall emit two `theme-color` meta tags, one per appearance.
- **FR-1.4** Where Reduce Motion is set, the site shall run no animation: no page rise, no hero stagger, no card lift, instant appearance change.
- **FR-1.5** Reading text shall be capped at 66ch; no line of prose shall exceed 75 characters at any width.
- **FR-1.6** Every tappable control shall have a hit area of at least 44 × 44 px.
- **FR-1.7** Every control edge the reader needs to see shall reach 3:1 against its ground; decorative rules may stay at 12 %.
- **FR-1.8** The grain shall sit on the body background, beneath content, so photographs and screenshots are not dusted.
- **FR-1.9** Internal and external links shall open in the same tab.
- **FR-1.10** The first focusable element on every page shall be a "Skip to content" link.
- **FR-1.11** Every page shall carry a canonical URL.
- **FR-1.12** When a path is not found, the site shall serve a 404 page in the site's voice with a link home.
- **FR-1.13** The SingleBell screenshots shall be served under 400 KB in total, at two widths, lazy-loaded, with `width` and `height` set; the app icon under 20 KB; the portrait in two sizes under 40 KB each.
- **FR-1.14** Image derivatives shall be produced by `post-render.R` (R, `magick`) so originals stay untouched in the repository. *(replaces the Python social-card script too)*

### Phase 2 — Type and voice

- **FR-2.1** The site shall self-host Literata (reading text, names), Atkinson Hyperlegible Next (labels, nav, data) and Atkinson Hyperlegible Mono (code) as subset WOFF2 with `font-display: swap` and metric-matched fallbacks; total font weight ≤ 200 KB.
- **FR-2.2** The type scale shall be the review's seven steps (14 / 15 / 18 / 22 / 28 / 40 / 44–76 fluid); body text 18 px serif, line height 1.6.
- **FR-2.3** The site shall use no uppercase; "On this page" becomes sentence case.
- **FR-2.4** Home's opening, the Home paragraph, the CV profile, About and Now shall be written by Abhishek. Claude shall not draft them. *(standing rule)*
- **FR-2.5** The navigation bar shall read Work · Notes · CV · About; the three social icons shall leave the bar for the Elsewhere line, and the icon font shall go with them. *(D4, D3)*
- **FR-2.6** When About is not yet written, the bar shall not show an About tab. *(gate)*
- **FR-2.7** Stuff shall split into Made (Workbench, SingleBell) and Notes (talks, write-ups); each listing row is a name, one line, and the whole row a link. Each deck row states date, length and file size.
- **FR-2.8** The CV core-competency pills shall be removed from the web page.

### Phase 3 — Signature

- **FR-3.1** The site shall ship `marks/chalk.svg`: eight rules, five tally strokes, two strike-throughs, one underline, one circle, as straight SVG strokes roughened by one turbulence-and-displacement filter defined once. *(D2)*
- **FR-3.2** `{{< tally N >}}` shall render N in gates of five with N as text for assistive tech and the strokes `aria-hidden`; it shall be used only for real counts under ~25.
- **FR-3.3** `{{< rule >}}` shall pick the next stroke from the set so neighbouring rules never match.
- **FR-3.4** Nothing on any page shall be boxed: card borders, fills, hover lift, arrow fade, pill outlines, the portrait ring and glow are removed. Dust (chalk at 6–10 %) replaces borders where a surface is needed.
- **FR-3.5** The light appearance shall be pencil on paper: graphite `#2A302D` writing on paper `#F2F3EA`, accent `#6E5A16`, marks drawn thinner without roughening.
- **FR-3.6** Dark slate shall lift to `#131A17`; code blocks and the footer shall sit on deep slate `#0C110F`.
- **FR-3.7** Colours shall be exposed as CSS custom properties on `:root` so inline SVG figures follow the appearance.
- **FR-3.8** `R/theme_chalk.R` shall provide one ggplot theme and palette; the CV career strip and papers-by-year figures shall be drawn with it at render time.
- **FR-3.9** Motion shall be at most one authored moment per page (Home: rule draws once, 600 ms; appearance toggle: 350 ms wipe; page change: 200 ms cross-fade via view transitions where supported).
- **FR-3.10** The favicon shall become one gate of five; a 1200 × 630 social card shall be generated in R.
- **FR-3.11** Home shall be recomposed per the review's notebook layout: opening sentence, rule, paragraph, portrait as 4:5 with caption, then Now / Made / Written / Elsewhere bands.

### Phase 4 — Depth

- **FR-4.1** Notes shall publish an RSS feed once it has its first piece.
- **FR-4.2** `cv.qmd` shall render a Typst PDF from the same source.
- **FR-4.3** The reveal.js theme shall be published as a Quarto extension and installed in both deck repositories, replacing the hand-copied `_signature-reveal.scss`.
- **FR-4.4** A GitHub Action shall run after render: Lighthouse on Home, CV, SingleBell; a link check; screenshots at 390 / 768 / 1440 px in both appearances as artefacts. It shall fail on a budget regression.
- **FR-4.5** Every page shall carry a "last tended" date.
- **FR-4.6** Every page shall carry a `Person` JSON-LD record.

### Non-functional budgets

| Item | Budget |
| --- | --- |
| Lighthouse accessibility | 100 on every page |
| SingleBell page weight | < 1 MB |
| Fonts | ≤ 200 KB, loaded after first paint |
| Home largest paint | < 1.5 s on 4G; layout shift 0 |
| Scripts | ≤ 4 if Bootstrap goes (D9) |
| Slide decks | unchanged; size stated beside each link |
| Zoom | no content loss at 200 % and 400 %, both appearances |

### Error handling

| Condition | Behaviour |
| --- | --- |
| Path not found | 404 page, one line, link home (FR-1.12) |
| Font file fails to load | Metric-matched system fallback; no layout shift beyond 0.05 CLS |
| `magick` lacks AVIF (libheif) support on the build machine | `post-render.R` writes WebP and warns; AVIF is optional and never fails the build |
| View transitions unsupported | Page changes as today, instantly |
| Reduce Motion set | No animation at all (FR-1.4) |
| JS disabled | Appearance follows `prefers-color-scheme` via CSS; tallies still read as numbers |

---

## 4. Acceptance criteria — the phase gates

**Gate 1 (Repair).** Given the rendered site, when Lighthouse runs on every page, then accessibility is 100; when SingleBell loads, then transfer is under 1 MB; when any paragraph is measured at 1440 px, then no line passes 75 characters; when a reader with Reduce Motion opens Home, then nothing moves.

**Gate 2 (Type and voice).** Given an iPhone, a Windows laptop and an Android phone, when Home is opened on each, then the typefaces are identical; when the bar is read, then it shows Work · Notes · CV (· About once written) and no icons; when a friend reads Home aloud, then it sounds like Abhishek (his words, FR-2.4).

**Gate 3 (Signature).** Given any page with the name and portrait covered, when someone who knows Abhishek looks at it, then they can say whose site it is; when every page is inspected, then nothing is boxed; when the appearance is toggled, then slate reads as slate and paper as paper.

**Gate 4 (Depth).** Given Notes, when the feed is fetched, then it holds three pieces; given both decks, when opened beside the site, then type and rules match; given a push, when the Action runs, then budgets are checked and screenshots are attached.

---

## 5. Architecture decisions (architecture-designer)

Short ADRs for the choices that shape the build. Status: Accepted unless marked.

**ADR-01 Stay on Quarto + GitHub Pages, R-only tooling.** *Context:* the review allows Astro later. *Decision:* Quarto 1.9, `docs/` on `main`, R for figures, images and the social card; Lua only inside Quarto shortcodes. *Alternatives:* Astro (more control, loses R-native figures and freeze); Hugo. *Consequences:* every figure stays reproducible from `.qmd`; Bootstrap weight remains until D9.

**ADR-02 Self-hosted subset fonts.** *Decision:* Literata variable (or three static cuts if > 200 KB), Atkinson Hyperlegible Next and Mono, subset to Latin + Bengali-if-D7, in `fonts/` with `@font-face` and `size-adjust`/`ascent-override` fallbacks. *Alternatives:* Google Fonts CDN (third-party request, breaks "nothing collected"); keep system stacks (the site differs per device). *Consequences:* licence files committed; font budget enforced by the Phase 4 Action.

**ADR-03 Chalk marks as a filtered SVG sprite.** *Decision (D2):* `marks/chalk.svg` holds straight strokes; one `feTurbulence` + `feDisplacementMap` filter, applied only to marks. *Alternatives:* hand-drawn traced marks (better, later); CSS borders (no signature). *Consequences:* marks are swappable; photographs never get the filter; the light appearance uses the same sprite without the filter.

**ADR-04 Shortcodes in a local Quarto extension.** *Decision:* `_extensions/chalk/` with a Lua filter for `tally` and `rule`. *Alternatives:* raw HTML in `.qmd` (unreadable, unaccessible); R helpers emitting HTML (ties marks to code chunks). *Consequences:* the same extension later powers the decks (ADR-07).

**ADR-05 Image derivatives in `post-render.R` via `magick`.** *Decision:* originals stay in `images/`; `post-render.R` writes WebP (and AVIF when the build's ImageMagick has libheif) at two widths into `docs/`, with `width`/`height` set in the page. *Alternatives:* committing derivatives by hand; a Node pipeline (breaks D5). *Consequences:* `docs/` grows; the build must not fail when AVIF is unavailable.

**ADR-06 Navigation Work · Notes · CV · About, gated on content.** *Decision (D4):* bar changes in Phase 2; About tab appears only when About exists (FR-2.6). *Alternatives:* keep three tabs (rejected 8 Oct). *Consequences:* Stuff is retired as a name; `stuff.html` redirects to Notes to keep inbound links alive.

**ADR-07 Deck theme as a Quarto extension.** *Decision:* publish `_signature-reveal.scss` plus the chalk extension as `stat-absk/quarto-chalk` (name TBD); install in both deck repos. *Consequences:* one source; deck rebuilds require `quarto add` once per repo.

**ADR-08 CV PDF via Typst.** *Decision:* `cv.qmd` gains a `typst` format; competencies may live in the PDF only (FR-2.8). *Alternatives:* LaTeX (slower, heavier); printing the HTML (loses control). *Consequences:* two outputs from one source; print stylesheet still added for the web page.

**ADR-09 Bootstrap: decide last (Proposed).** *Decision:* Phases 1–3 on the current framework; measure; then D9. *Consequences:* the 142 KB compressed CSS stays for now; the icon font goes in Phase 2 regardless.

**ADR-10 Phase order: repair before signature.** *Decision:* the review's order stands — undisputed fixes ship first, the signature lands on a site that already reads well. *Consequences:* each phase is a pushable state; no long-lived branch.

---

## 6. Pre-mortem (the-fool)

**Scene:** It is April 2027. The upgrade has failed — the site is in a worse or stranded state than in October 2026.

### Failure narratives, ranked

**#1 The half-signature — Likelihood High, Impact High.**
Phases 1 and 2 ship in November. Phase 3 is estimated at two to three weeks of evenings; by week five it is 60 % done — new slate, no cards, but the home page is still the old composition and the marks look placeholder. A busy quarter at work starts. In April the live site has Literata and chalk rules on some bands and rounded cards on others. *Root cause:* Phase 3 was one unit of work with no sub-gates, and the SVG fallback made the marks "good enough to start, not good enough to finish".
Chain: Phase 3 stalls → mixed visual language live → the site reads *less* considered than before → motivation to finish drops further.

**#2 Nav ahead of words — Likelihood High, Impact Medium.**
Phase 2's navigation lands on schedule, but About, Now and the Home rewrite are Abhishek's to write (FR-2.4) and none are written. The bar shows "About" pointing at a stub, Home still says "Biostatistics leader" under the new fonts. *Root cause:* technical tasks and prose tasks were tracked as one phase, so the technical half shipped around a hole.
Chain: empty About → review's "it sounds like you" gate never passes → the voice work, the plan's point, is the one piece that never lands.

**#3 The build that only works on one Mac — Likelihood Medium, Impact High.**
`post-render.R` calls `magick` for AVIF; the RStudio-bundled ImageMagick on the laptop has libheif, the GitHub Action's does not (or the reverse). Fonts were subset with a tool run once by hand. In February a new laptop renders `docs/` with missing derivatives and the push deploys broken `<picture>` elements. *Root cause:* a pipeline step without a capability check, and a one-off tool step not recorded.
Chain: broken images live → quick fix bypasses `post-render.R` → derivatives drift from originals.

**#4 Weight comes back through the fonts — Likelihood Medium, Impact Medium.**
Literata variable with italics is 280 KB; it ships anyway because the budget was a sentence, not a check. Lighthouse drops to 92, LCP on 4G passes 2 s, text flashes from Georgia to Literata. *Root cause:* the 200 KB budget had no enforcement until Phase 4's Action, two phases later.

**#5 Undoing September — Likelihood Low, Impact Medium.**
The ruled rows replace the four cards chosen from prototypes four weeks earlier; the home page is redesigned twice in a quarter and the second pass is regretted. *Root cause:* no prototype step for Phase 3's composition. Mitigated by D10: reuse prototype C.

### Early warning signs

| Signal | Predicts | Check |
| --- | --- | --- |
| A Phase 3 sub-item open for more than two weekends | #1 | Each weekend |
| Phase 2 technical tasks all ticked while FR-2.4 prose boxes are empty | #2 | Before any Phase 2 push |
| `post-render.R` has a step with no `if (capability)` guard, or a README step "run once by hand" | #3 | At PR |
| `fonts/` exceeds 200 KB on disk | #4 | On adding any font file |
| "We'll do the home composition properly later" said twice | #1, #5 | — |

### Mitigations folded into the tracker

| Failure | Mitigation | Effort |
| --- | --- | --- |
| #1 | Phase 3 split into three pushable sub-phases (3a material + marks, 3b rows + margin, 3c Home + figures), each with its own gate | Low |
| #2 | Prose tasks tracked separately as §7 "Abhishek writes"; About tab gated (FR-2.6); Home rewrite gated: the new composition ships only with new words | Low |
| #3 | `post-render.R` checks `magick::magick_config()` for heif/webp and degrades; font subsetting is an R script (`R/subset_fonts.R`) committed with the repo | Medium |
| #4 | A local pre-push check script in R (`R/check_budgets.R`) measures `docs/` weights from Phase 1, before the Action exists | Low |
| #5 | Phase 3c starts from the September prototype C; one screenshot comparison before building | Low |

### Inversion check

What would guarantee failure: no sub-gates in the longest phase; prose on the critical path of technical work; a build step that depends on one machine. **Do any exist now?** All three did in the review's roadmap; the tracker below removes them.

---

## 7. The tracker

Legend: `[ ]` open · `[x]` done · `[~]` in progress · `[-]` dropped. Add the date when ticking.

### Abhishek writes (prose, in his own words — not drafted by Claude)

- [ ] **W1** Home opening sentence (FR-2.4) — *needed for 3c*
- [ ] **W2** Home paragraph: where you work, where you came from, what holds your attention — *needed for 3c*
- [ ] **W3** CV profile: three plain sentences — *needed for Gate 2*
- [ ] **W4** About page: the route Calcutta → Chennai; why statistics; what reviewing taught you; the coffee-agroforestry and horse-acupuncture sentence — *gates the About tab (FR-2.6)*
- [ ] **W5** Now: one dated paragraph — *needed for 3c*
- [ ] **W6** One line each for Made / Notes listing rows (Workbench, SingleBell, Enroll-HD deck, Tufte deck)
- [ ] **W7** 404 line and footer sentence
- [ ] **W8** Portrait caption: where and when it was taken
- [ ] **W9** Notes #1, #2, #3 (400–600 words each; the two "Research focus" paragraphs on the CV are candidates) — *Phase 4*
- [ ] **W10** Outside work: six photographs and a sentence each (D8) — *Phase 4*
- [ ] **W11** Colophon — *Phase 4*

### Phase 1 — Repair · one weekend · Gate 1

| | Task | Owner | Req |
| --- | --- | --- | --- |
| [x] | 1.1 "Senior Manager, Biostatistics" on Home (the site description has no title in it; the CV already said it) | C | FR-1.1 |
| [x] | 1.2 Appearance follows the device: `respect-user-color-scheme: true` (Quarto 1.9.38 has it); dark remains the no-preference default (D6 assumed) | C | FR-1.2 |
| [x] | 1.3 Two `theme-color` tags, one per `prefers-color-scheme` | C | FR-1.3 |
| [x] | 1.4 Reduce Motion → `animation: none; transition: none` for everything | C | FR-1.4 |
| [x] | 1.5 Measure: **34rem, not 66ch** — in this sans `66ch` resolves to 707 px and 90 characters, so the cap is a `--measure` token (578 px, ≤ 73 chars) to retune when the serif lands. Audited Home, CV, Stuff, SingleBell, Workbench at 1440 px: no prose line over 75 | C | FR-1.5 |
| [x] | 1.6 Hero pills, footer links 44 px (measured 44–47) | C | FR-1.6 |
| [x] | 1.7 `$edge` token at chalk 38 % / graphite 50 %, on pills, cards, nav cards | C | FR-1.7 |
| [x] | 1.8 Grain at `z-index: -1` inside the body's stacking context: under content, over the ground | C | FR-1.8 |
| [x] | 1.9 `link-external-newwindow: false` | C | FR-1.9 |
| [x] | 1.10 Skip link: injected by `include-before-body`, moved to the top of `<body>` by the existing scroll-edge script (Quarto puts the include inside `main`); first Tab lands on it | C | FR-1.10 |
| [x] | 1.11 `canonical-url: true` | C | FR-1.11 |
| [x] | 1.12 `404.qmd` — title is the review's suggested line, body is only the link home; **W7 replaces it** | A→C | FR-1.12 |
| [x] | 1.13 `post-render.R`: AVIF + WebP (AVIF guarded by a capability check) at 1x/2x display widths, `<picture>` rewrite, `width`/`height`, lazy loading. SingleBell as served: 312 KB | C | FR-1.13, FR-1.14 |
| [x] | 1.14 `R/make_social_card.R` (ragg + magick, Palatino until Literata); Python file deleted | C | D5 |
| [x] | 1.15 `R/check_budgets.R` — gzip text + 1x images, exits 1 over budget | C | pre-mortem #4 |
| [ ] | 1.16 Lighthouse: no Node on this machine and the anonymous PageSpeed API quota was exhausted on 8 Oct. Run <https://pagespeed.web.dev/analysis?url=https%3A%2F%2Fstat-absk.github.io%2F> (and `/cv.html`, `/singlebell.html`) and record the scores below | A | Gate 1 |
| [x] | 1.17 Rendered, reviewed in preview, pushed with OK — `c701ef3`, 8 Oct 2026 | C | — |

**Gate 1 record:** accessibility ___ / ___ / ___ (pending 1.16) · SingleBell 312 KB as served (was ~6.3 MB) · longest prose line ≤ 73 chars · live 2026-10-08

*Deviations from the review in Phase 1:* the measure is a rem token, not `66ch` (see 1.5); the skip link needs two lines of the existing script, since Quarto offers no body-top include.

### Phase 2 — Type and voice · two weeks · Gate 2

| | Task | Owner | Req |
| --- | --- | --- | --- |
| [x] | 2.1 OFL licences for all three families fetched by `R/fetch_fonts.R` into `fonts/` (8 Oct 2026, download approved) | C | ADR-02 |
| [x] | 2.2 No subsetting tool needed: Google serves latin-subset variable WOFF2 — Literata roman 38 KB + italic 21 KB, Atkinson Next 33 KB, Mono 10 KB = **102 KB**, served from `/fonts/` | C | FR-2.1 |
| [~] | 2.3 `_fonts.scss` (`@font-face`, `font-display: swap`) written by the script; faces verified loading. Metric-matched fallbacks need the fonts' vertical metrics, which R cannot read from WOFF2 — **measure CLS on the live site; add `size-adjust` overrides only if it shows** | C | FR-2.1 |
| [x] | 2.4 `_type.scss`: seven steps (14/15/18/22/28/40/44–76), serif body 18 px, old-style figures in prose, lining tabular in labels and data; labels/nav/dates in the sans | C | FR-2.2 |
| [x] | 2.5 No uppercase; "On this page" sentence case; `text-wrap: balance` on headings, `pretty` on paragraphs | C | FR-2.3 |
| [x] | 2.6 `_signature.scss` → `_ground.scss` / `_type-rules.scss` / `_bands.scss` / `_pages.scss` (`_marks.scss` arrives in Phase 3). Rule order preserved within each file | C | review §Build |
| [ ] | 2.7 Wire W1–W3 into Home and CV when written | A→C | FR-2.4 |
| [x] | 2.8 `work.qmd` (Workbench, SingleBell) and `notes.qmd` (the decks, each with month, slide count, file size) replace `stuff.qmd`. The tab is "Work" as the review's bar names it; the page is titled Work, not Made. Descriptions are the existing ones — **W6 revises** | A→C (W6) | FR-2.7 |
| [x] | 2.9 Bar → Work · Notes · CV; About tab waits for W4 | C | FR-2.5, FR-2.6 |
| [~] | 2.10 Icons out of the bar; Scholar · GitHub · LinkedIn as words in the footer (every page) and already in the hero pills. **The icon font stays**: Quarto's own toggle and search button use it, so removing it is part of D9 | C | FR-2.5, D3 |
| [x] | 2.11 `stuff.html` → Notes via `aliases` (verified: lands on `/notes.html`) | C | ADR-06 |
| [x] | 2.12 Competency pills removed from the web CV | C | FR-2.8 |
| [ ] | 2.13 D7 Bangla name — if yes, Bengali subset and `lang="bn"` on About (waits for About, W4) | A→C | — |
| [ ] | 2.14 Cross-device check (iPhone, Windows, Android) — screenshots into this file | A | Gate 2 |
| [ ] | 2.15 Rendered and reviewed locally 8 Oct 2026; **awaiting push OK** | C | — |

*Deviations from the review in Phase 2:* the icon font remains (Quarto's toggle and search use it — folded into D9); fallback metric overrides deferred until CLS is measured; the tab is named Work rather than Made.

### Phase 3 — Signature · two to three weeks · Gate 3, in three pushable parts

**3a Material and marks**

| | Task | Owner | Req |
| --- | --- | --- | --- |
| [ ] | 3a.1 Tokens as CSS custom properties on `:root` | C | FR-3.7 |
| [ ] | 3a.2 Dark: slate `#131A17`, deep slate `#0C110F` for code and footer; dust surfaces | C | FR-3.6 |
| [ ] | 3a.3 Light: graphite on paper; marks thinner, unfiltered | C | FR-3.5 |
| [ ] | 3a.4 `marks/chalk.svg` sprite + one turbulence/displacement filter (< 15 KB) | C | FR-3.1, ADR-03 |
| [ ] | 3a.5 `_extensions/chalk/` Lua: `tally`, `rule` with accessible text | C | FR-3.2, FR-3.3 |
| [ ] | 3a.6 Favicon as one gate of five; social card from `R/make_social_card.R` | C | FR-3.10 |

**3b Rows, margin, motion**

| | Task | Owner | Req |
| --- | --- | --- | --- |
| [ ] | 3b.1 Remove every box: card borders/fills/lift/arrow, pill outlines, portrait ring and glow; three-radius system retired except images | C | FR-3.4 |
| [ ] | 3b.2 Listing rows on Made and Notes (reuse Sept prototype C) | C | FR-3.4, D10 |
| [ ] | 3b.3 Working margin: CV dates into the band's left column; margin-note component (folds under on phones) | C | review §Layout |
| [ ] | 3b.4 Content width 1180 px; three zones; spacing steps 48 / 72 / 112 | C | review §Grid |
| [ ] | 3b.5 Motion set: rule draws once on Home; appearance wipe; view-transition cross-fade; Reduce Motion → none | C | FR-3.9 |
| [ ] | 3b.6 Focus ring squared on inline text links | C | review §A11y |

**3c Home and figures** — *needs W1, W2, W5, W8*

| | Task | Owner | Req |
| --- | --- | --- | --- |
| [ ] | 3c.1 Home recomposed to the notebook layout; portrait 4:5 with caption; name up to 76 px fluid | A→C | FR-3.11 |
| [ ] | 3c.2 `R/theme_chalk.R` | C | FR-3.8 |
| [ ] | 3c.3 CV career strip (seven roles, 2011–now) | C | FR-3.8 |
| [ ] | 3c.4 CV papers by year, first-author marked; 15 papers as three tally gates; DOI links on all 15 | A→C (DOIs) | FR-3.8, FR-3.2 |
| [ ] | 3c.5 Workbench: four pills → one primary link + one sentence; chapters as a tally; screenshots via pipeline | C | review §Page by page |
| [ ] | 3c.6 SingleBell: store link as plain primary link; privacy policy to its own page with `#privacy` alias | C | review §Page by page |
| [ ] | 3c.7 Cover-the-name test with one person who knows you | A | Gate 3 |
| [ ] | 3c.8 Render, review, **ask before push** | C | — |

### Phase 4 — Depth · ongoing · Gate 4

| | Task | Owner | Req |
| --- | --- | --- | --- |
| [ ] | 4.1 Notes listing from `posts/`; RSS once W9 #1 exists | A→C | FR-4.1 |
| [ ] | 4.2 Outside work page (W10, D8) through the image pipeline | A→C | — |
| [ ] | 4.3 Colophon (W11) | A→C | — |
| [ ] | 4.4 `cv.qmd` Typst output; competencies in PDF only; print stylesheet for the web page | C | FR-4.2, ADR-08 |
| [ ] | 4.5 Deck theme + chalk extension published as a Quarto extension; installed in `enrollhd-getting-started` and `tufte-pharma`; decks rebuilt | C | FR-4.3, ADR-07 |
| [ ] | 4.6 GitHub Action: Lighthouse, link check, screenshots at 390 / 768 / 1440 in both appearances; fails on budget regression | C | FR-4.4 |
| [ ] | 4.7 "Last tended" date on every page | C | FR-4.5 |
| [ ] | 4.8 `Person` JSON-LD (name, role, employer, Scholar, GitHub, LinkedIn, ORCID if any) | A→C | FR-4.6 |
| [ ] | 4.9 Measure, then decide D9 (Bootstrap) | A | ADR-09 |

---

## 8. Out of scope

- An email address or contact form (D3).
- Hand-drawn chalk marks (D2) — may replace the sprite later without other change.
- Moving off Quarto (ADR-01); any Node or Python tooling (D5).
- Analytics of any kind.
- Any prose drafted by Claude (FR-2.4).

## 9. Log

| Date | Entry |
| --- | --- |
| 2026-10-08 | Review received. Decisions D1–D5 settled. Tracker created. Nothing pushed. |
| 2026-10-08 | Phase 1 built and verified locally (1.1–1.15). Planning Markdown excluded from the render (`project.render`). |
| 2026-10-08 | Phase 1 pushed live (`c701ef3`); live markup verified (pictures, skip link, canonical, theme-color, same-tab links). Lighthouse pending (1.16). |
| 2026-10-08 | Phase 2 technical half built and verified locally: fonts (102 KB), scale, SCSS split, Work/Notes pages, bar, footer words, competencies cut. Prose (W1–W6) and About still with Abhishek. Awaiting push. |
