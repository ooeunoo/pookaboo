import 'package:flutter/material.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/localization/generated/message.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/styles/theme.dart';
import 'package:pookabu/shared/utils/helper/vibration_helper.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';
import 'package:intl/intl.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  final Color? color;
  final Color? titleColor;
  final TextStyle? titleStyle;

  final double? fontSize;
  final Color? splashColor;
  final Widget? image; // 이미지 추가
  final bool disable;
  final bool vibrate;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    this.titleColor,
    this.titleStyle,
    this.fontSize,
    this.splashColor,
    this.image,
    this.disable = false,
    this.vibrate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: Dimens.space8),
      height: height ?? Dimens.buttonH,
      width: width,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(Dimens.space16)),
      child: TextButton(
        onPressed: () {
          if (disable) return;

          onPressed();
        },
        style: ButtonStyle(
            backgroundColor: color != null
                ? MaterialStateProperty.all(color)
                : (disable
                    ? MaterialStateProperty.all(Palette.coolGrey09)
                    : MaterialStateProperty.all(Palette.lemon01)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.space16)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: Dimens.space4),
                    child: SizedBox(
                      width: Dimens.icon,
                      height: Dimens.icon,
                      child: image!,
                    ),
                  ),
                  AppSpacerH(value: Dimens.space8),
                ],
              ),
            AppText(
              title,
              style: titleStyle ??
                  Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: titleColor ??
                          (disable ? Palette.coolGrey06 : Palette.coolGrey12)),
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
