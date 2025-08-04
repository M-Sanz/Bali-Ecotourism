import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bali_smart_ecotourism_app/models/login_model.dart';
import 'package:bali_smart_ecotourism_app/pages/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bali_smart_ecotourism_app/api_service.dart';

class SharedService {
  static final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final loginDetailsJson = prefs.getString("login_details");

    if (loginDetailsJson == null) {
      return false;
    }

    LoginResponseModel? loginDetails;
    try {
      loginDetails = LoginResponseModel.fromJson(jsonDecode(loginDetailsJson));
    } catch (e) {
      await prefs.remove("login_details");
      return false;
    }

    String? token = loginDetails.data?.token;
    if (token == null) {
      print("Token is null");
      await prefs.remove("login_details");
      return false;
    }

    if (JwtDecoder.isExpired(token)) {
      try {
        final refreshToken = await secureStorage.read(key: 'refresh_token');
        if (refreshToken == null) {
          await prefs.remove("login_details");
          return false;
        }

        final refreshResponse = await http.post(
          Uri.parse('${APIService.apiURL}/wp-json/jwt-auth/v1/token'),
          headers: {
            'Cookie': 'refresh_token=$refreshToken',
          },
        );
        if (refreshResponse.statusCode == 200) {
          final newData = jsonDecode(refreshResponse.body);
          final newToken = newData['data']['token'];

          loginDetails.data!.token = newToken;
          await prefs.setString("login_details", jsonEncode(loginDetails));
          token = newToken;
        } else {
          await prefs.remove("login_details");
          return false;
        }
      } catch (e) {
        await prefs.remove("login_details");
        return false;
      }
    }

    try {
      final response = await http.post(
        Uri.parse('${APIService.apiURL}/wp-json/jwt-auth/v1/token/validate'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

        final userId = decodedToken['data']['user']['id'];
        print("Extracted user ID: $userId");

        SharedService.setUserId(userId.toString());
        return true;
      } else {
        await prefs.remove("login_details");
        return false;
      }
    } catch (e) {
      await prefs.remove("login_details");
      return false;
    }
  }

  static Future<LoginResponseModel?> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_details") != null
        ? LoginResponseModel.fromJson(
            jsonDecode(prefs.getString("login_details")!))
        : null;
  }

  static Future<void> setLoginDetails(
      LoginResponseModel loginResponseModel) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("login_details", jsonEncode(loginResponseModel.toJson()));
  }

  static Future<void> logout(BuildContext context) async {
    print("logging out");
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("login_details");
    Navigator.of(context).pushReplacementNamed(LoginOrRegister.routeName);
  }

  static Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", userId);
  }
}
