import 'package:flutter/material.dart' hide Step;
import 'package:lottie/lottie.dart';
import 'package:pookabu/shared/constant/assets.dart';
import 'package:pookabu/shared/entities/form/confirm_step.dart';
import 'package:pookabu/shared/entities/form/information_step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/widgets/form/material/form_container.dart';
import 'package:pookabu/shared/widgets/form/material/form_button.dart';
import 'package:pookabu/shared/widgets/form/material/form_header.dart';

class AppConfirmForm extends StatefulWidget {
  final ConfirmStep step;
  final void Function(StepResult? result) onNextPress;

  const AppConfirmForm({
    super.key,
    required this.step,
    required this.onNextPress,
  });

  @override
  State<AppConfirmForm> createState() => _AppConfirmFormState();
}

class _AppConfirmFormState extends State<AppConfirmForm> {
  late final Future<LottieComposition> _composition;

  @override
  void initState() {
    super.initState();
    _composition = AssetLottie(Assets.finish).load();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      step: widget.step,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          FormHeader(title: widget.step.title),
          if (widget.step.description?.isNotEmpty == true)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                    ),
                    child: Text(widget.step.description!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              ],
            ),
          FutureBuilder<LottieComposition>(
            future: _composition,
            builder: (context, snapshot) {
              var composition = snapshot.data;
              if (composition != null) {
                return Lottie(composition: composition, repeat: false);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const Spacer(),
          FormButton(
            onNextPress: widget.onNextPress,
            nextText: '등록 완료',
          ),
        ],
      ),
    );
  }
}
