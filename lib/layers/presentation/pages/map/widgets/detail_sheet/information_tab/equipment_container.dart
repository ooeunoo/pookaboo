import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class EquipmentContainer extends StatelessWidget {
  final List<Map<String, dynamic>> equipments;

  const EquipmentContainer({super.key, required this.equipments});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ...equipments.map((equipment) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.space20, vertical: Dimens.space12),
          child: _equipmentWidget(context, equipment["emoji"],
              equipment["title"], equipment["value"]),
        );
      })
    ]);
  }

  Widget _equipmentWidget(
      BuildContext context, String emoji, String title, String count) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          Container(
            width: Dimens.space40,
            height: Dimens.space40,
            decoration: BoxDecoration(
              color: const Color(0xff31363F),
              borderRadius: BorderRadius.circular(Dimens.space60),
            ),
            child: Center(
                child: AppText(emoji,
                    style: Theme.of(context).textTheme.bodySmall!)),
          ),
          const AppSpacerH(),
          AppText(title, style: Theme.of(context).textTheme.bodySmall!),
          const AppSpacerH(),
          Container(
            decoration: BoxDecoration(
              color: Palette.coolGrey10,
              borderRadius: BorderRadius.circular(Dimens.space4),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.space4, vertical: Dimens.space2),
              child: Center(
                  child: AppText("장애인",
                      style: Theme.of(context).textTheme.labelMedium!)),
            ),
          ),
          AppSpacerH(value: Dimens.space4),
          Container(
            decoration: BoxDecoration(
              color: Palette.coolGrey10,
              borderRadius: BorderRadius.circular(Dimens.space4),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.space4, vertical: Dimens.space2),
              child: Center(
                  child: AppText("어린이",
                      style: Theme.of(context).textTheme.labelMedium!)),
            ),
          ),
        ],
      ),
      AppText('$count 개', style: Theme.of(context).textTheme.labelLarge!)
    ]);
  }
}
