import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/chart_data.dart';
import '../models/chart_style.dart';

/// 可自定义的柱状图小部件
class BarChartWidget extends StatefulWidget {
  /// 要在图表中显示的数据
  final ChartData data;

  /// 图表的样式配置
  final ChartStyle? chartStyle;

  /// 柱子的样式配置
  final BarStyle? barStyle;

  /// 坐标轴的样式配置
  final AxisStyle? axisStyle;

  /// 标题的样式配置
  final TitleStyle? titleStyle;

  /// 提示框的样式配置
  final TooltipStyle? tooltipStyle;

  /// 柱子备注的样式配置
  final RemarksStyle? remarksStyle;

  const BarChartWidget({
    super.key,
    required this.data,
    this.chartStyle,
    this.barStyle,
    this.axisStyle,
    this.titleStyle,
    this.tooltipStyle,
    this.remarksStyle,
  });

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _hoveredBar;
  late ChartStyle chartStyle;
  late BarStyle barStyle;
  late AxisStyle axisStyle;
  late TitleStyle titleStyle;
  late TooltipStyle tooltipStyle;
  late RemarksStyle remarksStyle;
  double padding = 20.0;
  late double chartWidth;
  late double chartHeight;

  @override
  void initState() {
    super.initState();
    chartStyle = widget.chartStyle ?? const ChartStyle();
    barStyle = widget.barStyle ?? BarStyle();
    axisStyle = widget.axisStyle ?? const AxisStyle();
    titleStyle = widget.titleStyle ?? const TitleStyle();
    tooltipStyle = widget.tooltipStyle ?? const TooltipStyle();
    remarksStyle = widget.remarksStyle ?? const RemarksStyle();
    _animationController = AnimationController(
      duration: widget.barStyle?.animationDuration ?? const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.barStyle?.animationCurve ?? Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: chartStyle.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTitle(titleStyle),
          Expanded(
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(TitleStyle titleStyle) {
    return Padding(
      padding: titleStyle.padding,
      child: Column(
        children: [
          Text(
            widget.data.title,
            style: TextStyle(
              color: titleStyle.color,
              fontSize: titleStyle.fontSize,
              fontWeight: titleStyle.fontWeight,
            ),
            textAlign: titleStyle.alignment,
          ),
          if (widget.data.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.data.subtitle!,
              style: TextStyle(
                color: titleStyle.color.withOpacity(0.7),
                fontSize: titleStyle.fontSize * 0.8,
                fontWeight: FontWeight.normal,
              ),
              textAlign: titleStyle.alignment,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChart() {
    final maxValue = widget.data.data.map((e) => e.value).reduce(math.max);
    final minValue = widget.data.data.map((e) => e.value).reduce(math.min);
    final valueRange = maxValue - minValue;

    return LayoutBuilder(
      builder: (context, constraints) {
        chartWidth = constraints.maxWidth - padding * 2;
        chartHeight = constraints.maxHeight - padding * 2;
        final barWidth = (chartWidth - (widget.data.data.length - 1) * barStyle.spacing) / widget.data.data.length;

        return Stack(
          children: [
            // 网格线
            if (axisStyle.showGrid) _buildGridLines(),

            // Y轴标签
            _buildYAxisLabels(maxValue, minValue, valueRange),

            // Y轴刻度
            _buildYAxisScales(maxValue, minValue, valueRange),

            // 柱子
            Positioned(
              left: padding,
              top: padding,
              child: SizedBox(
                width: chartWidth,
                height: chartHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.data.data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final dataPoint = entry.value;
                    final barHeight = valueRange > 0 ? (dataPoint.value - minValue) / valueRange * chartHeight : 0.0;

                    return Container(
                      width: barWidth,
                      margin: EdgeInsets.only(
                        right: index < widget.data.data.length - 1 ? barStyle.spacing : 0,
                      ),
                      child: _buildBar(
                        dataPoint,
                        barHeight,
                        maxValue,
                        barWidth,
                        chartHeight,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            Positioned(
              left: padding,
              top: padding,
              child: SizedBox(
                width: chartWidth,
                height: chartHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.data.data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final dataPoint = entry.value;
                    final barHeight = valueRange > 0 ? (dataPoint.value - minValue) / valueRange * chartHeight : 0.0;

                    return Container(
                      width: barWidth,
                      margin: EdgeInsets.only(
                        right: index < widget.data.data.length - 1 ? barStyle.spacing : 0,
                      ),
                      child: _buildBar(
                        dataPoint,
                        barHeight,
                        maxValue,
                        barWidth,
                        chartHeight,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // X轴标签
            _buildXAxisLabels(chartWidth, chartHeight, padding, barWidth),

            // 坐标轴
            if (axisStyle.showAxis) _buildAxisLines(axisStyle, chartWidth, chartHeight, padding),
          ],
        );
      },
    );
  }

  Widget _buildAxisLines(AxisStyle axisStyle, double chartWidth, double chartHeight, double padding) {
    return Positioned(
      left: padding,
      bottom: padding,
      child: SizedBox(
        width: chartWidth + axisStyle.overWidth,
        height: chartHeight + axisStyle.overWidth,
        child: CustomPaint(
          painter: AxisLinesPainter(
            color: axisStyle.color,
            strokeWidth: axisStyle.gridWidth,
          ),
        ),
      ),
    );
  }

  Widget _buildGridLines() {
    return Positioned(
      left: padding,
      top: padding,
      child: SizedBox(
        width: chartWidth,
        height: chartHeight,
        child: CustomPaint(
          painter: GridLinesPainter(
            color: axisStyle.gridColor,
            strokeWidth: axisStyle.gridWidth,
            gridCountX: axisStyle.gridCountX,
            gridCountY: axisStyle.gridCountY,
          ),
        ),
      ),
    );
  }

  Widget _buildYAxisLabels(double maxValue, double minValue, double valueRange) {
    return Positioned(
      left: 0,
      top: padding,
      child: SizedBox(
        width: padding,
        height: chartHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(axisStyle.gridCountX + 1, (index) {
            final value = maxValue - (valueRange * index / axisStyle.gridCountX);
            return Text(
              _formatValue(value, widget.data.unit),
              style: TextStyle(
                color: axisStyle.labelColor,
                fontSize: axisStyle.labelFontSize,
                fontWeight: axisStyle.labelFontWeight,
              ),
              textAlign: TextAlign.center,
            );
          }),
        ),
      ),
    );
  }

  Widget _buildYAxisScales(double maxValue, double minValue, double valueRange) {
    return Positioned(
      left: padding - 8,
      top: padding,
      child: SizedBox(
        width: padding,
        height: chartHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(axisStyle.gridCountX + 1, (index) {
            return Container(
              height: 1,
              width: 5,
              color: Colors.grey,
            );
          }),
        ),
      ),
    );
  }

  Widget _buildXAxisLabels(double chartWidth, double chartHeight, double padding, double barWidth) {
    return Positioned(
      left: padding,
      top: padding + chartHeight + 8,
      child: SizedBox(
        width: chartWidth,
        child: Row(
          children: widget.data.data.asMap().entries.map((entry) {
            final index = entry.key;
            final dataPoint = entry.value;

            return Container(
              width: barWidth,
              margin: EdgeInsets.only(
                right: index < widget.data.data.length - 1 ? (widget.barStyle?.spacing ?? 8.0) : 0,
              ),
              child: Text(
                dataPoint.label,
                style: TextStyle(
                  color: axisStyle.labelColor,
                  fontSize: axisStyle.labelFontSize,
                  fontWeight: axisStyle.labelFontWeight,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBar(ChartDataPoint dataPoint, double barHeight, double maxValue, double barWidth, double chartHeight) {
    final color = dataPoint.color != null ? Color(int.parse(dataPoint.color!.replaceFirst('#', '0xFF'))) : barStyle.color;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final animatedHeight = barHeight * _animation.value;

        return GestureDetector(
          onTap: () {
            if (tooltipStyle.showTooltip) {
              _showTooltip(context, dataPoint);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (dataPoint.remarks!.map((e) => e.toString()).toString().replaceAll(RegExp(r'^/[|/]$'), '').length * 5 <=
                  chartHeight - animatedHeight)
                Container(
                    alignment: Alignment.bottomCenter, height: chartHeight - animatedHeight, child: _buildRemarks(dataPoint)),
              Stack(
                children: [
                  Container(
                    width: barWidth,
                    height: animatedHeight,
                    decoration: BoxDecoration(
                      color: color,
                      border: barStyle.borderWidth > 0
                          ? Border.all(
                              color: barStyle.borderColor,
                              width: barStyle.borderWidth,
                            )
                          : null,
                      borderRadius: barStyle.borderRadius != null
                          ? BorderRadius.circular(barStyle.borderRadius!)
                          : barStyle.borderRadiusStyle,
                    ),
                  ),
                  if (dataPoint.remarks!.map((e) => e.toString()).toString().replaceAll(RegExp(r'^/[|/]$'), '').length * 5 >
                      chartHeight - animatedHeight)
                    Positioned(
                      child: Container(alignment: Alignment.center, child: _buildRemarks(dataPoint)),
                    )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRemarks(ChartDataPoint dataPoint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(
        dataPoint.remarks!.map((e) => e.toString()).toString().replaceAll(RegExp(r'^/[|/]$'), ''),
        style: TextStyle(
          color: remarksStyle.textColor,
          fontSize: remarksStyle.fontSize,
          fontWeight: remarksStyle.fontWeight,
        ),
      ),
    );
  }

  void _showTooltip(BuildContext context, ChartDataPoint dataPoint) {
    final tooltipText = dataPoint.tooltip ?? '${dataPoint.label}: ${_formatValue(dataPoint.value, widget.data.unit)}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(tooltipText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatValue(double value, String? unit) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M${unit ?? ''}';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K${unit ?? ''}';
    } else {
      return '${value.toStringAsFixed(0)}${unit ?? ''}';
    }
  }
}

/// 用于绘制网格线的自定义画笔
class GridLinesPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int gridCountX;
  final int gridCountY;

  GridLinesPainter({
    required this.color,
    required this.strokeWidth,
    required this.gridCountX,
    required this.gridCountY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // 绘制水平网格线
    for (int i = 0; i <= gridCountX; i++) {
      final y = size.height * i / gridCountX;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // 绘制竖直网格线
    for (int i = 0; i <= gridCountY; i++) {
      final x = size.width * i / gridCountY;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 用于绘制坐标轴的自定义画笔
class AxisLinesPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  AxisLinesPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final y = size.height;
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      paint,
    );
    final x = size.width * 0;
    canvas.drawLine(
      Offset(x, 0),
      Offset(x, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
