# stat-absk.github.io — Upgrade Plan

Oct 8, 2026 · @Abhishek

## The short version

The site is already more considered than most personal sites, so this plan builds on its foundation instead of replacing it. What it lacks is a signature that is yours, not SingleBell's, and a home page that sounds like you.

I reviewed the live pages, the full source in your repository, and local renders at 390 px and 1440 px. Three moves do most of the work:

1. **A signature you can see: counted by hand.** Real chalk marks, drawn by you and traced to SVG, become the site's rules, tallies and favicon. Today "chalk on slate" lives in the code comments; on screen it is a dark page with one yellow accent.
2. **Typefaces you own.** The site uses system fonts, so it is New York on your iPhone and Georgia or Noto Serif everywhere else. Two self-hosted families make it the same site on every device.
3. **Your voice on the front door.** The SingleBell page is plain, exact and dry. The home page says "Biostatistics leader". The first should rewrite the second.

Around those sit the measurable fixes: lines that run to 90 characters, 6.1 MB of screenshots on one page, a site that ignores the reader's light or dark setting, and no way to write to you.

## Where the site stands

The system underneath is sound; the problems are in what a visitor sees and reads in the first ten seconds.

### What already works

- **A documented system.** Five colours, four text strengths, six sizes, three radii and two durations, each with its reason written beside it in the SCSS.
- **Text contrast passes everywhere I measured.** Dark: 14.1, 9.0 and 5.7 to 1. Light: 13.8, 9.3 and 6.6 to 1. The accent is 12.8 on slate and 6.0 on paper.
- **Real ideas in the layout.** The section name held in a left column, and the large name collapsing into the bar as it scrolls away, are both worth keeping.
- **Care for settings most sites ignore.** Reduce Transparency and Increase Contrast are both answered, and keyboard focus is always visible.
- **The SingleBell page.** It is the best writing on the site and the model for everything else.
- **Nothing is tracked.** I found no analytics or third-party scripts in the built pages.

### What falls short

| Finding | Evidence | Weight |
| --- | --- | --- |
| The signature is borrowed and mostly invisible | The palette and rules are transcribed from SingleBell's Theme.swift. Nothing on screen is drawn or chalked. A dark ground, one yellow accent, rounded cards and pill links is a common look. | High |
| The type is not yours | `ui-serif` and `system-ui` resolve to New York and SF on Apple, Georgia or Noto Serif and Roboto elsewhere. | High |
| The home page speaks in recruiter language | "Biostatistics leader" appears on Home, in the page description and in the CV profile. Compare "The absence is the point" on the SingleBell page. | High |
| Lines are too long to read comfortably | Paragraphs are capped at 46rem. At 17 px sans that is 88 to 95 characters; 60 to 70 is the comfortable range. | High |
| The home screen falls apart at desktop width | At 1440 px the text ends near 550 px and the portrait sits 300 px away at the far edge. The name tops out at 44 px on a full-viewport screen. | High |
| Facts disagree | Home says Associate Director. The CV says Senior Manager, Associate Director-equivalent. | High |
| No way to write to you | No email or contact line anywhere; LinkedIn is the only route. | High |
| The SingleBell page is heavy | Seven phone screenshots total 6.1 MB as PNG and display 200 px wide. The 256 px app icon is 295 KB. Nothing is lazy-loaded. | High |
| The site always opens dark | It ignores the reader's light or dark setting, and the browser-chrome colour stays dark in light mode. | Medium |
| Motion is the default kind | A page rise, a staggered hero rise and a card lift on hover. Reduce Motion shortens these to 200 ms instead of removing them. | Medium |
| Card grids flatten everything | Home's four doors and the Stuff page are identical rounded boxes. Stuff cards hold 60 to 130 words at 15 px with ragged heights. | Medium |
| Controls are faint and small | Pill and card edges are 1.4 to 1 against slate. Hero pills are about 36 px tall; 44 px is the touch minimum. | Medium |
| The human side is missing | No About, no writing (the `posts/` folder is set up and empty), nothing from outside work. | Medium |
| Publications are not linked | Fifteen papers, no DOI or journal links. | Medium |
| Framework weight | Two Bootstrap stylesheets at 512 KB each (71 KB compressed), a 180 KB icon font for three icons, 13 scripts. | Low |
| Grain sits on top of everything | The texture overlay is at z-index 9999, so it dusts the portrait and screenshots as well as the ground. | Low |
| Small navigation gaps | Workbench and SingleBell are missing from the top bar. The name truncates on phones. External links open new tabs unannounced. There is no 404 page. | Low |

