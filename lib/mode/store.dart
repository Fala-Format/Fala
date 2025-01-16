import 'dart:convert';
import 'dart:io';

import 'package:fala/common/common.dart';
import 'package:fala/mode/subscriptions_link_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

class Store {
  static SharedPreferencesAsync? _sharedPreferencesAsync;
  static SharedPreferencesAsync get sharedPreferencesAsync {
    if(_sharedPreferencesAsync == null) {
      if (Platform.isIOS) {
        _sharedPreferencesAsync = SharedPreferencesAsync(options: SharedPreferencesAsyncFoundationOptions(suiteName: "group.io.fala.ios.client"));
      } else if(Platform.isAndroid) {
        _sharedPreferencesAsync = SharedPreferencesAsync(options: SharedPreferencesAsyncAndroidOptions(backend: SharedPreferencesAndroidBackendLibrary.SharedPreferences));
      } else {
        _sharedPreferencesAsync = SharedPreferencesAsync();
      }
    }
    return _sharedPreferencesAsync!;
  }

  static setSubscriptionLinks(List<SubscriptionsLinkEntity> entity) {
    sharedPreferencesAsync.setStringList("subscriptions", entity.map((item) => jsonEncode(item)).toList()).then((_) => syncICloud());
  }
  static Future<List<SubscriptionsLinkEntity>> getSubscriptionLinks() async {
    List<String>? list = await sharedPreferencesAsync.getStringList("subscriptions");
    if(list != null) {
      return list.map((item) => SubscriptionsLinkEntity.fromJson(jsonDecode(item))).toList();
    }
    return [];
  }
}