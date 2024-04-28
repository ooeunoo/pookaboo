// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:pookabu/shared/constant/env.dart';

class AdmobService {
  static bool isProduction = ENV.POOKABU_ENV == production;

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return isProduction
          ? ENV.GOOGLE_ADMOB_PROD_BANNER_AOS
          : 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return isProduction
          ? ENV.GOOGLE_ADMOB_PROD_BANNER_IOS
          : 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
