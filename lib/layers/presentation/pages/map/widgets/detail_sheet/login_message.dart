import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pookabu/layers/presentation/cubit/app/app_cubit.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/constant/assets.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class LogInMessage extends StatelessWidget {
  const LogInMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(builder: (context, state) {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          context.read<AppCubit>().changeBottomNavigation(1);
          context.go(BottomNavigation.profile.path);
          if (context.canPop()) {
            context.pop();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText('✨ 로그인하여 더 많은 정보를 확인해보세요.',
                style: Theme.of(context).textTheme.bodySmall!),
            SvgPicture.asset(
              Assets.arrowRight,
              colorFilter: const ColorFilter.mode(
                Palette.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      );
    });
  }
}
