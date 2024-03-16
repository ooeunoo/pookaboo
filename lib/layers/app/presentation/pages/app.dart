import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pookaboo/injection.dart';
import 'package:pookaboo/layers/app/presentation/cubit/app_cubit.dart';
import 'package:pookaboo/layers/app/presentation/pages/update_user_data_bottom_sheet/update_user_data_bottom_sheet.dart';
import 'package:pookaboo/layers/app/presentation/widgets/navigation_bar_item_widget.dart';
import 'package:pookaboo/shared/router/app_routes.dart';
import 'package:pookaboo/shared/service/storage/secure_storage.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/styles/palette.dart';

class AppPage extends StatefulWidget {
  final Widget screen;

  const AppPage({super.key, required this.screen});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final SecureStorage _secureStorage = sl<SecureStorage>();

  @override
  void initState() {
    super.initState();
  }

  void _checkUserUpdate() async {
    bool require = await _secureStorage.requiredUpdatedInitialUserData();
    if (require) {
      _showUpdateUserMetadataBottomSheet();
    }
  }

  void _showUpdateUserMetadataBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space20),
                topRight: Radius.circular(Dimens.space20))),
        builder: (context) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: const Wrap(
                children: <Widget>[
                  UpdateUserDataBottomSheet(),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    _checkUserUpdate();

    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              widget.screen,
            ],
          ),
          bottomNavigationBar: buildBottomNavigation(context, state),
        );
      },
    );
  }

  Widget buildBottomNavigation(BuildContext context, AppState state) {
    final tabs = [
      NavigationBarItemWidget(
        initialLocation: AppRoutes.map.path,
        icon: const Icon(Icons.search),
        label: 'Home',
      ),
      NavigationBarItemWidget(
        initialLocation: AppRoutes.profile.path,
        icon: const Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return Visibility(
        visible: state.visible,
        child: Container(
          // height: Dimens.,
          decoration: const BoxDecoration(
              color: Palette.coolGrey08,
              border: Border(
                  top: BorderSide(color: Palette.coolGrey08, width: 1.0))),
          child: BottomNavigationBar(
            onTap: (value) async {
              if (value != state.index) {
                context.read<AppCubit>().changeBottomNavigation(value);
                context.go(tabs[value].initialLocation);
                // 흠.. 바텀시트가 열려있을때 닫고 다른 페이지로 이동하기 위한 코드. 동작 이해 아직 안됨.
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

  Widget buildBottomSheet(BuildContext context) {
    return Container();
  }
}
