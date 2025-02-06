import 'package:fala/generated/json/base/json_field.dart';
import 'package:fala/generated/json/custom_data_entity.g.dart';
import 'dart:convert';
export 'package:fala/generated/json/custom_data_entity.g.dart';

@JsonSerializable()
class CustomDataEntity {
	String? title;
	List<CustomDataData>? data;
	List<CustomDataChart>? chart;
	@JSONField(name: 'chart_hint')
	double? chartHint;

	CustomDataEntity();

	factory CustomDataEntity.fromJson(Map<String, dynamic> json) => $CustomDataEntityFromJson(json);

	Map<String, dynamic> toJson() => $CustomDataEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CustomDataData {
	String? title;
	String? value;
	@JSONField(name: "sub_title")
	String? subTitle;

	CustomDataData();

	factory CustomDataData.fromJson(Map<String, dynamic> json) => $CustomDataDataFromJson(json);

	Map<String, dynamic> toJson() => $CustomDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class CustomDataChart {
	String? title;
	double? value;

	CustomDataChart();

	factory CustomDataChart.fromJson(Map<String, dynamic> json) => $CustomDataChartFromJson(json);

	Map<String, dynamic> toJson() => $CustomDataChartToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}