import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/chart_data.dart';

/// 用于获取远程图表数据的服务
class DataService {
  /// 从远程URL获取图表数据
  static Future<ChartData> fetchChartData(RemoteConfig config) async {
    try {
      final uri = Uri.parse(config.url);
      final headers = config.headers ?? <String, String>{};
      
      final client = HttpClient();
      client.connectionTimeout = Duration(seconds: config.timeoutSeconds);
      
      final request = await client.getUrl(uri);
      headers.forEach((key, value) {
        request.headers.set(key, value);
      });
      
      final response = await request.close();
      
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final jsonData = json.decode(responseBody);
        return ChartData.fromJson(jsonData);
      } else {
        throw HttpException(
          '加载数据失败: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      throw const HttpException('无网络连接');
    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException('获取数据失败: $e');
    }
  }

  /// 使用错误处理和重试逻辑获取图表数据
  static Future<ChartData> fetchChartDataWithRetry(
    RemoteConfig config, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempts = 0;
    Exception? lastException;

    while (attempts < maxRetries) {
      try {
        return await fetchChartData(config);
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        attempts++;
        
        if (attempts < maxRetries) {
          await Future.delayed(retryDelay);
        }
      }
    }

    throw lastException ?? const HttpException('超过最大重试次数');
  }

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
        const ChartDataPoint(label: '一月', value: 12000, color: '#FF6B6B'),
        const ChartDataPoint(label: '二月', value: 15000, color: '#4ECDC4'),
        const ChartDataPoint(label: '三月', value: 18000, color: '#45B7D1'),
        const ChartDataPoint(label: '四月', value: 22000, color: '#96CEB4'),
        const ChartDataPoint(label: '五月', value: 19000, color: '#FFEAA7'),
        const ChartDataPoint(label: '六月', value: 25000, color: '#DDA0DD'),
      ],
    );
  }
}
