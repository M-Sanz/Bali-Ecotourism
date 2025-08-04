import 'package:flutter/material.dart';

class Constants {
  //App related strings
  static String appName = "Bali Smart Ecoturism App";

  //Colors for theme
  static Color lightPrimary = const Color(0xfff3f4f9);
  static const Color darkPrimary = const Color(0xff55B183);
  static Color lightAccent = const Color(0xffD0ECE3);
  static Color darkAccent = const Color(0xffE68549);
  static Color darkGrey = const Color(0xffA0A0A0);
  static Color lightBG = Colors.white;
  static Color darkBG = const Color(0xff2B2B2B);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0.3,
      toolbarTextStyle: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ).bodyMedium,
      titleTextStyle: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ).titleLarge,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      elevation: 0,
      color: Color(0xfff3f4f9),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: darkAccent),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    appBarTheme: AppBarTheme(
      elevation: 0,
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: lightBG,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: lightBG,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ).titleLarge,
    ),
    bottomAppBarTheme: BottomAppBarTheme(elevation: 0, color: darkBG),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: darkPrimary),
  );

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  static List<Map<String, Object>> categoryList = [
    {"id": 0, "name": "Mangrove", "icon": "🌲", "slug": "hutan-mangrove"},
    {"id": 1, "name": "Hotel", "icon": "🏨", "slug": "hotel"},
    {"id": 2, "name": "Restaurant", "icon": "🍽️", "slug": "restaurant"},
    {"id": 3, "name": "Religious Sites", "icon": "🕌", "slug": "tempat-ibadah"},
    {"id": 4, "name": "Market", "icon": "🛍️", "slug": "market"},
    {
      "id": 5,
      "name": "Tourist Attraction",
      "icon": "🎢",
      "slug": "lokasi-wisata"
    },
  ];
}
