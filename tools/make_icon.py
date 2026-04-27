#!/usr/bin/env python3
"""
Génère le logo de Brevet Quest — "BQ" en Quicksand W900 avec dégradé
violet/rose (façon _SparkleTitle de la home), sparkles ✦ autour.

Usage:
    python3 tools/make_icon.py
"""
from __future__ import annotations

import math
import shutil
import urllib.request
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "icon" / "app_icon.png"
OUT_FG = ROOT / "assets" / "icon" / "app_icon_fg.png"
FONT_PATH = ROOT / "tools" / "Quicksand-VF.ttf"
FONT_URL = "https://github.com/google/fonts/raw/main/ofl/quicksand/Quicksand%5Bwght%5D.ttf"

SIZE = 1024
RADIUS = 220

# Palette alignée avec lib/theme/app_theme.dart
LAVENDER_LIGHT = (217, 194, 255)   # #D9C2FF
LAVENDER = (184, 168, 255)         # #B8A8FF
LAVENDER300 = (217, 194, 255)
VIOLET = (123, 45, 143)            # #7B2D8F
VIOLET_DEEP = (74, 24, 96)         # #4A1860
PLUM_DARK = (45, 21, 56)           # #2D1538
DANGER = (232, 62, 140)            # #E83E8C — le "rose vif"
WHITE = (255, 255, 255)


def ensure_font() -> Path:
    if not FONT_PATH.exists():
        local = Path("/tmp/Quicksand-VF.ttf")
        if local.exists():
            shutil.copy(local, FONT_PATH)
        else:
            urllib.request.urlretrieve(FONT_URL, FONT_PATH)
    return FONT_PATH


def quicksand(size: int) -> ImageFont.FreeTypeFont:
    f = ImageFont.truetype(str(ensure_font()), size)
    # Variable font — set weight to 900 (max disponible dans Quicksand wght axis)
    try:
        f.set_variation_by_axes([700])  # Quicksand max weight is 700
    except Exception:
        pass
    return f


def rounded_mask(size: int, radius: int) -> Image.Image:
    m = Image.new("L", (size, size), 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, size, size), radius=radius, fill=255)
    return m


def make_bg(size: int) -> Image.Image:
    """Dégradé diagonal lavande → lavande plus saturé (comme app_theme.bgGradient)."""
    img = Image.new("RGB", (size, size), LAVENDER)
    px = img.load()
    c1 = (233, 213, 255)   # #E9D5FF — lavande très clair
    c2 = (217, 194, 255)   # #D9C2FF
    c3 = (184, 168, 255)   # #B8A8FF — lavande300
    for y in range(size):
        for x in range(size):
            t = (x + y) / (2 * size)
            if t < 0.5:
                k = t * 2
                r = int(c1[0] * (1 - k) + c2[0] * k)
                g = int(c1[1] * (1 - k) + c2[1] * k)
                b = int(c1[2] * (1 - k) + c2[2] * k)
            else:
                k = (t - 0.5) * 2
                r = int(c2[0] * (1 - k) + c3[0] * k)
                g = int(c2[1] * (1 - k) + c3[1] * k)
                b = int(c2[2] * (1 - k) + c3[2] * k)
            px[x, y] = (r, g, b)
    return img


def make_horizontal_gradient(size: int, colors: list[tuple[int, int, int]]) -> Image.Image:
    """Gradient horizontal interpolant entre N couleurs (pour ShaderMask)."""
    img = Image.new("RGB", (size, size))
    px = img.load()
    n = len(colors) - 1
    for x in range(size):
        t = x / (size - 1)
        idx = min(int(t * n), n - 1)
        local_t = (t * n) - idx
        c1 = colors[idx]
        c2 = colors[idx + 1]
        r = int(c1[0] * (1 - local_t) + c2[0] * local_t)
        g = int(c1[1] * (1 - local_t) + c2[1] * local_t)
        b = int(c1[2] * (1 - local_t) + c2[2] * local_t)
        for y in range(size):
            px[x, y] = (r, g, b)
    return img


def draw_sparkle(draw, cx, cy, sz, color, alpha=255, rot=0.0):
    """Étoile à 4 branches ✦."""
    pts_v = [(cx, cy - sz), (cx + sz * 0.18, cy),
             (cx, cy + sz), (cx - sz * 0.18, cy)]
    pts_h = [(cx - sz, cy), (cx, cy - sz * 0.18),
             (cx + sz, cy), (cx, cy + sz * 0.18)]
    if rot:
        cos, sin = math.cos(rot), math.sin(rot)

        def rot_pts(pts):
            return [
                (cx + (x - cx) * cos - (y - cy) * sin,
                 cy + (x - cx) * sin + (y - cy) * cos)
                for (x, y) in pts
            ]

        pts_v = rot_pts(pts_v)
        pts_h = rot_pts(pts_h)
    fill = (*color, alpha)
    draw.polygon(pts_v, fill=fill)
    draw.polygon(pts_h, fill=fill)


