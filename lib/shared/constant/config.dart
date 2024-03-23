import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class Config {
  Config._();

  static Config get = Config._();

  String appName = "Pookaboo";

  String supabaseLoginRedirectTo =
      'io.supabase.flutterquickstart://login-callback/';

  LatLng initialCenter = LatLng(37.584690, 127.046502);

  String routeIds = '11277825,434235';
  // 위치 업데이트 거리 (미터 단위)
  int positionStreamDistanceFilter = 50;
}
