# The writing standard

These notes replace the textbook the student wishes the course had: one chapter per lecture, each written so a
student who missed the lecture could learn the material from it alone and pass the exam. The model is Martin
Kleppmann's *Designing Data-Intensive Applications*: start from a concrete problem, give the background, introduce
every term exactly where it is needed, work examples with real numbers, then step back to the trade-offs.

Every rule below came from a real student's feedback on a first draft. The reasons matter more than the rules.

## Contents
1. Completeness: everything on the slides is examinable
2. Context before content
3. Section titles say what the section is for
4. No unexplained terms, ever
5. Examples, numbers and worked problems
6. Using the textbooks
7. Interactivity, used sparingly
8. Chapter checklist
9. Prose style

## 1. Completeness: everything on the slides is examinable

Lecturers commonly say "everything in the slides is potentially examinable", and students take it literally.
So every fact, list item, number, name, diagram label and example on every content slide must appear in the notes
and be explained. Thin coverage is the most common failure: a 40-slide lecture compressed into 2,000 words
loses facts the exam will ask about.

- Go through each lecture slide by slide (use the page markers from `extract_text.py`; view slides as images when
  the text is a diagram or the extraction is thin). For each slide, record what is on it before writing anything.
- Write the explanatory chapter, then end it with **"The lecture slides, point by point"**: a table with one row
  per content slide (title → every point on it, compressed → `§` link to where the chapter explains it). This is
  the student's proof that nothing was dropped, and a fast revision pass the night before.
- Tutorials and labs: work every tutorial question in full in the relevant chapter, with the method shown. If the
  tutorial builds software, explain the stack and the design decisions, not just the steps.
- Numbers on slides (dates, percentages, market shares, counts, product versions) are exam fodder: keep them exact.
- If two sources disagree (slide vs tutorial vs textbook), say so and say which the course uses.

## 2. Context before content

Slides are compressed: a slide that says "TP monitors (CICS, COMS) → stateless apps → serverless" carries a
fifty-year story in nine words. The notes' job is to unpack it.

For each topic, ask **why the lecturer included it** and write that down first:
- What problem existed? Who had it, and when? What did people do before? Why wasn't that good enough?
- What does this idea make possible, and what does it cost?
- How does it connect to the previous and next topics, and to other chapters?

