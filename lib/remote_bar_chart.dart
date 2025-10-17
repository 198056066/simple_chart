/// 远程柱状图插件
/// 
/// 一个通用的Flutter插件，用于显示具有远程数据获取功能的柱状图。
/// 
/// 功能特性：
/// - 通过HTTP请求获取远程数据
/// - 可自定义的样式和外观
/// - 动画柱状图渲染
/// - 错误处理和重试机制
/// - 提示框支持
/// - 响应式设计
/// 
/// 使用示例：
/// ```dart
/// RemoteBarChart(
///   remoteConfig: RemoteConfig(
///     url: 'https://api.example.com/chart-data',
///     headers: {'Authorization': 'Bearer token'},
///   ),
///   height: 300,
///   onDataLoaded: (data) => print('数据已加载: ${data.title}'),
///   onError: (error) => print('错误: $error'),
/// )
/// ```

// 导出所有公共类和组件
export 'models/chart_data.dart';
export 'models/chart_style.dart';
export 'services/data_service.dart';
export 'widgets/simple_chart.dart';
export 'widgets/bar_chart_widget.dart';
