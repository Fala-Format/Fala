import 'package:fala/generated/json/base/json_field.dart';
import 'package:fala/generated/json/latset_info_entity.g.dart';
import 'dart:convert';
export 'package:fala/generated/json/latset_info_entity.g.dart';

@JsonSerializable()
class LatestInfoEntity {
	String? name;
	List<LatestInfoAssets>? assets;
	String? body;

	LatestInfoEntity();

	factory LatestInfoEntity.fromJson(Map<String, dynamic> json) => $LatestInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $LatestInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class LatestInfoAssets {
	@JSONField(name: 'browser_download_url')
	String? browserDownloadUrl;

	LatestInfoAssets();

	factory LatestInfoAssets.fromJson(Map<String, dynamic> json) => $LatestInfoAssetsFromJson(json);

	Map<String, dynamic> toJson() => $LatestInfoAssetsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}