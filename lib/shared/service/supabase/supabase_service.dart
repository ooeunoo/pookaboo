import 'package:pookaboo/shared/constant/env.dart';
import 'package:pookaboo/shared/service/storage/secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///[AndroidManifest.xml]
/******************************** 
<intent-filter>
    <action android:name="android.intent.action.MAIN"/>
    <category android:name="android.intent.category.LAUNCHER"/>
</intent-filter>
<intent-filter>
    <action android:name="android.intent.action.VIEW" />

    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
<!-- Accepts URIs that begin with packageID, oauth -->
<data android:scheme="com.example.supabase" android:host="oauth"/>
</intent-filter>
********************************/

///[Info.plist]
/*******************************
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>io.supabase.flutterexample</string>
		</array>
	</dict>
</array>
*****************************/

class SupabaseService {
  static Future<void> init(SecureStorage localStroage) async {
    await Supabase.initialize(
        url: ENV.SUPABASE_URL,
        anonKey: ENV.SUPABASE_ANON_KEY,
        authOptions: FlutterAuthClientOptions(localStorage: localStroage));
    // /// Initialize Firebase
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // // Pass all uncaught errors from the framework to Crashlytics.
    // // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // /// Catch errors that happen outside of the Flutter context,
    // Isolate.current.addErrorListener(
    //   RawReceivePort((List<dynamic> pair) async {
    //     final List<dynamic> errorAndStacktrace = pair;
    //     await FirebaseCrashlytics.instance.recordError(
    //       errorAndStacktrace.first,
    //       errorAndStacktrace.last as StackTrace,
    //     );
    //   }).sendPort,
    // );
  }

  SupabaseClient get client => Supabase.instance.client;
}
