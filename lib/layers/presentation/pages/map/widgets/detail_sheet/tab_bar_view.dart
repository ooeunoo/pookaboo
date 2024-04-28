import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookabu/injection.dart';
import 'package:pookabu/layers/presentation/bloc/toilet/toilet_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/presentation/bloc/review/review_bloc.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/information_tab/information.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/review_tab/review.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';

class DetailSheetTabBarView extends StatefulWidget {
  final Toilet toilet;

  const DetailSheetTabBarView(this.toilet, {super.key});

  @override
  _DetailSheetTabBarViewState createState() => _DetailSheetTabBarViewState();
}

class _DetailSheetTabBarViewState extends State<DetailSheetTabBarView> {
  Toilet get toilet => widget.toilet;

  int _selectedIndex = 0;
  late String rating;
  late String totalReviews;

  @override
  initState() {
    super.initState();
    totalReviews = toilet.total_reviews.toString();
    rating = Rating.getAverageRating(toilet.rating!).toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        builder: (context, UserState state) {
      bool shouldBlur = state is! AuthenticatedState;

      return Column(
        children: [
          /////////////////////////////////////////////////////////////////////////////////
          ////// TabBar
          /////////////////////////////////////////////////////////////////////////////////
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Center(
              child: Row(
                children: [
                  _buildTabItem(0, '정보'),
                  // AppSpacerH(
                  //   value: Dimens.space12,
                  // ),
                  _buildTabItem(1, '⭐️ 평점 $rating ($totalReviews)'),
                ],
              ),
            ),
          ),

          AppSpacerV(value: Dimens.space20),

          /////////////////////////////////////////////////////////////////////////////////
          ////// TabBar View
          /////////////////////////////////////////////////////////////////////////////////
          IndexedStack(
            index: _selectedIndex,
            children: [
              /////////////////////////////////////
              /////////////////////////////////////
              /////////////////////////////////////
              Visibility(
                visible: _selectedIndex == 0,
                child: BlocProvider(
                  create: (context) => sl<ToiletBloc>()
                    ..add(GetToiletImagesEvent(toiletId: widget.toilet.id)),
                  child: shouldBlur
                      ? _blurredContainer(DetailSheetInformation(widget.toilet))
                      : DetailSheetInformation(widget.toilet),
                ),
              ),

              /////////////////////////////////////
              /////////////////////////////////////
              /////////////////////////////////////
              Visibility(
                visible: _selectedIndex == 1,
                child: BlocProvider(
                  create: (context) => sl<ReviewBloc>()
                    ..add(GetToiletReviewsByToiletIdEvent(
                        toilet_id: widget.toilet.id)),
                  child: shouldBlur
                      ? _blurredContainer(DetailSheetReview(widget.toilet))
                      : DetailSheetReview(widget.toilet),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  /////////////////////////////////////////////////////////////////////////////////
  ////// Tab Item
  /////////////////////////////////////////////////////////////////////////////////
  Widget _buildTabItem(int index, String title) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: Dimens.space150,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color:
                  _selectedIndex == index ? Colors.white : Colors.transparent,
              width: Dimens.space1,
            ),
          ),
        ),
        // padding: EdgeInsets.symmetric(vertical: Dimens.space10),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.space10),
          child: Center(
            child: Text(
              title,
              style: _selectedIndex == index
                  ? Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Palette.coolGrey01,
                      )
                  : Theme.of(context).textTheme.labelLarge!,
            ),
          ),
        ),
      ),
    );
  }

  Widget _blurredContainer(Widget child) {
    return child.blurred(
      blur: 3,
      blurColor: Palette.coolGrey11,
    );
  }
}
