import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pookabu/injection.dart';
import 'package:pookabu/layers/presentation/bloc/announcement/announcement_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/toilet/toilet_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/map/map_bloc.dart';
import 'package:pookabu/layers/presentation/cubit/settings/setting_cubit.dart';
import 'package:pookabu/layers/presentation/bloc/review/review_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/visitation/visitation_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/profile/profile_bloc.dart';
import 'package:pookabu/shared/constant/config.dart';
import 'package:pookabu/shared/localization/generated/message.dart';
import 'package:pookabu/shared/localization/l10n.dart';
import 'package:pookabu/shared/router/app_routes.dart';
import 'package:pookabu/shared/styles/theme.dart';

class PookabuApp extends StatefulWidget {
  const PookabuApp({super.key});

  @override
  State<PookabuApp> createState() => _PookabuAppState();
}

class _PookabuAppState extends State<PookabuApp> {
  @override
  initState() {
    super.initState();
    initPlugin();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SettingsCubit>()..getActiveTheme()),
        BlocProvider(create: (_) => sl<UserBloc>()..add(CheckRequestedEvent())),
        BlocProvider(create: (_) => sl<MapBloc>()),
        BlocProvider(create: (_) => sl<VisitataionBloc>()),
        BlocProvider(create: (_) => sl<ReviewBloc>()),
        BlocProvider(create: (_) => sl<ProfileBloc>()),
        BlocProvider(create: (_) => sl<ToiletBloc>()),
        BlocProvider(create: (_) => sl<AnnouncementBloc>())
      ],
      child: OKToast(
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, __) {
            AppRoute.setStream(context);

            return BlocBuilder<SettingsCubit, SettingState>(
              builder: (_, data) => MaterialApp.router(
                routerConfig: AppRoute.router,
                localizationsDelegates: const [
                  Messages.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                debugShowCheckedModeBanner: false,
                builder: (BuildContext context, Widget? child) {
                  final MediaQueryData data = MediaQuery.of(context);

                  return MediaQuery(
                    data: data.copyWith(
                      alwaysUse24HourFormat: true,
                      textScaler: const TextScaler.linear(1),
                    ),
                    child: child!,
                  );
                },
                title: Config.appName,
                theme: themeLight(context),
                darkTheme: themeDark(context),
                locale: Locale(data.type ?? "ko"),
                supportedLocales: L10n.all,
                themeMode: data.activeTheme.mode,
              ),
            );
          },
        ),
      ),
    );
  }

  // App Tracking Transparency
  Future<void> initPlugin() async {
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
