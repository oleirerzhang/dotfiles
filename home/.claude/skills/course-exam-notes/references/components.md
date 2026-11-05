# Page components

Everything here is already styled by `assets/shell/00-head.html` (light and dark themes, mobile layout) and
wired up by `01-shell-top.html` / `99-shell-bottom.html`. Write plain HTML using these classes; do not add new CSS
unless a component is genuinely missing.

## Contents
1. Chapter skeleton and numbering
2. Text and boxes
3. Tables, equations, steps, flows
4. Figures: SVG and sequence diagrams
5. Self-checks, cards, tags
6. Interactive widgets (pattern + rules)
7. What the shell does automatically

## 1. Chapter skeleton and numbering

```html
<section class="chapter" id="w05" data-num="5" data-label="W5" data-short="Performance" data-group="Weeks 5–8">
  <div class="titleblock"><div class="tb-main"><div class="tb-kicker">Week 5 · Lecture 5</div>
    <h1>Title</h1><p class="tb-sub">One-line contents</p></div>
    <div class="tb-side"><div>Sheet</div><div>05</div></div></div>
  <p class="lede">…</p>
  <h2 id="w05-topic">…</h2>   <!-- auto-numbered "5.k" because data-num is numeric -->
  <h3>…</h3>                 <!-- never numbered -->
</section>
```

- Files: `10-home.html`, `11-w01.html` … `2x-wNN.html`, `30-review.html`, `31-formulas.html`, `32-glossary.html`.
  The build concatenates `src/[1-3]*.html` in sorted order, so the filename prefix controls chapter order.
- Every h2 gets an explicit, unique id with the chapter prefix (`w05-cache`). Ids must be unique across the whole
  site, including widget ids (a widget `w05-cache` and an h2 `w05-cache` will collide: name panes `w05p-*`).
- Section numbers come from position. Inserting an h2 renumbers everything after it in that chapter, and any prose
  "§5.7" or slide-table link text becomes wrong. When adding material late, add h3s inside existing h2s; or, if you
  must insert an h2, grep the whole src for `§N.` references and fix them.
- Chapter-level links: `href="#w05"`. Section links: `href="#w05-cache"`.

## 2. Text and boxes

- `<p class="lede">` chapter opening paragraph. `<dfn>` for a term at its defining use.
- `<span class="m">` inline maths/variables; `<code>` for code and identifiers.
- Boxes: `<div class="box KIND" data-label="optional custom label">…</div>`, KIND is one of
  - `def` definition · `key` must-remember idea · `ex` worked example · `warn` common mistake / confusing pair
  - `note` background/history (lower exam priority) · `exam` how it is examined · `ok` a positive tip
  - `read` "Further reading in your textbooks" (chapter + section pointers)
- Custom label example: `<div class="box ex" data-label="Worked example · Tutorial 5, question 3">`.

## 3. Tables, equations, steps, flows

```html
<div class="tw"><table><thead><tr><th>…</th></tr></thead><tbody><tr><td>…</td></tr></tbody></table></div>
<div class="eq">X = N / R <span class="lbl">Little's law</span></div>
<div class="step"><b>Step 1</b><div>…</div></div>
<div class="flow"><span class="nd acc">Client<small>browser</small></span><span class="ar">→</span><span class="nd">Server</span></div>
```
Key-terms table (feeds the site-wide glossary automatically):
```html
<div class="tw"><table class="glossary"><thead><tr><th>Term</th><th>Meaning</th></tr></thead><tbody>
<tr><td>Throughput</td><td>Completed requests per unit time.</td></tr></tbody></table></div>
```

## 4. Figures

Hand-drawn SVG (auto-captioned "Figure N.k"):
```html
<figure class="fig"><div class="canvas"><svg viewBox="0 0 640 220" role="img" aria-label="…">
  <rect class="bx" x="20" y="20" width="140" height="50" rx="6"/><text class="t-m" x="90" y="50" text-anchor="middle">Client</text>
  <line class="ln" x1="160" y1="45" x2="300" y2="45" marker-end="url(#ah)"/>
</svg></div><figcaption>What it shows.</figcaption></figure>
```
SVG classes: boxes `bx bx2 bx-acc bx-ok bx-bad bx-warn`; lines `ln ln-mute ln-acc ln-bad ln-ok grid`;
text `t-s t-m t-l t-mono t-mute t-acc t-bad t-ok t-warn`; fills `fill-acc` etc.; arrowheads
`marker-end="url(#ah|ah-acc|ah-bad|ah-ok|ah-mute)"`. Use classes, never hard-coded colours, so dark mode works.
On phones the canvas scrolls horizontally (`min-width:540px`), so keep viewBoxes ≤ ~700 wide.

