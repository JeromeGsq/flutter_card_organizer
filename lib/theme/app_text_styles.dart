import 'package:flutter_card_organizer/theme/app_colors.dart';
import 'package:flutter/widgets.dart';

/// Text styles used in the app.
class AppTextStyles {
  AppTextStyles._();

  TextStyle h1({Color color = AppColors.black}) => _AppTextStyle(
        color: color,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2({Color color = AppColors.black}) => _AppTextStyle(
        color: color,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  TextStyle h3({Color color = AppColors.black}) => _AppTextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );
}

class _AppTextStyle extends TextStyle {
  const _AppTextStyle({
    FontWeight fontWeight,
    Color color,
    double fontSize,
    double letterSpacing,
    FontStyle fontStyle = FontStyle.normal,
  }) : super(
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          fontFamily: 'Roboto',
        );
}
