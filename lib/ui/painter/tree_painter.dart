import 'package:flutter/material.dart';
import '../../models/graph_node.dart';

class TreePainter extends CustomPainter {
  final GraphNode root;
  final Map<int, Offset> positions;
  final int activeId;

  TreePainter({
    required this.root,
    required this.positions,
    required this.activeId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.6)
      ..strokeWidth = 2.0;

    void drawEdges(GraphNode parent) {
      final parentPos = positions[parent.id]!;
      for (final child in parent.children) {
        final childPos = positions[child.id]!;
        canvas.drawLine(parentPos, childPos, linePaint);
        drawEdges(child);
      }
    }

    drawEdges(root);

    for (final entry in positions.entries) {
      final id = entry.key;
      final pos = entry.value;

      final fill = Paint()..color = Colors.white;

      // Base stroke
      final stroke = Paint()
        ..color = Colors.indigo
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      // Draw the circle
      canvas.drawCircle(pos, 22, fill);
      canvas.drawCircle(pos, 22, stroke);

      // If this is the active node, draw glowing border
      if (id == activeId) {
        final glow = Paint()
          ..color = Colors.orange.withOpacity(0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

        canvas.drawCircle(pos, 22, glow);

        // Draw a sharper border on top of glow
        final border = Paint()
          ..color = Colors.orange
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;

        canvas.drawCircle(pos, 22, border);
      }

      // Draw text
      final textSpan = TextSpan(
        text: id.toString(),
        style: TextStyle(
          color: Colors.indigo.shade700,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      );
      final tp = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
