import 'package:flutter/material.dart';

class ProgressHUD extends StatelessWidget {

  final Widget child;
  final bool inAsyncCall;
  final double opacity = 0.5;
  final Color color;
  final Animation<Color>? valueColor;

  ProgressHUD({
    Key? key,
    required this.child,
    required this.inAsyncCall,
    this.color = Colors.grey,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(dismissible: true, color: color),
          ),
          Center(
              child: CircularProgressIndicator()
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}