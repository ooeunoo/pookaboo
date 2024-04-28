import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';

class AppDragHandleBar extends StatelessWidget {
  const AppDragHandleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.space36,
      height: Dimens.space4,
      decoration: BoxDecoration(
        color: Palette.coolGrey06,
        borderRadius: BorderRadius.circular(Dimens.space4),
      ),
    );
  }
}
