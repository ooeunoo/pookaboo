import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pookabu/layers/data/models/review/review.dart';
import 'package:pookabu/layers/presentation/bloc/review/review_bloc.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/utils/helper/url_helper.dart';
import 'package:pookabu/shared/widgets/app_review_card.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';
import 'package:pookabu/shared/widgets/common/app_divider.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';
import 'package:pookabu/shared/widgets/app_review_header.dart';

class ReviewPage extends StatefulWidget {
  final String userId;

  const ReviewPage({super.key, required this.userId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late List<Review> _reviews = [];

  void _setReviews(List<Review> reviews) {
    _reviews = reviews;
  }

  void _openConfirmModal(int reviewId) {
    showDialog(
        context: context,
        barrierDismissible: false, // false로 변경
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.space16))),
            backgroundColor: Palette.coolGrey10,
            content: SizedBox(
              width: context.widthInPercent(95),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSpacerV(),
                  AppText('리뷰 삭제',
                      style: Theme.of(context).textTheme.bodyMedium!),
                  AppSpacerV(value: Dimens.space20),
                  AppText('복구 또는 다시 작성할 수 없어요.',
                      style: Theme.of(context).textTheme.labelLarge!),
                  AppText('삭제하시겠어요?',
                      style: Theme.of(context).textTheme.labelLarge!),
                  AppSpacerV(value: Dimens.space20),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                            title: '취소',
                            titleColor: Palette.coolGrey03,
                            color: Colors.transparent,
                            onPressed: () {
                              context.back();
                            }),
                      ),
                      const AppSpacerH(),
                      Expanded(
                        child: AppButton(
                            title: '삭제',
                            titleColor: Palette.coolGrey03,
                            color: Palette.red02,
                            onPressed: () {
                              context.read<ReviewBloc>().add(
                                  DeleteToiletReviewsByReviewIdEvent(
                                      reviewId: reviewId));
                              context.back();
                            }),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: Dimens.space16),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.back();
            },
          ),
        ),
        title: AppText(
          '나의 리뷰',
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(builder: (context, state) {
        if (state is LoadedToiletReviewsByUserIdState) {
          _setReviews(state.reviews);
        } else if (state is SuccessDeleteToiletReviewState) {
          context
              .read<ReviewBloc>()
              .add(GetToiletReviewsByUserIdEvent(user_id: widget.userId));
        }

        return Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.space20),
            child: ListView.builder(
              itemCount: _reviews.isEmpty ? 0 : _reviews.length,
              itemBuilder: (context, index) {
                final review = _reviews[index];

                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.space20, vertical: Dimens.space12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppReviewHeader(
                          image: review.toilet!.image_url,
                          name: review.toilet!.name,
                          date: review.created_at),
                      AppSpacerV(value: Dimens.space20),
                      AppReviewCard(review: review),
                      AppSpacerV(value: Dimens.space20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              _openConfirmModal(review.id);
                            },
                            child: AppText(
                              "삭제",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Palette.red01,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          )
                        ],
                      ),
                      AppSpacerV(value: Dimens.space16),
                      if (index !=
                          _reviews.length -
                              1) // Render AppDivider for all except the last index
                        AppDivider(
                            color: Palette.coolGrey08, height: Dimens.space1),
                    ],
                  ),
                );
              },
            ));
      }),
    );
  }
}
