import 'dart:math';
import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  ArrowPainter({
    required this.start,
    required this.end,
    this.color = Colors.green,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0 // You can adjust the line thickness here
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(end.dx, end.dy); // Starting point of the arrow line

    // Calculate the control point for the curve
    double midX = (start.dx + end.dx) / 2;
    double midY = (start.dy + end.dy) / 2;
    double controlX = midX;
    double controlY = end.dy - 50; // Adjust for desired curvature

    // Draw the main line of the arrow
    path.quadraticBezierTo(controlX, controlY, start.dx, start.dy);

    // Calculate the angle for the arrowhead at the target end
    final double arrowLength = 20.0; // Length of the arrow side lines
    double angle = atan2(start.dy - controlY, start.dx - controlX);

    // Calculate points for the '>' style arrow
    Offset arrowPoint1 = Offset(start.dx - arrowLength * cos(angle - pi / 4),
        start.dy - arrowLength * sin(angle - pi / 4));

    Offset arrowPoint2 = Offset(start.dx - arrowLength * cos(angle + pi / 4),
        start.dy - arrowLength * sin(angle + pi / 4));

    // Draw the two sides of the arrow
    path.moveTo(start.dx, start.dy);
    path.lineTo(arrowPoint1.dx, arrowPoint1.dy);

    path.moveTo(start.dx, start.dy);
    path.lineTo(arrowPoint2.dx, arrowPoint2.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
