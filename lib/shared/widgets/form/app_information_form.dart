import 'package:flutter/material.dart' hide Step;
import 'package:pookabu/shared/entities/form/information_step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/widgets/form/material/form_container.dart';
import 'package:pookabu/shared/widgets/form/material/form_button.dart';
import 'package:pookabu/shared/widgets/form/material/form_header.dart';

class AppInformationForm extends StatelessWidget {
  final InformationStep step;
  final void Function(StepResult? result) onNextPress;

  const AppInformationForm({
    super.key,
    required this.step,
    required this.onNextPress,
  });

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      step: step,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          FormHeader(title: step.title),
          if (step.description?.isNotEmpty == true)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                    ),
                    child: Text(step.description!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              ],
            ),
          const Spacer(),
          FormButton(
            onNextPress: onNextPress,
          ),
        ],
      ),
    );
  }
}