## The signature: counted by hand

Every structural mark on the site is one a hand made, and a mark appears only where something is counted, measured or begun.

The idea comes from three things that are already true of you. A statistician is someone who counts carefully. Chalk is the tool in both your practices: on the slate in the app, and on the hands before a lift. And SingleBell already counts the week in seven tally strokes. The tally is where your work, your app and your practice meet, and no other statistician's site has it.

### The four devices

| Device | What it is | Where it appears | Where it never appears |
| --- | --- | --- | --- |
| The tally | Hand-drawn strokes in gates of five. The one bold element. | Real counts under about 25: the 15 papers, years in a role, chapters in the Workbench. The favicon becomes one gate of five. | As decoration, as a bullet, or beside anything that is not a count. |
| The chalk rule | One long stroke that opens a section, chosen from a set of eight so neighbours never match. | Above each band, under the name on Home. | Around boxes. Nothing is boxed. |
| The working margin | The left column that now holds only a section name. | Dates, short notes, small figures, captions. | Empty. |
| The figure | Your own plots in one ggplot theme, `theme_chalk()`. | A career strip on the CV, papers by year, anything in a note or a deck. | Stock charts or icons standing in for data. |

### Making the marks

Draw them with real chalk on a real slate, photograph them in daylight, and trace them to SVG. It is an hour of work and it is the most human thing on the site.

- [ ] Eight rules, each a single unhurried stroke about 30 cm long
- [ ] Five upright tally strokes and two strike-throughs
- [ ] One underline and one loose circle, for marking a word or a point
- [ ] Trace in Inkscape, simplify paths, save as one SVG sprite under 15 KB

If drawing them is not possible, straight SVG strokes roughened with a turbulence filter are the fallback. They read as chalk but they are not yours.

### What leaves, so the signature stands alone

Boldness is spent in one place, so everything around the marks goes quiet.

- Pill outlines on links and competencies
- Card boxes, their hover lift and the arrow that fades in
- The circular portrait with its ring and glow
- Middle dots in the footer and the uppercase label above the contents list
- The three-radius system: marks have no radius, and only images keep one

### The test

Cover the name and the portrait. If someone who knows you could still say whose site it is, the signature is working.

## Typography

Two self-hosted families replace the system stacks, and the reading text moves from sans to serif.

### The faces

| Job | Face | Why this one |
| --- | --- | --- |
| Reading text and names | Literata, variable with optical sizes | Low contrast and sturdy serifs. Chalk cannot draw a hairline, and thin strokes break up on a dark ground. Warm italics, old-style figures. |
| Labels, dates, data, navigation | Atkinson Hyperlegible Next | Drawn so that no two characters can be mistaken: I, l and 1; O and 0. That is a statistician's value, set in type. |
| Code and R output | Atkinson Hyperlegible Mono | The same skeleton as the labels, so code sits in the page instead of interrupting it. |

All three are under the Open Font License; confirm the current licence files before hosting them. Serve them as subset WOFF2 from your own repository, with `font-display: swap` and fallback metrics matched so nothing shifts. The budget is 200 KB for all fonts; if the variable Literata exceeds it, use three static cuts instead.

One optional touch: your name set once in Bangla beneath the Latin, on the About page only. It needs a few glyphs of a Bengali serif and a `lang="bn"` attribute.

### The scale

