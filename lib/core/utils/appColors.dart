
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors {
  static const Color mainColor = Color(0xFF591D44);
  static const Color buttonColor = Color(0xFFC72A09);
  static const Color textColor = Color(0xFFC72A09);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFF66BB6A);
  static const Color backgroundColor = Color(0xFFFAFAFA);


  static LinearGradient buttonGradient = LinearGradient(
    colors: [
      Color(0xFF3C353B),
      Color(0xFF785E57),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );


}