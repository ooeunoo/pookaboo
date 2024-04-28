import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/theme.dart';
import 'package:pookabu/shared/widgets/common/app_loading.dart';

extension ContextExtensions on BuildContext {
  bool isMobile() {
    final shortestSide = MediaQuery.of(this).size.shortestSide;

    return shortestSide < 600;
  }

  double widthInPercent(double percent) {
    final toDouble = percent / 100;

    return MediaQuery.of(this).size.width * toDouble;
  }

  double heightInPercent(double percent) {
    final toDouble = percent / 100;
    return MediaQuery.of(this).size.height * toDouble;
  }

  static late BuildContext ctx;

  showSnackBar(SnackBar snackbar) =>
      ScaffoldMessenger.of(this).showSnackBar(snackbar);

  void back() {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop();
    }
  }

  void dismiss() {
    try {
      Navigator.pop(ctx);
    } catch (_) {}
  }
}
