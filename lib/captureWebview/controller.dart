import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CaptureWebViewController {
  List<Widget> children = [];
  late BuildContext context;
  Function(VoidCallback) updateState = (_){};

  Future<Uint8List> capture(String html, {double? width, double? height}) {
    var htmlString = """$html        
        <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
        <script type='text/javascript'>
          function capture() {
            html2canvas(document.body).then(function(canvas) {
              var dataUrl = canvas.toDataURL("image/png");
              window.FlutterChannel.postMessage(dataUrl);
            });
          }
          window.onload = capture;
        </script>        
        """;
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlString);
    Widget webview = SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: height ?? MediaQuery.of(context).size.height,
      child: WebViewWidget(controller: controller),
    );
    updateState((){
      children.add(webview);
    });
    Completer<Uint8List> completer = Completer();
    controller.addJavaScriptChannel("FlutterChannel", onMessageReceived: (message) {
      completer.complete(base64Decode(message.message.split(',')[1]));
      children.remove(webview);
    });
    return completer.future;
  }
}