import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // * Colors default app
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFF0D47A1);

  // * Custom colors
  static const Color disableColor = Color(0xffC6C6C6);
  static const Color errorColor = Color(0xffF44336);
  static const Color statusBarColor = Colors.black;
  static const Color greyColor = Color(0xff4F4F4F);
  static const Color disableButtonColor = Color(0xff616161);
  static const Color backgroundColor = Color(0xffE9E9F3);
  static const Color greenColor = Color(0xff4CAF50);
  static const Color redColor = Color(0xffF44336);
  static const Color orangeColor = Color(0xffFF9800);
  static const Color blueColor = Color(0xff2196F3);

  static ThemeData get defaultTheme => ThemeData(
        primaryColor: primaryColor,
        textSelectionTheme: const TextSelectionThemeData(cursorColor: accentColor),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.white,
          shadowColor: Colors.black54,
          color: primaryColor,
          elevation: 2,
          centerTitle: true,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        buttonTheme: ButtonThemeData(
          height: 45,
          disabledColor: disableColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        scaffoldBackgroundColor: Colors.grey.shade200,
        disabledColor: disableColor,
        hintColor: disableColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.light(
          secondary: accentColor,
          primary: primaryColor,
          error: errorColor,
          background: Colors.grey.shade200,
          surfaceTint: backgroundColor,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: const TextStyle(fontSize: 12),
          hintStyle: TextStyle(color: Colors.grey.shade400),
          errorMaxLines: 2,
          isDense: true,
          filled: true,
          fillColor: Colors.white38,
          contentPadding: const EdgeInsets.all(10),
          prefixIconColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.error)) return redColor;
            return states.contains(MaterialState.focused) ? accentColor : Colors.grey;
          }),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: accentColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.disableColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: accentColor, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.errorColor, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.errorColor, width: 2),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(iconColor: MaterialStateColor.resolveWith((states) => Colors.white70)),
        ),
        popupMenuTheme: const PopupMenuThemeData(surfaceTintColor: Colors.white),
      );
}
