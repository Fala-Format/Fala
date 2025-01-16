import 'package:fala/generated/json/base/json_field.dart';
import 'package:fala/generated/json/subscriptions_link_entity.g.dart';
import 'dart:convert';

import 'package:fala/mode/subscription_entity.dart';
export 'package:fala/generated/json/subscriptions_link_entity.g.dart';

@JsonSerializable()
class SubscriptionsLinkEntity {
	String? url;
	List<SubscriptionEntity>? subscriptions;
	bool loading = false;

	SubscriptionsLinkEntity();

	factory SubscriptionsLinkEntity.fromJson(Map<String, dynamic> json) => $SubscriptionsLinkEntityFromJson(json);

	Map<String, dynamic> toJson() => $SubscriptionsLinkEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}