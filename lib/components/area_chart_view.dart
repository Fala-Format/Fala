import 'dart:ui';

import 'package:fala/mode/custom_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'dart:math';

const mainColor = Color(0xFFDC7938);

class AreaChartView extends StatelessWidget {
  final List<CustomDataChart> chartDatas;
  final double? hint;
  const AreaChartView(this.chartDatas, {super.key, this.hint = 0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      // 获取父组件的宽高
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;
      List<double> data = chartDatas.map((chart) => cubeRoot(chart.value ?? 0)).toList();
      double maxValue = data.max;
      double minValue = data.min;
      double chartHint = cubeRoot(hint ?? 0);
      List<Offset> points = data.mapIndexed((index, value){
        return Offset(width / (data.length - 1) * index, height - (value - minValue) / (maxValue - minValue) * height);
      }).toList();
      return Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(width, height), // 设置绘制区域大小
            painter: AreaChartPainter(points, hint: height - (chartHint - minValue) / (maxValue - minValue) * height),
          ),
          ...chartDatas.mapIndexed((index, chart) {
            if(chart.title?.isNotEmpty == true) {
              return Positioned(
                  left: points[index].dx,
                  bottom: 0,
                  child: Text(chart.title!, style: TextStyle(color: Colors.grey.withAlpha(125), fontSize: 10),)
              );
            } else {
              return SizedBox();
            }
          })
        ],
      );
    });
  }

  double cubeRoot(double num) {
    return num < 0 ? -pow(-num, 1 / 3).toDouble() : pow(num, 1 / 3).toDouble();
  }
}

class AreaChartPainter extends CustomPainter {
  final List<Offset> points;
  final double hint;
  const AreaChartPainter(this.points, {this.hint = 0});

  @override
  void paint(Canvas canvas, Size size) {
    // 创建 Path
    Path path = Path();
    path.moveTo(points.first.dx, points.first.dy); // 起始点
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy); // 连接数据点
    }
    path.lineTo(size.width, size.height); // 连接到底部右侧
    path.lineTo(0, size.height); // 连接到底部左侧
    path.close(); // 闭合路径

    // 填充颜色（面积部分）
    Rect gradientRect = Rect.fromLTWH(0, 0, size.width, size.height);
    Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          mainColor.withAlpha(153), // 顶部颜色
          mainColor.withAlpha(0), // 底部颜色
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(gradientRect)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 绘制折线
    Paint linePaint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    Path linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    Paint dashedLinePaint = Paint()
      ..color = Colors.grey.withAlpha(55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    Path dashedLinePath = Path();
    dashedLinePath.moveTo(0, hint);
    dashedLinePath.lineTo(size.width, hint);
    drawDashedLine(canvas, dashedLinePath, dashedLinePaint, dashWidth: 5, gapWidth: 3);
  }

  void drawDashedLine(Canvas canvas, Path path, Paint paint, {double dashWidth = 5, double gapWidth = 3}) {
    PathMetric pathMetric = path.computeMetrics().first;
    double distance = 0.0;
    while (distance < pathMetric.length) {
      final double nextSegment = distance + dashWidth;
      final bool isDash = nextSegment < pathMetric.length;
      if (isDash) {
        final Path extractPath = pathMetric.extractPath(distance, nextSegment);
        canvas.drawPath(extractPath, paint);
      }
      distance += dashWidth + gapWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}