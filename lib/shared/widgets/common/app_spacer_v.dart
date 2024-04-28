import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';

class AppSpacerV extends StatelessWidget {
  const AppSpacerV({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: value ?? Dimens.space8,
    );
  }
}
