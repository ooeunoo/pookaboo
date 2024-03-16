import 'package:flutter/material.dart';
import 'package:pookaboo/layers/toilet/data/models/toilet.dart';
import 'package:pookaboo/shared/constant/enum.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/styles/palette.dart';
import 'package:pookaboo/shared/widgets/app_divider.dart';
import 'package:pookaboo/shared/widgets/app_spacer_h.dart';
import 'package:pookaboo/shared/widgets/app_spacer_v.dart';
import 'package:pookaboo/shared/widgets/app_text.dart';

class ToiletBottomSheetReview extends StatefulWidget {
  final Toilet toilet;

  const ToiletBottomSheetReview(this.toilet, {super.key});

  @override
  State<ToiletBottomSheetReview> createState() =>
      _ToiletBottomSheetReviewState();
}

class _ToiletBottomSheetReviewState extends State<ToiletBottomSheetReview> {
  late final List<Map<String, dynamic>> _ratings = [];
  late List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();

    Rating toiletRatingScore = widget.toilet.rating!;

    for (var scoreType in RatingScoreType.values) {
      double score = widget.toilet.rating?.toJson()[scoreType.key];
      _ratings.add({
        "emoji": scoreType.emoji,
        "title": scoreType.name,
        "subTitle": "변기, 세면대 주변이 깨끗해요깨끗해요깨끗해요깨끗해요깨끗해요깨끗해요.",
        'score': score.toStringAsFixed(1)
      });
    }

    // _ratings = [
    //   {
    //     "emoji": "🧹",
    //     "title": "청결도",
    //     "subTitle": "변기, 세면대 주변이 깨끗해요.",
    //     "score": "3"
    //   },
    //   {
    //     "emoji": "🎛️",
    //     "title": "편의성",
    //     "subTitle": "시설, 어메니티 등 사용하기 편리해요.",
    //     "score": "3"
    //   },
    //   {
    //     "emoji": "🫧",
    //     "title": "관리도",
    //     "subTitle": "변기, 세면대 주변이 깨끗해요.",
    //     "score": "3"
    //   },
    //   {
    //     "emoji": "🚨",
    //     "title": "안전성",
    //     "subTitle": "밤 늦게 사용해도 안전해요.",
    //     "score": "3"
    //   },
    // ];
    _reviews = [
      {
        'rating': {
          "clean": "1",
          "management": "2",
          "convenience": "2",
          "safety": "3",
        },
        "comment": "좋아, 좋아",
        "user": "최민식",
        "date": "2022.03.04"
      },
      {
        'rating': {
          "clean": "1",
          "management": "2",
          "convenience": "2",
          "safety": "3",
        },
        "comment": "좋아, 좋아",
        "user": "김민호",
        "date": "2022.03.06"
      },
      {
        'rating': {
          "clean": "1",
          "management": "2",
          "convenience": "2",
          "safety": "3",
        },
        "comment": "좋아, 좋아",
        "user": "유인서",
        "date": "2021.07.04"
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.space100),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        /////////////////////////////////////////////////////////////////////////////////
        ////// Rating
        /////////////////////////////////////////////////////////////////////////////////
        ..._ratings.map((rating) {
          return _rating(
            rating['emoji'] as String,
            rating['title'] as String,
            rating['subTitle'] as String,
            rating['score'] as String,
          );
        }),
        AppSpacerV(value: Dimens.space30),
        const AppDivider(),
        AppSpacerV(value: Dimens.space30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
          child: AppText("후기 ${_reviews.length}",
              style: Theme.of(context).textTheme.bodyMedium!),
        ),
        AppSpacerV(value: Dimens.space30),
        /////////////////////////////////////////////////////////////////////////////////
        ////// Review
        /////////////////////////////////////////////////////////////////////////////////
        ..._reviews.map((review) {
          return _review(
              review['rating'] as Map<String, String>,
              review['comment'] as String,
              review['user'] as String,
              review['date'] as String);
        })
      ]),
    );
  }

  Widget _rating(String emoji, String title, String subTitle, String score) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimens.space20, vertical: Dimens.space12),
      child: Row(
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
                width: Dimens.fullWidth(context) * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(title,
                        style: Theme.of(context).textTheme.bodySmall!),
                    AppSpacerV(value: Dimens.space2),
                    AppText(subTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium!),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              AppText('$score ⭐️',
                  style: Theme.of(context).textTheme.bodyMedium!),
              // AppText('⭐️')
            ],
          )
        ],
      ),
    );
  }

  Widget _review(
      Map<String, String> rating, String comment, String user, String date) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Dimens.space20, vertical: Dimens.space12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatings(rating),
            AppSpacerV(
              value: Dimens.space20,
            ),
            AppText(comment, style: Theme.of(context).textTheme.bodyMedium!),
            AppSpacerV(
              value: Dimens.space12,
            ),
            Row(
              children: [
                AppText("$user﹒$date",
                    style: Theme.of(context).textTheme.labelMedium!),
              ],
            ),
            AppSpacerV(
              value: Dimens.space12,
            ),
            AppDivider(color: Palette.coolGrey08, height: Dimens.space1),
          ],
        ));
  }

  Widget _buildRatingLabel(String label, String rating, {bool divider = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText("$label ", style: Theme.of(context).textTheme.labelLarge!),
        AppText(rating,
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

  Widget _buildRatings(Map<String, dynamic> ratings) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRatingLabel("청결도", ratings['clean']),
        _buildRatingLabel("편의성", ratings['convenience']),
        _buildRatingLabel("관리도", ratings['management']),
        _buildRatingLabel("안전성", ratings['safety'], divider: false),
      ],
    );
  }
}
