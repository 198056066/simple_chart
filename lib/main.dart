import 'package:flutter/material.dart';
import 'package:simple_chart/remote_bar_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '柱状图演示',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ChartDemoPage(),
    );
  }
}

class ChartDemoPage extends StatefulWidget {
  const ChartDemoPage({super.key});

  @override
  State<ChartDemoPage> createState() => _ChartDemoPageState();
}

class _ChartDemoPageState extends State<ChartDemoPage> {
  int _selectedExample = 0;
  
  final List<ChartExample> _examples = [
    ChartExample(
      title: '示例数据',
      description: '本地示例数据，带自定义样式',
    ),
    ChartExample(
      title: '自定义样式图表',
      description: '带自定义颜色和动画的图表',
      customStyle: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('柱状图演示'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 示例选择器
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _examples.length,
              itemBuilder: (context, index) {
                final example = _examples[index];
                final isSelected = _selectedExample == index;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedExample = index;
                    });
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? Theme.of(context).primaryColor
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          example.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          example.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected 
                                ? Colors.white70 
                                : Colors.black54,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.storage,
                              size: 16,
                              color: isSelected ? Colors.white : Colors.black54,
                            ),
                            const SizedBox(width: 4),
                          ],
            ),
          ],
        ),
      ),
                );
              },
            ),
          ),
          
          // 图表显示
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildSelectedChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedChart() {
    final example = _examples[_selectedExample];

      // 对于本地数据，我们使用示例数据
      final sampleData = DataService.createSampleData();
      return BarChartWidget(
        data: sampleData,
        chartStyle: example.customStyle ? _getCustomChartStyle() : null,
        barStyle: example.customStyle ? _getCustomBarStyle() : null,
        axisStyle: example.customStyle ? _getCustomAxisStyle() : null,
        titleStyle: example.customStyle ? _getCustomTitleStyle() : null,
      );
  }

  ChartStyle _getCustomChartStyle() {
    return const ChartStyle(
      backgroundColor: Color(0xFF1E1E1E),
      borderColor: Color(0xFF333333),
      borderWidth: 2,
      borderRadius: 16,
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.all(16),
    );
  }

  BarStyle _getCustomBarStyle() {
    return const BarStyle(
      color: Color(0xFF00BCD4),
      borderWidth: 1,
      borderColor: Color(0xFF00ACC1),
      borderRadius: 8,
      spacing: 12,
      animationDuration: Duration(milliseconds: 1200),
      animationCurve: Curves.elasticOut,
    );
  }

  AxisStyle _getCustomAxisStyle() {
    return const AxisStyle(
      color: Color(0xFF666666),
      width: 2,
      labelColor: Color(0xFFCCCCCC),
      labelFontSize: 14,
      labelFontWeight: FontWeight.w500,
      gridColor: Color(0xFF333333),
      gridWidth: 1,
      showGrid: true,
      gridCount: 6,
    );
  }

  TitleStyle _getCustomTitleStyle() {
    return const TitleStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 24,
      fontWeight: FontWeight.bold,
      alignment: TextAlign.center,
      padding: EdgeInsets.only(bottom: 24),
    );
  }
}

class ChartExample {
  final String title;
  final String description;
  final RemoteConfig? remoteConfig;
  final bool customStyle;

  ChartExample({
    required this.title,
    required this.description,
    this.remoteConfig,
    this.customStyle = false,
  });
}