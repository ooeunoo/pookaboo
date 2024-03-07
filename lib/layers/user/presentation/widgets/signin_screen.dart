import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pookaboo/layers/auth/presentation/bloc/auth_bloc.dart';
import 'package:pookaboo/shared/constant/images.dart';
import 'package:pookaboo/shared/extension/context.dart';
import 'package:pookaboo/shared/extension/string.dart';
import 'package:pookaboo/shared/localization/generated/message.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/widgets/app_button.dart';
import 'package:pookaboo/shared/widgets/app_parent.dart';
import 'package:pookaboo/shared/widgets/app_spacer_v.dart';
import 'package:pookaboo/shared/widgets/app_text.dart';
import 'package:pookaboo/shared/widgets/app_text_input.dart';
import 'package:pookaboo/shared/widgets/app_top_bar.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInScreen> {
  void _signInWithKakao() {
    context.read<AuthBloc>().add(const AuthEvent.signInWithKakaoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: Dimens.header,
        leading: Padding(
          padding: EdgeInsets.only(left: Dimens.space24),
          child: AppText(Messages.of(context)!.myPage,
              style: Theme.of(context).textTheme.bodyLarge!),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(Dimens.space24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                Messages.of(context)!.recommendSignIn,
                style: Theme.of(context).textTheme.labelLarge!,
                align: TextAlign.center,
              ),
              AppSpacerV(value: Dimens.space24),
              AppButton(
                title: Messages.of(context)!.startWithKakao,
                onPressed: _signInWithKakao,
                image: SvgPicture.asset(
                  Images.kakaoLogo,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}