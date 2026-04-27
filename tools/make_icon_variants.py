#!/usr/bin/env python3
"""Génère 3 variantes d'icône (cristal / médaille / étoile filante) en
preview 512x512 dans /tmp pour choix visuel."""
from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

OUT_DIR = Path("/tmp/brevet-icon-variants")
SIZE = 512
RADIUS = 110

# Palette
LAVENDER = (217, 194, 255)
VIOLET = (155, 127, 232)
VIOLET_DEEP = (74, 24, 96)
PLUM_DARK = (45, 21, 56)
PINK_GLOW = (232, 62, 140)
PINK_SOFT = (255, 182, 218)
GOLD = (255, 207, 122)
GOLD_DEEP = (215, 156, 60)
WHITE = (255, 255, 255)


def rounded_mask(size: int, radius: int) -> Image.Image:
    m = Image.new("L", (size, size), 0)
    ImageDraw.Draw(m).rounded_rectangle((0, 0, size, size), radius=radius, fill=255)
    return m


def make_bg(size: int, soft=False) -> Image.Image:
    """Dégradé radial doux centre rose-lavande, bords violet."""
    img = Image.new("RGB", (size, size), VIOLET_DEEP)
    px = img.load()
    cx, cy = size / 2, size * 0.4
    max_d = math.hypot(size, size)
    for y in range(size):
        for x in range(size):
            d = math.hypot(x - cx, y - cy) / max_d
            t = min(d * 1.6, 1.0)
            if t < 0.55:
                k = t / 0.55
                a = LAVENDER if soft else PINK_SOFT
                r = int(a[0] * (1 - k) + VIOLET[0] * k)
                g = int(a[1] * (1 - k) + VIOLET[1] * k)
                b = int(a[2] * (1 - k) + VIOLET[2] * k)
            else:
                k = (t - 0.55) / 0.45
                r = int(VIOLET[0] * (1 - k) + VIOLET_DEEP[0] * k)
                g = int(VIOLET[1] * (1 - k) + VIOLET_DEEP[1] * k)
                b = int(VIOLET[2] * (1 - k) + VIOLET_DEEP[2] * k)
            px[x, y] = (r, g, b)
    return img


def apply_mask(img: Image.Image) -> Image.Image:
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    out.paste(img, (0, 0), rounded_mask(img.size[0], RADIUS))
    return out


