import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';

class AppDivider extends StatelessWidget {
  final Color? color;
  final double? height;

  const AppDivider({super.key, this.color, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color ?? Palette.coolGrey13, height: height ?? Dimens.space16);
  }
}
