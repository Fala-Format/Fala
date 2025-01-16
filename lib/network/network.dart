import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fala/common/common.dart';
import 'package:fala/mode/latset_info_entity.dart';
import 'package:fala/mode/subscription_entity.dart';
import 'package:fala/mode/subscriptions_link_entity.dart';
import 'package:flutter/foundation.dart';

class Network {
  static Future<Uint8List?> getSourceData(SubscriptionSources source) async {
    Dio dio = Dio(BaseOptions(responseType: ResponseType.bytes, headers: {
      "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1"
    }));
    if(source.proxy != null) {
      dio.httpClientAdapter = IOHttpClientAdapter(
          createHttpClient: () {
            final client =  HttpClient();
            client.findProxy = (_) {
              return source.proxy!;
            };
            return client;
          }
      );
    }
    try {
      Response<Uint8List> response = await dio.get(source.url ?? "");
      if(response.statusCode == 200) {
        return response.data!;
      }
    } catch(e) {
      showMessage("网络错误！");
      if(kDebugMode) {
        print("get Error: $e");
      }
    }
    return null;
  }

  static Future<SubscriptionsLinkEntity?> getSubscriptionsLink(String url) async {
    try {
      Response response = await Dio().get(url);
      if(response.statusCode == 200) {
        var json = utf8.decode(base64Decode(response.data));
        var results = jsonDecode(json);
        if(results is List) {
          List<SubscriptionEntity> subscriptions = results.map((item) => SubscriptionEntity.fromJson(item)).toList();
          if(subscriptions.isNotEmpty && subscriptions.first.sources != null) {
            SubscriptionsLinkEntity linkEntity = SubscriptionsLinkEntity();
            linkEntity.subscriptions = subscriptions;
            linkEntity.url = url;
            return linkEntity;
          }
        }
      }
    } catch(e) {
      showMessage("网络错误！");
      if(kDebugMode) {
        print("get Subscription error: $e");
      }
    }
    return null;
  }

  static Future<LatestInfoEntity?> checkVersion() async {
    const checkUrl = "https://api.github.com/repos/Fala-Format/Fala/releases/latest";
    try {
      Response response = await Dio().get(checkUrl);
      if(response.statusCode == 200) {
        LatestInfoEntity entity = LatestInfoEntity.fromJson(response.data);
        if(entity.name?.isNotEmpty == true) {
          return entity;
        }
      }
    } catch(e) {
      showMessage("网络错误！");
      if(kDebugMode) {
        print("get Subscription error: $e");
      }
    }
    return null;
  }
}