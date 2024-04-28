import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class NavigationGuide extends StatelessWidget {
  const NavigationGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      AppText('조금만 참아주세요! 거의 다 도착했어요 😊',
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Palette.skyblue01)),
      // AppSpacerH(value: Dimens.space2),
      // AppText('3명',
      //     style: Theme.of(context)
      //         .textTheme
      //         .labelMedium!
      //         .copyWith(color: Palette.skyblue01, fontWeight: FontWeight.w600)),
      // // AppSpacerH(value: Dimens.space2),
      // AppText('이 달려가고 있어요 💨',
      //     style: Theme.of(context)
      //         .textTheme
      //         .labelMedium!
      //         .copyWith(color: Palette.skyblue01)),
    ]);
  }
}
