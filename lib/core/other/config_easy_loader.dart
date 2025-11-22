import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// Configure the Easy Loader Indicator
/// from flutter_easy_loading package
class ConfigEasyLoader {
  ConfigEasyLoader._(); // Private constructor to prevent instantiation

  static void darkTheme() {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.dark
      ..maskType = EasyLoadingMaskType.black
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..indicatorSize = 45
      ..radius = 10
      ..userInteractions = false
      ..dismissOnTap = false
      ..textStyle = const TextStyle(
        color: Color(0xffffffff),
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        fontSize: 12,
      );
  }
}