Sequence diagrams are written as text and drawn by the shell:
```html
<figure class="fig"><pre class="seq" data-actors="Client|Payment service|Bank">
== Phase 1
Client -> Payment service : charge $100, key K42
Payment service => Bank : debit
Bank --> Payment service : ok
Payment service -x Client : reply lost
note Client : timeout, retry with K42
log Payment service : K42 already done → return stored result
crash Bank : power loss
gap
</pre><figcaption>…</figcaption></figure>
```
Arrows: `->` solid, `=>` accent, `-->` dashed reply, `~>` red/failure, `-x` lost. The separator is " : "
(space colon space); actor names may contain spaces and must match `data-actors` exactly.

## 5. Self-checks, cards, tags

```html
<p class="checks-h">Check yourself</p>
<details class="check"><summary>Question?</summary><div><p>Answer with reasoning.</p></div></details>
<div class="grid2"><a class="card" href="#w01"><span class="k">Week 1</span><b>Title</b><span>Blurb</span></a></div>
<span class="tag y">yes</span> <span class="tag n">no</span> <span class="tag w">sometimes</span>
```

## 6. Interactive widgets

Add one only where changing a number or a choice and watching the result teaches more than prose:
simulators of interleavings/protocols, calculators for the course's formulas, plotters of curves, "follow the links"
walkthroughs. Typically 0–2 per chapter; most chapters need none. Each widget must also be explained in prose
(the exam is on paper).

```html
<div class="widget" id="w08-calc">
  <div class="w-head"><span>Interactive</span><b>Little's law calculator</b></div>
  <div class="w-body">
    <div class="w-row"><label>Throughput X (req/s) <input type="number" id="w08x" value="50" min="0" step="1"></label>
                       <label>Response time R (s) <input type="number" id="w08r" value="0.2" min="0" step="0.01"></label></div>
    <div class="w-out" id="w08out"></div>
  </div>
</div>
<script>
(function(){
  const $=id=>document.getElementById(id), v=id=>parseFloat($(id).value)||0;
  function go(){ const X=v('w08x'), R=v('w08r');
    $('w08out').innerHTML = `N = X × R = ${N.fmt(X)} × ${N.fmt(R)} = <b>${N.fmt(X*R)}</b> requests in the system`; }
  ['w08x','w08r'].forEach(id=>$(id).addEventListener('input',go)); go();
})();
</script>
```
Rules: wrap each script in an IIFE; prefix every id with the chapter; show the formula with the numbers
substituted (so it teaches the method); use `N.fmt(x,d)`, `N.pct(x,d)`, `N.esc(s)`, and `N.el(tag,attrs,text)` for SVG.
Segmented buttons: `<div class="seg"><button class="on">A</button><button>B</button></div>`; status pills
`<span class="pill ok|bad|warn|acc">`. Wrap any `localStorage` use in try/catch.

## 7. What the shell does automatically

- Hash router: one chapter visible at a time; `#w05` opens a chapter, `#w05-cache` opens the chapter and scrolls.
- Contents rail grouped by `data-group`, with each chapter's h2 list; ticks for chapters marked revised.
- h2 and figure numbering; chapter footers with prev/next and "Mark as revised".
- Theme buttons (system/light/dark), stored per viewer.
- Glossary chapter built from every `table.glossary`, searchable.
- `98-explain.html`: highlight any text → "Explain this" → a quick streamed explanation from Claude with
  "simpler / example / exam angle" follow-ups. Works only in the published artifact with the `sample` capability;
  Beside the button is a box for a custom request about the highlighted text (e.g. "suggest a section title for these points"). Each explanation is saved in the viewer's browser (localStorage, last 300): the highlighted text gets a dotted underline and a small marker that reopens it without a model call; the card has a Delete button. Markers are re-anchored after a reload by searching for the saved text in its chapter, so heavy edits to a passage can orphan its marker (harmless; it just disappears). It hides itself when opened as a local file.
