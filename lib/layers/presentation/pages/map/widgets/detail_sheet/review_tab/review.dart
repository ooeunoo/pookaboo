import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookabu/layers/data/models/review/review.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/presentation/bloc/review/review_bloc.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/app_rating_card.dart';
import 'package:pookabu/shared/widgets/app_review_card.dart';
import 'package:pookabu/shared/widgets/common/app_divider.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class DetailSheetReview extends StatefulWidget {
  final Toilet toilet;

  const DetailSheetReview(this.toilet, {super.key});

  @override
  State<DetailSheetReview> createState() => _DetailSheetReviewState();
}

class _DetailSheetReviewState extends State<DetailSheetReview> {
  late List<Review> _reviews = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewBloc, ReviewState>(
        listener: (context, state) async {
      if (state is LoadedToiletReviewsByToiletIdState) {
        _reviews = state.reviews;
      }
    }, builder: (context, state) {
      return Padding(
        padding: EdgeInsets.only(bottom: Dimens.space100),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          /////////////////////////////////////////////////////////////////////////////////
          ////// Rating
          /////////////////////////////////////////////////////////////////////////////////
          ...RatingScoreType.values.map((value) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.space20, vertical: Dimens.space12),
              child: AppRatingCard(
                name: value.name,
                description: value.description,
                emoji: value.emoji,
                score: widget.toilet.rating?.toJson()[value.key],
              ),
            );
          }),
          /////////////////////////////////////////////////////////////////////////////////
          ////// DIVIDER
          /////////////////////////////////////////////////////////////////////////////////
          AppSpacerV(value: Dimens.space30),
          const AppDivider(),
          AppSpacerV(value: Dimens.space30),
          /////////////////////////////////////////////////////////////////////////////////
          ////// COMMENT TITLE
          /////////////////////////////////////////////////////////////////////////////////
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
            child: AppText("후기 ${_reviews.length}",
                style: Theme.of(context).textTheme.bodyMedium!),
          ),
          AppSpacerV(value: Dimens.space30),
          /////////////////////////////////////////////////////////////////////////////////
          ////// RATINGS
          /////////////////////////////////////////////////////////////////////////////////
          ..._reviews.asMap().entries.map((entry) {
            final int index = entry.key;
            final review = entry.value;
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.space20, vertical: Dimens.space12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppReviewCard(review: review),
                  AppSpacerV(value: Dimens.space20),
                  if (index != _reviews.length - 1)
                    AppDivider(
                        color: Palette.coolGrey08, height: Dimens.space1),
                ],
              ),
            );
          })
        ]),
      );
    });
  }
}
