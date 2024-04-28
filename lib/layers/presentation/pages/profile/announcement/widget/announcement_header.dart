import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class AnnouncementHeader extends StatelessWidget {
  final String header;

  const AnnouncementHeader({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.space20, vertical: Dimens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(header, style: Theme.of(context).textTheme.bodyLarge!)
        ],
      ),
    );
  }
}
