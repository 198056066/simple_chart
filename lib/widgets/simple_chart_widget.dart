import 'package:flutter/material.dart';
import '../models/chart_data.dart';
import '../models/chart_style.dart';
import '../services/data_service.dart';
import 'bar_chart_widget.dart';

/// 显示从远程源获取数据的柱状图的小部件
class SimpleBarChart extends StatefulWidget {
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

  const SimpleBarChart({
    super.key,
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
  State<SimpleBarChart> createState() => _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart> {
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
  void didUpdateWidget(SimpleBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
      _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasInitialLoad = true;
      });
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