When a slide is historical ("All that is old is new again", "A short history of …"), write an actual history:
era-by-era subsections, each saying what technology existed, what problem it solved, what new problem it created,
and which modern idea descends from it. End with a recap table (then → problem solved → today's version).

When the slide gives only a list (e.g. "three reasons to use the cloud"), give each item a sentence of
explanation and, where possible, a concrete example or number.

## 3. Section titles say what the section is for

Slide titles are often slogans or puns ("All that is old is new again", "Two ways out", "The black lines").
Do not copy them as section titles. Title each section by its purpose, so the contents rail reads like a
textbook's table of contents:

| Slide title | Better section title |
|---|---|
| All that is old is new again | A short history of cloud computing |
| Two ways out | Two ways around blocking: stronger synchronous middleware, or asynchronous messages |
| Safe, idempotent, cacheable | Using HTTP properly: method properties, status codes, headers, caching and links |
| Answers versus actions | Answers versus actions: what changes when AI can act |

Mention the slide's own title in the first sentence ("The lecture's slide for this part is titled …") so the
student can match notes to slides. Open each h2 with one or two sentences saying why this section is here.

## 4. No unexplained terms, ever

Every abbreviation, product name, standard, protocol, person or piece of jargon gets a plain-language
explanation **at its first use in the notes**, even if the slide never explains it. Examples of what this means:

- "TP monitors (CICS, COMS)" → say what a TP monitor is (middleware that runs many short transactions for many
  terminals with a small pool of workers), what CICS is (IBM's, from 1968–69, still runs much of banking), what COMS
  is (Unisys's equivalent), and why they matter here.
- "EKS, AKS, GKE" in a table → a note under the table expanding each.
- "over HTTP" in Chapter 1 → "(HyperText Transfer Protocol, the Web's request/response protocol)".

Options, in order of preference:
1. A `box def` when the term is central to the section.
2. An inline parenthetical when it is incidental: "SMART (the self-monitoring counters built into disks)".
3. A forward pointer when the proper explanation belongs later: "REST (Web-style HTTP APIs, Chapter 7)".
   Then make sure Chapter 7 really explains it.

Also explain assumed background knowledge the slides skip (e.g. what a socket is, what a hypervisor is, what a
percentile is). A course's "assumed knowledge" is not always the student's knowledge.

After drafting, run `scripts/find_jargon.py` and fix every real hit. Then put each important term in the
chapter's Key terms table (they feed the searchable glossary).

## 5. Examples, numbers and worked problems

- Every abstract idea gets a concrete example, preferably a running example that recurs through the chapter
  (a bookshop, a bank transfer, a cinema booking).
- Every formula gets a worked example with units, written as numbered steps, plus a `box warn` for the classic
  trap (wrong units, averaging rates instead of times, confusing two similar laws).
- Every comparison (2PC vs saga, queue vs topic) gets a side-by-side table, and a sentence on when to choose which.
- Every chapter gets an `exam` box on how the topic is examined and what a full-marks answer contains, and 4–10
  self-check questions in the exam's own question styles, with model answers.

## 6. Using the textbooks

The reference textbooks are for depth, context and better examples, not for copying. Read the chapters that
match each lecture (search the extracted text for the lecture's key terms), then:

- Use them to understand the topic well enough to explain it in your own words, add background the slides skip,
  and borrow the *kind* of example they use (with your own numbers and wording).
- Do not reproduce their text, figures or tables. Write original prose. Brief quotations (under ~15 words, in
  quotation marks, attributed) are fine when the exact wording matters, such as a famous definition.
- End each chapter (or major section) with a `box read` listing **specific** pointers:
  "Kleppmann, *DDIA*: Ch. 7 'Transactions', sections 'Weak isolation levels' and 'Serializability'".
  Use the book's actual chapter and section names from its table of contents. A vague "see Ch. 5" is useless.
- Point to the textbook for auxiliary material that is not examinable but helps understanding.
- If a supplied PDF turns out to be the wrong book or edition, say so and skip it.

## 7. Interactivity, used sparingly

Interactive widgets help when the student would learn by changing an input and watching the result: a race
condition simulator, a protocol with failures injected at chosen points, a calculator for the course's formulas,
a curve that moves with a parameter. Roughly 0–2 per chapter, 6–10 for a whole course. Never use a widget instead of
prose: the exam is on paper. List them all on the home page.

## 8. Chapter checklist

- [ ] Title block, lede that motivates the chapter and links it to the previous one
- [ ] h2 sections titled by purpose, each opening with why it is there
- [ ] Every slide fact covered; every tutorial question worked
- [ ] Every term explained at first use (`find_jargon.py` clean)
- [ ] Definitions, worked examples, warnings, exam box
- [ ] Figures/sequence diagrams where a picture explains better than words
- [ ] Textbook pointers (`box read`) with specific chapters and sections
- [ ] Self-checks with model answers
- [ ] "The lecture slides, point by point" table, every content slide, with § links
- [ ] Key terms table

Typical size: 6,000–12,000 words per lecture chapter. Err towards more detail and specificity.

## 9. Prose style

- Plain, direct, specific. Short paragraphs. Active voice. One idea per paragraph.
- Concrete nouns and real numbers rather than abstractions ("a 30 ms round trip", not "some latency").
- Avoid filler and AI-isms: no "delve", "crucial", "landscape", "it's important to note", no rhetorical
  questions as section openers, no "In conclusion". Bold sparingly, for the term being defined or the key result.
- Second person ("you") for instructions and exam advice; neutral third person for explanations.
- British or American spelling to match the course materials; be consistent.