The current six sizes come from the app, where text is glanced at from the floor mid-set. A page is read at arm's length for minutes, so it needs a larger body and a wider range.

| Step | Now | Proposed | Used for |
| --- | --- | --- | --- |
| Caption | 12 px | 14 px | Dates, captions, margin notes |
| Label | 15 px | 15 px | Navigation, table heads, figure labels |
| Body | 17 px sans | 18 px serif | All reading text, line height 1.6 |
| Lead | 22 px | 22 px | One opening paragraph per page |
| Section | 22 px | 28 px | Section names |
| Page | 28 to 30 px | 40 px | Page names |
| Display | 32 to 44 px | 44 to 76 px, fluid | The home opening only |

### The rules

- **Measure.** Reading text is capped at 66ch, about 65 characters. This replaces the 46rem cap.
- **Figures.** Old-style in prose, lining and tabular in dates, tables and figures.
- **Emphasis.** Italic, not bold. Names stay in the serif at regular weight, as they are now.
- **Acronyms.** FDA, NDA, BLA and RWE in small capitals if the cut has them; otherwise leave them alone.
- **Wrapping.** `text-wrap: balance` on headings, `pretty` on paragraphs, hanging punctuation where supported.
- **Tracking.** No negative tracking below 28 px on the dark ground; light text on dark needs the room.
- **Case.** No uppercase anywhere. "On this page" becomes sentence case at label size.

## Colour and material

The palette keeps its lineage and changes little; the work is making the material true, so slate looks like slate and paper like paper.

### Dark: chalk on slate

| Name | Value | Job | Change |
| --- | --- | --- | --- |
| Slate | `#131A17` | The ground | Lifted from `#0E1412`. Near-black hides grain and dust; real slate is grey-green. |
| Deep slate | `#0C110F` | Recessed areas: code blocks, the footer | New. Code currently sits on a lighter surface, which reads as raised. |
| Chalk | `#F2F3EA` | All writing, at four strengths | Unchanged. On the new slate: 13.5, 8.6 and 5.5 to 1. |
| Yellow chalk | `#E9D592` | Links and the one primary action | Unchanged. 12.1 to 1. Still means "go" and nothing else. |
| Dust | Chalk at 6 to 10% | A soft smudge behind a figure or a quoted block | New. Replaces card borders and fills. |
| Work and rest | From Theme.swift | Data only: two series in a figure | New to the site. The app's phase green and blue, softened to chalk. Never used in the interface. |

### Light: pencil on paper

The light theme is currently the dark one inverted. Give it its own honest material: pencil is to paper what chalk is to slate, a mark a hand makes and can rub out.

- **Paper** stays `#F2F3EA`. Its faint green keeps it away from the cream that every other site uses.
- **Graphite** `#2A302D` replaces inverted slate as the writing colour. It is 12.1 to 1, softer than ink and still well past AAA.
- **The accent** stays `#6E5A16` at 6.0 to 1. The reasoning in your SCSS for pressing the yellow down is right.
- **Marks** use the same traced strokes, drawn thinner and without the chalk roughening.

### Material rules

- **Grain belongs to the ground.** Move it from the overlay at z-index 9999 to the body background, so photographs and screenshots stay clean.
- **Photographs carry the colour.** The painted wall behind your portrait is the only saturated colour on the site. Keep it that way: the interface stays chalk, the pictures are the world.
- **Edges you need to see reach 3 to 1.** A control's edge is chalk at 38% on slate (3.3 to 1) or graphite at 50% on paper (3.4 to 1). The 12% rule stays for lines that only decorate.
- **The reader's setting wins.** The site opens in whichever appearance the device asks for, and the toggle overrides it.

## Layout and rhythm

The band layout stays and its left column is put to work; the page narrows so compositions hold together at any width.

### The grid

