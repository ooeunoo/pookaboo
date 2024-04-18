class Env {
  Env._();

  static Env get = Env._();

  // Envrionment
  String kakaoJavascriptApiKey =
      const String.fromEnvironment('KAKAO_JAVASCRIPT_API_KEY');
  String kakaoNativeApiKey =
      const String.fromEnvironment('KAKAO_NATIVE_API_KEY');

  String supaBaseUrl = const String.fromEnvironment('SUPA_BASE_URL');
  String supaBaseAnonKey = const String.fromEnvironment('SUPA_BASE_ANON_KEY');
}
