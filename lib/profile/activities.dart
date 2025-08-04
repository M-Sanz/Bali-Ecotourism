import 'package:flutter/material.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('3'),
    );
  }
}