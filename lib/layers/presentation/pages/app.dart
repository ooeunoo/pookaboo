import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pookabu/layers/presentation/cubit/app/app_cubit.dart';
import 'package:pookabu/layers/presentation/pages/widgets/navigation_bar_item_widget.dart';
import 'package:pookabu/shared/router/app_routes.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/utils/helper/vibration_helper.dart';

class AppPage extends StatelessWidget {
  final Widget screen;

  const AppPage({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Palette.coolGrey12,
          resizeToAvoidBottomInset: false,
          body: screen,
          bottomNavigationBar: buildBottomNavigation(context, state),
        );
      },
    );
  }

  Widget buildBottomNavigation(BuildContext context, AppState state) {
    final tabs = [
      NavigationBarItemWidget(
        path: AppRoutes.map.path,
        icon: const Icon(Icons.search),
        label: 'Home',
      ),
      NavigationBarItemWidget(
        path: AppRoutes.profile.path,
        icon: const Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return Visibility(
        visible: state.visible,
        child: Container(
          decoration: const BoxDecoration(
              color: Palette.coolGrey08,
              border: Border(
                  top: BorderSide(color: Palette.coolGrey08, width: 1.0))),
          child: BottomNavigationBar(
            onTap: (value) async {
              onHeavyVibration();

              if (value != state.index) {
                context.read<AppCubit>().changeBottomNavigation(value);
                context.go(tabs[value].path);
                // 흠. 바텀시트가 열려있을때 닫고 다른 페이지로 이동하기 위한 코드. 동작 이해 아직 안됨.
                if (context.canPop()) {
                  context.pop();
                }
              }
            },
            elevation: 0,
            items: tabs
                .map((item) => BottomNavigationBarItem(
                      icon: item.icon,
                      label: item.label,
                    ))
                .toList(),
            currentIndex: state.index,
          ),
        ));
  }
}
