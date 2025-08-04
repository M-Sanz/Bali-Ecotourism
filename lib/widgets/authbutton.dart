import "package:flutter/material.dart";
import 'package:bali_smart_ecotourism_app/utils/constants.dart';

class AuthButton extends StatelessWidget {
  final Function()? onTap;
  final buttonText;

  const AuthButton({super.key, required this.onTap, required this.buttonText });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Constants.darkPrimary
        ),
        child: Center(child: Text("${buttonText}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),)),
      ),
    );
  }
}
