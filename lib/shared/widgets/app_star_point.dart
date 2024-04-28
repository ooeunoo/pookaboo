import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';

class AppStarScore extends StatefulWidget {
  final void Function(int rating) onChange;
  final double? iconSize;

  const AppStarScore({
    super.key,
    required this.onChange,
    this.iconSize = 24.0, // Default icon size
  });

  @override
  _AppStarScoreState createState() => _AppStarScoreState();
}

class _AppStarScoreState extends State<AppStarScore> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              if (rating == index + 1) {
                rating = 0;
              } else {
                rating = index + 1;
              }
              widget.onChange(rating);
            });
          },
          child: Padding(
            padding: EdgeInsets.only(right: Dimens.space4),
            child: Icon(
              rating >= index + 1 ? Icons.star : Icons.star_border,
              color: rating >= index + 1 ? Colors.yellow : Colors.grey,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
