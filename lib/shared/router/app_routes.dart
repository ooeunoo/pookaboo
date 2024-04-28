import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pookabu/injection.dart';
import 'package:pookabu/layers/presentation/bloc/announcement/announcement_bloc.dart';
import 'package:pookabu/layers/presentation/cubit/app/app_cubit.dart';
import 'package:pookabu/layers/presentation/pages/app.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/review/review_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/visitation/visitation_bloc.dart';
import 'package:pookabu/layers/presentation/pages/profile/announcement/announcement.dart';
import 'package:pookabu/layers/presentation/pages/profile/edit_profile/edit_profile.dart';
import 'package:pookabu/layers/presentation/pages/profile/profile.dart';
import 'package:pookabu/layers/presentation/pages/splash/splash.dart';
import 'package:pookabu/layers/presentation/pages/map/map.dart';
import 'package:pookabu/layers/presentation/pages/profile/review/review.dart';
import 'package:pookabu/layers/presentation/pages/profile/toilet_proposal/toilet_proposal.dart';
import 'package:pookabu/layers/presentation/pages/profile/visitation/visitation.dart';
import 'package:pookabu/shared/router/extra_params.dart';
import 'package:pookabu/shared/router/router_refresh_stream.dart';

enum AppRoutes {
  splash("/splash"),

  // map page
  map("/map"),

  // profile page
  profile("/profile"),

  // init profile
  init_profile('/init_profile'),

  // visitation page
  visitation('/visitation'),
  // Announcement page
  announcement('/announcement'),

  // review page
  reviews("/reviews"),

  toilet_proposal('/toilet_proposal'),

  edit_profile("/edit_profile"),
  ;

  const AppRoutes(this.path);

  final String path;
}

class AppRoute {
  static late BuildContext context;

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  AppRoute.setStream(BuildContext ctx) {
    context = ctx;
  }

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: AppRoutes.splash.path,
        name: AppRoutes.splash.name,
        builder: (_, __) => const SplashPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BlocProvider(
            create: (context) => sl<AppCubit>()..changeBottomNavigation(0),
            child: AppPage(screen: child),
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.map.path,
            name: AppRoutes.map.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MapPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile.path,
            name: AppRoutes.profile.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.announcement.path,
            name: AppRoutes.announcement.name,
            pageBuilder: (context, state) {
              context.read<AnnouncementBloc>().add(GetAnnouncementsEvent());
              return const MaterialPage(
                child: AnnouncementPage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.visitation.path,
            name: AppRoutes.visitation.name,
            pageBuilder: (context, state) {
              final extra = state.extra! as ExtraParams;
              context.read<VisitataionBloc>().add(
                  GetToiletVisitationsByUserIdEvent(user_id: extra.userId));
              return MaterialPage(
                child: VisitationPage(userId: extra.userId),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.reviews.path,
            name: AppRoutes.reviews.name,
            pageBuilder: (context, state) {
              final extra = state.extra! as ExtraParams;
              context
                  .read<ReviewBloc>()
                  .add(GetToiletReviewsByUserIdEvent(user_id: extra.userId));
              return MaterialPage(
                child: ReviewPage(userId: extra.userId),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.edit_profile.path,
            name: AppRoutes.edit_profile.name,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: EditProfilePage(),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.toilet_proposal.path,
            name: AppRoutes.toilet_proposal.name,
            pageBuilder: (context, state) {
              final extra = state.extra! as ExtraParams;
              return MaterialPage(
                child: ToiletProposal(userId: extra.userId),
              );
            },
          ),
        ],
      ),
    ],
    initialLocation: AppRoutes.map.path,
    routerNeglect: true,
    // debugLogDiagnostics: kDebugMode,
    refreshListenable: RouterRefreshStream(context.read<UserBloc>().stream),
    redirect: (_, GoRouterState state) {
      // String currentPath = state.matchedLocation;

      // // 프로필 페이지로 이동한 경우, 로그인이 되어있지않다면 로그인 페이지로 이동
      // if (currentPath == AppRoutes.profile.path) {
      //   final userState = context.read<UserBloc>().state;
      //   final bool isUserAuthenticated = userState.maybeWhen(
      //     authUserUnauthenticated: () => false,
      //     authUserAuthenticated: (_) => true,
      //     orElse: () => false,
      //   );

      //   // 사용자가 로그인되어 있지 않은 경우 로그인 페이지로 리디렉션합니다.
      //   if (!isUserAuthenticated) {
      //     return AppRoutes.login.path;
      //   }
      // }

      // if (currentPath == AppRoutes.login.path) {}

      // ///  Check if not login
      // ///  if current page is login page we don't need to direct user
      // ///  but if not we must direct user to login page
      // if (!((MainBoxMixin.mainBox?.get(MainBoxKeys.isLogin.name) as bool?) ??
      //     false)) {
      //   return isLoginPage ? null : AppRoutes.login.path;
      // }

      // /// Check if already login and in login page
      // /// we should direct user to main page

      // if (isLoginPage &&
      //     ((MainBoxMixin.mainBox?.get(MainBoxKeys.isLogin.name) as bool?) ??
      //         false)) {
      //   return AppRoutes.root.path;
      // }

      /// No direct
      return null;
    },
  );
}
