import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/pages/auth/profile.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';

AppBar header(context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.4,
    title: Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        height: 0,
      ),
    ),
  );
}
