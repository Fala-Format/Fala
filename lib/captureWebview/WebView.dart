import 'package:flutter/material.dart';

import 'controller.dart';

class CaptureWebView extends StatefulWidget {
  final CaptureWebViewController controller;
  const CaptureWebView(this.controller, {super.key});

  @override
  State<StatefulWidget> createState() => _WebState();
}

class _WebState extends State<CaptureWebView> {

  @override
  void initState() {
    widget.controller.updateState = setState;
    widget.controller.context = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.controller.children,
    );
  }

}