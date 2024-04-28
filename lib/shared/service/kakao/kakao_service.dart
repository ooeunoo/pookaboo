import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:pookaboo/shared/constant/env.dart';
import 'package:pookaboo/shared/utils/logging/log.dart';

class KakaoService {
  static Future<void> init() async {
    KakaoSdk.init(
      nativeAppKey: ENV.KAKAO_NATIVE_API_KEY,
      // javaScriptAppKey: Env.get.kakaoJavascriptApiKey,
    );
  }
}
