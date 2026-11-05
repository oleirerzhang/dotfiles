---
name: course-exam-notes
description: Turn a university course's materials (lecture slides, tutorials, labs, lecture notes, review lecture) plus reference textbooks into a complete, textbook-style exam study site, as one interactive HTML page with chapters per week, worked examples, self-checks, a slide-by-slide recap, a searchable glossary, a formula sheet, a few interactive models, and a highlight-to-explain button powered by Claude. Use this whenever someone wants study notes, revision notes, exam notes, a study guide or a "textbook" built from their course files or lecture slides, wants their lecture PDFs "elaborated" or "explained", or points at a folder of course materials and asks for help preparing for an exam, even if they don't say "HTML" or "site". Also use it to extend or improve notes previously made this way.
---

# Course exam notes

Build a study site that reads like a good textbook written specifically for one course: every slide fact covered
and explained, background and history supplied, every term defined, and lots of worked examples, so the student can learn
the course from the notes alone and walk into the exam confident.

The bundled shell (layout, themes, navigation, glossary, numbering, explainer) is finished and tested. Your work
is the content, which is where nearly all the effort should go.

## What the user should provide

If any of these are missing, ask once, then proceed with what you have:

1. **A course folder** (required), ideally organised by week, for example:
   ```
   COMP1234/
     W01/  lecture slides (PDF/PPTX), lecture notes, tutorial sheet, tutorial solutions, lab code
     W02/  …
     review/  the revision lecture, past/sample exams, exam-format slides
     outline.pdf   the unit outline (assessment, exam rules, learning outcomes)
   ```
   Solutions, sample exams and the review lecture are especially valuable: they show what is examined and how.
2. **Reference textbooks** (optional, recommended): PDFs of the prescribed and recommended books, in a `textbooks/`
   subfolder or attached. They provide depth and context; the notes cite them and do not copy them.
3. **Facts about the exam**, if not in the files: date, length, open/closed book, cheat-sheet rules, question types.
4. **Preferences**: course name and code for the title; anything the lecturer emphasised ("everything on the slides
   is examinable", "no calculators", "focus on weeks 6–12").

If the course folder is an existing directory on this machine, work there (or in a sibling `…-notes/` folder),
not in a scratch location, so the result survives the session.

## Workflow

The job is large (typically 60,000–120,000 words for a 12-week course) and will span context resets. Keep a
`PROGRESS.md` in the project folder (chapters done, chapters pending, open questions, the artifact slug) and update it
after each chapter, so you or a later session can resume without redoing work.

### 1. Inventory and extract
```bash
python3 <skill>/scripts/extract_text.py "<course-folder>" "<project>/txt"
python3 <skill>/scripts/extract_text.py "<textbooks-folder>" "<project>/books"
```
Read the summary. For files marked LOW TEXT (scanned or diagram-heavy slides), look at the pages as images
(the Read tool renders PDF pages). Note which textbook is which (title, edition, chapter list); if a supplied
book turns out to be irrelevant, say so and set it aside.

### 2. Plan
Read the unit outline, the review lecture and any sample exam first: they define what matters. Then skim every
week. Decide the chapter list (usually one per lecture week, plus Review, Formula sheet if there are calculations,
and Glossary), and the cross-week threads (ideas that recur). Map each week to textbook chapters by searching the
extracted text for the week's key terms. Write this plan to `PROGRESS.md`. Tell the user the plan in a few lines
and continue unless they object.

### 3. Scaffold
```bash
python3 <skill>/scripts/scaffold.py "<project>" --title "COMP1234 Exam Notes" \
  --subtitle "Database systems" --course "COMP1234 Database Systems (University of X)" --key c1234
```
Then copy `src/11-chapter-template.html` to one file per chapter (`11-w01.html`, `12-w02.html`, …, keeping the
numeric prefixes in order and below 30), set each section's `id`, `data-num`, `data-short` and `data-group`, delete
the template, and fill in `10-home.html`. `--key` is a short prefix for the viewer's saved settings.

### 4. Write the chapters (most of the effort)
Read `references/writing-standard.md` before writing the first chapter and follow it for every chapter. It holds the
standard this student population expects and the reasons behind it. In short:
- every content slide's facts covered, then a **"The lecture slides, point by point"** table at the end;
- context, motivation and history before mechanism; section titles that say what each section is *for*;
- no abbreviation, product name or term left unexplained at first use;
- worked examples with real numbers, warnings for the classic traps, exam boxes, self-checks;
- original prose, with specific textbook chapter and section pointers in `box read`.

Read `references/components.md` for the HTML vocabulary (boxes, tables, SVG figures, text-based sequence
diagrams, widgets). Use the components rather than inventing new markup.

Work one chapter at a time: read that week's slides, tutorial and the mapped textbook sections, write the chapter,
build and check it, update `PROGRESS.md`. Write long chapters in several edits rather than one enormous write.

### 5. The exam toolkit
- **Review chapter** (`30-review.html`): exam format and rules; technique; the course on one page; the most-examined
  comparisons; practice questions of every exam question type with model answers (worked in full for
  calculations); and the review lecture slide by slide.
- **Formula sheet** (`31-formulas.html`) if the course has calculations: every formula, its symbols and units, its trap,
  a link to the chapter.
- **Glossary**: automatic, from each chapter's Key terms table.

### 6. Audit
- `python3 <skill>/scripts/find_jargon.py "<project>"`: fix every genuine unexplained term.
- Re-read each chapter's slide table against the slides: any slide fact not explained in the chapter body?
- Section titles: do any still just repeat a slide slogan? Retitle (keep the id).
- Cross-references: `§N.k` in prose must match the actual numbering (it is positional; see components.md §1).

### 7. Build, check, view, publish
Follow `references/publishing.md`: build, run `check.py` and the JS syntax check, view it in a browser (light and
dark modes, phone width, one widget, glossary search), then publish as an artifact with the `sample` capability
so the highlight-to-explain button works. Give the user the link, and the local `.html` path for offline use.

## Improving existing notes

When the user asks for more detail, better structure or fixes in notes made with this skill, read `PROGRESS.md` and
the affected chapters first. Typical requests and how to handle them:
- *"More context/detail"*: add context paragraphs, history, examples and textbook-derived background to existing
  sections; prefer new h3s inside existing h2s so § numbers don't shift.
- *"This term isn't explained"*: fix that one, then run `find_jargon.py` and fix the whole class of problem.
- *"Section X is just the slide title"*: retitle by purpose and add a "why this section exists" opening.
Rebuild, check and republish to the same artifact (pass its slug and current version) so the link stays the same.

## Bundled files
- `scripts/extract_text.py`: course/textbook files to text with page/slide markers; flags image-only files
- `scripts/scaffold.py`: new project from templates
- `scripts/build.py`: assemble `src/` into `dist/index.html`
- `scripts/check.py`: duplicate ids, broken internal links, tag balance
- `scripts/find_jargon.py`: abbreviations and names used without explanation
- `assets/shell/`: head/CSS, navigation shell, explainer, router (finished; edit only to fix bugs)
- `assets/chapters/`: home, chapter, review, formula and glossary templates
- `references/writing-standard.md`: the content standard (read before writing)
- `references/components.md`: the HTML component catalogue
- `references/publishing.md`: build, check, preview and artifact publishing