def draw_bq_with_gradient(img: Image.Image, cx: int, cy: int, font_size: int):
    """Texte 'BQ' avec gradient horizontal violetDeep → violet → rose → violet,
    façon _SparkleTitle de la home."""
    text = "BQ"
    font = quicksand(font_size)
    bbox = font.getbbox(text)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    tx = cx - tw // 2 - bbox[0]
    ty = cy - th // 2 - bbox[1]

    # Ombre douce derrière
    shadow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.text((tx + 6, ty + 12), text, font=font, fill=(*PLUM_DARK, 180))
    shadow = shadow.filter(ImageFilter.GaussianBlur(10))
    img.alpha_composite(shadow)

    # Mask alpha du texte (en blanc sur noir)
    mask = Image.new("L", img.size, 0)
    md = ImageDraw.Draw(mask)
    md.text((tx, ty), text, font=font, fill=255)

    # Gradient horizontal violetDeep → violet → rose → violet
    grad = make_horizontal_gradient(
        img.size[0], [VIOLET_DEEP, VIOLET, DANGER, VIOLET]
    ).convert("RGBA")

    # Compose : ne garde que le gradient là où le mask est > 0
    img.paste(grad, (0, 0), mask)


def render(size: int, with_mask: bool) -> Image.Image:
    bg = make_bg(size).convert("RGBA")
    img = bg.copy()

    # Sparkles décoratifs ✦ blancs autour, comme dans la home
    deco = Image.new("RGBA", img.size, (0, 0, 0, 0))
    dd = ImageDraw.Draw(deco)
    sparkles = [
        (int(size * 0.16), int(size * 0.20), int(size * 0.05), 0),
        (int(size * 0.84), int(size * 0.18), int(size * 0.04), 0.3),
        (int(size * 0.10), int(size * 0.50), int(size * 0.035), 0.1),
        (int(size * 0.90), int(size * 0.50), int(size * 0.04), -0.2),
        (int(size * 0.18), int(size * 0.82), int(size * 0.045), 0),
        (int(size * 0.82), int(size * 0.82), int(size * 0.05), 0.4),
        (int(size * 0.50), int(size * 0.10), int(size * 0.035), 0.2),
        (int(size * 0.50), int(size * 0.92), int(size * 0.03), -0.3),
    ]
    for x, y, s, rot in sparkles:
        draw_sparkle(dd, x, y, s, WHITE, alpha=235, rot=rot)
    img.alpha_composite(deco)

    # "BQ" centré avec gradient
    cx, cy = size // 2, int(size * 0.50)
    draw_bq_with_gradient(img, cx, cy, int(size * 0.48))

    if with_mask:
        out = Image.new("RGBA", img.size, (0, 0, 0, 0))
        out.paste(img, (0, 0), rounded_mask(size, RADIUS))
        return out
    return img


def render_foreground(size: int) -> Image.Image:
    """Foreground pour adaptive icon Android — BQ + sparkles centrés
    dans la safe zone (~66 %) sur fond transparent."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    cx, cy = size // 2, size // 2

    deco = Image.new("RGBA", img.size, (0, 0, 0, 0))
    dd = ImageDraw.Draw(deco)
    sparkles = [
        (int(size * 0.30), int(size * 0.30), int(size * 0.035), 0),
        (int(size * 0.70), int(size * 0.30), int(size * 0.030), 0.3),
        (int(size * 0.30), int(size * 0.70), int(size * 0.030), 0.1),
        (int(size * 0.70), int(size * 0.70), int(size * 0.035), -0.2),
    ]
    for x, y, s, rot in sparkles:
        draw_sparkle(dd, x, y, s, WHITE, alpha=235, rot=rot)
    img.alpha_composite(deco)

    draw_bq_with_gradient(img, cx, cy, int(size * 0.36))
    return img


def main():
    OUT.parent.mkdir(parents=True, exist_ok=True)
    icon = render(SIZE, with_mask=True)
    icon.save(OUT, "PNG")
    print(f"OK Icon: {OUT.relative_to(ROOT)} ({SIZE}x{SIZE})")
    fg = render_foreground(SIZE)
    fg.save(OUT_FG, "PNG")
    print(f"OK Adaptive foreground: {OUT_FG.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