- **Width.** Content is capped at 1180 px, down from a 1600 px body. Beyond that the slate is simply slate.
- **Three zones.** A margin of about 220 px, a text column at the 66ch measure, and an aside for figures and photographs.
- **Alignment.** Everything is left-aligned to the text column's edge. Nothing is centred except the footer line.
- **Air.** The spacing scale gains three large steps, 48, 72 and 112 px, for the space between sections. The existing 4 to 32 px steps stay for space within them.

### The home page

The current first screen is a name, a tagline, four pills, a far-off portrait and four cards. The new one opens with a sentence in your voice, set large, and reads down like the first page of a notebook.

```
  AB                                    Work   Notes   CV   About


  margin          text                                 aside
  ------          ----                                 -----

                  I'm Abhishek. I work out what        +----------+
                  a clinical trial can                 |          |
                  honestly claim.                      | portrait |
                                                       |   4:5    |
                  ~~~~~~~~~~ chalk rule ~~~~~~~~~      |          |
                                                       +----------+
                  Three or four sentences: where       Where and when
                  you work, where you came from,       it was taken
                  what holds your attention.

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Now             One paragraph, dated.
                  Replaced, not added to.

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Made            Workbench     Practice trial design on rpact
                  SingleBell    One bell, nothing collected

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Written         date          Enroll-HD for statisticians
                  date          Tufte for pharma

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Elsewhere       Email, Scholar, GitHub, LinkedIn, as a sentence
```

### Changes that follow from the grid

- **Cards become ruled rows.** A name on the left, one line on the right, the whole row a link. This covers Home's four doors and everything on Stuff.
- **The portrait becomes a 4:5 rectangle.** Larger, with the painted wall showing, a 6 px corner, no ring and no glow. A caption says where it was taken.
- **CV dates move into the margin.** Today the CV nests an 11.5rem date column inside the band's 11rem label column. One margin does both jobs.
- **Margin notes.** A short aside sits beside the paragraph it belongs to, at caption size. On phones it folds in below the paragraph, indented.
- **The footer is one sentence.** For example: "Abhishek Bhattacharjee, 2026. Made with Quarto. This site collects nothing."
- **Phones.** One column. The bar shows the AB mark and a menu, so the name is never cut off.

## Motion and interaction

Each page gets at most one authored moment; every other movement answers something the reader did.

| Moment | Trigger | What happens | Length |
| --- | --- | --- | --- |
| Arrival | First visit to Home in a session | The chalk rule under the opening sentence draws left to right, once. | 600 ms |
| Changing appearance | The light and dark toggle | A duster wipe: the new appearance sweeps across from the left. | 350 ms |
| Changing page | Any internal link | A cross-fade, with the bar held still. Browsers without view transitions change pages as they do now. | 200 ms |
| Hovering a link | Pointer over a link | The underline firms from 40% to full. This exists today; keep it. | 250 ms |
| Pressing | Pointer or finger down | The link dims to 70%. This exists today; keep it. | Instant |

### What is removed

- The rise on every page load
- The staggered rise of the hero's pieces and the four cards
- The card lift on hover and the arrow that fades in beside the name

### Calm by default

- **Reduce Motion means none.** The arrival stroke is simply there, the wipe is a cut, the page change is instant. Today these are shortened to 200 ms, and the hero pieces still slide.
- **Nothing moves on scroll.** No reveals, no parallax, no progress bar. The sticky section name is the only thing that tracks the reader.
- **Nothing asks for attention.** No pop-ups, banners or badges. The site has no cookies to ask about; it stores only the appearance choice.
- **Links stay in the tab.** External links stop opening new windows, so the back button always works and the reader decides.
- **The existing tokens stay.** `--settle` at 350 ms, `--snap` at 250 ms and the one easing curve already cover everything above.

## Voice and content

Write the whole site the way you wrote the SingleBell page: first person, plain verbs, exact numbers, and honest about what a thing does not do.

### Rewrites

The right-hand column is a direction, built only from facts already on your site. The final words should be yours.

