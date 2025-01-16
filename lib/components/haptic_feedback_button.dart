import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HapticFeedbackButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  const HapticFeedbackButton({super.key, required this.child, this.onPressed});

  @override
  State<StatefulWidget> createState() => _HapticFeedbackButtonState();
}

class _HapticFeedbackButtonState extends State<HapticFeedbackButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: (){
        HapticFeedback.lightImpact();
        widget.onPressed?.call();
      },
    );
  }
}