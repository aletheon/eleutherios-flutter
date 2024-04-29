import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Colors.grey; // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var redPinkColor = const Color.fromARGB(255, 255, 106, 95);
  static var blueColor = Colors.blue.shade500;
  static var darkBlueColor = const Color.fromARGB(255, 1, 64, 116);
  static var greenColor = Colors.green.shade500;
  static var darkGreenColor = const Color.fromARGB(255, 87, 131, 0);

  static var userColor = Colors.purple.shade300;
  static var policyColor = Colors.amber.shade300;
  static var ruleColor = Colors.amber.shade300;
  static var forumColor = Colors.red.shade300;
  static var freeServiceColor = Colors.green.shade300;
  static var paidServiceColor = Colors.blue.shade300;

  static var cert1 = const Color.fromARGB(255, 153, 0, 11);
  static var cert2 = const Color.fromARGB(255, 213, 105, 6);
  static var cert3 = const Color.fromARGB(255, 249, 171, 23);
  static var cert4 = const Color.fromARGB(255, 6, 189, 142);
  static var cert5 = const Color.fromARGB(255, 87, 131, 0);

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
      //color: whiteColor,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor,
    backgroundColor: blackColor, // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
      //color: blackColor,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    backgroundColor: whiteColor,
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.dark})
      : _mode = mode,
        super(Pallete.darkModeAppTheme) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == ThemeMode.light.name) {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Pallete.lightModeAppTheme;
      prefs.setString('theme', ThemeMode.light.name);
    } else {
      _mode = ThemeMode.dark;
      state = Pallete.darkModeAppTheme;
      prefs.setString('theme', ThemeMode.dark.name);
    }
  }
}
