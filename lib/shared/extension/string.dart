import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/styles/theme.dart';
import 'package:pookabu/shared/utils/logging/log.dart';
import 'package:pookabu/shared/widgets/common/app_toast.dart';

extension StringExtension on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }

  // 파일 확장자 제거
  String extractFileNameWithoutExtension() {
    String fileNameWithExtension = split('/').last;
    String fileNameWithoutExtension = fileNameWithExtension.split('.').first;
    return fileNameWithoutExtension;
  }

  String extractValueFromUrl() {
    List<String> parts = split('?');
    String value = parts.first.split('/').last;
    return value;
  }

  void toToastError(BuildContext context) {
    try {
      final message = isEmpty ? "error" : this;

      //dismiss before show toast
      dismissAllToast(showAnim: true);
      showToastWidget(
        AppToast(
          bgColor: Palette.redLatte,
          icon: Icons.error,
          message: message,
          textColor: Colors.white,
        ),
        dismissOtherToast: true,
        position: ToastPosition.top,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      // FirebaseCrashLogger().nonFatalError(error: e, stackTrace: stackTrace);
      log.e("error $e");
    }
  }

  void toToastSuccess(BuildContext context) {
    try {
      final message = isEmpty ? "success" : this;

      //dismiss before show toast
      dismissAllToast(showAnim: true);

      // showToast(msg)
      showToastWidget(
        AppToast(
          bgColor: Palette.greenLatte,
          icon: Icons.check_circle,
          message: message,
          textColor: Colors.white,
        ),
        dismissOtherToast: true,
        position: ToastPosition.top,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      // FirebaseCrashLogger().nonFatalError(error: e, stackTrace: stackTrace);
      log.e("$e");
    }
  }

  void toToastLoading(BuildContext context) {
    try {
      final message = isEmpty ? "loading" : this;
      //dismiss before show toast
      dismissAllToast(showAnim: true);

      showToastWidget(
        AppToast(
          bgColor: Palette.pinkLatte,
          icon: Icons.info,
          message: message,
          textColor: Colors.white,
        ),
        dismissOtherToast: true,
        position: ToastPosition.top,
        duration: const Duration(seconds: 3),
      );
    } catch (e, stackTrace) {
      // FirebaseCrashLogger().nonFatalError(error: e, stackTrace: stackTrace);
      log.e("$e");
    }
  }
}
