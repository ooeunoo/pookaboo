import 'dart:isolate';

import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/shared/constant/env.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

///[AndroidManifest.xml]
/********************************* 
<manifest>
   <!-- webview_flutter 에서 인터넷 접속을 위한 권한을 선언합니다 -->
   <uses-permission android:name="android.permission.INTERNET" />

   <application
   android:usesCleartextTraffic="true">
       ...
   </application>
</manifest>
*********************************/

///[Info.plist]
/********************************* 
<dict>
    <key>NSAppTransportSecurity</key>
      <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSAllowsArbitraryLoadsInWebContent</key>
        <true/>
      </dict>
    <key>io.flutter.embedded_views_preview</key>
    <true/>
</dict>
*********************************/

class KakaoMapService {
  static Future<void> init() async {
    AuthRepository.initialize(appKey: ENV.KAKAO_JAVASCRIPT_API_KEY);
  }
}
