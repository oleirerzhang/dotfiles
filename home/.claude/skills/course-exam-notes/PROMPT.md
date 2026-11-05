# Using the course-exam-notes skill

This skill turns a course's materials into a textbook-style, interactive HTML study site:
- one chapter per lecture week, with worked examples and self-checks
- a slide-by-slide recap in each chapter
- a review chapter, a formula sheet and a searchable glossary
- a highlight-to-explain button that asks Claude about any text you select, with a box beside it for your own request.

It was first built for COMP4348 (Semester 2, 2026). It is not tied to that course.

## What to give Claude

Put everything in one folder on your Mac, somewhere permanent (not a temporary session folder), so the notes
are saved next to the course files:

```
COMP1234/
  W01/  lecture slides (PDF or PPTX), lecture notes, tutorial sheet, tutorial solutions, lab code
  W02/  …
  review/      revision lecture, sample or past exams, exam-format slides
  textbooks/   PDFs of the prescribed and recommended books
  outline.pdf  unit outline: assessment, exam rules, learning outcomes
```

- **Required:** the lecture slides for every week.
- **Most valuable after that:** tutorial solutions, sample or past exams and the review lecture. They show
  what is examined and how.
- **Optional, recommended:** textbooks. They give depth and background. The notes cite them by chapter and section
  rather than copying them.
- **If not in the files:** exam date, length, open/closed book, cheat-sheet rules, question types.

## Prompt

```text
Use the course-exam-notes skill to make exam study notes for COMP1234 Database Systems (University of Sydney)
from my course folder /Users/oliverzhang/uni/COMP1234. Textbooks are in its textbooks/ subfolder.
The exam is on 20 June, 2 hours, closed book with one A4 cheat sheet; questions are MCQ, short answer
and calculations. The lecturer said everything on the slides is examinable.
Write the notes into /Users/oliverzhang/uni/COMP1234-notes and publish them as an artifact.
```

The skill usually starts without being named; naming it guarantees it.

## Follow-up prompts that work well

- "Chapter 4 needs more context and examples. Ground it in the textbooks."
- "Section 10.2 is just the slide title. Restructure it around what the section is for."
- "TP monitors (CICS, COMS) are never explained. Fix that and check the whole site for other unexplained terms."
- "Add an interactive calculator for the queueing formulas in Chapter 8."
- "Republish."

A full course takes several long sessions. The skill keeps a `PROGRESS.md` in the notes folder, so a later
session can say "continue the notes in /Users/oliverzhang/uni/COMP1234-notes" and pick up where the last stopped.

## Installing

`~/dotfiles/scripts/install-dotfiles` links this folder to `~/.claude/skills/course-exam-notes`, where Claude
Code finds it. For claude.ai, zip the folder (or package it with the skill-creator skill) and upload it under
Settings → Capabilities → Skills.
