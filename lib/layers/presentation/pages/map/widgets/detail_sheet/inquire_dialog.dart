import 'package:flutter/material.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';
import 'package:pookabu/shared/widgets/common/app_snak_bar.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';
import 'package:pookabu/shared/widgets/common/app_text_input.dart';

class InquireDialog extends StatefulWidget {
  final Toilet toilet;
  final void Function(String inquiry) confirmPress;

  const InquireDialog({
    super.key,
    required this.toilet,
    required this.confirmPress,
  });

  @override
  State<InquireDialog> createState() => _InquireDialogState();
}

class _InquireDialogState extends State<InquireDialog> {
  Toilet get toilet => widget.toilet;
  void Function(String inqury) get confirm => widget.confirmPress;

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _registerInquiry() {
    confirm(_controller.text);
    NotifyAfterInquirySnackBar(context);
    context.back();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.widthInPercent(95),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSpacerV(),
          Row(
            children: [
              AppText(
                '문의하기',
                style: Theme.of(context).textTheme.bodyMedium!,
              ),
              const AppSpacerH(),
            ],
          ),
          AppSpacerV(value: Dimens.space4),
          AppText(
            toilet.name,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium!,
          ),
          AppTextInput(
            verticalMargin: 0,
            controller: _controller,
            minLine: 3,
          ),
          AppSpacerV(value: Dimens.space12),
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
                    title: '등록',
                    titleColor: Palette.coolGrey12,
                    color: Palette.lemon01,
                    onPressed: () {
                      _registerInquiry();
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
