import 'package:bali_smart_ecotourism_app/api_service.dart';
import 'package:bali_smart_ecotourism_app/widgets/authbutton.dart';
import 'package:bali_smart_ecotourism_app/services/ProgressHUD.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';

class Login extends StatefulWidget {
  final Function()? onTap;

  Login({super.key, required this.onTap});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Add visibility state variable
  bool _isPasswordVisible = false;
  bool isApiCallProcess = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          child: _loginUI(context),
        ));
  }

  Widget _loginUI(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topRight, colors: [
        Constants.darkPrimary,
        Color.fromRGBO(230, 133, 73, 1)
      ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 120,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60),
                )),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 70,
                  ),
                  Text(
                    "Login",
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(245, 245, 245, 1),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 25),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(
                                  color: Colors.black54,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Updated password field with visibility toggle
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(245, 245, 245, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, right: 15),
                      child: TextField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Colors.black54,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot Password"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AuthButton(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        isApiCallProcess = true;
                      });
                      print("Login Process");
                      APIService.loginUser(
                              emailController.text, passwordController.text)
                          .then((response) {
                        setState(() {
                          isApiCallProcess = false;
                        });

                        if (response) {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Invalid Username/Password")));
                        }
                      });
                    },
                    buttonText: "Login",
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Do not have an account? ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: ' Register',
                          style: TextStyle(
                            color: Color.fromRGBO(230, 133, 73, 1),
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onTap,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
