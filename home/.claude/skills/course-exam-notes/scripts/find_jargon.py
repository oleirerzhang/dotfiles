#!/usr/bin/env python3
"""List abbreviations and capitalised product names that are used without an explanation at first use.

Usage:  python3 find_jargon.py <project-dir> [--all]

Reads chapter files src/[1-3]*.html in build order and reports, for each term, the first place it appears
with ~150 characters of context, skipping terms that are followed or preceded by a parenthetical
expansion, or that sit inside <dfn>. It is a heuristic: expect false positives (SQL keywords, enum values,
variable names). Read the list and decide; then add the explanation at the FIRST use, or a pointer
("(Chapter 7)") if it is explained properly later.
--all also lists terms that look explained, for a final audit.
"""
import glob, html, os, re, sys

proj = os.path.abspath(sys.argv[1]); show_all = '--all' in sys.argv
files = sorted(glob.glob(os.path.join(proj, 'src', '[1-3]*.html')))
COMMON = set('I II III IV OK US UK EU CPU OS PC TV PDF A B C D E F G H J K L M N O P Q R S T U V W X Y Z'.split())

def text(s):
    s = re.sub(r'<(script|style|svg|pre|code)\b.*?</\1>', ' ', s, flags=re.S | re.I)
    s = re.sub(r'<dfn>(.*?)</dfn>', lambda m: '\x01' + m.group(1) + '\x02', s, flags=re.S)
    s = re.sub(r'<[^>]+>', ' ', s)
    return html.unescape(re.sub(r'\s+', ' ', s))

seen = {}
for f in files:
    t = text(open(f, encoding='utf-8').read())
    for m in re.finditer(r'(?<![\w\x01])([A-Z][A-Za-z0-9]*[A-Z][A-Za-z0-9/\-]*|[A-Z]{2,}s?)\b', t):
        a = m.group(1)
        if a in seen or a in COMMON or a.isdigit(): continue
        after, before = t[m.end():m.end() + 3], t[max(0, m.start() - 2):m.start()]
        ok = after.lstrip().startswith('(') or before.endswith('(') or t[m.end():m.end() + 1] == '\x02'
        seen[a] = (os.path.basename(f), ok, t[max(0, m.start() - 70):m.end() + 80].replace('\x01', '').replace('\x02', ''))
n = 0
for a, (f, ok, ctx) in seen.items():
    if ok and not show_all: continue
    n += 1
    print(f"{f:<22} {a:<14} {'(explained) ' if ok else ''}…{ctx}…")
print(f'\n{n} terms listed')
