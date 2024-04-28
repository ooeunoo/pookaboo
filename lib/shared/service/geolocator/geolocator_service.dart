import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pookabu/shared/constant/config.dart';

///[gradle.properties]
/******************************** 
android.useAndroidX=true
android.enableJetifier=true
********************************/

///[android/app/build.gradle]
/******************************* 
android {
  compileSdkVersion 33

  ...
}
*******************************/

///[AndroidManifest.xml]
/******************************* 
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
*******************************/

///[Info.plist]
////////////////////////////////////////////////
///<key>NSLocationWhenInUseUsageDescription</key>
///<string>This app needs access to location when open.</string>
///<key>NSLocationTemporaryUsageDescriptionDictionary</key>
///<dict>
///  <key>YourPurposeKey</key>
///  <string>The example App requires temporary access to the device&apos;s precise location.</string>
///</dict>

class GeolocatorService {
  Future<Position> getPosition() async {
    bool permission = await hasPermission();

    if (!permission) {
      return Future.error('Location services are disabled.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: Config.positionStreamDistanceFilter, // 미터
    ));
  }

  Future<bool> hasPermission() async {
    LocationPermission permission;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> askPermission() async {
    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
