import 'dart:async';
import 'dart:io';

import 'package:app_installer/app_installer.dart';
import 'package:dio/dio.dart';
import 'package:fala/common/common.dart';
import 'package:fala/components/haptic_feedback_button.dart';
import 'package:fala/components/subscription_preview.dart';
import 'package:fala/mode/latset_info_entity.dart';
import 'package:fala/mode/store.dart';
import 'package:fala/mode/subscriptions_link_entity.dart';
import 'package:fala/network/network.dart';
import 'package:fala/provider/subscription_provider.dart';
import 'package:fala/views/about.dart';
import 'package:fala/views/manager.dart';
import 'package:fala/views/scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  bool _isMenuVisible = false;

  @override
  void initState() {
    Dio().get("https://www.baidu.com");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVersion();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Stack(
                children: [
                  ReorderableListView.builder(
                      itemBuilder: (context, index) {
                        var subscription = context
                            .watch<SubscriptionProvider>()
                            .subscriptions[index];
                        return SubscriptionPreview(
                            subscription, key: ValueKey(index));
                      },
                      itemCount: context
                          .watch<SubscriptionProvider>()
                          .subscriptions
                          .length,
                      onReorder: context
                          .watch<SubscriptionProvider>()
                          .updateIndex
                  ),

                  //悬浮按钮
                  Positioned(
                      bottom: 45,
                      right: 5,
                      child: HapticFeedbackButton(
                          onPressed: () {
                            setState(() {
                              _isMenuVisible = !_isMenuVisible;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(10)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(127),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(4, 4),
                                  )
                                ]
                            ),
                            child: Icon(Icons.more_horiz),
                          )
                      )
                  ),
                  // 菜单项
                  if (_isMenuVisible)
                    Positioned(
                      bottom: 120,
                      right: 15,
                      child: Column(
                        spacing: 10,
                        children: [
                          HapticFeedbackButton(
                            onPressed: () {
                              setState(() {
                                _isMenuVisible = false;
                              });
                              showAddLink();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(127),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(4, 4),
                                    )
                                  ]
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(Icons.add_link),
                                  Text("添加订阅")
                                ],
                              ),
                            ),
                          ),
                          HapticFeedbackButton(
                            onPressed: () {
                              setState(() {
                                _isMenuVisible = false;
                              });
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => ScannerView())).then((value) {
                                if (value is String) {
                                  getSubscription(value);
                                } else {
                                  showMessage("不是文本二维码");
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(127),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(4, 4),
                                    )
                                  ]
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(Icons.filter_center_focus),
                                  Text("添加订阅")
                                ],
                              ),
                            ),
                          ),
                          HapticFeedbackButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ManagerView()));
                              setState(() {
                                _isMenuVisible = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(127),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(4, 4),
                                    )
                                  ]
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(Icons.settings),
                                  Text("订阅管理")
                                ],
                              ),
                            ),
                          ),
                          HapticFeedbackButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => AboutView()));
                              setState(() {
                                _isMenuVisible = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(127),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: Offset(4, 4),
                                    )
                                  ]
                              ),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Icon(Icons.info_outline),
                                  Text("关于Fala")
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              )
          )
      );

  Future<void> getSubscription(String urls) async {
    if (urls.isEmpty) {
      showMessage("二维码内容为空");
    }
    List<SubscriptionsLinkEntity> list = [];
    for (var url in urls.split("\n")) {
      SubscriptionsLinkEntity? linkEntity = await Network.getSubscriptionsLink(
          url);
      if (linkEntity != null &&
          !context.read<SubscriptionProvider>().existLink(linkEntity)) {
        list.add(linkEntity);
      }
    }

    if (list.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, updateState) {
                return AlertDialog(
                  content: SingleChildScrollView(
                    child: Column(
                      children: list.map((link) =>
                          Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.link),
                                title: Text(link.url ?? "", maxLines: 1),
                              ), ...link.subscriptions!.map((subscription) =>
                                  ListTile(
                                    leading: IconButton(
                                      onPressed: () {
                                        updateState(() {
                                          subscription.visible =
                                          !subscription.visible;
                                        });
                                      },
                                      icon: Icon(subscription.visible ? Icons
                                          .check_box_rounded : Icons
                                          .check_box_outline_blank_rounded,
                                          color: subscription.visible
                                              ? Colors.blue
                                              : Colors.grey),
                                    ),
                                    title: Text(subscription.title ?? ""),
                                  )),
                            ],
                          )).toList(),
                    ),
                  ),
                  actions: [
                    HapticFeedbackButton(onPressed: () {
                      Navigator.of(context).pop();
                      for (var link in list) {
                        context.read<SubscriptionProvider>().addLink(link);
                      }
                    }, child: Text("确定"))
                  ],
                );
              },
            );
          });
    } else {
      showMessage("订阅格式错误或订阅为空！");
    }
  }

  void showAddLink() {
    showDialog(context: context, builder: (context) {
      TextEditingController controller = TextEditingController();
      return AlertDialog(
        title: Text("添加订阅"),
        content: TextField(
          keyboardType: TextInputType.url,
          controller: controller,
        ),
        actions: [
          HapticFeedbackButton(
              onPressed: () {
                Navigator.of(context).pop();
                getSubscription(controller.text);
              },
              child: Text("确定")
          )
        ],
      );
    });
  }

  void checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    if(!Platform.isAndroid) {
      return;
    }
    bool autoUpdate = await Store.sharedPreferencesAsync.getBool("autoUpdate") ?? true;
    if(!autoUpdate) {
      return;
    }
    int currentVersion = int.parse(packageInfo.version.replaceAll(".", ""));
    int ignoreVersion = await Store.sharedPreferencesAsync.getInt(
        "ignoreVersion") ?? 0;
    LatestInfoEntity? entity = await Network.checkVersion();
    if (entity != null) {
      int latest = int.parse(
          (entity.name ?? "v0.0.0").replaceAll("v", "").replaceAll(".", ""));
      if (latest <= ignoreVersion) {
        return;
      }
      if (latest > currentVersion) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: DefaultTextStyle(
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium!,
                              child: Text("版本更新")
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          constraints: BoxConstraints(
                            maxHeight: 200,
                          ),
                          child: SingleChildScrollView(
                            child: Markdown(
                                data: entity.body ?? "", shrinkWrap: true),
                          ),
                        ),
                        Row(
                          spacing: 20,
                          children: [
                            Expanded(
                              child: HapticFeedbackButton(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 30,
                                  alignment: Alignment.center,
                                  child: DefaultTextStyle(
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .labelMedium!,
                                      child: Text("忽略此更新")
                                  ),
                                ),
                                onPressed: () {
                                  Store.sharedPreferencesAsync.setInt(
                                      "ignoreVersion", latest);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Expanded(
                              child: HapticFeedbackButton(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 30,
                                  alignment: Alignment.center,
                                  child: DefaultTextStyle(
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!,
                                      child: Text("立即更新")
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDownload(entity.assets?.first.browserDownloadUrl ?? "");
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
              );
            }
        );
      }
    }
  }

  void showDownload(String url) async {
    if(url.isEmpty) {
      return showMessage("下载地址错误，请到Github下载最新安装包");
    }

    int total = 1;
    int count = 0;
    String _speed = "0 MB/S";
    StateSetter? onReceiveProgress;
    BuildContext? dialogContext;
    String fileName = "Fala.apk";
    Directory? storageDir = await getExternalStorageDirectory();
    String storagePath = storageDir!.path;
    File file = File('$storagePath/$fileName');
    if(file.existsSync()){
      file.deleteSync();
    }
    String _getMB(num size){
      return "${(size/1024/1024).toStringAsFixed(2)} MB";
    }

    /// 发起下载请求
    int downloadCount = count;
    int downloadTime = DateTime.now().millisecondsSinceEpoch;
    Dio().download(url, file.path, onReceiveProgress: (count, total) async {
      if(onReceiveProgress != null) {
        onReceiveProgress!(() {
          int current = DateTime.now().millisecondsSinceEpoch;
          count = count;
          total = total;
          if(current - downloadTime >= 1000){
            _speed = "${_getMB(count - downloadCount)}/S";
            downloadCount = count;
            downloadTime = current;
          }
        });
      }
      if(count == total){
        if(dialogContext != null) {
          Navigator.pop(dialogContext!);
        }
        AppInstaller.installApk(file.path);
      }
    });

    showDialog(context: context, builder: (BuildContext context) => Dialog(
      child: StatefulBuilder(builder: (BuildContext context ,StateSetter downloadState) {
        onReceiveProgress = downloadState;
        dialogContext = context;
        return SizedBox(
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  value: count / total,
                ),
              ),
              Text("${(count/total * 100).toInt()} %", style: TextStyle(fontSize: 16)),
              Container(
                margin: EdgeInsets.only(top: 120),
                padding: EdgeInsets.only(top: 20),
                child: Text("共计：${_getMB(total)}, 速度：$_speed", style: TextStyle(fontSize: 12)),
              )
            ],
          ),
        );
      }),
    ));
  }
}