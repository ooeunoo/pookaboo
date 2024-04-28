import 'dart:async';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pookaboo/injection.dart';
import 'package:pookaboo/pookaboo_app.dart';
import 'package:pookaboo/shared/constant/assets.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load(fileName: Assets.env);

      await MobileAds.instance.initialize();

      /// Register Service locator
      await configureDependencies();

      return SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      ).then((_) => runApp(const PookabooApp()));
    },
    (error, stackTrace) async {
      print('error: $error, stackTrace: $stackTrace');
      // FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
