import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/problemes_data.dart';
import '../theme/app_theme.dart';

/// Vue d'un schéma géométrique pour illustrer un problème. Affiche
/// optionnellement un emoji décoratif en haut-droite (option A légère).
class ProblemeSchemaView extends StatelessWidget {
  const ProblemeSchemaView({super.key, required this.schema, this.emoji});

  final ProblemeSchema schema;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.violet.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: _SchemaPainter(schema: schema)),
            ),
            if (emoji != null)
              Positioned(
                top: 0,
                right: 0,
                child: Text(emoji!, style: const TextStyle(fontSize: 26)),
              ),
          ],
        ),
      ),
    );
  }
}

class _SchemaPainter extends CustomPainter {
  _SchemaPainter({required this.schema});

  final ProblemeSchema schema;

  static final Paint _stroke = Paint()
    ..color = AppColors.violetDeep
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..strokeJoin = StrokeJoin.round;

  static final Paint _fill = Paint()
    ..color = AppColors.lavender100.withValues(alpha: 0.6)
    ..style = PaintingStyle.fill;

  static final Paint _dashed = Paint()
    ..color = AppColors.violet.withValues(alpha: 0.5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    switch (schema) {
      case RightTriangleSchema s:
        _paintRightTriangle(canvas, size, s);
      case ThalesSchema s:
        if (s.butterfly) {
          _paintThalesButterfly(canvas, size, s);
        } else {
          _paintThales(canvas, size, s);
        }
      case RightTriangleTrigSchema s:
        _paintRightTriangleTrig(canvas, size, s);
      case RectangleSchema s:
        _paintRectangle(canvas, size, s);
      case TriangleSchema s:
        _paintTriangle(canvas, size, s);
      case CircleSchema s:
        _paintCircle(canvas, size, s);
      case CuboidSchema s:
        _paintCuboid(canvas, size, s);
      case CylinderSchema s:
        _paintCylinder(canvas, size, s);
      case IllustratedSchema s:
        _paintIllustrated(canvas, size, s);
    }
  }

  @override
  bool shouldRepaint(covariant _SchemaPainter old) => old.schema != schema;

  // --- helpers ---

  void _drawLabel(
    Canvas canvas,
    String text,
    Offset position, {
    double fontSize = 13,
    Color color = AppColors.plumDark,
    Alignment alignment = Alignment.center,
  }) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.quicksand(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final double dx = position.dx - tp.width * (alignment.x + 1) / 2;
    final double dy = position.dy - tp.height * (alignment.y + 1) / 2;
    tp.paint(canvas, Offset(dx, dy));
  }

  void _drawRightAngleMark(Canvas canvas, Offset corner, Offset along1, Offset along2, {double size = 10}) {
    final Offset d1 = (along1 - corner);
    final Offset d2 = (along2 - corner);
    final Offset u1 = d1 / d1.distance * size;
    final Offset u2 = d2 / d2.distance * size;
    final Path p = Path()
      ..moveTo(corner.dx + u1.dx, corner.dy + u1.dy)
      ..lineTo(corner.dx + u1.dx + u2.dx, corner.dy + u1.dy + u2.dy)
      ..lineTo(corner.dx + u2.dx, corner.dy + u2.dy);
    canvas.drawPath(p, _stroke);
  }

