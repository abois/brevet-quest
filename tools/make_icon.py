#!/usr/bin/env python3
"""
Génère le logo de Brevet Quest — carré 1024×1024 avec gradient violet Y2K,
sparkle central et accents décoratifs.

Usage:
    python3 tools/make_icon.py
"""
from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "assets" / "icon" / "app_icon.png"
OUT_FG = ROOT / "assets" / "icon" / "app_icon_fg.png"

SIZE = 1024
RADIUS = 220  # Coins arrondis (style iOS / Material You)

# Palette Y2K violet — alignée avec lib/theme/app_theme.dart
LAVENDER_LIGHT = (217, 194, 255)   # #D9C2FF
LAVENDER = (184, 168, 255)         # #B8A8FF
VIOLET = (155, 127, 232)           # #9B7FE8
VIOLET_DEEP = (74, 24, 96)         # #4A1860
PINK_GLOW = (232, 62, 140)         # #E83E8C
WHITE = (255, 255, 255)


def make_rounded_mask(size: int, radius: int) -> Image.Image:
    """Masque alpha pour découper en carré arrondi."""
    mask = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(mask)
    d.rounded_rectangle((0, 0, size, size), radius=radius, fill=255)
    return mask


def make_diagonal_gradient(size: int, c1, c2, c3) -> Image.Image:
    """Dégradé diagonal lavande → violet → violet profond."""
    img = Image.new("RGB", (size, size), c1)
    px = img.load()
    for y in range(size):
        for x in range(size):
            t = (x + y) / (2 * size)
            # Mélange en deux temps : c1 → c2 sur la première moitié, c2 → c3 sur la seconde.
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


def add_radial_glow(img: Image.Image, center, color, radius: int, alpha: int):
    """Ajoute un halo radial doux à `center`."""
    glow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(glow)
    for r in range(radius, 0, -10):
        a = int(alpha * (1 - r / radius) ** 2)
        d.ellipse(
            (center[0] - r, center[1] - r, center[0] + r, center[1] + r),
            fill=(*color, a),
        )
    glow = glow.filter(ImageFilter.GaussianBlur(40))
    img.alpha_composite(glow)


def draw_sparkle(draw: ImageDraw.ImageDraw, cx, cy, size, color, alpha=255, rot=0):
    """Étoile à 4 branches (✦) — losange étiré horizontalement + vertical."""
    pts_v = [
        (cx, cy - size),
        (cx + size * 0.18, cy),
        (cx, cy + size),
        (cx - size * 0.18, cy),
    ]
    pts_h = [
        (cx - size, cy),
        (cx, cy - size * 0.18),
        (cx + size, cy),
        (cx, cy + size * 0.18),
    ]
    fill = (*color, alpha)
    if rot:
        # Rotation simple via matrice 2x2 autour de (cx, cy).
        cos, sin = math.cos(rot), math.sin(rot)
        def rotate(pts):
            return [
                (cx + (x - cx) * cos - (y - cy) * sin,
                 cy + (x - cx) * sin + (y - cy) * cos)
                for (x, y) in pts
            ]
        pts_v = rotate(pts_v)
        pts_h = rotate(pts_h)
    draw.polygon(pts_v, fill=fill)
    draw.polygon(pts_h, fill=fill)


def find_font(size: int) -> ImageFont.ImageFont:
    candidates = [
        "/usr/share/fonts/truetype/freefont/FreeSansBold.ttf",
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    ]
    for c in candidates:
        if Path(c).exists():
            return ImageFont.truetype(c, size)
    return ImageFont.load_default()


def render(size: int, with_mask: bool) -> Image.Image:
    bg = make_diagonal_gradient(size, LAVENDER_LIGHT, LAVENDER, VIOLET)
    img = bg.convert("RGBA")

    # Halo central rose chaud (effet Y2K).
    add_radial_glow(img, (size // 2, int(size * 0.42)), PINK_GLOW, size // 2, 90)
    # Halo bas-droite lavande sombre.
    add_radial_glow(img, (int(size * 0.85), int(size * 0.85)), VIOLET_DEEP, size // 3, 80)

    overlay = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(overlay)

    # Sparkle principal au centre (blanc lumineux + glow).
    cx, cy = size // 2, int(size * 0.42)
    draw_sparkle(d, cx, cy, int(size * 0.34), WHITE, alpha=255)

    # Glow autour du sparkle principal.
    glow_layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow_layer)
    draw_sparkle(gd, cx, cy, int(size * 0.42), WHITE, alpha=110)
    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(28))
    img.alpha_composite(glow_layer)

    # Petits sparkles décoratifs (déco Y2K).
    deco = [
        (int(size * 0.18), int(size * 0.22), int(size * 0.05), 0),
        (int(size * 0.82), int(size * 0.20), int(size * 0.04), 0.4),
        (int(size * 0.20), int(size * 0.78), int(size * 0.04), 0.2),
        (int(size * 0.84), int(size * 0.62), int(size * 0.05), -0.3),
    ]
    for x, y, s, rot in deco:
        draw_sparkle(d, x, y, s, WHITE, alpha=210, rot=rot)

    # Texte « BREVET QUEST » en bas, en majuscules tracking large.
    text = "BREVET QUEST"
    font = find_font(int(size * 0.085))
    bbox = d.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    tx = (size - tw) // 2
    ty = int(size * 0.78)
    # Ombre douce
    shadow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.text((tx + 4, ty + 6), text, font=font, fill=(74, 24, 96, 200))
    shadow = shadow.filter(ImageFilter.GaussianBlur(6))
    img.alpha_composite(shadow)
    d.text((tx, ty), text, font=font, fill=WHITE)

    img.alpha_composite(overlay)

    if with_mask:
        mask = make_rounded_mask(size, RADIUS)
        out = Image.new("RGBA", img.size, (0, 0, 0, 0))
        out.paste(img, (0, 0), mask)
        return out
    return img


def render_foreground(size: int) -> Image.Image:
    """Version foreground pour Android adaptive icon — fond transparent + sparkle centré.

    L'adaptive icon ajoute son propre fond ; le foreground doit être centré
    dans une safe zone de ~66% (le système peut zoomer/cropper jusqu'à 33%).
    """
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    cx, cy = size // 2, size // 2
    # Sparkle central plus petit pour rester dans la safe zone.
    main = int(size * 0.22)
    draw_sparkle(d, cx, cy, main, WHITE, alpha=255)
    # Glow
    glow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    draw_sparkle(gd, cx, cy, int(main * 1.25), WHITE, alpha=140)
    glow = glow.filter(ImageFilter.GaussianBlur(22))
    img.alpha_composite(glow)
    # Quatre petits sparkles
    deco = [
        (int(size * 0.30), int(size * 0.30), int(size * 0.04)),
        (int(size * 0.70), int(size * 0.30), int(size * 0.035)),
        (int(size * 0.30), int(size * 0.70), int(size * 0.035)),
        (int(size * 0.70), int(size * 0.70), int(size * 0.04)),
    ]
    for x, y, s in deco:
        draw_sparkle(d, x, y, s, WHITE, alpha=220)
    return img


def main():
    OUT.parent.mkdir(parents=True, exist_ok=True)
    icon = render(SIZE, with_mask=True)
    icon.save(OUT, "PNG")
    print(f"✅ Icon: {OUT.relative_to(ROOT)} ({SIZE}×{SIZE})")
    fg = render_foreground(SIZE)
    fg.save(OUT_FG, "PNG")
    print(f"✅ Adaptive foreground: {OUT_FG.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
