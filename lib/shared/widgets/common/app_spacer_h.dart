import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';

class AppSpacerH extends StatelessWidget {
  const AppSpacerH({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: value ?? Dimens.space8,
    );
  }
}
