import 'package:flutter/material.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class AppRatingRow extends StatefulWidget {
  final Rating rating;

  const AppRatingRow({super.key, required this.rating});

  @override
  State<AppRatingRow> createState() => _AppRatingRowState();
}

class _AppRatingRowState extends State<AppRatingRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRatingLabel("청결도", widget.rating.cleanliness),
        _buildRatingLabel("편의성", widget.rating.convenience),
        _buildRatingLabel("관리도", widget.rating.management),
        _buildRatingLabel("안전성", widget.rating.safety, divider: false),
      ],
    );
  }

  Widget _buildRatingLabel(String label, double rating, {bool divider = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText("$label ", style: Theme.of(context).textTheme.labelLarge!),
        AppText(rating.toStringAsFixed(0),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Palette.lemon03,
                )),
        if (divider) ...[
          const AppSpacerH(),
          AppText('|', style: Theme.of(context).textTheme.labelLarge!),
          const AppSpacerH(),
        ],
      ],
    );
  }
}
