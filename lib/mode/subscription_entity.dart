import 'dart:typed_data';

import 'package:fala/generated/json/base/json_field.dart';
import 'package:fala/generated/json/subscription_entity.g.dart';
import 'dart:convert';
export 'package:fala/generated/json/subscription_entity.g.dart';

@JsonSerializable()
class SubscriptionEntity {
	String? title;
	List<SubscriptionSources>? sources;
	bool visible = true;
	@JSONField(name: "refresh_interval")
	int refreshInterval = 3;
	int index = -1;

	SubscriptionEntity();

	factory SubscriptionEntity.fromJson(Map<String, dynamic> json) => $SubscriptionEntityFromJson(json);

	Map<String, dynamic> toJson() => $SubscriptionEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SubscriptionSources {
	@JSONField(name: "data_type")
	String? dataType;
	String? url;
	String? type;
	String? proxy;
	Uint8List? data;

	SubscriptionSources();

	factory SubscriptionSources.fromJson(Map<String, dynamic> json) => $SubscriptionSourcesFromJson(json);

	Map<String, dynamic> toJson() => $SubscriptionSourcesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}