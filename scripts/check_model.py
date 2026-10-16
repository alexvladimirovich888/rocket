#!/usr/bin/env python3
"""
check_model.py - validate an exported Roadster mesh against the target hitbox.

Reads a Wavefront .obj file, measures its bounding box and triangle count,
and compares them with the hitbox and budget in config/roadster.json.

Usage:
    python scripts/check_model.py path/to/roadster.obj
    python scripts/check_model.py path/to/roadster.obj --scale 1.0 --forward x

Units: export from Blender so that 1 Blender unit = 1 Unreal unit (uu),
or pass --scale to convert (e.g. --scale 100 if you modelled in metres
and want 1 m = 100 uu).

Exit code is 0 when every check passes and 1 otherwise, so it can run in CI.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_CONFIG = ROOT / "config" / "roadster.json"

if os.name == "nt":
    os.system("")  # enable ANSI colours in the Windows console

GREEN, RED, YELLOW, DIM, RESET = "\033[32m", "\033[31m", "\033[33m", "\033[2m", "\033[0m"


def parse_obj(path: Path):
    """Return (vertices, triangle_count) from an .obj file."""
    vertices: list[tuple[float, float, float]] = []
    triangles = 0
    with path.open("r", encoding="utf-8", errors="replace") as fh:
        for line in fh:
            if line.startswith("v "):
                parts = line.split()
                vertices.append((float(parts[1]), float(parts[2]), float(parts[3])))
            elif line.startswith("f "):
                corners = len(line.split()) - 1
                if corners >= 3:
                    triangles += corners - 2  # fan triangulation of n-gons
    return vertices, triangles


def bounding_box(vertices, scale: float):
    xs, ys, zs = zip(*vertices)
    return (
        (max(xs) - min(xs)) * scale,
        (max(ys) - min(ys)) * scale,
        (max(zs) - min(zs)) * scale,
    )


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("obj", type=Path, help="exported mesh (.obj)")
    ap.add_argument("--config", type=Path, default=DEFAULT_CONFIG)
    ap.add_argument("--scale", type=float, default=1.0, help="multiply coordinates by this factor")
    ap.add_argument("--forward", choices=["x", "y"], default="x", help="axis the car's nose points along")
    ap.add_argument("--up", choices=["y", "z"], default="z", help="vertical axis in the exported file")
    args = ap.parse_args(argv)

    if not args.obj.is_file():
        print(f"{RED}error:{RESET} file not found: {args.obj}")
        return 1

    cfg = json.loads(args.config.read_text(encoding="utf-8"))
    hb = cfg["hitbox"]
    tol = hb.get("tolerancePercent", 8) / 100
    tri_budget = cfg["budget"]["lod0Triangles"]

    verts, tris = parse_obj(args.obj)
    if not verts:
        print(f"{RED}error:{RESET} no vertices found in {args.obj}")
        return 1

    sx, sy, sz = bounding_box(verts, args.scale)
    axes = {"x": sx, "y": sy, "z": sz}
    up = args.up
    forward = args.forward
    side = ({"x", "y", "z"} - {up, forward}).pop()
    measured = {"length": axes[forward], "width": axes[side], "height": axes[up]}
    target = {"length": hb["lengthUU"], "width": hb["widthUU"], "height": hb["heightUU"]}

    print(f"\n  Roadster mesh check  {DIM}{args.obj.name} · preset {hb['preset']} · tolerance ±{tol:.0%}{RESET}\n")
    ok = True
    for key in ("length", "width", "height"):
        m, t = measured[key], target[key]
        diff = (m - t) / t
        passed = abs(diff) <= tol
        ok &= passed
        mark = f"{GREEN}PASS{RESET}" if passed else f"{RED}FAIL{RESET}"
        print(f"  {mark}  {key:<7} {m:8.2f} uu   target {t:7.2f} uu   ({diff:+.1%})")

    tri_ok = tris <= tri_budget
    ok &= tri_ok
    mark = f"{GREEN}PASS{RESET}" if tri_ok else f"{YELLOW}OVER{RESET}"
    print(f"  {mark}  tris    {tris:8d}      budget {tri_budget:7d}")

    print()
    if ok:
        print(f"  {GREEN}All checks passed.{RESET}\n")
        return 0
    print(f"  {RED}Some checks failed.{RESET} Tip: the visual body may overhang the hitbox a little,"
          f" but large differences make hits feel wrong.\n")
    return 1


if __name__ == "__main__":
    sys.exit(main())
