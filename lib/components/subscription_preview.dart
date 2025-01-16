import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fala/captureWebview/WebView.dart';
import 'package:fala/captureWebview/controller.dart';
import 'package:fala/components/haptic_feedback_button.dart';
import 'package:fala/extension/colors.dart';
import 'package:fala/mode/subscription_entity.dart';
import 'package:fala/network/network.dart';
import 'package:fala/provider/subscription_provider.dart';
import 'package:fala/views/content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class SubscriptionPreview extends StatefulWidget {
  final SubscriptionEntity entity;
  const SubscriptionPreview(this.entity, {super.key});

  @override
  State<StatefulWidget> createState() => _SubscriptionState();

}

class _SubscriptionState extends State<SubscriptionPreview> with AutomaticKeepAliveClientMixin {
  Timer? _timer;
  bool loading = true;
  final CaptureWebViewController _captureWebViewController = CaptureWebViewController();

  @override
  void initState() {
    _timer = Timer.periodic(Duration(minutes: widget.entity.refreshInterval), update);
    WidgetsBinding.instance.addPostFrameCallback((_) => update(null));
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> update(Timer? timer) async {
    if(!mounted) {
      return;
    }
    var source = widget.entity.sources?.firstWhere((source) => source.type == "preview");
    if(source == null){
      return;
    }
    setState(() {
      loading = true;
    });
    Uint8List? data = await Network.getSourceData(source);
    if(data == null){
      return;
    }
    if(!mounted) {
      return;
    }
    switch(source.dataType) {
      case 'image':
        source.data = data;
        break;
      case 'html':
        source.data =
        await _captureWebViewController.capture(utf8.decode(data), height: 200);
        break;
      case 'markdown':
        source.data = await ScreenshotController().captureFromWidget(
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                minHeight: 50,
                maxHeight: 200,
              ),
              child: Markdown(data: utf8.decode(data), shrinkWrap: true),
            ), context: context);
        break;
      case 'text':
        source.data = await ScreenshotController().captureFromWidget(
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                minHeight: 50,
                maxHeight: 200,
              ),
              child: Text(utf8.decode(data)),
            ), context: context);
        break;
      default:
        break;
    }
    if(mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var source = widget.entity.sources?.firstWhere((source) => source.type == "preview");
    if(source == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [
        CaptureWebView(_captureWebViewController),
        Container(
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 0.6)
            ),
            constraints: BoxConstraints(
                minWidth: double.infinity
            ),
            clipBehavior: Clip.hardEdge,
            child: HapticFeedbackButton(
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    CustomSlidableAction(
                      onPressed: (_) {
                        HapticFeedback.lightImpact();
                        SubscriptionEntity subscript = SubscriptionEntity.fromJson(widget.entity.toJson());
                        subscript.visible = false;
                        context.read<SubscriptionProvider>().editSubscription(widget.entity, subscript);
                      },
                      backgroundColor: CustomColors.danger,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    CustomSlidableAction(
                      onPressed: (_){
                        HapticFeedback.lightImpact();
                        showSetting();
                      },
                      backgroundColor: CustomColors.warning,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.settings, color: Colors.white),
                    ),
                    CustomSlidableAction(
                      onPressed: (_){
                        HapticFeedback.lightImpact();
                        update(_timer);
                      },
                      backgroundColor: CustomColors.primary,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.refresh, color: Colors.white),
                    )
                  ],
                ),
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: double.infinity,
                    minHeight: 50
                  ),
                  child: Stack(
                    children: [
                      source.data == null ? SizedBox() : Padding(
                        padding: EdgeInsets.all(0),
                        child: Image.memory(source.data!, fit: BoxFit.fill),
                      ),
                      Visibility(
                        visible: loading,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ContentView(widget.entity)));
              },
            ),
          ),
        ),
        Positioned(
          left: 25,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.white,
            child: Text(widget.entity.title ?? ""),
          ),
        )
      ],
    );
  }

  void showSetting() {
    showDialog(context: context, builder: (context){
      SubscriptionEntity entity = widget.entity;
      TextEditingController controller = TextEditingController(text: entity.refreshInterval.toString());
      return AlertDialog(
        title: Text("刷新间隔（分钟）"),
        content: TextField(
          keyboardType: TextInputType.number,
          controller: controller,
        ),
        actions: [
          HapticFeedbackButton(
              onPressed: () {
                Navigator.of(context).pop();
                entity.refreshInterval = int.parse(controller.text);
                context.read<SubscriptionProvider>().editSubscription(widget.entity, entity);
              },
              child: Text("确定")
          )
        ],
      );
    });
  }

  @override
  bool get wantKeepAlive => true;

}