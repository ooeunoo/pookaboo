import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pookaboo/layers/data/models/review/review.dart';
import 'package:pookaboo/layers/data/models/toilet/toilet.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/styles/palette.dart';
import 'package:pookaboo/shared/utils/helper/time_helper.dart';
import 'package:pookaboo/shared/widgets/app_rating_row.dart';
import 'package:pookaboo/shared/widgets/common/app_divider.dart';
import 'package:pookaboo/shared/widgets/common/app_spacer_v.dart';
import 'package:pookaboo/shared/widgets/common/app_text.dart';

class AppReviewCard extends StatefulWidget {
  final Review review;
  final int? maxLine;

  const AppReviewCard({super.key, required this.review, this.maxLine});

  @override
  State<AppReviewCard> createState() => _AppReviewCardState();
}

class _AppReviewCardState extends State<AppReviewCard> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppRatingRow(
            rating: Rating(
                cleanliness: widget.review.cleanliness,
                safety: widget.review.safety,
                convenience: widget.review.convenience,
                management: widget.review.management)),
        AppSpacerV(
          value: Dimens.space20,
        ),
        if (widget.review.comment.isNotEmpty) ...{
          GestureDetector(
            onTap: () {
              setState(() {
                isExpand = !isExpand;
              });
            },
            child: AppText(widget.review.comment,
                maxLines: isExpand ? null : (widget.maxLine ?? 3),
                overflow: isExpand ? null : TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!),
          ),
          AppSpacerV(
            value: Dimens.space20,
          ),
        },
        Row(
          children: [
            AppText(
                "${widget.review.user!.nickname ?? widget.review.user!.name}﹒${parseAndFormatDateTime(widget.review.created_at)}",
                style: Theme.of(context).textTheme.labelMedium!),
          ],
        ),
      ],
    );
  }
}
