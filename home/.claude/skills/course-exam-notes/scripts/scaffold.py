#!/usr/bin/env python3
"""Create a new notes project from the skill's templates.

Usage:
  python3 scaffold.py <project-dir> --title "COMP1234 Exam Notes" \
      --subtitle "Databases and data management" \
      --course "COMP1234 Database Systems (University of X)" --key c1234

Creates <project-dir>/course.json and <project-dir>/src/ with the page shell, a home page,
one chapter template, the review, formula and glossary chapters. Refuses to overwrite an existing src/.
"""
import argparse, json, os, shutil, sys

here = os.path.dirname(os.path.abspath(__file__))
assets = os.path.join(here, '..', 'assets')
ap = argparse.ArgumentParser()
ap.add_argument('project'); ap.add_argument('--title', required=True); ap.add_argument('--subtitle', default='')
ap.add_argument('--course', required=True); ap.add_argument('--key', required=True)
a = ap.parse_args()

proj = os.path.abspath(a.project); src = os.path.join(proj, 'src')
if os.path.exists(src):
    sys.exit(f'{src} already exists; not overwriting')
os.makedirs(src)
for f in os.listdir(os.path.join(assets, 'shell')):
    shutil.copy(os.path.join(assets, 'shell', f), src)
for f in os.listdir(os.path.join(assets, 'chapters')):
    shutil.copy(os.path.join(assets, 'chapters', f), src)
json.dump({'title': a.title, 'subtitle': a.subtitle, 'course': a.course, 'key': a.key},
          open(os.path.join(proj, 'course.json'), 'w'), indent=2)
print('scaffolded', proj)
print('next: copy src/11-chapter-template.html to src/11-w01.html, src/12-w02.html, ... (one per week/topic), then delete the template')
