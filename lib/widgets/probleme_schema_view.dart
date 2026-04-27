import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/problemes_data.dart';
import '../theme/app_theme.dart';

/// Vue d'un schéma géométrique pour illustrer un problème.
class ProblemeSchemaView extends StatelessWidget {
  const ProblemeSchemaView({super.key, required this.schema});

  final ProblemeSchema schema;

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
        child: CustomPaint(
          painter: _SchemaPainter(schema: schema),
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
}
