"""Recolour an upstream GNOME Shell stylesheet onto a theme palette.

Usage: gnome-shell-recolor.py <upstream.css> <grey-ramp.json> <accent> <accent-fg>

Neutral greys (channel spread <= 12) are mapped by level through the grey
ramp ([[level, "#rrggbb"], ...], sorted by level); coloured hexes are kept.
The runtime accent keywords are replaced with fixed theme colours.
"""

import json
import re
import sys


def to_rgb(hex_color):
    h = hex_color.lstrip("#")
    return [int(h[i : i + 2], 16) for i in (0, 2, 4)]


def main():
    src, ramp_path, accent, accent_fg = sys.argv[1:5]
    with open(ramp_path) as f:
        ramp = [(level, to_rgb(color)) for level, color in json.load(f)]

    def map_grey(level):
        for (l0, c0), (l1, c1) in zip(ramp, ramp[1:]):
            if l0 <= level <= l1:
                t = (level - l0) / (l1 - l0) if l1 > l0 else 0.0
                return [round(a + (b - a) * t) for a, b in zip(c0, c1)]
        return ramp[-1][1]

    def recolor(match):
        rgb = to_rgb(match.group(0))
        if max(rgb) - min(rgb) > 12:
            return match.group(0)
        return "#%02x%02x%02x" % tuple(map_grey(sum(rgb) / 3))

    with open(src) as f:
        css = f.read()
    css = re.sub(r"#[0-9a-fA-F]{6}(?![0-9a-zA-Z_-])", recolor, css)
    css = css.replace("-st-accent-fg-color", accent_fg)
    css = css.replace("-st-accent-color", accent)
    sys.stdout.write(css)


main()
