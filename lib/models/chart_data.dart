/// 表示柱状图中的单个数据点
class ChartDataPoint {
  /// 此数据点的标签（显示在X轴上）
  final String label;
  
  /// 此数据点的值（柱子的高度）
  final double value;
  
  /// 此特定柱子的可选颜色
  final String? color;
  
  /// 此柱子的可选提示文本
  final String? tooltip;

  const ChartDataPoint({
    required this.label,
    required this.value,
    this.color,
    this.tooltip,
  });

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartDataPoint(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
      color: json['color'] as String?,
      tooltip: json['tooltip'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      if (color != null) 'color': color,
      if (tooltip != null) 'tooltip': tooltip,
    };
  }
}

/// 表示完整的图表数据结构
class ChartData {
  /// 图表的标题
  final String title;
  
  /// 图表的数据点列表
  final List<ChartDataPoint> data;
  
  /// 图表的可选副标题
  final String? subtitle;
  
  /// 数值的可选单位（例如："kg"、"$"、"%"）
  final String? unit;

  const ChartData({
    required this.title,
    required this.data,
    this.subtitle,
    this.unit,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      title: json['title'] as String,
      data: (json['data'] as List)
          .map((item) => ChartDataPoint.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtitle: json['subtitle'] as String?,
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'data': data.map((item) => item.toJson()).toList(),
      if (subtitle != null) 'subtitle': subtitle,
      if (unit != null) 'unit': unit,
    };
  }
}
