import re, sys
from html.parser import HTMLParser
src = open(sys.argv[1], encoding='utf-8').read()
ids = re.findall(r'\bid="([^"]+)"', src)
dups = sorted({i for i in ids if ids.count(i) > 1})
hrefs = set(re.findall(r'href="#([^"]+)"', src))
# ids auto-assigned to h2 without id: chapter-k; we gave all h2 ids explicitly, so check direct
missing = sorted(h for h in hrefs if h not in ids)
print("ids:", len(ids), "dup ids:", dups)
print("internal links:", len(hrefs), "missing targets:", missing)
VOID = {'area','base','br','col','embed','hr','img','input','link','meta','source','track','wbr','path','line','rect','circle','polygon','polyline','stop'}
class P(HTMLParser):
    def __init__(s):
        super().__init__(); s.stack=[]; s.err=[]
    def handle_starttag(s, t, a):
        if t in VOID: return
        s.stack.append((t, s.getpos()))
    def handle_startendtag(s, t, a): pass
    def handle_endtag(s, t):
        if t in VOID: return
        if not s.stack: s.err.append(('extra close', t, s.getpos())); return
        if s.stack[-1][0] == t: s.stack.pop(); return
        # find
        for k in range(len(s.stack)-1, -1, -1):
            if s.stack[k][0] == t:
                for u in s.stack[k+1:]:
                    if u[0] not in ('p','li','td','th','tr','option'): s.err.append(('unclosed', u[0], u[1]))
                del s.stack[k:]; return
        s.err.append(('stray close', t, s.getpos()))
p = P()
# strip scripts content to avoid false positives
body = re.sub(r'(<script\b[^>]*>)(.*?)(</script>)', lambda m: m.group(1)+m.group(3), src, flags=re.S)
body = re.sub(r'(<pre class="seq"[^>]*>)(.*?)(</pre>)', lambda m: m.group(1)+m.group(3), body, flags=re.S)
p.feed(body)
print("tag errors:", p.err[:20], "open at end:", [s for s in p.stack if s[0] not in ('html','body','p','li')][:10])
