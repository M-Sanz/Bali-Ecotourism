import 'package:bali_smart_ecotourism_app/api_service.dart';
import 'package:bali_smart_ecotourism_app/models/user_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import '../../widgets/authbutton.dart';

class Register extends StatefulWidget {
  final Function()? onTap;

  Register({super.key, required this.onTap});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Add visibility state variables
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            colors: [Constants.darkPrimary, Color.fromRGBO(230, 133, 73, 1)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 120),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 30),
                      _buildTextField(usernameController, "Username"),
                      SizedBox(height: 15),
                      _buildTextField(emailController, "Email"),
                      SizedBox(height: 15),
                      // Updated password fields with visibility toggle
                      _buildPasswordField(
                        controller: passwordController,
                        hintText: "Password",
                        isVisible: _isPasswordVisible,
                        onToggle: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      SizedBox(height: 15),
                      _buildPasswordField(
                        controller: confirmPasswordController,
                        hintText: "Confirmation Password",
                        isVisible: _isConfirmPasswordVisible,
                        onToggle: () => setState(() =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible),
                      ),
                      SizedBox(height: 40),
                      AuthButton(
                        onTap: _registerUser,
                        buttonText: "Register",
                      ),
                      SizedBox(height: 30),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: ' Login',
                              style: TextStyle(
                                  color: Color.fromRGBO(230, 133, 73, 1)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onTap,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(245, 245, 245, 1),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 25),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  // New specialized widget for password fields
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromRGBO(245, 245, 245, 1),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 25, right: 15),
        child: TextField(
          controller: controller,
          obscureText: !isVisible,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser() {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password doesn't match")));
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    UserModel newUser = UserModel(
      userName: usernameController.text,
      emailId: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    APIService.registerUser(newUser).then((UserResponseModel responseModel) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseModel.message ?? "No Message Found")));

      widget.onTap!();
    });
  }
}
