import 'dart:math';
import 'package:flutter/material.dart';

class RadarChartPainter extends CustomPainter {
  final int sides;
  final int levels;
  final int numberOfPolygons;
  final double radiusStep;
  final List<String> labels;
  final List<double> data;
  final List<double> avgData;
  final Color dataColor;
  final Color avgColor;

  final double legendSquareSize = 10;
  final double legendSpacing = 10;

  RadarChartPainter({
    required this.sides,
    required this.levels,
    required this.numberOfPolygons,
    required this.labels,
    required this.data,
    required this.avgData,
    required this.dataColor,
    required this.avgColor,
  }) : radiusStep = 90 / levels;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final linePaint = Paint()
      ..color = Color(0XFFD9D9D9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final dataPaint = Paint()
      ..color = dataColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final avgPaint = Paint()
      ..color = avgColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final double step = 2 * pi / sides;

    for (int j = 0; j < numberOfPolygons; j++) {
      final double radius = (j + 1) * radiusStep;
      final path = Path();

      for (int i = 0; i < sides; i++) {
        final angle = -pi / 2 + i * step;
        final xOffset = center.dx + radius * cos(angle);
        final yOffset = center.dy + radius * sin(angle);

        if (i == 0) {
          path.moveTo(xOffset, yOffset);
        } else {
          path.lineTo(xOffset, yOffset);
        }
      }
      path.close();

      canvas.drawPath(path, linePaint);
    }

    final labelRadius = (numberOfPolygons + 1) * radiusStep;
    final angleStep = 2 * pi / sides;
    final labelTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );

    for (int i = 0; i < sides; i++) {
      final angle = -pi / 2 + i * angleStep;
      final labelText = labels[i];

      final xOffset = center.dx + labelRadius * cos(angle);
      final yOffset = center.dy + labelRadius * sin(angle);

      final textSpan = TextSpan(
        text: labelText,
        style: labelTextStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final offset = Offset(
        xOffset - textPainter.width / 2,
        yOffset - textPainter.height / 2,
      );

      if (i == 0) {
        canvas.save();
        canvas.translate(offset.dx, offset.dy);
        textPainter.paint(canvas, Offset.zero);
        canvas.restore();
      } else {
        textPainter.paint(canvas, offset);
      }
    }

    //오각형으로 도형 그리기
    final dataPath = Path();
    for (int i = 0; i < sides; i++) {
      final angle = -pi / 2 + i * angleStep;
      final value = data[i];

      final x = center.dx + labelRadius * value * cos(angle);
      final y = center.dy + labelRadius * value * sin(angle);

      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, dataPaint);

    final avgDataPath = Path();
    for (int i = 0; i < sides; i++) {
      final angle = -pi / 2 + i * angleStep;
      final value = avgData[i];
      final x = center.dx + labelRadius * value * cos(angle);
      final y = center.dy + labelRadius * value * sin(angle);

      if (i == 0) {
        avgDataPath.moveTo(x, y);
      } else {
        avgDataPath.lineTo(x, y);
      }
    }
    avgDataPath.close();
    canvas.drawPath(avgDataPath, avgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PentagonRadarChart extends StatelessWidget {
  final List<double> data;
  final List<double> avgData;
  final int levels;
  final int numberOfPolygons;
  final List<String> labels;
  final Color dataColor;
  final Color avgColor;

  PentagonRadarChart({
    required this.data,
    required this.avgData,
    required this.levels,
    required this.numberOfPolygons,
    required this.labels,
    required this.dataColor,
    required this.avgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: RadarChartPainter(
              sides: 5,
              levels: levels,
              numberOfPolygons: numberOfPolygons,
              labels: labels,
              data: data,
              avgData: avgData,
              dataColor: dataColor,
              avgColor: avgColor,
            ),
          ),
        ),
        SizedBox(height: 50), // Add some spacing between chart and labels
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the labels horizontally
          children: [
            Container(
              color: dataColor,
              width: 10,
              height: 10,
            ),
            SizedBox(width: 5),
            Text('자녀', style: TextStyle(fontSize: 12)),
            SizedBox(width: 20), // Add spacing between labels
            Container(
              color: avgColor,
              width: 10,
              height: 10,
            ),
            SizedBox(width: 5),
            Text('연령대 평균', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
