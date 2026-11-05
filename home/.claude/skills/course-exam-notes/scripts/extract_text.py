#!/usr/bin/env python3
"""Extract text from every course file so it can be read and grepped.

Usage:  python3 extract_text.py <course-folder> <out-dir>

Walks <course-folder> recursively. For each PDF, PPTX, DOCX, TXT/MD, writes <out-dir>/<relative path>.txt.
PDFs keep page markers ("=== page N ===") so slides can be cited by number.
Tries pdftotext (poppler), then PyMuPDF, then pypdf. PPTX/DOCX are read with the standard library (zip + XML),
so no extra packages are needed. Prints a summary with page and word counts, and flags files that yielded
almost no text (usually scanned/image-only PDFs: read those pages as images instead).
"""
import os, re, subprocess, sys, zipfile, shutil
from xml.etree import ElementTree as ET

root, out = os.path.abspath(sys.argv[1]), os.path.abspath(sys.argv[2])
os.makedirs(out, exist_ok=True)

def pdf_text(p):
    if shutil.which('pdftotext'):
        try:
            n = int(re.search(r'Pages:\s+(\d+)', subprocess.run(['pdfinfo', p], capture_output=True, text=True).stdout).group(1))
            parts = []
            for i in range(1, n + 1):
                t = subprocess.run(['pdftotext', '-layout', '-f', str(i), '-l', str(i), p, '-'], capture_output=True, text=True).stdout
                parts.append(f'=== page {i} ===\n{t}')
            return '\n'.join(parts), n
        except Exception:
            pass
    try:
        import fitz
        d = fitz.open(p)
        return '\n'.join(f'=== page {i+1} ===\n{pg.get_text()}' for i, pg in enumerate(d)), len(d)
    except ImportError:
        pass
    from pypdf import PdfReader
    r = PdfReader(p)
    return '\n'.join(f'=== page {i+1} ===\n{pg.extract_text() or ""}' for i, pg in enumerate(r.pages)), len(r.pages)

def ooxml_text(p, kind):
    z = zipfile.ZipFile(p)
    if kind == 'pptx':
        names = sorted((n for n in z.namelist() if re.match(r'ppt/slides/slide\d+\.xml$', n)),
                       key=lambda n: int(re.search(r'(\d+)', n.split('/')[-1]).group(1)))
        notes = {int(re.search(r'(\d+)', n.split('/')[-1]).group(1)): n for n in z.namelist() if re.match(r'ppt/notesSlides/notesSlide\d+\.xml$', n)}
        parts = []
        for i, n in enumerate(names, 1):
            t = ' '.join(x.text or '' for x in ET.fromstring(z.read(n)).iter() if x.tag.endswith('}t'))
            parts.append(f'=== slide {i} ===\n{t}')
            if i in notes:
                nt = ' '.join(x.text or '' for x in ET.fromstring(z.read(notes[i])).iter() if x.tag.endswith('}t'))
                if nt.strip(): parts.append(f'--- speaker notes ---\n{nt}')
        return '\n'.join(parts), len(names)
    x = ET.fromstring(z.read('word/document.xml'))
    paras = []
    for para in x.iter():
        if para.tag.endswith('}p'):
            paras.append(''.join(t.text or '' for t in para.iter() if t.tag.endswith('}t')))
    return '\n'.join(paras), 1

rows = []
for d, _, fs in os.walk(root):
    for f in sorted(fs):
        p = os.path.join(d, f); ext = f.lower().rsplit('.', 1)[-1]
        try:
            if ext == 'pdf': t, n = pdf_text(p)
            elif ext in ('pptx', 'docx'): t, n = ooxml_text(p, ext)
            elif ext in ('txt', 'md'): t, n = open(p, errors='ignore').read(), 1
            else: continue
        except Exception as e:
            rows.append((os.path.relpath(p, root), 0, 0, f'ERROR {e}')); continue
        rel = os.path.relpath(p, root); dst = os.path.join(out, rel + '.txt')
        os.makedirs(os.path.dirname(dst), exist_ok=True); open(dst, 'w').write(t)
        w = len(t.split()); flag = 'LOW TEXT: check as images' if n and w / max(n, 1) < 15 else ''
        rows.append((rel, n, w, flag))
for r in rows:
    print(f'{r[1]:>5} pp {r[2]:>8} words  {r[0]}  {r[3]}')
print(f'{len(rows)} files -> {out}')