# ------------------------------------------------------------------
# B — Cristal facetté
# ------------------------------------------------------------------
def variant_crystal() -> Image.Image:
    img = make_bg(SIZE).convert("RGBA")
    cx, cy = SIZE // 2, int(SIZE * 0.50)
    h = int(SIZE * 0.45)
    w = int(h * 0.62)

    # Glow rose autour
    glow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse((cx - w * 1.4, cy - h * 0.95, cx + w * 1.4, cy + h * 0.95),
               fill=(*PINK_GLOW, 120))
    glow = glow.filter(ImageFilter.GaussianBlur(40))
    img.alpha_composite(glow)

    top = (cx, cy - h // 2)
    bot = (cx, cy + h // 2)
    left = (cx - w, cy - int(h * 0.10))
    right = (cx + w, cy - int(h * 0.10))
    upper_l = (cx - int(w * 0.55), cy - int(h * 0.28))
    upper_r = (cx + int(w * 0.55), cy - int(h * 0.28))

    d = ImageDraw.Draw(img)
    # Outline + base shape
    d.polygon([top, right, bot, left], fill=(220, 200, 255, 240))
    # Facette gauche claire
    d.polygon([top, upper_l, left, bot], fill=(255, 220, 240, 240))
    # Facette centrale plus foncée
    d.polygon([top, upper_l, upper_r], fill=(180, 130, 220, 255))
    d.polygon([upper_l, upper_r, bot], fill=(120, 80, 180, 255))
    # Facette droite la plus claire (highlight)
    d.polygon([top, upper_r, right], fill=(255, 240, 255, 255))
    d.polygon([upper_r, right, bot], fill=(200, 160, 230, 255))

    # Contour blanc fin
    d.line([top, right, bot, left, top], fill=(255, 255, 255, 220), width=4)
    d.line([top, upper_l, left], fill=(255, 255, 255, 180), width=3)
    d.line([top, upper_r, right], fill=(255, 255, 255, 180), width=3)
    d.line([upper_l, upper_r], fill=(255, 255, 255, 220), width=3)
    d.line([upper_l, bot], fill=(255, 255, 255, 180), width=3)
    d.line([upper_r, bot], fill=(255, 255, 255, 180), width=3)

    # Petit highlight blanc en haut-droite
    hl = Image.new("RGBA", img.size, (0, 0, 0, 0))
    ImageDraw.Draw(hl).polygon(
        [(cx + int(w * 0.1), cy - int(h * 0.45)),
         (cx + int(w * 0.55), cy - int(h * 0.30)),
         (cx + int(w * 0.40), cy - int(h * 0.10)),
         (cx + int(w * 0.05), cy - int(h * 0.20))],
        fill=(255, 255, 255, 200)
    )
    hl = hl.filter(ImageFilter.GaussianBlur(3))
    img.alpha_composite(hl)

    # 4 mini sparkles autour
    for x, y, s in [
        (int(SIZE * 0.18), int(SIZE * 0.20), int(SIZE * 0.04)),
        (int(SIZE * 0.82), int(SIZE * 0.18), int(SIZE * 0.035)),
        (int(SIZE * 0.20), int(SIZE * 0.85), int(SIZE * 0.035)),
        (int(SIZE * 0.83), int(SIZE * 0.83), int(SIZE * 0.04)),
    ]:
        sd = ImageDraw.Draw(img)
        sd.polygon([(x, y - s), (x + s * 0.18, y),
                    (x, y + s), (x - s * 0.18, y)],
                   fill=(255, 255, 255, 230))
        sd.polygon([(x - s, y), (x, y - s * 0.18),
                    (x + s, y), (x, y + s * 0.18)],
                   fill=(255, 255, 255, 230))

    return apply_mask(img)


# ------------------------------------------------------------------
# D — Médaille (cercle doré + éclat central, sans lettre)
# ------------------------------------------------------------------
def variant_medal() -> Image.Image:
    img = make_bg(SIZE).convert("RGBA")
    cx, cy = SIZE // 2, int(SIZE * 0.50)
    radius = int(SIZE * 0.30)

    # Halo
    halo = Image.new("RGBA", img.size, (0, 0, 0, 0))
    hd = ImageDraw.Draw(halo)
    hd.ellipse((cx - radius * 1.5, cy - radius * 1.5,
                cx + radius * 1.5, cy + radius * 1.5),
               fill=(*PINK_GLOW, 90))
    halo = halo.filter(ImageFilter.GaussianBlur(30))
    img.alpha_composite(halo)

    # Cercle doré (gradient haut-bas)
    disk = Image.new("RGBA", img.size, (0, 0, 0, 0))
    dd = ImageDraw.Draw(disk)
    for i in range(radius * 2):
        t = i / (radius * 2)
        r_col = int(GOLD[0] * (1 - t) + GOLD_DEEP[0] * t)
        g_col = int(GOLD[1] * (1 - t) + GOLD_DEEP[1] * t)
        b_col = int(GOLD[2] * (1 - t) + GOLD_DEEP[2] * t)
        dy = i - radius
        if abs(dy) > radius:
            continue
        dx = int(math.sqrt(radius * radius - dy * dy))
        dd.line((cx - dx, cy - radius + i, cx + dx, cy - radius + i),
                fill=(r_col, g_col, b_col, 255))
    img.alpha_composite(disk)

    # Bord plus sombre
    d = ImageDraw.Draw(img)
    d.ellipse((cx - radius, cy - radius, cx + radius, cy + radius),
              outline=(*GOLD_DEEP, 200), width=6)

    # Étoile blanche centrale rayonnante
    star_size = int(radius * 0.55)
    for layer_alpha, layer_size in [(80, int(star_size * 1.4)),
                                     (140, int(star_size * 1.15)),
                                     (255, star_size)]:
        sd = ImageDraw.Draw(img)
        sd.polygon([(cx, cy - layer_size),
                    (cx + layer_size * 0.18, cy),
                    (cx, cy + layer_size),
                    (cx - layer_size * 0.18, cy)],
                   fill=(255, 255, 255, layer_alpha))
        sd.polygon([(cx - layer_size, cy),
                    (cx, cy - layer_size * 0.18),
                    (cx + layer_size, cy),
                    (cx, cy + layer_size * 0.18)],
                   fill=(255, 255, 255, layer_alpha))

    # Highlight en haut du disque
    hl = Image.new("RGBA", img.size, (0, 0, 0, 0))
    ImageDraw.Draw(hl).ellipse(
        (cx - radius * 0.7, cy - radius * 0.95,
         cx + radius * 0.7, cy - radius * 0.3),
        fill=(255, 255, 255, 130))
    hl = hl.filter(ImageFilter.GaussianBlur(15))
    img.alpha_composite(hl)

    return apply_mask(img)


# ------------------------------------------------------------------
# E — Étoile filante avec traînée
# ------------------------------------------------------------------
def variant_shooting_star() -> Image.Image:
    img = make_bg(SIZE, soft=True).convert("RGBA")

    # Quelques étoiles en fond
    bg = Image.new("RGBA", img.size, (0, 0, 0, 0))
    bd = ImageDraw.Draw(bg)
    for x, y, r in [
        (int(SIZE * 0.15), int(SIZE * 0.20), 4),
        (int(SIZE * 0.85), int(SIZE * 0.30), 5),
        (int(SIZE * 0.12), int(SIZE * 0.65), 3),
        (int(SIZE * 0.78), int(SIZE * 0.78), 4),
        (int(SIZE * 0.30), int(SIZE * 0.85), 4),
        (int(SIZE * 0.62), int(SIZE * 0.13), 3),
    ]:
        bd.ellipse((x - r, y - r, x + r, y + r), fill=(255, 255, 255, 220))
    img.alpha_composite(bg)

    # Étoile principale (en haut-droite, tête de la traînée)
    sx, sy = int(SIZE * 0.66), int(SIZE * 0.34)
    star_size = int(SIZE * 0.18)

    # Traînée — partant de bas-gauche vers l'étoile
    trail = Image.new("RGBA", img.size, (0, 0, 0, 0))
    td = ImageDraw.Draw(trail)
    end_x, end_y = int(SIZE * 0.20), int(SIZE * 0.78)
    # Largeur dégressive
    steps = 50
    for i in range(steps):
        t = i / steps
        # interpolation
        x = end_x + (sx - end_x) * t
        y = end_y + (sy - end_y) * t
        w = int(2 + 30 * t)
        a = int(60 + 195 * t)
        td.ellipse((x - w, y - w, x + w, y + w),
                   fill=(255, 240, 200, a))
    trail = trail.filter(ImageFilter.GaussianBlur(8))
    img.alpha_composite(trail)

    # Halo autour de l'étoile
    halo = Image.new("RGBA", img.size, (0, 0, 0, 0))
    hd = ImageDraw.Draw(halo)
    hd.ellipse((sx - star_size * 2, sy - star_size * 2,
                sx + star_size * 2, sy + star_size * 2),
               fill=(*GOLD, 130))
    halo = halo.filter(ImageFilter.GaussianBlur(28))
    img.alpha_composite(halo)

    # Étoile à 4 branches blanche/dorée
    for layer_alpha, layer_size, color in [
        (140, int(star_size * 1.3), GOLD),
        (255, star_size, WHITE),
    ]:
        sd = ImageDraw.Draw(img)
        sd.polygon([(sx, sy - layer_size),
                    (sx + layer_size * 0.18, sy),
                    (sx, sy + layer_size),
                    (sx - layer_size * 0.18, sy)],
                   fill=(*color, layer_alpha))
        sd.polygon([(sx - layer_size, sy),
                    (sx, sy - layer_size * 0.18),
                    (sx + layer_size, sy),
                    (sx, sy + layer_size * 0.18)],
                   fill=(*color, layer_alpha))

    return apply_mask(img)


def main():
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    variant_crystal().save(OUT_DIR / "B-cristal.png", "PNG")
    variant_medal().save(OUT_DIR / "D-medaille.png", "PNG")
    variant_shooting_star().save(OUT_DIR / "E-etoile-filante.png", "PNG")
    print(f"OK 3 variantes dans {OUT_DIR}")


if __name__ == "__main__":
    main()
