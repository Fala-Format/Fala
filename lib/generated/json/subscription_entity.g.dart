import 'package:fala/generated/json/base/json_convert_content.dart';
import 'package:fala/mode/subscription_entity.dart';

SubscriptionEntity $SubscriptionEntityFromJson(Map<String, dynamic> json) {
  final SubscriptionEntity subscriptionEntity = SubscriptionEntity();
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    subscriptionEntity.title = title;
  }
  final bool? visible = jsonConvert.convert<bool>(json['visible']);
  if (visible != null) {
    subscriptionEntity.visible = visible;
  }
  final int? refreshInterval = jsonConvert.convert<int>(json['refresh_interval']);
  if (refreshInterval != null) {
    subscriptionEntity.refreshInterval = refreshInterval;
  }
  final int? index = jsonConvert.convert<int>(json['index']);
  if (index != null) {
    subscriptionEntity.index = index;
  }
  final List<SubscriptionSources>? sources = (json['sources'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<SubscriptionSources>(e) as SubscriptionSources)
      .toList();
  if (sources != null) {
    subscriptionEntity.sources = sources;
  }
  return subscriptionEntity;
}

Map<String, dynamic> $SubscriptionEntityToJson(SubscriptionEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['title'] = entity.title;
  data['visible'] = entity.visible;
  data['refresh_interval'] = entity.refreshInterval;
  data['index'] = entity.index;
  data['sources'] = entity.sources?.map((v) => v.toJson()).toList();
  return data;
}

extension SubscriptionEntityExtension on SubscriptionEntity {
  SubscriptionEntity copyWith({
    String? title,
    int? refreshInterval,
    int? index,
    List<SubscriptionSources>? sources,
  }) {
    return SubscriptionEntity()
      ..title = title ?? this.title
      ..refreshInterval = refreshInterval ?? this.refreshInterval
      ..index = index ?? this.index
      ..sources = sources ?? this.sources;
  }
}

SubscriptionSources $SubscriptionSourcesFromJson(Map<String, dynamic> json) {
  final SubscriptionSources subscriptionSources = SubscriptionSources();
  final String? dataType = jsonConvert.convert<String>(json['data_type']);
  if (dataType != null) {
    subscriptionSources.dataType = dataType;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    subscriptionSources.url = url;
  }
  final String? type = jsonConvert.convert<String>(json['type']);
  if (type != null) {
    subscriptionSources.type = type;
  }
  final String? proxy = jsonConvert.convert<String>(json['proxy']);
  if (proxy != null) {
    subscriptionSources.proxy = proxy;
  }
  return subscriptionSources;
}

Map<String, dynamic> $SubscriptionSourcesToJson(SubscriptionSources entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data_type'] = entity.dataType;
  data['url'] = entity.url;
  data['type'] = entity.type;
  data['proxy'] = entity.proxy;
  return data;
}

extension SubscriptionSourcesExtension on SubscriptionSources {
  SubscriptionSources copyWith({
    String? dataType,
    String? url,
    String? type,
    String? proxy,
  }) {
    return SubscriptionSources()
      ..dataType = dataType ?? this.dataType
      ..url = url ?? this.url
      ..type = type ?? this.type
      ..proxy = proxy ?? this.proxy;
  }
}