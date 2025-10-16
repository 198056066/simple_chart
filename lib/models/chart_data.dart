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

/// 远程数据获取的配置
class RemoteConfig {
  /// 获取数据的URL地址
  final String url;
  
  /// 请求中包含的HTTP头信息
  final Map<String, String>? headers;
  
  /// 请求超时时间（秒）（默认：30）
  final int timeoutSeconds;
  
  /// 获取数据时是否显示加载指示器
  final bool showLoading;
  
  /// 失败时是否显示错误消息
  final bool showError;
  
  /// 要显示的自定义错误消息
  final String? customErrorMessage;

  const RemoteConfig({
    required this.url,
    this.headers,
    this.timeoutSeconds = 30,
    this.showLoading = true,
    this.showError = true,
    this.customErrorMessage,
  });

  factory RemoteConfig.fromJson(Map<String, dynamic> json) {
    return RemoteConfig(
      url: json['url'] as String,
      headers: json['headers'] != null 
          ? Map<String, String>.from(json['headers'] as Map)
          : null,
      timeoutSeconds: json['timeoutSeconds'] as int? ?? 30,
      showLoading: json['showLoading'] as bool? ?? true,
      showError: json['showError'] as bool? ?? true,
      customErrorMessage: json['customErrorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if (headers != null) 'headers': headers,
      'timeoutSeconds': timeoutSeconds,
      'showLoading': showLoading,
      'showError': showError,
      if (customErrorMessage != null) 'customErrorMessage': customErrorMessage,
    };
  }
}
