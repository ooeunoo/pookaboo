import 'package:flutter/material.dart';
import 'package:pookaboo/layers/map/presentation/pages/map/widgets/bottom_sheet/information.dart';
import 'package:pookaboo/layers/map/presentation/pages/map/widgets/bottom_sheet/review.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/styles/palette.dart';
import 'package:pookaboo/shared/widgets/app_spacer_h.dart';
import 'package:pookaboo/shared/widgets/app_spacer_v.dart';

class ToiletBottomSeetTabBarView extends StatefulWidget {
  const ToiletBottomSeetTabBarView({super.key});

  @override
  _ToiletBottomSeetTabBarViewState createState() =>
      _ToiletBottomSeetTabBarViewState();
}

class _ToiletBottomSeetTabBarViewState
    extends State<ToiletBottomSeetTabBarView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /////////////////////////////////////////////////////////////////////////////////
        ////// TabBar
        /////////////////////////////////////////////////////////////////////////////////
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabItem(0, '정보'),
                AppSpacerH(
                  value: Dimens.space12,
                ),
                _buildTabItem(1, '평점'),
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
          children: const [
            ToiletBottomSheetInformation(),
            ToiletBottomSheetReview(),
          ],
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////////////////////////////////
  ////// Tab Item
  /////////////////////////////////////////////////////////////////////////////////
  Widget _buildTabItem(int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        width: 120, // Adjust the width as needed
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: _selectedIndex == index
                  ? Colors.white
                  : Colors.transparent, // Change color for selected tab
              width: 2.0, // Border width
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: Text(
            title,
            style: _selectedIndex == index
                ? Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimens.bodySmall,
                      color: Palette.text,
                    )
                : Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimens.labelLarge,
                      color: Palette.subText,
                    ),
          ),
        ),
      ),
    );
  }
}
