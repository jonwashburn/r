#!/usr/bin/env python3
"""Rebuild the paper slice from shape-of-logic at a pinned commit.

Copies the transitive import closure of the seed modules into IndisputableMonolith/.
"""
from __future__ import annotations

import re
import shutil
import sys
from collections import deque
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOL = Path("/Users/jonathanwashburn/Documents/Projects/shape-of-logic")
IM = SOL / "IndisputableMonolith"

SEEDS = [
    "IndisputableMonolith.Foundation.NothingToDistinction",
    "IndisputableMonolith.Foundation.TMinus1ToT8Bridge",
    "IndisputableMonolith.Foundation.CircleWindingChain",
    "IndisputableMonolith.Foundation.PhiForcing",
    "IndisputableMonolith.Foundation.AlexanderDuality",
    "IndisputableMonolith.Foundation.DimensionForcing",
    "IndisputableMonolith.Foundation.GapDerivation",
    "IndisputableMonolith.RecognitionCore",
    "IndisputableMonolith.Foundation.PrimitiveRecognitionCalculus.QuotientSelection",
    "IndisputableMonolith.Cost.FunctionalEquation",
    "IndisputableMonolith.CostUniqueness",
    "IndisputableMonolith.Constants",
    "IndisputableMonolith.Constants.AlphaDerivation",
    "IndisputableMonolith.Patterns.GrayCycle",
    "IndisputableMonolith.Masses.TorsionForcing",
    "IndisputableMonolith.Gravity.ILG",
    "IndisputableMonolith.Gravity.ParameterizationBridge",
    "IndisputableMonolith.Gravity.GravityParameters",
    "IndisputableMonolith.Gravity.DerivedFactors",
    "IndisputableMonolith.Gravity.Rotation",
    # FoP boundary + exhibit surface (2026-07-06)
    "IndisputableMonolith.Verification.DimensionalRigidity",
    "IndisputableMonolith.Foundation.PrimitiveDistinction",
    "IndisputableMonolith.Verification.T5.LedgerCost",
    "IndisputableMonolith.Cosmology.EtaBPrefactorDerivation",
    "IndisputableMonolith.Masses.Verification",
]

IMPORT_RE = re.compile(r"^\s*import\s+(IndisputableMonolith(?:\.[A-Za-z0-9_]+)+)")


def mod_to_path(mod: str) -> Path:
    rel = mod.removeprefix("IndisputableMonolith.").replace(".", "/") + ".lean"
    return IM / rel


def parse_imports(path: Path) -> list[str]:
    if not path.exists():
        return []
    out: list[str] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        m = IMPORT_RE.match(line)
        if m:
            out.append(m.group(1))
    return out


def closure(seeds: list[str]) -> set[str]:
    seen: set[str] = set()
    q: deque[str] = deque(seeds)
    while q:
        mod = q.popleft()
        if mod in seen:
            continue
        seen.add(mod)
        p = mod_to_path(mod)
        for dep in parse_imports(p):
            if dep not in seen:
                q.append(dep)
    return seen


def main() -> int:
    if not SOL.is_dir():
        print(f"shape-of-logic not found at {SOL}", file=sys.stderr)
        return 1
    mods = sorted(closure(SEEDS))
    dest_root = ROOT / "IndisputableMonolith"
    if dest_root.exists():
        shutil.rmtree(dest_root)
    dest_root.mkdir(parents=True)
    copied = 0
    for mod in mods:
        src = mod_to_path(mod)
        if not src.exists():
            print(f"MISSING {src}", file=sys.stderr)
            return 1
        rel = src.relative_to(IM)
        dst = dest_root / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
        copied += 1
    # Pin toolchain from source
    for name in ("lean-toolchain", "lake-manifest.json"):
        shutil.copy2(SOL / name, ROOT / name)
    print(f"copied {copied} modules from {SOL}")
    print(f"commit pin: run `cd {SOL} && git rev-parse HEAD`")
    return 0


if __name__ == "__main__":
    sys.exit(main())
