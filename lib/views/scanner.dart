import 'dart:async';

import 'package:fala/components/haptic_feedback_button.dart';
import 'package:fala/extension/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<StatefulWidget> createState() => _Scanner();

}

class _Scanner extends State<ScannerView> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode]
  );

  StreamSubscription<Object?>? _subscription;
  bool _scanned = false;

  void _handleBarcode(BarcodeCapture barcodes) {
    if(barcodes.barcodes.isNotEmpty && !_scanned) {
      _scanned = true;
      String result = barcodes.barcodes.first.rawValue ?? "";
      if(result.isNotEmpty) {
        HapticFeedback.vibrate();
        Navigator.pop(context, result);
      }
    }
  }
  
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _subscription = controller.barcodes.listen(_handleBarcode);
    unawaited(controller.start());
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    unawaited(controller.dispose());
    super.dispose();
  }

  Future<void> _analyzeImageFromFile() async {
    try {
      final XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(!mounted){
        return;
      }
      if(file != null) {
        final BarcodeCapture? barcodeCapture = await controller.analyzeImage(file.path);
        if(barcodeCapture != null) {
          _handleBarcode(barcodeCapture);
        }
      }
    } catch(_) { }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("扫码二维码"),
      ),
      body: SafeArea(
        child: MobileScanner(
            controller: controller
        )
      ),
      floatingActionButton: HapticFeedbackButton(
        onPressed: _analyzeImageFromFile,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
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
          padding: EdgeInsets.all(10),
          child: Icon(Icons.photo),
        ),
      ),
    );
  }

}