| Where | Now | Direction |
| --- | --- | --- |
| Home, opening line | "Biostatistics leader — clinical development strategy, regulatory science, real-world evidence." | "I'm Abhishek. I work out what a clinical trial can honestly claim." |
| Home, paragraph | "Associate Director, Biostatistics at Pfizer in Chennai, leading a team of statisticians across therapeutic areas." | "I lead a group of statisticians at Pfizer in Chennai. Before that I reviewed cancer drug applications at the FDA, which is where I learned how evidence gets argued over." |
| CV, profile | "Biostatistics leader pairing hands-on industry development and FDA regulatory experience across the drug-development lifecycle…" | Three plain sentences: what you do now, what you did at the FDA, what you are working towards. |
| CV, core competencies | Twelve keyword pills | Cut. The experience entries already show each one. If a recruiter-facing list is needed, keep it in the PDF only. |
| Stuff, each card | One paragraph of up to 130 words, opening with a dash | One line on the listing row. The detail moves to the thing's own page. |
| Link labels | "Everything else, on Stuff →" | "All notes and talks". No arrows; the underline already says it is a link. |

### Pages to add

| Page | What it holds | Why |
| --- | --- | --- |
| About | The route your CV traces: Calcutta, Pune, Gainesville, Greeley, Jacksonville, Silver Spring, Chennai. Why statistics. What reviewing taught you. | The story is on the CV as dates. Told as a story it is the most human page you could have. |
| Now | One dated paragraph on what you are working on and reading. Replaced each time, never appended. | Small, honest and easy to keep current. |
| Notes | Short pieces of 400 to 600 words. The `posts/` folder is already configured. | Your "Research focus" paragraph on the CV holds two notes waiting to be written. |
| Outside work | A few photographs, places, and the kettlebell practice, each with a sentence. | It shows the person. Six good pictures beat sixty. |
| Colophon | The typefaces, how the chalk marks were made, and what the site collects: nothing. | It explains the signature once, so the rest of the site never has to. |

### Details worth their own line

- **Papers 9, 11 and 12.** Soil carbon under coffee agroforestry, and laser acupuncture for stressed horses. These are the most disarming facts on the site and they are buried. One sentence on About: a statistician works on whatever needs counting.
- **A way to reach you.** Add an email address or a plain "Write to me" line on Home and About.
- **One title, one city.** Settle Associate Director versus Senior Manager, and use the same words on Home, the CV and the page description.
- **"Stuff" as a name.** It is modest and human, but it hides two different things. Split it into Made (Workbench, SingleBell) and Notes (talks, write-ups).
- **Honest sizes.** The two decks are 4.6 MB and 6.9 MB. Say so beside the link.
- **Last tended.** A quiet date at the foot of each page, so a reader knows how fresh it is.

## Page by page

Home and the CV change most; the SingleBell page changes least, because it is already the standard the others are being raised to.

| Page | Keep | Change |
| --- | --- | --- |
| Home | The name collapsing into the bar. The Latest list. The disclaimer. | Open with a sentence instead of a title and tagline. Portrait as a 4:5 rectangle. Four cards become the Made and Written rows. Add Now and a contact line. Name set at up to 76 px. |
| CV | The date, role and detail structure. Names in serif. The research-focus paragraph. | Dates into the margin. A career strip above Experience: seven roles on one time axis, 2011 to now. Papers grouped by year with DOI links, and the count of 15 as three tally gates. Competency pills cut. A typeset PDF from the same source. A print stylesheet. |
| Stuff | The four things and their descriptions. | Split into Made and Notes. Boxes become ruled rows with one line each. Each deck gets its date, length and file size. |
| Workbench | Both screenshots and their captions. The "What it is, and isn't" section. | Four link pills become one primary link and one sentence holding the other three. Workbench chapters counted as a tally. Screenshots served as AVIF. |
| SingleBell | Nearly all of it: the writing, the floated screenshots, the "deliberately doesn't do" section. | Screenshots from 6.1 MB to under 400 KB, lazy-loaded. The store link becomes a plain primary link. The privacy policy moves to its own address, with the old `#privacy` anchor still landing there. |
| Slide decks | The shared reveal.js theme. | The same typefaces and chalk rules as the site. The theme installed as an extension instead of copied by hand into each deck's repository. |
| About, Now, Notes, Outside work, Colophon | New | See Voice and content. |
| 404 | New | One line in the site's voice, for example "Nothing is written here", and the way home. |

