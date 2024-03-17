import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookaboo/layers/data/models/review/review.dart';
import 'package:pookaboo/layers/data/models/toilet/toilet.dart';
import 'package:pookaboo/layers/presentation/bloc/review/review_bloc.dart';
import 'package:pookaboo/shared/constant/enum.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/styles/palette.dart';
import 'package:pookaboo/shared/widgets/app_rating_card.dart';
import 'package:pookaboo/shared/widgets/app_review_card.dart';
import 'package:pookaboo/shared/widgets/common/app_divider.dart';
import 'package:pookaboo/shared/widgets/common/app_spacer_v.dart';
import 'package:pookaboo/shared/widgets/common/app_text.dart';

class ToiletBottomSheetReview extends StatefulWidget {
  final Toilet toilet;

  const ToiletBottomSheetReview(this.toilet, {super.key});

  @override
  State<ToiletBottomSheetReview> createState() =>
      _ToiletBottomSheetReviewState();
}

class _ToiletBottomSheetReviewState extends State<ToiletBottomSheetReview> {
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
          ..._reviews.map((review) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.space20, vertical: Dimens.space12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppReviewCard(review: review),
                  AppSpacerV(
                    value: Dimens.space20,
                  ),
                  AppDivider(color: Palette.coolGrey08, height: Dimens.space1),
                ],
              ),
            );
          })
        ]),
      );
    });
  }
}
