import 'package:flutter/material.dart';

class L10n {
  static final all = {const Locale('en', 'US'), const Locale('zh', 'Hans')};

  static String getLanguage(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'zh':
        return '简体中文';
      default:
        return 'English';
    }
  }
}
