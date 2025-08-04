import 'package:bali_smart_ecotourism_app/pages/auth/login_or_register.dart';
import 'package:bali_smart_ecotourism_app/routes/page_route.dart';
import 'package:bali_smart_ecotourism_app/screens/homescreen.dart';
import 'package:bali_smart_ecotourism_app/services/shared_service.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controller/map_controller.dart';

Widget _defaultHome = LoginOrRegister();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _result = await SharedService.isLoggedIn();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // Navigation bar color
    systemNavigationBarIconBrightness:
        Brightness.dark, // Icon theme (dark/light)
    systemNavigationBarContrastEnforced:
        true, // For better transparency handling
  ));

  if (_result) {
    _defaultHome = HomeScreen();
  }
  runApp(MyApp());
  Get.put(MyMapController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: true,
      title: "Bali Smart Ecotourism",
      theme: Constants.lightTheme, // Constants.lightTheme,
      home: _defaultHome,
      getPages: ApplicationPage.pages,
    );
  }
}
