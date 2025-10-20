import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/chart_data.dart';

/// 用于获取远程图表数据的服务
class DataService {
  /// 验证图表数据结构
  static bool validateChartData(ChartData data) {
    if (data.title.isEmpty) return false;
    if (data.data.isEmpty) return false;
    
    for (final point in data.data) {
      if (point.label.isEmpty) return false;
      if (point.value.isNaN || point.value.isInfinite) return false;
    }
    
    return true;
  }

  /// 创建用于测试的示例图表数据
  static ChartData createSampleData() {
    return ChartData(
      title: '示例销售数据',
      subtitle: '月度销售表现',
      unit: '元',
      data: [
        const ChartDataPoint(label: '一月', value: 12000, color: '#FF6B6B', remarks: ['#FF6B6B', 'qweq', 'wqrregr', 'rewrwe']),
        const ChartDataPoint(label: '二月', value: 15000, color: '#4ECDC4', remarks: ['wqrregr', 'rewrwe']),
        const ChartDataPoint(label: '三月', value: 18000, color: '#45B7D1', remarks: ['#FF6B6B']),
        const ChartDataPoint(label: '四月', value: 22000, color: '#96CEB4', remarks: ['wqrregr']),
        const ChartDataPoint(label: '五月', value: 19000, color: '#FFEAA7', remarks: ['#FF6B6B', 'qweq', 'wqrregr', 'rewrwe']),
        const ChartDataPoint(label: '六月', value: 25000, color: '#DDA0DD', remarks: ['#FF6B6B', 'qweq', 'wqrregr', 'rewrwe']),
      ],
    );
  }
}
