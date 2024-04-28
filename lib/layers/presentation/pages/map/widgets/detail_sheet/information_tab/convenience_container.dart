import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class ConvenienceContainer extends StatelessWidget {
  final List<Map<String, dynamic>> conveniences;

  const ConvenienceContainer({super.key, required this.conveniences});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ...conveniences.map((convenience) {
        return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.space20, vertical: Dimens.space12),
            child: _convenienceWidget(
                context, convenience["emoji"], convenience["title"]));
      })
    ]);
  }

  Widget _convenienceWidget(BuildContext context, String emoji, String title) {
    return Row(children: [
      AppText(emoji, style: Theme.of(context).textTheme.bodySmall!),
      const AppSpacerH(),
      AppText(title, style: Theme.of(context).textTheme.bodySmall!),
      const AppSpacerH(),
    ]);
  }
}
