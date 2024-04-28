import 'package:flutter/material.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class AppRatingCard extends StatelessWidget {
  final String name;
  final String description;
  final String emoji;
  final double? score;

  const AppRatingCard(
      {super.key,
      required this.name,
      required this.description,
      required this.emoji,
      this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(
              width: context.widthInPercent(60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(name, style: Theme.of(context).textTheme.bodySmall!),
                  AppSpacerV(value: Dimens.space4),
                  AppText(description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium!),
                ],
              ),
            )
          ],
        ),
        if (score != null) ...{
          Row(
            children: [
              AppText('$score ⭐️',
                  style: Theme.of(context).textTheme.bodyMedium!),
            ],
          )
        }
      ],
    );
  }
}
