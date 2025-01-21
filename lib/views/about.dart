import 'dart:io';

import 'package:fala/common/common.dart';
import 'package:fala/mode/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<StatefulWidget> createState() => _AboutState();
}

class _AboutState extends State<AboutView> {
  bool syncICloud = true;
  bool autoUpdate = true;

  @override
  void initState() {
    Store.sharedPreferencesAsync.getBool("syncICloud").then((value) => syncICloud = value != false);
    Store.sharedPreferencesAsync.getBool("autoUpdate").then((value) => autoUpdate = value != false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  Text("Fala", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text("Fala 是一个开源的自定义订阅工具，旨在帮助用户轻松管理和查看关心的数据。通过简单易用的功能和跨平台支持，Fala 将订阅体验提升到一个全新高度。"),
                  Divider(),
                  if(Platform.isAndroid)
                    Row(
                      children: [
                        Expanded(child: Text("自动更新")),
                        Switch(value: autoUpdate, onChanged: (value) {
                          setState(() {
                            autoUpdate = value;
                            Store.sharedPreferencesAsync.setBool("autoUpdate", value);
                            HapticFeedback.lightImpact();
                          });
                        })
                      ],
                    ),
                  if(Platform.isIOS)
                    Row(
                      children: [
                        Expanded(child: Text("同步ICloud")),
                        Switch(value: syncICloud, onChanged: (value) {
                          setState(() {
                            syncICloud = value;
                            Store.sharedPreferencesAsync.setBool("autoUpdate", value);
                            HapticFeedback.lightImpact();
                          });
                        })
                      ],
                    ),
                  Divider(),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      spacing: 20,
                      children: [
                        Text("版本：$appVersion")
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

}