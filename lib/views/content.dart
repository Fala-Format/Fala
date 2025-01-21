import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fala/mode/subscription_entity.dart';
import 'package:fala/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContentView extends StatefulWidget {
  final SubscriptionEntity entity;

  const ContentView(this.entity, {super.key});

  @override
  State<StatefulWidget> createState() => _ContentState();

}

class _ContentState extends State<ContentView> {
  Timer? _timer;
  Widget? content;
  bool isLoading = true;

  @override
  void initState() {
    update();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  Future<void> update() async {
    var source = widget.entity.sources?.firstWhere((source) =>
    source.type == "content");
    if (source == null) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    Uint8List? data = await Network.getSourceData(source);
    if (data == null) {
      return;
    }
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(
        Duration(minutes: widget.entity.refreshInterval), (_) => update());
    switch (source.dataType) {
      case 'image':
        content = Image.memory(data);
        break;
      case 'html':
        content = WebViewWidget(controller: WebViewController()
          ..loadHtmlString(utf8.decode(data)));
        break;
      case 'markdown':
        content = Markdown(data: utf8.decode(data));
        break;
      case 'text':
        try {
          var json = utf8.decode(data);
          var jsonData = jsonDecode(json);
          content = SingleChildScrollView(
            child: JsonView.map(jsonData),
          );
        } catch (_) {
          content = SingleChildScrollView(
            child: Text(utf8.decode(data)),
          );
        }
        break;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: RefreshIndicator(
            onRefresh: update,
            displacement: 0,
            color: Colors.transparent,
            backgroundColor: Colors.transparent,
            strokeWidth: 0,
            elevation: 0,
            child: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: content == null ? SizedBox() : content!
                ),
                Visibility(
                  visible: isLoading,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          )
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