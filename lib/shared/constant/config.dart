import 'package:kakao_map_plugin/kakao_map_plugin.dart';

abstract class Config {
  Config._();

  static String appName = "Pookaboo";

  static LatLng initialCenter = LatLng(37.584690, 127.046502);

  static String routeIds = '11277825,434235';
  // 위치 업데이트 거리 (미터 단위)
  static int positionStreamDistanceFilter = 50;

  static String mainImageUrl =
      'https://orlbgeqydvmfkynxbsjj.supabase.co/storage/v1/object/public/toilet_main_images/2961.jpg';
}
