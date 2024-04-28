// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

SnackBar AppSnackBar(BuildContext context, Widget content,
    {int? duration, double? height}) {
  return SnackBar(
    backgroundColor: Palette.coolGrey11,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimens.space12),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
    duration: Duration(seconds: duration ?? 2),
    margin: EdgeInsets.only(
        bottom: height ?? 0, left: Dimens.space20, right: Dimens.space20),
    content: content,
  );
}

// 로그인 후 이용해주세요.
void NotifyRequireLoginSnackBar(BuildContext context) {
  context.showSnackBar(AppSnackBar(
      context,
      height: Dimens.space12,
      Row(
        children: [
          AppText('로그인',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Palette.lemon03, fontWeight: FontWeight.bold)),
          AppText(' 후 이용 해주세요', style: Theme.of(context).textTheme.bodySmall!),
        ],
      )));
}

// 문의하신 내용이 등록되었습니다.
void NotifyAfterInquirySnackBar(
  BuildContext context,
) {
  context.showSnackBar(AppSnackBar(
    context,
    height: Dimens.space12,
    AppText('문의하신 내용이 등록되었습니다.', style: Theme.of(context).textTheme.bodySmall!),
  ));
}

// 내 정보를 수정했어요.
void NotifyAfterEditProfileSnackBar(BuildContext context) {
  context.showSnackBar(AppSnackBar(
      context,
      height: Dimens.space12,
      AppText('내 정보를 수정했어요.', style: Theme.of(context).textTheme.bodySmall!)));
}

// 마이페이지 -> 내 정보 수정 에서 바꿀 수 있어요.
void NotifyGuideProfileEditSnackBar(BuildContext context) {
  context.showSnackBar(AppSnackBar(
      context,
      height: Dimens.space12,
      Row(
        children: [
          AppText('마이페이지 -> 내 정보 수정',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Palette.lemon03,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimens.labelMedium)),
          AppText('에서 바꿀 수 있어요.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: Dimens.labelMedium)),
        ],
      )));
}

// 화장실 리뷰를 등록했어요!
void NotifyReviewWritedSnackBar(BuildContext context) {
  context.showSnackBar(AppSnackBar(
      context,
      height: Dimens.space12,
      AppText('화장실 리뷰를 등록했어요!',
          style: Theme.of(context).textTheme.bodySmall!)));
}

// [설정]에서 위치 접근을 허용해주세요!
void NotifyLocationPermissionSnackBar(BuildContext context) {
  context.showSnackBar(AppSnackBar(
      context,
      height: Dimens.space12,
      AppText("[설정]에서 위치 접근을 허용해주세요!",
          style: Theme.of(context).textTheme.bodySmall!)));
}
