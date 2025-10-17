# 远程柱状图插件 (Remote Bar Chart Plugin)

一个通用的Flutter插件，用于显示具有远程数据获取功能的柱状图。

## 功能特性

- 🌐 **远程数据获取**: 通过HTTP请求从远程API获取图表数据
- 🎨 **高度可定制**: 支持自定义图表样式、柱子样式、坐标轴样式等
- ✨ **动画效果**: 支持柱子出现的动画效果，可自定义动画曲线和持续时间
- 🔄 **错误处理**: 内置错误处理和重试机制
- 💡 **提示框支持**: 支持点击柱子显示详细信息
- 📱 **响应式设计**: 自适应不同屏幕尺寸
- 🎯 **易于使用**: 简单的API设计，快速集成

## 安装

在你的 `pubspec.yaml` 文件中添加依赖：

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
```

## 快速开始

### 基本用法

```dart
import 'package:flutter/material.dart';
import 'remote_bar_chart.dart';

class MyChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('柱状图示例')),
      body: RemoteBarChart(
        remoteConfig: RemoteConfig(
          url: 'https://api.example.com/chart-data',
          headers: {'Authorization': 'Bearer your-token'},
        ),
        height: 300,
        onDataLoaded: (data) => print('数据已加载: ${data.title}'),
        onError: (error) => print('错误: $error'),
      ),
    );
  }
}
```

### 使用本地数据

```dart
import 'package:flutter/material.dart';
import 'remote_bar_chart.dart';

class LocalChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 创建示例数据
    final sampleData = DataService.createSampleData();
    
    return Scaffold(
      appBar: AppBar(title: Text('本地数据图表')),
      body: BarChartWidget(
        data: sampleData,
        height: 300,
      ),
    );
  }
}
```

## 数据格式

插件支持以下JSON数据格式：

```json
{
  "title": "月度销售报告",
  "subtitle": "2024年第一季度表现",
  "unit": "元",
  "data": [
    {
      "label": "一月",
      "value": 45000,
      "color": "#FF6B6B",
      "tooltip": "一月销售: 45,000元"
    },
    {
      "label": "二月",
      "value": 52000,
      "color": "#4ECDC4",
      "tooltip": "二月销售: 52,000元"
    }
  ]
}
```

### 数据字段说明

- `title`: 图表标题（必需）
- `subtitle`: 图表副标题（可选）
- `unit`: 数值单位（可选）
- `data`: 数据点数组（必需）
  - `label`: 数据点标签（必需）
  - `value`: 数据点数值（必需）
  - `color`: 柱子颜色，十六进制格式（可选）
  - `tooltip`: 提示框文本（可选）

## 自定义样式

### 图表样式

```dart
RemoteBarChart(
  remoteConfig: remoteConfig,
  chartStyle: ChartStyle(
    backgroundColor: Colors.white,
    borderColor: Colors.grey,
    borderWidth: 1.0,
    borderRadius: 8.0,
    padding: EdgeInsets.all(16.0),
    margin: EdgeInsets.all(8.0),
  ),
  // ... 其他配置
)
```

### 柱子样式

```dart
RemoteBarChart(
  remoteConfig: remoteConfig,
  barStyle: BarStyle(
    color: Colors.blue,
    borderWidth: 1.0,
    borderColor: Colors.blueAccent,
    borderRadius: 4.0,
    spacing: 8.0,
    animationDuration: Duration(milliseconds: 800),
    animationCurve: Curves.easeOutCubic,
  ),
  // ... 其他配置
)
```

### 坐标轴样式

```dart
RemoteBarChart(
  remoteConfig: remoteConfig,
  axisStyle: AxisStyle(
    color: Colors.grey,
    width: 1.0,
    labelColor: Colors.black87,
    labelFontSize: 12.0,
    labelFontWeight: FontWeight.normal,
    gridColor: Colors.grey300,
    gridWidth: 0.5,
    showGrid: true,
    gridCount: 5,
  ),
  // ... 其他配置
)
```

### 标题样式

```dart
RemoteBarChart(
  remoteConfig: remoteConfig,
  titleStyle: TitleStyle(
    color: Colors.black87,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    alignment: TextAlign.center,
    padding: EdgeInsets.only(bottom: 16.0),
  ),
  // ... 其他配置
)
```

### 提示框样式

```dart
RemoteBarChart(
  remoteConfig: remoteConfig,
  tooltipStyle: TooltipStyle(
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 12.0,
    borderRadius: 4.0,
    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    showTooltip: true,
  ),
  // ... 其他配置
)
```

## 远程配置

### RemoteConfig 参数

```dart
RemoteConfig(
  url: 'https://api.example.com/chart-data',  // 必需：数据API地址
  headers: {                                  // 可选：HTTP请求头
    'Authorization': 'Bearer token',
    'Content-Type': 'application/json',
  },
  timeoutSeconds: 30,                         // 可选：请求超时时间（秒）
  showLoading: true,                          // 可选：是否显示加载指示器
  showError: true,                            // 可选：是否显示错误信息
  customErrorMessage: '自定义错误消息',        // 可选：自定义错误消息
)
```

## 回调函数

### 数据加载成功回调

```dart
RemoteBarChart(
  remoteConfig: remoteConfig,
  onDataLoaded: (ChartData data) {
    print('数据加载成功: ${data.title}');
    print('数据点数量: ${data.data.length}');
  },
  // ... 其他配置
)
```

### 错误处理回调

```dart
RemoteBarChart(
  remoteConfig: remoteConfig,
  onError: (Exception error) {
    print('数据加载失败: $error');
    // 处理错误逻辑
  },
  // ... 其他配置
)
```

## 自定义组件

### 自定义加载组件

```dart
RemoteBarChart(
  remoteConfig: remoteConfig,
  loadingWidget: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('正在加载数据...'),
      ],
    ),
  ),
  // ... 其他配置
)
```

### 自定义错误组件

```dart
RemoteBarChart(
  remoteConfig: remoteConfig,
  errorWidget: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error, size: 48, color: Colors.red),
        SizedBox(height: 16),
        Text('数据加载失败'),
        ElevatedButton(
          onPressed: () {
            // 重试逻辑
          },
          child: Text('重试'),
        ),
      ],
    ),
  ),
  // ... 其他配置
)
```

## 示例项目

项目包含一个完整的示例应用，展示了插件的各种用法：

1. **示例数据**: 使用本地示例数据展示基本功能
2. **远程数据**: 从远程API获取数据
3. **自定义样式**: 展示各种自定义样式选项

运行示例：

```bash
flutter run
```

## API 参考

### RemoteBarChart

主要的远程柱状图组件。

#### 构造函数参数

| 参数 | 类型 | 必需 | 描述 |
|------|------|------|------|
| `remoteConfig` | `RemoteConfig` | 是 | 远程数据获取配置 |
| `chartStyle` | `ChartStyle?` | 否 | 图表样式配置 |
| `barStyle` | `BarStyle?` | 否 | 柱子样式配置 |
| `axisStyle` | `AxisStyle?` | 否 | 坐标轴样式配置 |
| `titleStyle` | `TitleStyle?` | 否 | 标题样式配置 |
| `tooltipStyle` | `TooltipStyle?` | 否 | 提示框样式配置 |
| `height` | `double` | 否 | 图表高度（默认：300） |
| `width` | `double?` | 否 | 图表宽度 |
| `onDataLoaded` | `Function(ChartData)?` | 否 | 数据加载成功回调 |
| `onError` | `Function(Exception)?` | 否 | 错误处理回调 |
| `showLoadingIndicator` | `bool` | 否 | 是否显示加载指示器（默认：true） |
| `loadingWidget` | `Widget?` | 否 | 自定义加载组件 |
| `errorWidget` | `Widget?` | 否 | 自定义错误组件 |

### BarChartWidget

本地柱状图组件，用于显示本地数据。

#### 构造函数参数

| 参数 | 类型 | 必需 | 描述 |
|------|------|------|------|
| `data` | `ChartData` | 是 | 图表数据 |
| `chartStyle` | `ChartStyle?` | 否 | 图表样式配置 |
| `barStyle` | `BarStyle?` | 否 | 柱子样式配置 |
| `axisStyle` | `AxisStyle?` | 否 | 坐标轴样式配置 |
| `titleStyle` | `TitleStyle?` | 否 | 标题样式配置 |
| `tooltipStyle` | `TooltipStyle?` | 否 | 提示框样式配置 |

### DataService

数据服务类，提供数据获取和验证功能。

#### 静态方法

- `fetchChartData(RemoteConfig config)`: 从远程URL获取图表数据
- `fetchChartDataWithRetry(RemoteConfig config, {int maxRetries, Duration retryDelay})`: 带重试逻辑的数据获取
- `validateChartData(ChartData data)`: 验证图表数据结构
- `createSampleData()`: 创建示例数据

## 许可证

MIT License

## 贡献

欢迎提交Issue和Pull Request来改进这个插件。

## 更新日志

### v1.0.0
- 初始版本发布
- 支持远程数据获取
- 支持自定义样式
- 支持动画效果
- 支持错误处理和重试机制