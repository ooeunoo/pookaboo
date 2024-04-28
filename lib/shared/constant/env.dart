// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

String production = 'production';

abstract class ENV {
  ENV._();

  static String POOKABOO_ENV = dotenv.env['POOKABOO_ENV'] as String;

  static String KAKAO_JAVASCRIPT_API_KEY =
      dotenv.env['KAKAO_JAVASCRIPT_API_KEY'] as String;

  static String KAKAO_NATIVE_API_KEY =
      dotenv.env['KAKAO_NATIVE_API_KEY'] as String;

  static String SUPABASE_URL = dotenv.env['SUPABASE_URL'] as String;
  static String SUPABASE_ANON_KEY = dotenv.env['SUPABASE_ANON_KEY'] as String;

  static String GOOGLE_ADMOB_PROD_BANNER_IOS =
      dotenv.env['GOOGLE_ADMOB_PROD_BANNER_IOS'] as String;

  static String GOOGLE_ADMOB_PROD_BANNER_AOS =
      dotenv.env['GOOGLE_ADMOB_PROD_BANNER_AOS'] as String;
}
