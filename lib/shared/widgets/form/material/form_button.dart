import 'package:flutter/material.dart' hide Step;
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';

enum ButtonsAlignment { vertical, horizontal }

class FormButton extends StatelessWidget {
  final void Function(StepResult? result)? onNextPress;
  final String? nextText;
  final void Function()? onBackPress;
  final void Function()? onSkipPress;

  final StepResult? result;
  final bool disable;

  const FormButton({
    super.key,
    this.onNextPress,
    this.onBackPress,
    this.onSkipPress,
    this.result,
    this.disable = false,
    this.nextText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onNextPress != null) ...{
          Row(
            children: [
              Expanded(
                  child: AppButton(
                disable: disable,
                title: nextText ?? '다음',
                onPressed: () {
                  onNextPress!(result);
                },
              )),
            ],
          ),
        },
        if (onSkipPress != null) ...{
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                  child: AppButton(
                      title: "스킵하기",
                      color: Colors.transparent,
                      titleColor: Colors.white,
                      onPressed: () {
                        onBackPress!();
                      })),
            ],
          ),
        },
        if (onBackPress != null) ...{
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                  child: AppButton(
                      title: "뒤로가기",
                      color: Colors.transparent,
                      titleColor: Colors.white,
                      onPressed: () {
                        onBackPress!();
                      })),
            ],
          ),
        }
      ],
    );
  }
}
