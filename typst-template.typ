// The CV on paper, drawn the way the site is: pencil on paper. Graphite on the
// paper ground, Literata for reading and names, Atkinson Hyperlegible for
// labels and dates, the section name in the working margin beside its
// content, dates in the same margin, and one hand-drawn rule above each
// section. Nothing is boxed.

#let paper    = rgb("#F2F3EA")
#let graphite = rgb("#2A302D")
#let soft     = rgb("#2A302D").transparentize(28%)
#let faint    = rgb("#2A302D").transparentize(56%)
#let accent   = rgb("#6E5A16")
#let serif    = "Literata"
#let sans     = "Atkinson Hyperlegible Next"
#let margin-w = 3.9cm      // the working margin, left of the text column
#let margin-text-w = margin-w - 0.45cm   // what is written in it wraps before the text column

// A rule drawn by hand: one unhurried stroke, a little off true, from the
// margin's edge across the text. Neighbours never match.
#let rule-n = counter("chalk-rule")
#let chalk-rule() = {
  rule-n.step()
  context {
    let i = calc.rem(rule-n.get().first(), 4)
    let a = (1.1pt, -0.8pt, 0.6pt, -1.3pt).at(i)
    place(dx: -margin-w, dy: 0pt, curve(
      stroke: (paint: faint, thickness: 0.8pt, cap: "round"),
      curve.move((0pt, 0pt)),
      curve.cubic((70pt, a), (160pt, -a), (250pt, a * 0.4)),
      curve.cubic((330pt, -a), (410pt, a), (486pt, 0pt)),
    ))
  }
}

// A section: the rule, then the name set in the margin beside the content.
// The opening sticks to what follows, so a name is never left at a page's
// foot. Where the margin will also hold dates, the content starts a line
// lower, so the margin reads name, then dates.
#let section(name, dated: false) = {
  block(sticky: true, breakable: false, {
    v(1.1em)
    chalk-rule()
    v(1.0em)
    place(dx: -margin-w, dy: 0.05em,
      box(width: margin-text-w, par(leading: 0.45em, text(font: serif, size: 13pt, weight: 400, fill: graphite)[#name])))
    if dated { v(1.5em) }
  })
}

// A sub-section (a year under Publications): a quiet label in the sans.
#let sub(name) = {
  v(0.5em)
  text(font: sans, size: 8.5pt, fill: soft)[#name]
  v(0.1em)
}

// A date, set in the margin on the line it belongs to.
#let when(d) = box(width: 0pt, height: 0pt,
  place(dx: -margin-w, dy: -0.72em,
    box(width: margin-text-w, text(font: sans, size: 8pt, fill: soft, number-type: "lining")[#d])))

// The thing itself: semibold, so the entry reads first.
#let what(c) = text(weight: 600)[#c]

// One entry: a dated thing and its detail.
#let entry(body) = block(above: 0.5em, below: 0.9em, body)

// A count in gates of five: four uprights and the strike, drawn in graphite.
#let tally(n) = {
  let gates = ()
  let left = n
  while left > 0 { let k = calc.min(left, 5); gates.push(k); left -= k }
  let st = (paint: graphite, thickness: 1pt, cap: "round")
  box(baseline: 12%, stack(dir: ltr, spacing: 4.5pt, ..gates.map(k => {
    let w = calc.min(k, 4) * 4.4pt + 2pt
    box(width: w, height: 9pt, {
      for i in range(calc.min(k, 4)) {
        place(dx: i * 4.4pt + 1.4pt, dy: 0.4pt, line(start: (0pt, 0pt), end: (-0.4pt, 8.2pt), stroke: st))
      }
      if k == 5 { place(dx: 0pt, dy: 0pt, line(start: (0pt, 7.4pt), end: (w - 1pt, 1.6pt), stroke: st)) }
    })
  })))
}

#let cv(title: none, subtitle: none, body) = {
  set page(
    paper: "a4",
    fill: paper,
    margin: (left: 1.9cm + margin-w, right: 2cm, top: 2.2cm, bottom: 2.3cm),
    footer: context [
      #set text(font: sans, size: 7.5pt, fill: faint, number-type: "lining")
      #title · #subtitle #h(1fr) #counter(page).display()
    ],
  )
  set text(font: serif, size: 9.8pt, fill: graphite, number-type: "old-style")
  set par(justify: false, leading: 0.62em, spacing: 0.7em)
  set list(marker: box(baseline: -0.25em, circle(radius: 1.3pt, fill: faint)), indent: 0.1em, body-indent: 0.65em, spacing: 0.45em)
  show link: it => text(fill: accent, it)
  show strong: set text(weight: 600)

  // The opening: the name set large, the page's name under it in the sans.
  v(0.2cm)
  text(font: serif, size: 25pt, weight: 400, tracking: -0.012em, fill: graphite)[#title]
  v(0.25em)
  text(font: sans, size: 9.5pt, fill: soft)[#subtitle]
  v(1.1em)
  body
}
