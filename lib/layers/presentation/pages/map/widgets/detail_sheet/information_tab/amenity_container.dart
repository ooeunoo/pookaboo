import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class AmenityContainer extends StatelessWidget {
  final List<Map<String, dynamic>> amenities;

  const AmenityContainer({super.key, required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ...amenities.map((amenity) {
        return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.space20, vertical: Dimens.space12),
            child: _amenityWidget(context, amenity["emoji"], amenity["title"]));
      })
    ]);
  }

  Widget _amenityWidget(BuildContext context, String emoji, String title) {
    return Row(children: [
      AppText(emoji, style: Theme.of(context).textTheme.bodySmall!),
      const AppSpacerH(),
      AppText(title, style: Theme.of(context).textTheme.bodySmall!),
      const AppSpacerH(),
    ]);
  }
}
