import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/shared/constant/assets.dart';
import 'package:pookabu/shared/localization/generated/message.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInScreen> {
  void _signInWithKakao() {
    context.read<UserBloc>().add(SignInWithKakaoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimens.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              Messages.of(context)!.recommendLogIn,
              style: Theme.of(context).textTheme.labelLarge!,
              align: TextAlign.center,
            ),
            AppSpacerV(value: Dimens.space24),
            AppButton(
              title: Messages.of(context)!.startWithKakao,
              onPressed: _signInWithKakao,
              image: SvgPicture.asset(
                Assets.kakaoLogo,
              ),
            )
          ],
        ),
      ),
    );
  }
}
