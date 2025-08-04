import 'package:bali_smart_ecotourism_app/pages/auth/login.dart';
import 'package:bali_smart_ecotourism_app/pages/auth/register.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});
  static const routeName = '/login-or-register';

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void tooglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(onTap: tooglePages,);
    } else {
      return Register(onTap: tooglePages,);
    }
  }
}
