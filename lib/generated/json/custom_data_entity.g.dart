import 'package:fala/generated/json/base/json_convert_content.dart';
import 'package:fala/mode/custom_data_entity.dart';

CustomDataEntity $CustomDataEntityFromJson(Map<String, dynamic> json) {
  final CustomDataEntity customDataEntity = CustomDataEntity();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    customDataEntity.title = title;
  }
  final List<CustomDataData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<CustomDataData>(e) as CustomDataData)
      .toList();
  if (data != null) {
    customDataEntity.data = data;
  }
  final List<CustomDataChart>? chart = (json['chart'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<CustomDataChart>(e) as CustomDataChart)
      .toList();
  if (chart != null) {
    customDataEntity.chart = chart;
  }
  final double? chartHint = jsonConvert.convert<double>(json['chart_hint']);
  if (chartHint != null) {
    customDataEntity.chartHint = chartHint;
  }
  return customDataEntity;
}

Map<String, dynamic> $CustomDataEntityToJson(CustomDataEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['data'] = entity.data?.map((v) => v.toJson()).toList();
  data['chart'] = entity.chart?.map((v) => v.toJson()).toList();
  data['chart_hint'] = entity.chartHint;
  return data;
}

extension CustomDataEntityExtension on CustomDataEntity {
  CustomDataEntity copyWith({
    String? title,
    List<CustomDataData>? data,
    List<CustomDataChart>? chart,
    double? chartHint,
  }) {
    return CustomDataEntity()
      ..title = title ?? this.title
      ..data = data ?? this.data
      ..chart = chart ?? this.chart
      ..chartHint = chartHint ?? this.chartHint;
  }
}

CustomDataData $CustomDataDataFromJson(Map<String, dynamic> json) {
  final CustomDataData customDataData = CustomDataData();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    customDataData.title = title;
  }
  final String? subTitle = jsonConvert.convert<String>(json['title_sub']);
  if (subTitle != null) {
    customDataData.subTitle = subTitle;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    customDataData.value = value;
  }
  return customDataData;
}

Map<String, dynamic> $CustomDataDataToJson(CustomDataData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['title_sub'] = entity.subTitle;
  data['value'] = entity.value;
  return data;
}

extension CustomDataDataExtension on CustomDataData {
  CustomDataData copyWith({
    String? title,
    String? subTitle,
    String? value,
  }) {
    return CustomDataData()
      ..title = title ?? this.title
      ..subTitle = subTitle ?? this.subTitle
      ..value = value ?? this.value;
  }
}

CustomDataChart $CustomDataChartFromJson(Map<String, dynamic> json) {
  final CustomDataChart customDataChart = CustomDataChart();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    customDataChart.title = title;
  }
  final double? value = jsonConvert.convert<double>(json['value']);
  if (value != null) {
    customDataChart.value = value;
  }
  return customDataChart;
}

Map<String, dynamic> $CustomDataChartToJson(CustomDataChart entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['value'] = entity.value;
  return data;
}

extension CustomDataChartExtension on CustomDataChart {
  CustomDataChart copyWith({
    String? title,
    double? value,
  }) {
    return CustomDataChart()
      ..title = title ?? this.title
      ..value = value ?? this.value;
  }
}