### Navigation

The bar becomes Work, Notes, CV and About. Work holds the Workbench and SingleBell, which today are reachable only from Home's cards and the footer. The three social icons leave the bar and become words in the Elsewhere line; that also removes the 180 KB icon font.

### Two figures for the CV

Both are drawn in R at render time with `theme_chalk()` and take their colours from the page, so they follow the light and dark setting.

- **The career strip.** One horizontal bar per role, 2011 to now, labelled directly, with university, regulator and industry told apart by position, not colour. It turns seven dated entries into something read at a glance.
- **Papers by year.** One dot per paper from 2017 to 2026, first-author papers marked with the chalk circle. It sits in the margin beside the publication list.

## Accessibility and performance

Text contrast already passes; the gaps are in settings the site does not yet honour and in page weight.

### Accessibility

| Item | Now | Target |
| --- | --- | --- |
| Light or dark on arrival | Always dark | Follows the device. Quarto's `respect-user-color-scheme` option does this; check it against your version, 1.9. |
| Browser-chrome colour | Fixed at `#0E1412` | Two `theme-color` tags, one per appearance. |
| Reduce Motion | Animations shortened to 200 ms | No animation at all. |
| Skip link | I found none in the built pages | "Skip to content" as the first focusable element. |
| Touch targets | Hero pills about 36 px tall; footer links smaller | 44 px minimum on anything tappable. |
| Control edges | 1.4 to 1 | 3 to 1 or better. |
| External links | Open a new window with no warning | Open in the same tab. |
| Tallies and figures | Not yet built | Each tally carries its number as text; strokes are hidden from screen readers. Each figure has a one-sentence summary. |
| Focus ring | 12 px corner on everything, including text links | Keep the 2 px accent ring; square it on inline text. |
| Zoom | Untested | No loss of content at 200% and 400%, on both appearances. |

### Performance

| Item | Now | Target |
| --- | --- | --- |
| SingleBell screenshots | 6.1 MB across seven PNGs | Under 400 KB as AVIF with a WebP fallback, at two widths, lazy-loaded, with width and height set. |
| SingleBell app icon | 295 KB for 256 px | Under 20 KB. |
| Portrait | 151 KB at 800 px, shown at up to 272 px | Two sizes, 40 KB at most, with width and height set. |
| Fonts | None loaded | 200 KB at most, after first paint. |
| Icon font | 180 KB for three icons | Removed. |
| Stylesheets | Two Bootstrap files, 71 KB each compressed | Decide in the last phase: keep, or replace with one sheet under 40 KB. |
| Scripts | 13 files | Four or fewer if Bootstrap goes. |
| Slide decks | 4.6 MB and 6.9 MB, self-contained | Unchanged, with the size stated beside each link. |
| Home, first load | Not measured on a real connection | Largest paint under 1.5 s on 4G, zero layout shift. |

### Being found

- A canonical address on every page
- A `Person` record in JSON-LD: name, role, employer, and links to Scholar, GitHub, LinkedIn and ORCID if you have one
- A 1200 by 630 social card in the signature, replacing the square portrait now used for large-card previews
- An RSS feed once Notes has its first piece

## Build

Stay on Quarto and GitHub Pages. R is where you work, the figures in this plan are ggplot figures, and nothing here needs a different framework.

### New pieces

