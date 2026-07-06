#!/usr/bin/env python3
"""Audit the paper slice: no sorry, no admit, no top-level axiom declarations.

Scans every .lean file in IndisputableMonolith/ plus Paper.lean and
IndisputableMonolith.lean. Exits nonzero on any hit. Comments and string
literals mentioning the words (docstrings describing the audit itself) are
excluded by requiring the token to appear in code position.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

AXIOM_RE = re.compile(r"^\s*(noncomputable\s+)?axiom\s+\S")
SORRY_RE = re.compile(r"(^|[^\w'])sorry([^\w']|$)")
ADMIT_RE = re.compile(r"(^|[^\w'])admit([^\w']|$)")


def strip_comments(text: str) -> str:
    # Remove block comments (including doc comments) and line comments.
    text = re.sub(r"/-.*?-/", "", text, flags=re.S)
    text = re.sub(r"--.*", "", text)
    return text


def main() -> int:
    files = sorted(ROOT.glob("IndisputableMonolith/**/*.lean"))
    files += [ROOT / "IndisputableMonolith.lean", ROOT / "Paper.lean"]
    issues = []
    for f in files:
        code = strip_comments(f.read_text(encoding="utf-8"))
        for i, line in enumerate(code.splitlines(), 1):
            if AXIOM_RE.match(line):
                issues.append((f, i, "axiom", line.strip()))
            if SORRY_RE.search(line):
                issues.append((f, i, "sorry", line.strip()))
            if ADMIT_RE.search(line):
                issues.append((f, i, "admit", line.strip()))
    for f, i, kind, line in issues:
        print(f"{f.relative_to(ROOT)}:{i}: {kind}: {line}")
    print(f"audited {len(files)} files; {len(issues)} issues")
    return 1 if issues else 0


if __name__ == "__main__":
    sys.exit(main())
