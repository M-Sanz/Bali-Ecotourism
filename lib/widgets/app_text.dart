import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final double size;
  final String text;
  final Color? color;
  final FontWeight fontWeight;

  const AppText(
      {super.key,
      this.size = 30,
      required this.text,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight),
      maxLines: 2,
    );
  }
}
