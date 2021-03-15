import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemeDataFactory {
  static ThemeData prepareThemeData() => ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        accentColor: AppColors.accent,
        backgroundColor: AppColors.background,
        fontFamily: "Roboto",
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      );
}
