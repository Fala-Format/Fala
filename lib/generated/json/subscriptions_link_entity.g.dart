import 'package:fala/generated/json/base/json_convert_content.dart';
import 'package:fala/mode/subscription_entity.dart';
import 'package:fala/mode/subscriptions_link_entity.dart';

SubscriptionsLinkEntity $SubscriptionsLinkEntityFromJson(
    Map<String, dynamic> json) {
  final SubscriptionsLinkEntity subscriptionsLinkEntity = SubscriptionsLinkEntity();
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    subscriptionsLinkEntity.url = url;
  }
  final List<SubscriptionEntity>? subscriptions = (json['subscriptions'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<SubscriptionEntity>(e) as SubscriptionEntity)
      .toList();
  if (subscriptions != null) {
    subscriptionsLinkEntity.subscriptions = subscriptions;
  }
  return subscriptionsLinkEntity;
}

Map<String, dynamic> $SubscriptionsLinkEntityToJson(
    SubscriptionsLinkEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['url'] = entity.url;
  data['subscriptions'] = entity.subscriptions?.map((v) => v.toJson()).toList();
  return data;
}

extension SubscriptionsLinkEntityExtension on SubscriptionsLinkEntity {
  SubscriptionsLinkEntity copyWith({
    String? url,
    bool? autoRefresh,
    bool? canRefresh,
    List<SubscriptionEntity>? subscriptions,
  }) {
    return SubscriptionsLinkEntity()
      ..url = url ?? this.url
      ..subscriptions = subscriptions ?? this.subscriptions;
  }
}