  void _drawArc(Canvas canvas, Offset center, Offset p1, Offset p2,
      {double radius = 22, String? label}) {
    final double a1 = math.atan2(p1.dy - center.dy, p1.dx - center.dx);
    final double a2 = math.atan2(p2.dy - center.dy, p2.dx - center.dx);
    double sweep = a2 - a1;
    if (sweep < 0) sweep += math.pi * 2;
    if (sweep > math.pi) sweep -= math.pi * 2;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      a1,
      sweep,
      false,
      _stroke,
    );
    if (label != null) {
      final double mid = a1 + sweep / 2;
      final Offset lp = center + Offset(math.cos(mid), math.sin(mid)) * (radius + 14);
      _drawLabel(canvas, label, lp);
    }
  }

  // --- Right triangle (Pythagore) ---
  void _paintRightTriangle(Canvas canvas, Size size, RightTriangleSchema s) {
    const double pad = 26;
    final double w = size.width - pad * 2;
    final double h = size.height - pad * 2;
    final double side = math.min(w, h * 1.2);

    final Offset a = Offset(pad, pad + side * 0.7); // angle droit (bas-gauche)
    final Offset b = Offset(pad + side, pad + side * 0.7); // bas-droit
    final Offset c = Offset(pad, pad); // haut

    final Path tri = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..lineTo(c.dx, c.dy)
      ..close();
    canvas.drawPath(tri, _fill);
    canvas.drawPath(tri, _stroke);

    _drawRightAngleMark(canvas, a, b, c);

    // Sommets
    _drawLabel(canvas, 'A', a + const Offset(-12, 6), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'B', b + const Offset(8, 6), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'C', c + const Offset(-12, -10), fontSize: 11, color: AppColors.violet);

    if (s.legA != null) {
      _drawLabel(canvas, s.legA!, Offset((a.dx + b.dx) / 2, a.dy + 14));
    }
    if (s.legB != null) {
      _drawLabel(canvas, s.legB!, Offset(a.dx - 18, (a.dy + c.dy) / 2));
    }
    if (s.hypo != null) {
      _drawLabel(
        canvas,
        s.hypo!,
        Offset((b.dx + c.dx) / 2 + 14, (b.dy + c.dy) / 2 - 10),
      );
    }
  }

  // --- Right triangle trig ---
  void _paintRightTriangleTrig(Canvas canvas, Size size, RightTriangleTrigSchema s) {
    const double pad = 26;
    final double w = size.width - pad * 2;
    final double h = size.height - pad * 2;
    final double side = math.min(w, h * 1.2);

    final Offset a = Offset(pad, pad + side * 0.7); // angle droit
    final Offset b = Offset(pad + side, pad + side * 0.7); // l'angle marqué est ici
    final Offset c = Offset(pad, pad);

    final Path tri = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..lineTo(c.dx, c.dy)
      ..close();
    canvas.drawPath(tri, _fill);
    canvas.drawPath(tri, _stroke);

    _drawRightAngleMark(canvas, a, b, c);
    _drawArc(canvas, b, a, c, radius: 22, label: s.angleLabel);

    if (s.adjacent != null) {
      _drawLabel(canvas, s.adjacent!, Offset((a.dx + b.dx) / 2, a.dy + 14));
    }
    if (s.opposite != null) {
      _drawLabel(canvas, s.opposite!, Offset(a.dx - 18, (a.dy + c.dy) / 2));
    }
    if (s.hypotenuse != null) {
      _drawLabel(
        canvas,
        s.hypotenuse!,
        Offset((b.dx + c.dx) / 2 + 14, (b.dy + c.dy) / 2 - 10),
      );
    }
  }

  // --- Thalès (triangle avec parallèle) ---
  void _paintThales(Canvas canvas, Size size, ThalesSchema s) {
    const double pad = 26;
    final double w = size.width - pad * 2;
    final double h = size.height - pad * 2;

    // A en haut, B en bas-gauche, C en bas-droit
    final Offset apex = Offset(pad + w * 0.5, pad);
    final Offset bb = Offset(pad, pad + h);
    final Offset cc = Offset(pad + w, pad + h);

    // D sur [AB] à 45 % de A vers B, E sur [AC] à 45 %
    const double t = 0.5;
    final Offset d = Offset.lerp(apex, bb, t)!;
    final Offset e = Offset.lerp(apex, cc, t)!;

    final Path tri = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(bb.dx, bb.dy)
      ..lineTo(cc.dx, cc.dy)
      ..close();
    canvas.drawPath(tri, _fill);
    canvas.drawPath(tri, _stroke);
    canvas.drawLine(d, e, _stroke);

    _drawLabel(canvas, 'A', apex + const Offset(0, -12), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'B', bb + const Offset(-10, 6), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'C', cc + const Offset(10, 6), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'D', d + const Offset(-12, -2), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'E', e + const Offset(12, -2), fontSize: 11, color: AppColors.violet);

    // Étiquettes de longueurs
    if (s.ad != null) {
      _drawLabel(canvas, s.ad!, Offset((apex.dx + d.dx) / 2 - 12, (apex.dy + d.dy) / 2));
    }
    if (s.ab != null) {
      _drawLabel(canvas, s.ab!, Offset((apex.dx + bb.dx) / 2 - 18, (apex.dy + bb.dy) / 2 + 14));
    }
    if (s.ae != null) {
      _drawLabel(canvas, s.ae!, Offset((apex.dx + e.dx) / 2 + 14, (apex.dy + e.dy) / 2));
    }
    if (s.ac != null) {
      _drawLabel(canvas, s.ac!, Offset((apex.dx + cc.dx) / 2 + 18, (apex.dy + cc.dy) / 2 + 14));
    }
    if (s.de != null) {
      _drawLabel(canvas, s.de!, Offset((d.dx + e.dx) / 2, (d.dy + e.dy) / 2 - 12));
    }
    if (s.bc != null) {
      _drawLabel(canvas, s.bc!, Offset((bb.dx + cc.dx) / 2, bb.dy + 14));
    }
  }

  // --- Thalès papillon ---
  void _paintThalesButterfly(Canvas canvas, Size size, ThalesSchema s) {
    const double pad = 26;
    final double w = size.width - pad * 2;
    final double h = size.height - pad * 2;

    final Offset center = Offset(pad + w / 2, pad + h / 2);
    final Offset a = Offset(pad, pad + h * 0.15);
    final Offset b = Offset(pad + w, pad + h * 0.85);
    final Offset c = Offset(pad, pad + h * 0.85);
    final Offset d = Offset(pad + w, pad + h * 0.15);

    canvas.drawLine(a, b, _stroke);
    canvas.drawLine(c, d, _stroke);
    // Segments parallèles pointillés
    _drawDashedLine(canvas, a, d);
    _drawDashedLine(canvas, c, b);

    _drawLabel(canvas, 'O', center + const Offset(8, 8), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'A', a + const Offset(-12, -2), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'B', b + const Offset(10, 2), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'C', c + const Offset(-12, 6), fontSize: 11, color: AppColors.violet);
    _drawLabel(canvas, 'D', d + const Offset(10, -2), fontSize: 11, color: AppColors.violet);

    if (s.ad != null) {
      _drawLabel(canvas, s.ad!, Offset((a.dx + center.dx) / 2 - 8, (a.dy + center.dy) / 2 - 10));
    }
    if (s.ab != null) {
      _drawLabel(canvas, s.ab!, Offset((center.dx + b.dx) / 2 + 8, (center.dy + b.dy) / 2 + 10));
    }
    if (s.ae != null) {
      _drawLabel(canvas, s.ae!, Offset((c.dx + center.dx) / 2 - 8, (c.dy + center.dy) / 2 + 10));
    }
    if (s.ac != null) {
      _drawLabel(canvas, s.ac!, Offset((center.dx + d.dx) / 2 + 8, (center.dy + d.dy) / 2 - 10));
    }
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, {double dash = 6, double gap = 4}) {
    final double total = (b - a).distance;
    final Offset dir = (b - a) / total;
    double d = 0;
    while (d < total) {
      final double end = math.min(d + dash, total);
      canvas.drawLine(a + dir * d, a + dir * end, _dashed);
      d = end + gap;
    }
  }

  // --- Rectangle / carré ---
  void _paintRectangle(Canvas canvas, Size size, RectangleSchema s) {
    const double pad = 30;
    final double w = size.width - pad * 2;
    final double h = size.height - pad * 2;

    final Rect r = Rect.fromLTWH(pad, pad, w, h);
    canvas.drawRect(r, _fill);
    canvas.drawRect(r, _stroke);

    if (s.width != null) {
      _drawLabel(canvas, s.width!, Offset(r.center.dx, r.bottom + 14));
    }
    if (s.height != null) {
      _drawLabel(canvas, s.height!, Offset(r.left - 16, r.center.dy));
    }
  }

  // --- Triangle générique (base + hauteur) ---
  void _paintTriangle(Canvas canvas, Size size, TriangleSchema s) {
    const double pad = 26;
    final double w = size.width - pad * 2;
    final double h = size.height - pad * 2;

    final Offset b1 = Offset(pad, pad + h);
    final Offset b2 = Offset(pad + w, pad + h);
    final Offset apex = Offset(pad + w * 0.4, pad);

    final Path tri = Path()
      ..moveTo(b1.dx, b1.dy)
      ..lineTo(b2.dx, b2.dy)
      ..lineTo(apex.dx, apex.dy)
      ..close();
    canvas.drawPath(tri, _fill);
    canvas.drawPath(tri, _stroke);

    // Trait de hauteur
    final Offset foot = Offset(apex.dx, b1.dy);
    _drawDashedLine(canvas, apex, foot);
    _drawRightAngleMark(canvas, foot, b2, apex, size: 8);

    if (s.base != null) {
      _drawLabel(canvas, s.base!, Offset((b1.dx + b2.dx) / 2, b1.dy + 14));
    }
    if (s.height != null) {
      _drawLabel(canvas, s.height!, Offset(apex.dx + 12, (apex.dy + foot.dy) / 2));
    }
  }

  // --- Cercle / disque ---
  void _paintCircle(Canvas canvas, Size size, CircleSchema s) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double r = math.min(size.width, size.height) / 2 - 18;
    canvas.drawCircle(center, r, _fill);
    canvas.drawCircle(center, r, _stroke);

    final Offset edge = center + Offset(r, 0);
    canvas.drawLine(center, edge, _stroke);
    canvas.drawCircle(center, 2.5, _stroke..style = PaintingStyle.fill);
    _stroke.style = PaintingStyle.stroke;

    if (s.radius != null) {
      _drawLabel(canvas, s.radius!, Offset((center.dx + edge.dx) / 2, center.dy - 12));
    }
  }

  // --- Pavé / cube en perspective cavalière ---
  void _paintCuboid(Canvas canvas, Size size, CuboidSchema s) {
    const double pad = 22;
    final double w = size.width - pad * 2;
    final double h = size.height - pad * 2;

    // Profondeur en perspective
    final double depth = w * 0.25;
    final double rectW = w - depth;
    final double rectH = h - depth;

    final Offset a = Offset(pad, pad + depth);
    final Offset b = Offset(pad + rectW, pad + depth);
    final Offset c = Offset(pad + rectW, pad + depth + rectH);
    final Offset d = Offset(pad, pad + depth + rectH);
    final Offset a2 = a + Offset(depth, -depth);
    final Offset b2 = b + Offset(depth, -depth);
    final Offset d2 = d + Offset(depth, -depth);

    // Faces visibles
    canvas.drawPath(
      Path()..moveTo(a.dx, a.dy)..lineTo(b.dx, b.dy)..lineTo(c.dx, c.dy)..lineTo(d.dx, d.dy)..close(),
      _fill,
    );
    // Face avant
    canvas.drawRect(Rect.fromPoints(a, c), _stroke);
    // Arêtes haute et droite
    canvas.drawLine(a, a2, _stroke);
    canvas.drawLine(b, b2, _stroke);
    canvas.drawLine(a2, b2, _stroke);
    canvas.drawLine(b2, b, _stroke);
    canvas.drawLine(d, d2, _dashed);
    canvas.drawLine(d2, a2, _dashed);
    canvas.drawLine(b2, Offset(b2.dx, b2.dy + rectH), _dashed);

    if (s.length != null) {
      _drawLabel(canvas, s.length!, Offset((a.dx + b.dx) / 2, c.dy + 14));
    }
    if (s.height != null) {
      _drawLabel(canvas, s.height!, Offset(a.dx - 16, (a.dy + d.dy) / 2));
    }
    if (s.width != null) {
      _drawLabel(canvas, s.width!, Offset((a.dx + a2.dx) / 2 + 8, (a.dy + a2.dy) / 2 - 10));
    }
  }

  // --- Cylindre ---
  void _paintCylinder(Canvas canvas, Size size, CylinderSchema s) {
    const double pad = 22;
    final double w = size.width - pad * 2;

    final double rx = w / 3;
    final double ry = rx * 0.32;

    final Offset top = Offset(size.width / 2, pad + ry);
    final Offset bottom = Offset(size.width / 2, size.height - pad - ry);

    // Côtés
    final Path body = Path()
      ..moveTo(top.dx - rx, top.dy)
      ..lineTo(bottom.dx - rx, bottom.dy)
      ..arcToPoint(Offset(bottom.dx + rx, bottom.dy),
          radius: Radius.elliptical(rx, ry), clockwise: false)
      ..lineTo(top.dx + rx, top.dy)
      ..arcToPoint(Offset(top.dx - rx, top.dy),
          radius: Radius.elliptical(rx, ry), clockwise: true)
      ..close();
    canvas.drawPath(body, _fill);
    canvas.drawPath(body, _stroke);

    // Ellipse arrière du dessus (pointillée)
    final Rect topEll = Rect.fromCenter(center: top, width: rx * 2, height: ry * 2);
    final Path topBack = Path()..addArc(topEll, 0, math.pi);
    canvas.drawPath(topBack, _dashed);

    if (s.radius != null) {
      // Trait du rayon dans le haut
      canvas.drawLine(top, Offset(top.dx + rx, top.dy), _stroke);
      _drawLabel(canvas, s.radius!, Offset(top.dx + rx / 2, top.dy - 12));
    }
    if (s.height != null) {
      _drawLabel(canvas, s.height!, Offset(top.dx + rx + 16, (top.dy + bottom.dy) / 2));
    }
  }

  // ────────────── Scènes illustrées (option B) ──────────────
  void _paintIllustrated(Canvas canvas, Size size, IllustratedSchema s) {
    switch (s.kind) {
      case IllustratedKind.ladderWall:
        _paintLadderWall(canvas, size, s.labels);
      case IllustratedKind.pylon:
        _paintPylon(canvas, size, s.labels);
      case IllustratedKind.sail:
        _paintSail(canvas, size, s.labels);
      case IllustratedKind.cableCar:
        _paintCableCar(canvas, size, s.labels);
      case IllustratedKind.roof:
        _paintRoof(canvas, size, s.labels);
      case IllustratedKind.pizza:
        _paintPizza(canvas, size, s.labels);
      case IllustratedKind.pool:
        _paintPool(canvas, size, s.labels);
      case IllustratedKind.tank:
        _paintTank(canvas, size, s.labels);
      case IllustratedKind.crate:
        _paintCrate(canvas, size, s.labels);
      case IllustratedKind.field:
        _paintField(canvas, size, s.labels);
    }
  }

  Paint _paintFill(Color c) =>
      Paint()..style = PaintingStyle.fill..color = c;

  // Échelle contre mur
  void _paintLadderWall(Canvas canvas, Size size, Map<String, String> labels) {
    final double pad = 18;
    final double groundY = size.height - 28;
    // Sol
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, size.width, size.height - groundY),
      _paintFill(const Color(0xFFB8E0BC)),
    );
    // Mur (briques rosées)
    final double wallX = size.width * 0.62;
    final Rect wall = Rect.fromLTRB(wallX, pad, size.width - pad, groundY);
    canvas.drawRect(wall, _paintFill(const Color(0xFFD2899A)));
    final Paint mortar = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFFB76C82);
    final double brickH = (groundY - pad) / 7;
    for (int row = 0; row < 7; row++) {
      final double y = pad + row * brickH;
      final double offset = (row % 2) * brickH;
      for (double x = wallX - offset; x < size.width; x += brickH * 1.6) {
        canvas.drawRect(
          Rect.fromLTWH(x, y, brickH * 1.6, brickH),
          mortar,
        );
      }
    }
    // Échelle
    final Offset foot = Offset(wallX - (groundY - pad) * 0.75, groundY);
    final Offset top = Offset(wallX, groundY - (groundY - pad));
    final Offset dir = top - foot;
    final double len = dir.distance;
    final Offset u = Offset(dir.dx / len, dir.dy / len);
    final Offset n = Offset(-u.dy, u.dx);
    const double gap = 7;
    final Paint ladderPaint = Paint()
      ..color = AppColors.violetDeep
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    for (final double sign in <double>[-1, 1]) {
      canvas.drawLine(foot + n * gap * sign, top + n * gap * sign, ladderPaint);
    }
    final Paint rungPaint = Paint()
      ..color = AppColors.violetDeep
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    for (int i = 1; i <= 7; i++) {
      final double t = i / 8;
      final Offset c = foot + dir * t;
      canvas.drawLine(c + n * gap, c - n * gap, rungPaint);
    }
    // Marqueur d'angle droit
    canvas.drawRect(
      Rect.fromLTWH(wallX - 10, groundY - 10, 10, 10),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.violetDeep,
    );
    // Étiquettes
    if (labels['base'] != null) {
      _drawLabelChip(canvas, '${labels['base']} m',
          Offset((foot.dx + wallX) / 2, groundY + 14));
    }
    if (labels['height'] != null) {
      _drawLabelChip(canvas, '${labels['height']} m',
          Offset(wallX + 22, (top.dy + groundY) / 2));
    }
    if (labels['ladder'] != null) {
      _drawLabelChip(
          canvas,
          '${labels['ladder']} m',
          Offset((foot.dx + top.dx) / 2 - 30, (foot.dy + top.dy) / 2 - 18),
          color: AppColors.danger);
    }
  }

  // Pylône avec câble hauban
  void _paintPylon(Canvas canvas, Size size, Map<String, String> labels) {
    final double groundY = size.height - 24;
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, size.width, size.height - groundY),
      _paintFill(const Color(0xFFB8E0BC)),
    );
    final double baseX = size.width * 0.30;
    final Offset top = Offset(baseX, 26);
    final Offset bottom = Offset(baseX, groundY);
    // Pylône (rectangle gris)
    canvas.drawRect(
      Rect.fromLTRB(baseX - 6, top.dy, baseX + 6, bottom.dy),
      _paintFill(const Color(0xFF9B7FE8)),
    );
    // Câble hauban
    final Offset anchor = Offset(size.width - 30, groundY);
    canvas.drawLine(top, anchor, _stroke);
    // Marqueur d'angle droit
    canvas.drawRect(
      Rect.fromLTWH(baseX, groundY - 10, 10, 10),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.violetDeep,
    );
    // Étiquettes
    if (labels['base'] != null) {
      _drawLabelChip(canvas, '${labels['base']} m',
          Offset((baseX + anchor.dx) / 2, groundY + 14));
    }
    if (labels['mast'] != null) {
      _drawLabelChip(canvas, '${labels['mast']} m',
          Offset(baseX - 28, (top.dy + bottom.dy) / 2));
    }
    if (labels['cable'] != null) {
      _drawLabelChip(
          canvas,
          '${labels['cable']} m',
          Offset((top.dx + anchor.dx) / 2, (top.dy + anchor.dy) / 2 - 14),
          color: AppColors.danger);
    }
  }

  // Voile triangulaire sur mât
  void _paintSail(Canvas canvas, Size size, Map<String, String> labels) {
    final double groundY = size.height - 18;
    // Eau
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, size.width, size.height - groundY),
      _paintFill(const Color(0xFF8FCDE5)),
    );
    // Bateau (trapèze)
    final double boatLeft = size.width * 0.20;
    final double boatRight = size.width * 0.80;
    final Path boat = Path()
      ..moveTo(boatLeft, groundY)
      ..lineTo(boatRight, groundY)
      ..lineTo(boatRight - 14, groundY + 14)
      ..lineTo(boatLeft + 14, groundY + 14)
      ..close();
    canvas.drawPath(boat, _paintFill(const Color(0xFF7B2D8F)));
    // Mât AB (vertical)
    final double mastX = (boatLeft + boatRight) / 2;
    final Offset a = Offset(mastX, 22);
    final Offset b = Offset(mastX, groundY);
    canvas.drawLine(a, b, _stroke);
    // Voile triangulaire — A en haut, B en bas, C à droite (C = boatRight, groundY)
    final Offset c = Offset(boatRight - 8, groundY - 4);
    final Path sail = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(b.dx, b.dy)
      ..lineTo(c.dx, c.dy)
      ..close();
    canvas.drawPath(sail, _paintFill(const Color(0xFFF6F0FF)));
    canvas.drawPath(sail, _stroke);
    // Bout DE parallèle à BC (au tiers)
    final double t = 0.4;
    final Offset d = Offset.lerp(a, b, t)!;
    final Offset e = Offset.lerp(a, c, t)!;
    canvas.drawLine(d, e, _stroke);
    // Étiquettes
    if (labels['ad'] != null) {
      _drawLabelChip(canvas, '${labels['ad']} m',
          Offset(a.dx - 22, (a.dy + d.dy) / 2));
    }
    if (labels['ab'] != null) {
      _drawLabelChip(canvas, '${labels['ab']} m',
          Offset(a.dx - 22, (d.dy + b.dy) / 2));
    }
    if (labels['de'] != null) {
      _drawLabelChip(canvas, '${labels['de']} m',
          Offset((d.dx + e.dx) / 2, (d.dy + e.dy) / 2 - 14),
          color: AppColors.danger);
    }
    if (labels['bc'] != null) {
      _drawLabelChip(canvas, '${labels['bc']} m',
          Offset((b.dx + c.dx) / 2, b.dy - 14));
    }
  }

  // Câble de télésiège (pente)
  void _paintCableCar(Canvas canvas, Size size, Map<String, String> labels) {
    final double groundY = size.height - 22;
    canvas.drawRect(
      Rect.fromLTWH(0, groundY, size.width, size.height - groundY),
      _paintFill(const Color(0xFFB8E0BC)),
    );
    final Offset bottom = Offset(28, groundY);
    final Offset top = Offset(size.width - 30, 36);
    // Pylônes verticaux
    canvas.drawLine(bottom, Offset(bottom.dx, bottom.dy - 30), _stroke);
    canvas.drawLine(top, Offset(top.dx, top.dy + 30), _stroke);
    // Triangle implicite : on dessine la base horizontale et la verticale en pointillés
    canvas.drawLine(
      bottom,
      Offset(top.dx, groundY),
      _dashed,
    );
    canvas.drawLine(
      Offset(top.dx, groundY),
      top,
      _dashed,
    );
    // Câble du télésiège
    canvas.drawLine(bottom, top, Paint()
      ..color = AppColors.violetDeep
      ..strokeWidth = 3);
    // Cabine au milieu
    final Offset cabin = Offset.lerp(bottom, top, 0.5)!;
    canvas.drawRect(
      Rect.fromCenter(center: cabin, width: 20, height: 12),
      _paintFill(AppColors.danger),
    );
    // Marqueur d'angle droit en bas-droit
    canvas.drawRect(
      Rect.fromLTWH(top.dx - 10, groundY - 10, 10, 10),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = AppColors.violetDeep,
    );
    // Arc d'angle au coin bas-gauche
    final Rect arc = Rect.fromCircle(center: bottom, radius: 22);
    final double a1 = -math.atan2(top.dy - bottom.dy, top.dx - bottom.dx);
    canvas.drawArc(arc, -a1 - 0.05, a1 - 0.05 + 0.05, false, _stroke);
    if (labels['angle'] != null) {
      _drawLabelChip(canvas, labels['angle']!,
          Offset(bottom.dx + 32, bottom.dy - 14));
    }
    if (labels['base'] != null) {
      _drawLabelChip(canvas, '${labels['base']} m',
          Offset((bottom.dx + top.dx) / 2, groundY + 14));
    }
    if (labels['cable'] != null) {
      _drawLabelChip(canvas, '${labels['cable']} m',
          Offset((bottom.dx + top.dx) / 2 - 18, (bottom.dy + top.dy) / 2 - 16),
          color: AppColors.danger);
    }
  }

  // Toit (triangle isocèle posé sur des murs)
  void _paintRoof(Canvas canvas, Size size, Map<String, String> labels) {
    final double pad = 22;
    final double baseY = size.height * 0.78;
    // Murs
    final double leftX = size.width * 0.18;
    final double rightX = size.width * 0.82;
    canvas.drawRect(
      Rect.fromLTRB(leftX, baseY, rightX, size.height - 12),
      _paintFill(const Color(0xFFE9D5FF)),
    );
    // Toit (triangle)
    final Offset l = Offset(leftX - 8, baseY);
    final Offset r = Offset(rightX + 8, baseY);
    final Offset apex = Offset((leftX + rightX) / 2, pad);
    final Path roof = Path()
      ..moveTo(l.dx, l.dy)
      ..lineTo(r.dx, r.dy)
      ..lineTo(apex.dx, apex.dy)
      ..close();
    canvas.drawPath(roof, _paintFill(const Color(0xFFD2899A)));
    canvas.drawPath(roof, _stroke);
    // Hauteur
    final Offset foot = Offset(apex.dx, baseY);
    canvas.drawLine(apex, foot, _dashed);
    // Arc d'angle à gauche
    final Rect arc = Rect.fromCircle(center: l, radius: 22);
    final double a1 = -math.atan2(apex.dy - l.dy, apex.dx - l.dx);
    canvas.drawArc(arc, -a1 - 0.05, a1 + 0.05, false, _stroke);
    if (labels['angle'] != null) {
      _drawLabelChip(canvas, labels['angle']!,
          Offset(l.dx + 30, l.dy - 14));
    }
    if (labels['rafter'] != null) {
      _drawLabelChip(canvas, '${labels['rafter']} m',
          Offset((l.dx + apex.dx) / 2 - 14, (l.dy + apex.dy) / 2),
          color: AppColors.danger);
    }
    if (labels['height'] != null) {
      _drawLabelChip(canvas, '${labels['height']} m',
          Offset(apex.dx + 16, (apex.dy + foot.dy) / 2));
    }
  }

  // Pizza (disque)
  void _paintPizza(Canvas canvas, Size size, Map<String, String> labels) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    final double r = math.min(size.width, size.height) / 2 - 24;
    // Croûte
    canvas.drawCircle(c, r, _paintFill(const Color(0xFFE8B889)));
    // Garniture
    canvas.drawCircle(c, r - 8, _paintFill(const Color(0xFFE76A4D)));
    // Pepperonis
    final Paint pep = _paintFill(const Color(0xFFA22D2D));
    for (final List<double> p in <List<double>>[
      <double>[-0.4, -0.2],
      <double>[0.3, -0.4],
      <double>[0.5, 0.2],
      <double>[-0.2, 0.4],
      <double>[0.0, 0.0],
      <double>[-0.5, 0.1],
    ]) {
      canvas.drawCircle(
          Offset(c.dx + p[0] * r * 0.7, c.dy + p[1] * r * 0.7), r * 0.10, pep);
    }
    // Rayon
    canvas.drawLine(c, Offset(c.dx + r, c.dy), _stroke);
    canvas.drawCircle(c, 3, _paintFill(AppColors.violetDeep));
    if (labels['radius'] != null) {
      _drawLabelChip(canvas, '${labels['radius']} cm',
          Offset(c.dx + r / 2, c.dy - 14));
    }
  }

  // Bassin circulaire vu de dessus
  void _paintPool(Canvas canvas, Size size, Map<String, String> labels) {
    final Offset c = Offset(size.width / 2, size.height / 2);
    final double r = math.min(size.width, size.height) / 2 - 22;
    // Margelle
    canvas.drawCircle(c, r + 6, _paintFill(const Color(0xFFD9C2FF)));
    // Eau
    canvas.drawCircle(c, r, _paintFill(const Color(0xFF6FB7DD)));
    // Vagues stylisées (arcs)
    final Paint wave = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    for (final double rr in <double>[r * 0.45, r * 0.65]) {
      canvas.drawArc(
          Rect.fromCircle(center: c, radius: rr), 0.4, 0.7, false, wave);
      canvas.drawArc(
          Rect.fromCircle(center: c, radius: rr), 2.4, 0.7, false, wave);
    }
    // Rayon
    canvas.drawLine(c, Offset(c.dx + r, c.dy), _stroke);
    canvas.drawCircle(c, 3, _paintFill(AppColors.violetDeep));
    if (labels['radius'] != null) {
      _drawLabelChip(canvas, '${labels['radius']} m',
          Offset(c.dx + r / 2, c.dy - 14));
    }
  }

  // Cuve cylindrique
  void _paintTank(Canvas canvas, Size size, Map<String, String> labels) {
    final double pad = 20;
    final double w = size.width - pad * 2;
    final double rx = w / 5;
    final double ry = rx * 0.32;
    final Offset top = Offset(size.width / 2, pad + ry);
    final Offset bottom = Offset(size.width / 2, size.height - pad - ry);
    // Corps
    final Path body = Path()
      ..moveTo(top.dx - rx, top.dy)
      ..lineTo(bottom.dx - rx, bottom.dy)
      ..arcToPoint(Offset(bottom.dx + rx, bottom.dy),
          radius: Radius.elliptical(rx, ry), clockwise: false)
      ..lineTo(top.dx + rx, top.dy)
      ..arcToPoint(Offset(top.dx - rx, top.dy),
          radius: Radius.elliptical(rx, ry), clockwise: true)
      ..close();
    canvas.drawPath(body, _paintFill(const Color(0xFFB6E1F5)));
    canvas.drawPath(body, _stroke);
    // Niveau d'eau (3/4)
    final double waterY = top.dy + (bottom.dy - top.dy) * 0.30;
    final Path water = Path()
      ..moveTo(top.dx - rx, waterY)
      ..lineTo(bottom.dx - rx, bottom.dy)
      ..arcToPoint(Offset(bottom.dx + rx, bottom.dy),
          radius: Radius.elliptical(rx, ry), clockwise: false)
      ..lineTo(top.dx + rx, waterY)
      ..arcToPoint(Offset(top.dx - rx, waterY),
          radius: Radius.elliptical(rx, ry * 0.7), clockwise: true)
      ..close();
    canvas.drawPath(water, _paintFill(const Color(0xFF4A9DC9)));
    // Ellipse arrière dessus pointillée
    canvas.drawPath(
      Path()
        ..addArc(
          Rect.fromCenter(center: top, width: rx * 2, height: ry * 2),
          0,
          math.pi,
        ),
      _dashed,
    );
    if (labels['radius'] != null) {
      canvas.drawLine(top, Offset(top.dx + rx, top.dy), _stroke);
      _drawLabelChip(canvas, '${labels['radius']} dm',
          Offset(top.dx + rx / 2, top.dy - 14));
    }
    if (labels['height'] != null) {
      _drawLabelChip(canvas, '${labels['height']} dm',
          Offset(top.dx + rx + 22, (top.dy + bottom.dy) / 2));
    }
  }

  // Caisse (pavé en perspective)
  void _paintCrate(Canvas canvas, Size size, Map<String, String> labels) {
    final double pad = 22;
    final double w = size.width - pad * 2;
    final double h = size.height - pad * 2;
    final double depth = w * 0.22;
    final double rectW = w - depth;
    final double rectH = h - depth;
    final Offset a = Offset(pad, pad + depth);
    final Offset b = Offset(pad + rectW, pad + depth);
    final Offset c = Offset(pad + rectW, pad + depth + rectH);
    final Offset d = Offset(pad, pad + depth + rectH);
    final Offset a2 = a + Offset(depth, -depth);
    final Offset b2 = b + Offset(depth, -depth);
    // Face avant (bois clair)
    canvas.drawRect(Rect.fromPoints(a, c),
        _paintFill(const Color(0xFFE8C57F)));
    // Dessus
    final Path top = Path()
      ..moveTo(a.dx, a.dy)
      ..lineTo(a2.dx, a2.dy)
      ..lineTo(b2.dx, b2.dy)
      ..lineTo(b.dx, b.dy)
      ..close();
    canvas.drawPath(top, _paintFill(const Color(0xFFD8AC60)));
    // Côté
    final Path side = Path()
      ..moveTo(b.dx, b.dy)
      ..lineTo(b2.dx, b2.dy)
      ..lineTo(b2.dx, b2.dy + rectH)
      ..lineTo(c.dx, c.dy)
      ..close();
    canvas.drawPath(side, _paintFill(const Color(0xFFB68345)));
    // Contours
    canvas.drawRect(Rect.fromPoints(a, c), _stroke);
    canvas.drawPath(top, _stroke);
    canvas.drawPath(side, _stroke);
    // Lattes
    for (int i = 1; i <= 3; i++) {
      final double y = a.dy + i * rectH / 4;
      canvas.drawLine(
          Offset(a.dx, y),
          Offset(b.dx, y),
          Paint()
            ..color = const Color(0xFFB68345)
            ..strokeWidth = 1.2);
    }
    if (labels['length'] != null) {
      _drawLabelChip(canvas, '${labels['length']} dm',
          Offset((a.dx + b.dx) / 2, c.dy + 14));
    }
    if (labels['height'] != null) {
      _drawLabelChip(canvas, '${labels['height']} dm',
          Offset(a.dx - 22, (a.dy + d.dy) / 2));
    }
    if (labels['width'] != null) {
      _drawLabelChip(canvas, '${labels['width']} dm',
          Offset((a.dx + a2.dx) / 2 + 6, (a.dy + a2.dy) / 2 - 12));
    }
  }

  // Terrain rectangulaire (vue plan)
  void _paintField(Canvas canvas, Size size, Map<String, String> labels) {
    final double pad = 26;
    final Rect r = Rect.fromLTRB(pad, pad, size.width - pad, size.height - pad);
    canvas.drawRect(r, _paintFill(const Color(0xFFB8E0BC)));
    canvas.drawRect(r, _stroke);
    // Diagonale
    canvas.drawLine(r.topLeft, r.bottomRight, Paint()
      ..color = AppColors.danger
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke);
    // Petits arbres décoratifs
    for (final List<double> p in <List<double>>[
      <double>[0.18, 0.18],
      <double>[0.82, 0.20],
      <double>[0.20, 0.80],
      <double>[0.78, 0.78],
    ]) {
      final Offset o = Offset(
          r.left + p[0] * r.width, r.top + p[1] * r.height);
      canvas.drawCircle(o, 6, _paintFill(const Color(0xFF4D7C45)));
    }
    if (labels['width'] != null) {
      _drawLabelChip(canvas, '${labels['width']} m',
          Offset(r.center.dx, r.bottom + 14));
    }
    if (labels['height'] != null) {
      _drawLabelChip(canvas, '${labels['height']} m',
          Offset(r.left - 22, r.center.dy));
    }
    if (labels['diag'] != null) {
      _drawLabelChip(canvas, '${labels['diag']} m',
          Offset(r.center.dx - 30, r.center.dy - 18),
          color: AppColors.danger);
    }
  }

  void _drawLabelChip(Canvas canvas, String text, Offset pos,
      {Color color = AppColors.plumDark}) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.quicksand(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final double pad = 6;
    final RRect bg = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: pos,
        width: tp.width + pad * 2,
        height: tp.height + pad,
      ),
      const Radius.circular(8),
    );
    canvas.drawRRect(bg,
        Paint()..color = Colors.white.withValues(alpha: 0.94));
    canvas.drawRRect(
        bg,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = color.withValues(alpha: 0.5));
    tp.paint(
        canvas, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }
}
