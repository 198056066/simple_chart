import 'package:flutter/material.dart';
import '../models/chart_data.dart';
import '../models/chart_style.dart';
import '../services/data_service.dart';
import 'bar_chart_widget.dart';

/// 显示从远程源获取数据的柱状图的小部件
class RemoteBarChart extends StatefulWidget {
  /// 远程数据获取的配置
  final RemoteConfig remoteConfig;
  
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
  
  /// 图表的高度
  final double height;
  
  /// 图表的宽度
  final double? width;
  
  /// 数据成功加载时的回调
  final Function(ChartData)? onDataLoaded;
  
  /// 数据加载失败时的回调
  final Function(Exception)? onError;
  
  /// 是否显示加载指示器
  final bool showLoadingIndicator;
  
  /// 自定义加载小部件
  final Widget? loadingWidget;
  
  /// 自定义错误小部件
  final Widget? errorWidget;

  const RemoteBarChart({
    super.key,
    required this.remoteConfig,
    this.chartStyle,
    this.barStyle,
    this.axisStyle,
    this.titleStyle,
    this.tooltipStyle,
    this.height = 300,
    this.width,
    this.onDataLoaded,
    this.onError,
    this.showLoadingIndicator = true,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<RemoteBarChart> createState() => _RemoteBarChartState();
}

class _RemoteBarChartState extends State<RemoteBarChart> {
  ChartData? _chartData;
  bool _isLoading = false;
  Exception? _error;
  bool _hasInitialLoad = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didUpdateWidget(RemoteBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remoteConfig.url != widget.remoteConfig.url) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await DataService.fetchChartDataWithRetry(widget.remoteConfig);
      
      if (!mounted) return;
      
      setState(() {
        _chartData = data;
        _isLoading = false;
        _hasInitialLoad = true;
      });
      
      widget.onDataLoaded?.call(data);
    } catch (e) {
      if (!mounted) return;
      
      final exception = e is Exception ? e : Exception(e.toString());
      setState(() {
        _error = exception;
        _isLoading = false;
        _hasInitialLoad = true;
      });
      
      widget.onError?.call(exception);
    }
  }

  void _retry() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading && widget.showLoadingIndicator) {
      return _buildLoadingWidget();
    }
    
    if (_error != null) {
      return _buildErrorWidget();
    }
    
    if (_chartData != null) {
      return BarChartWidget(
        data: _chartData!,
        chartStyle: widget.chartStyle,
        barStyle: widget.barStyle,
        axisStyle: widget.axisStyle,
        titleStyle: widget.titleStyle,
        tooltipStyle: widget.tooltipStyle,
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildLoadingWidget() {
    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            '正在加载图表数据...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }
    
    final errorMessage = widget.remoteConfig.customErrorMessage ?? 
        '加载图表数据失败: ${_error?.toString() ?? '未知错误'}';
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _retry,
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
}
