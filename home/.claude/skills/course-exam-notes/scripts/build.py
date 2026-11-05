#!/usr/bin/env python3
"""Assemble the notes site from a project's src/ folder.

Usage:  python3 build.py <project-dir>

Reads <project-dir>/course.json  {"title", "subtitle", "course", "key"}
Concatenates, in order:
    src/00-head.html  src/01-shell-top.html  src/[1-3]*.html (sorted)  src/98-explain.html  src/99-shell-bottom.html
fills the {{TITLE}} {{SUBTITLE}} {{COURSE}} {{KEY}} placeholders, wraps the result in a full HTML document and writes
    <project-dir>/dist/index.html        (publish this one)
    <project-dir>/<title>.html           (the same file, convenient to open locally)
"""
import glob, json, os, sys

proj = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else '.')
conf = json.load(open(os.path.join(proj, 'course.json'), encoding='utf-8'))
src = os.path.join(proj, 'src')

def read(name):
    return open(os.path.join(src, name), encoding='utf-8').read()

chapters = sorted(p for p in glob.glob(os.path.join(src, '[1-3]*.html')))
body = read('01-shell-top.html') + ''.join(open(p, encoding='utf-8').read() for p in chapters) \
     + read('98-explain.html') + read('99-shell-bottom.html')
doc = ('<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n'
       '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
       + read('00-head.html') + '</head>\n<body>\n' + body + '</body>\n</html>\n')
for k in ('title', 'subtitle', 'course', 'key'):
    doc = doc.replace('{{%s}}' % k.upper(), conf[k])

os.makedirs(os.path.join(proj, 'dist'), exist_ok=True)
out1 = os.path.join(proj, 'dist', 'index.html')
out2 = os.path.join(proj, conf['title'] + '.html')
for o in (out1, out2):
    open(o, 'w', encoding='utf-8').write(doc)
words = len(__import__('re').sub(r'<[^>]+>', ' ', doc).split())
print(f'built {len(chapters)} chapter files, {len(doc)//1024} KB, ~{words:,} words')
print(out1); print(out2)
