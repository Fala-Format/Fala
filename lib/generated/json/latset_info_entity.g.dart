import 'package:fala/generated/json/base/json_convert_content.dart';
import 'package:fala/mode/latset_info_entity.dart';

LatestInfoEntity $LatestInfoEntityFromJson(Map<String, dynamic> json) {
  final LatestInfoEntity latestInfoEntity = LatestInfoEntity();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    latestInfoEntity.name = name;
  }
  final List<LatestInfoAssets>? assets = (json['assets'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<LatestInfoAssets>(e) as LatestInfoAssets)
      .toList();
  if (assets != null) {
    latestInfoEntity.assets = assets;
  }
  final String? body = jsonConvert.convert<String>(json['body']);
  if (body != null) {
    latestInfoEntity.body = body;
  }
  return latestInfoEntity;
}

Map<String, dynamic> $LatestInfoEntityToJson(LatestInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['assets'] = entity.assets?.map((v) => v.toJson()).toList();
  data['body'] = entity.body;
  return data;
}

extension LatestInfoEntityExtension on LatestInfoEntity {
  LatestInfoEntity copyWith({
    String? name,
    List<LatestInfoAssets>? assets,
    String? body,
  }) {
    return LatestInfoEntity()
      ..name = name ?? this.name
      ..assets = assets ?? this.assets
      ..body = body ?? this.body;
  }
}

LatestInfoAssets $LatestInfoAssetsFromJson(Map<String, dynamic> json) {
  final LatestInfoAssets latestInfoAssets = LatestInfoAssets();
  final String? browserDownloadUrl = jsonConvert.convert<String>(
      json['browser_download_url']);
  if (browserDownloadUrl != null) {
    latestInfoAssets.browserDownloadUrl = browserDownloadUrl;
  }
  return latestInfoAssets;
}

Map<String, dynamic> $LatestInfoAssetsToJson(LatestInfoAssets entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['browser_download_url'] = entity.browserDownloadUrl;
  return data;
}

extension LatestInfoAssetsExtension on LatestInfoAssets {
  LatestInfoAssets copyWith({
    String? browserDownloadUrl,
  }) {
    return LatestInfoAssets()
      ..browserDownloadUrl = browserDownloadUrl ?? this.browserDownloadUrl;
  }
}