| Piece | Where it lives | What it does |
| --- | --- | --- |
| The marks | `marks/chalk.svg` | One sprite holding the traced rules, strokes, circle and underline. |
| Shortcodes | `_extensions/chalk/` | A small Lua filter: `{{< tally 15 >}}` writes gates of five with the number as text; `{{< rule >}}` picks the next stroke from the set. |
| Plot theme | `R/theme_chalk.R` | One ggplot theme and palette for the site, the decks and anything else you publish. |
| Fonts | `fonts/` | Subset WOFF2 files and their `@font-face` rules. |
| Image step | `post-render.R` | Writes AVIF and WebP at two widths for every image, so originals stay untouched in the repository. |
| CV as PDF | `cv.qmd` | A second output format, Typst, so the web page and the PDF come from one source. |

### Changes to what exists

- **Split `_signature.scss`.** It is 800 lines. Break it into ground, type, marks, bands and pages, so each file answers one question.
- **Tokens as custom properties.** Expose the colours as CSS variables on `:root`. Inline SVG figures then take `currentColor` and the variables, and follow the appearance without a second render.
- **Chalk texture as a filter.** One SVG turbulence-and-displacement filter, defined once and applied only to the marks. They are small and static, so the cost is negligible.
- **`_type.scss`.** The two system stacks become fallbacks behind the new families; the six sizes become the seven in this plan.
- **`_quarto.yml`.** Body width down from 1600 px. `link-external-newwindow` off. The navigation described above. The appearance follows the device.
- **The deck theme.** `_signature-reveal.scss` is copied by hand into each deck's repository today, as your README notes. Publish it as a Quarto extension and install it in each deck, so there is one source.

### Checks on every push

A GitHub Action that runs after render and fails the build on a regression:

- Lighthouse on Home, CV and SingleBell, for accessibility and weight against the budgets above
- A link checker across the built site
- Screenshots at 390, 768 and 1440 px in both appearances, kept as artefacts to look through

### One decision to leave for last

Dropping Bootstrap would cut most of the remaining weight, but Quarto's bar, search and contents list depend on it. Do the first three phases on the current framework, measure, and only then decide. If you ever outgrow Quarto, Astro is the natural next home; nothing in this plan would be wasted by that move.

## Roadmap

Four phases, each shippable on its own, ordered so the fixes nobody can argue with land first and the signature lands on a site that already reads well. The sizes are my rough estimates for evening and weekend work.

| Phase | Work | Done when | Rough size |
| --- | --- | --- | --- |
| 1. Repair | One title and city everywhere. A contact line. Appearance follows the device. Reduce Motion means none. Measure capped at 66ch. Screenshots and portrait compressed. Targets at 44 px, control edges at 3 to 1. Grain under the content. Links stay in the tab. Skip link, canonical, 404. | Lighthouse accessibility is 100 on every page. The SingleBell page is under 1 MB. No line of prose passes 75 characters. | One weekend |
| 2. Type and voice | Fonts hosted and wired in. The new scale. Home and the CV profile rewritten. About and Now written. Stuff split into Made and Notes. Navigation changed. | The site looks the same on an iPhone, a Windows laptop and an Android phone. A friend reads Home aloud and it sounds like you. | Two weeks |
| 3. Signature | Marks drawn and traced. Tally and rule shortcodes. Working margin. Home recomposed. Cards to ruled rows. Light appearance as pencil on paper. `theme_chalk()`, the career strip and papers by year. The motion set. Favicon and social card. | The cover-the-name test passes. Nothing on any page is boxed. | Two to three weeks |
| 4. Depth | First three notes. Outside work. Colophon. CV as PDF. Deck theme as an extension. Checks on every push. The Bootstrap decision. | Notes has an RSS feed with three pieces in it. Both decks match the site. | Ongoing |

### Decisions I need from you

- [ ] Which title is current: Associate Director, or Senior Manager?
- [ ] Will you draw the chalk marks yourself, or should the fallback filter stand in?
- [ ] Should the site still open dark for readers whose device has no preference?
- [ ] Is your name in Bangla on the About page something you want?
- [ ] Which six photographs would you put on the Outside work page?

### What I would not change

The restraint. One accent that means one thing, no exclamation marks, nothing collected, reasons written beside every value in the code. The plan adds a hand to the site; it should not add noise.
