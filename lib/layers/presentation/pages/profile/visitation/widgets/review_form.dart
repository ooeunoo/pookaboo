import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/data/models/visitation/visitation.dart';
import 'package:pookabu/layers/domain/entities/review/create_review_params.dart';
import 'package:pookabu/layers/presentation/bloc/review/review_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/visitation/visitation_bloc.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/constant/assets.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/utils/helper/url_helper.dart';
import 'package:pookabu/shared/widgets/app_rating_card.dart';
import 'package:pookabu/shared/widgets/app_star_point.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';
import 'package:pookabu/shared/widgets/common/app_divider.dart';
import 'package:pookabu/shared/widgets/common/app_snak_bar.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';
import 'package:pookabu/shared/widgets/common/app_text_input.dart';
import 'package:pookabu/shared/widgets/app_review_header.dart';

class ReviewForm extends StatefulWidget {
  final String userId;
  final Visitation visitation;

  const ReviewForm({super.key, required this.visitation, required this.userId});

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final ScrollController _scrollController = ScrollController();
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();
  bool _disable = true;
  Rating _ratingController =
      Rating(cleanliness: 0, safety: 0, convenience: 0, management: 0);
  final List<XFile> _uploadImages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
    _scrollController.dispose();
    _commentFocusNode.dispose();
  }

  void _onChangeRatingScore(RatingScoreType key, double value) {
    switch (key) {
      case RatingScoreType.cleanliness:
        _ratingController = _ratingController.copyWith(cleanliness: value);
      case RatingScoreType.convenience:
        _ratingController = _ratingController.copyWith(convenience: value);
      case RatingScoreType.management:
        _ratingController = _ratingController.copyWith(management: value);
      case RatingScoreType.safety:
        _ratingController = _ratingController.copyWith(safety: value);
    }

    bool disable;
    if (_ratingController.cleanliness <= 0 ||
        _ratingController.convenience <= 0 ||
        _ratingController.management <= 0 ||
        _ratingController.safety <= 0) {
      disable = true;
    } else {
      disable = false;
    }
    setState(() {
      _disable = disable;
    });
  }

  void _onSave() async {
    CreateReviewParams params = CreateReviewParams(
        visitationId: widget.visitation.id,
        toiletId: widget.visitation.toilet.id,
        userId: widget.userId,
        cleanliness: _ratingController.cleanliness,
        convenience: _ratingController.convenience,
        safety: _ratingController.safety,
        management: _ratingController.management,
        comment: _commentController.text);
    if (mounted) {
      context.read<ReviewBloc>().add(CreateToiletReviewEvent(params: params));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewBloc, ReviewState>(listener: ((context, state) {
      if (state is SuccessCreateToiletReviewState) {
        NotifyReviewWritedSnackBar(context);
        context
            .read<VisitataionBloc>()
            .add(GetToiletVisitationsByUserIdEvent(user_id: widget.userId));
        context.back();
      }
    }), builder: (context, state) {
      return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /////////////////////////////////
              ///  Header
              /////////////////////////////////
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dimens.space30, horizontal: Dimens.space20),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    AppText("리뷰 작성",
                        style: Theme.of(context).textTheme.bodyLarge!),
                    Expanded(child: Container()),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SvgPicture.asset(Assets.close),
                    )
                  ],
                ),
              ),
              /////////////////////////////////
              ///  Header & RATING
              /////////////////////////////////
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
                child: Column(
                  children: [
                    AppReviewHeader(
                        image: widget.visitation.toilet.image_url,
                        name: widget.visitation.toilet.name,
                        date: widget.visitation.created_at),
                    const AppSpacerV(),
                    AppDivider(
                        height: Dimens.space1, color: Palette.coolGrey10),
                    const AppSpacerV(),
                    _ratingsStarSelectForm(_onChangeRatingScore),
                    const AppSpacerV()
                  ],
                ),
              ),
              /////////////////////////////////
              ///  DIVIDER
              /////////////////////////////////
              AppSpacerV(value: Dimens.space30),
              const AppDivider(),
              AppSpacerV(value: Dimens.space30),
              /////////////////////////////////
              ///  COMMENT & BUTTON
              /////////////////////////////////
              // Padding(
              //   padding: EdgeInsets.only(
              //     right: Dimens.space20,
              //     left: Dimens.space20,
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       AppText("사진",
              //           style: Theme.of(context).textTheme.bodyMedium!),
              //       _uploadImageForm(),
              //       AppSpacerV(value: Dimens.space30),
              //       AppSpacerV(value: Dimens.space30),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(
                  right: Dimens.space20,
                  left: Dimens.space20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText("의견",
                        style: Theme.of(context).textTheme.bodyMedium!),
                    _commentTextInputForm(
                        _commentController, _commentFocusNode),
                    AppSpacerV(value: Dimens.space30),
                    AppButton(
                        title: "리뷰 작성", onPressed: _onSave, disable: _disable),
                    AppSpacerV(value: Dimens.space30),
                  ],
                ),
              ),
            ],
          ));
    });
  }

  Widget _uploadImageForm() {
    return Container();
  }

  Widget _commentTextInputForm(
      TextEditingController controller, FocusNode node) {
    return AppTextInput(
      hintText: '화장실을 사용하면서 좋았던 점 또는 아쉬웠던 점을 공유해주세요.',
      keyboardType: TextInputType.text,
      controller: controller,
      curFocusNode: node,
      minLine: 4,
      maxLine: 10,
      verticalMargin: 0,
      onTapOutside: (_) {
        node.unfocus();
      },
      textAlign: TextAlign.start,
      scrollPadding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    );
  }

  Widget _ratingsStarSelectForm(
      void Function(RatingScoreType, double) onChangeRatingScore) {
    return Column(
      children: [
        ...RatingScoreType.values.map((value) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: Dimens.space12),
            child: Column(
              children: [
                AppRatingCard(
                    name: value.name,
                    description: value.description,
                    emoji: value.emoji),
                const AppSpacerV(),
                Padding(
                  padding: EdgeInsets.only(left: Dimens.space50),
                  child: AppStarScore(
                      iconSize: 30,
                      onChange: (int v) {
                        onChangeRatingScore(value, v.toDouble());
                      }),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
