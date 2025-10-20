import 'package:flutter/material.dart';

/// 图表样式和外观的配置
class ChartStyle {
  /// 图表的背景颜色
  final Color backgroundColor;

  /// 图表边框的颜色
  final Color borderColor;

  /// 图表边框的宽度
  final double borderWidth;

  /// 图表的边框圆角
  final double borderRadius;

  /// 图表内部的填充
  final EdgeInsets padding;

  /// 图表周围的边距
  final EdgeInsets margin;

  const ChartStyle({
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(8.0),
  });
}

/// 柱子样式的配置
class BarStyle {
  /// 柱子的默认颜色
  final Color color;

  /// 柱子边框的宽度
  final double borderWidth;

  /// 柱子边框的颜色
  final Color borderColor;

  /// 柱子的边框样式
  final BorderRadius borderRadiusStyle;

  /// 柱子的边框圆角
  double? borderRadius;

  /// 柱子之间的间距
  final double spacing;

  /// 柱子出现的动画持续时间
  final Duration animationDuration;

  /// 柱子出现的动画曲线
  final Curve animationCurve;

  BarStyle({
    this.color = Colors.blue,
    this.borderWidth = 0.0,
    this.borderColor = Colors.transparent,
    this.borderRadiusStyle = const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
    this.borderRadius,
    this.spacing = 8.0,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationCurve = Curves.easeOutCubic,
  });
}

/// 坐标轴样式的配置
class AxisStyle {
  /// 坐标轴线条的颜色
  final Color color;

  /// 坐标轴线条的宽度
  final double width;

  /// 坐标轴标签的颜色
  final Color labelColor;

  /// 坐标轴标签的字体大小
  final double labelFontSize;

  /// 坐标轴标签的字体粗细
  final FontWeight labelFontWeight;

  /// 网格线的颜色
  final Color gridColor;

  /// 网格线的宽度
  final double gridWidth;

  /// 是否显示网格线
  final bool showGrid;

  /// 是否显示轴线
  final bool showAxis;

  /// 要显示的x轴网格线数量
  final int gridCountX;

  /// 要显示的y轴网格线数量
  final int gridCountY;

  const AxisStyle({
    this.color = Colors.black54,
    this.width = 1.0,
    this.labelColor = Colors.black87,
    this.labelFontSize = 12.0,
    this.labelFontWeight = FontWeight.normal,
    this.gridColor = Colors.grey,
    this.gridWidth = 0.5,
    this.showGrid = false,
    this.showAxis = true,
    this.gridCountX = 5,
    this.gridCountY = 8,
  });
}

/// 标题样式的配置
class TitleStyle {
  /// 标题文本的颜色
  final Color color;

  /// 标题的字体大小
  final double fontSize;

  /// 标题的字体粗细
  final FontWeight fontWeight;

  /// 标题的文本对齐方式
  final TextAlign alignment;

  /// 标题周围的填充
  final EdgeInsets padding;

  const TitleStyle({
    this.color = Colors.black87,
    this.fontSize = 18.0,
    this.fontWeight = FontWeight.bold,
    this.alignment = TextAlign.center,
    this.padding = const EdgeInsets.only(bottom: 16.0),
  });
}

/// 提示框样式的配置
class TooltipStyle {
  /// 提示框的背景颜色
  final Color backgroundColor;

  /// 提示框的文本颜色
  final Color textColor;

  /// 提示框文本的字体大小
  final double fontSize;

  /// 提示框的边框圆角
  final double borderRadius;

  /// 提示框内部的填充
  final EdgeInsets padding;

  /// 是否显示提示框
  final bool showTooltip;

  const TooltipStyle({
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    this.fontSize = 12.0,
    this.borderRadius = 4.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    this.showTooltip = true,
  });
}
