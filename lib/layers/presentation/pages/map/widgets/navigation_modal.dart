import 'package:flutter/material.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/information_tab/information.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/location_guide.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/navigation_guide.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_divider.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class NavigationModal extends StatelessWidget {
  final Toilet toilet;
  final int time;

  const NavigationModal({super.key, required this.toilet, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /////////////////////////////////////////////
          ///  HEADER
          /////////////////////////////////////////////
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: context.widthInPercent(60),
                    child: AppText(toilet.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge!)),
              ],
            ),
          ),
          AppSpacerV(value: Dimens.space12),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.space20,
            ),
            child: LocationGuide(
              toilet: toilet,
              time: time,
              isExpand: false,
            ),
          ),
          AppSpacerV(value: Dimens.space12),
          AppDivider(height: Dimens.space1, color: Palette.coolGrey10),
          AppSpacerV(value: Dimens.space12),
          Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.space20,
              ),
              child: const NavigationGuide()),
        ],
      ),
    );
  }
}
