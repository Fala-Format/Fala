import 'dart:ui';

import 'package:fala/common/common.dart';
import 'package:fala/components/haptic_feedback_button.dart';
import 'package:fala/extension/colors.dart';
import 'package:fala/mode/subscription_entity.dart';
import 'package:fala/mode/subscriptions_link_entity.dart';
import 'package:fala/network/network.dart';
import 'package:fala/provider/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ManagerView extends StatefulWidget {
  const ManagerView({super.key});

  @override
  State<StatefulWidget> createState() =>_ManagerState();

}

class _ManagerState extends State<ManagerView> {
  final List<SubscriptionsLinkEntity> _selected = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: context.watch<SubscriptionProvider>().links.map((link) => _selected.isNotEmpty ? ListTile(
            title: Text(link.url ?? ""),
            trailing: Icon(_selected.contains(link) ? Icons.check_box_sharp : Icons.check_box_outlined, color: _selected.contains(link) ? Colors.blue : Colors.grey),
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                if(_selected.contains(link)) {
                  _selected.remove(link);
                } else {
                  _selected.add(link);
                }
              });
            },
          ) : GestureDetector(
            onLongPress: (){
              HapticFeedback.lightImpact();
              setState(() {
                _selected.add(link);
              });
            },
            child: Stack(
              children: [
                Slidable(
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      CustomSlidableAction(
                        onPressed: (_) {
                          HapticFeedback.lightImpact();
                          context.read<SubscriptionProvider>().removeLink(link);
                        },
                        backgroundColor: CustomColors.danger,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      CustomSlidableAction(
                        onPressed: (_){
                          HapticFeedback.lightImpact();
                          updateLink(link);
                        },
                        backgroundColor: CustomColors.primary,
                        foregroundColor: Colors.white,
                        child: Icon(Icons.refresh, color: Colors.white),
                      )
                    ],
                  ),
                  child: ExpansionTile(
                    title: Text(link.url!),
                    children: link.subscriptions!.map((subscription) => ListTile(
                      title: Text(subscription.title!),
                      trailing: HapticFeedbackButton(
                        onPressed: (){
                          SubscriptionEntity entity = SubscriptionEntity.fromJson(subscription.toJson());
                          entity.visible = !entity.visible;
                          context.read<SubscriptionProvider>().editSubscription(subscription, entity);
                        },
                        child: Icon(subscription.visible ? Icons.visibility_off : Icons.visibility),
                      ),
                    )).toList(),
                  ),
                ),
                Visibility(
                  visible: link.loading,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          )).toList(),
        )
      ),
      floatingActionButtonLocation: _selected.isEmpty ? FloatingActionButtonLocation.startFloat : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _selected.isEmpty ? HapticFeedbackButton(
        child: Icon(Icons.arrow_back_ios),
        onPressed: (){
          Navigator.pop(context);
        },
      ) : Container(
        width: 150,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(4, 4),
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 25,
          children: [
            HapticFeedbackButton(
              child: Icon(Icons.qr_code_2),
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: GestureDetector(
                      child: SizedBox(
                        width: 300,
                        height: 320,
                        child: Column(
                          children: [
                            Expanded(
                              child: QrImageView(data: _selected.map((link) => link.url ?? "").toList().join("\n")),
                            ),
                            Text("长按二维码保存/分享", style: TextStyle(color: Colors.grey, fontSize: 16),)
                          ],
                        ),
                      ),
                      onLongPress: (){
                        HapticFeedback.lightImpact();

                        ScreenshotController().captureFromWidget(Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: QrImageView(data: _selected.map((link) => link.url ?? "").toList().join("\n"))
                        ), context: context).then((imageData) => Share.shareXFiles(
                            [XFile.fromData(imageData.buffer.asUint8List(), mimeType: "image/png")]
                        ));
                      },
                    )
                  );
                });
              },
            ),
            HapticFeedbackButton(
              child: Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _selected.map((link) => link.url ?? "").toList().join("\n")));
                showMessage("复制成功!", context: context);
              },
            ),
            HapticFeedbackButton(
              child: Icon(Icons.delete),
              onPressed: () {
                for(var link in _selected) {
                  context.read<SubscriptionProvider>().removeLink(link);
                }
                setState(() {
                  _selected.clear();
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateLink(SubscriptionsLinkEntity link) async {
    setState(() {
      link.loading = true;
    });
    SubscriptionsLinkEntity? linkEntity = await Network.getSubscriptionsLink(link.url!);
    if(linkEntity != null) {
      context.read<SubscriptionProvider>().updateLink(linkEntity);
    }
  }
}