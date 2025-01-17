import 'dart:convert';
import 'dart:io';

import 'package:fala/common/common.dart';
import 'package:fala/mode/subscription_entity.dart';
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
    List<SubscriptionsLinkEntity> links = [];
    List<String>? list = await sharedPreferencesAsync.getStringList("subscriptions");
    if(list != null) {
      links = list.map((item) => SubscriptionsLinkEntity.fromJson(jsonDecode(item))).toList();
    }
    bool isNewInstall = await sharedPreferencesAsync.getBool("newInstall") ?? true;
    if(isNewInstall && links.isEmpty) {
      sharedPreferencesAsync.setBool("newInstall", false);
      SubscriptionsLinkEntity entity = SubscriptionsLinkEntity();
      entity.url = "https://raw.githubusercontent.com/Fala-Format/Fala-Format.github.io/refs/heads/main/example/sub_url";
      entity.subscriptions = [SubscriptionEntity.fromJson(jsonDecode("""
      {"title":"alien_price","sources":[{"data_type":"markdown","url":"https://raw.githubusercontent.com/Fala-Format/Fala/refs/heads/main/README.md","type":"content"},{"data_type":"markdown","url":"https://raw.githubusercontent.com/Fala-Format/Fala-Format.github.io/refs/heads/main/example/sub_preview","type":"preview"},{"data_type":"custom","url":"https://raw.githubusercontent.com/Fala-Format/Fala-Format.github.io/refs/heads/main/example/sub_widget","type":"widget_small"}]}
      """))];
      links.add(entity);
      setSubscriptionLinks(links);
    }
    return links;
  }
}