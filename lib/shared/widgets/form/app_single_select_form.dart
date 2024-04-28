import 'package:flutter/material.dart' hide Step;
import 'package:pookabu/shared/entities/form/data_step.dart';
import 'package:pookabu/shared/entities/form/select_option.dart';
import 'package:pookabu/shared/entities/form/single_select_step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/widgets/form/app_data_form.dart';
import 'package:pookabu/shared/widgets/form/material/form_container.dart';
import 'package:pookabu/shared/widgets/form/material/form_button.dart';
import 'package:pookabu/shared/widgets/form/material/form_description.dart';
import 'package:pookabu/shared/widgets/form/material/form_header.dart';
import 'package:pookabu/shared/widgets/form/material/select_option_card.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';

class AppSingleSelectForm extends StatefulWidget {
  final SingleSelectStep step;
  final void Function(StepResult? result) onNextPress;
  final void Function() onBackPress;

  const AppSingleSelectForm(
      {super.key,
      required this.step,
      required this.onNextPress,
      required this.onBackPress});

  @override
  _SingleSelectFormState createState() => _SingleSelectFormState();
}

class _SingleSelectFormState extends State<AppSingleSelectForm> {
  bool isLoading = false;
  SelectOption? _selected;

  SingleSelectStep get step => widget.step;

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
            FormDescription(description: step.description!),
          AppSpacerV(value: Dimens.space100),
          _options(context),
          AppSpacerV(value: Dimens.space40),
          FormButton(onBackPress: widget.onBackPress),
          const SizedBox(),
        ],
      ),
    );
  }

  Widget _options(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: step.options.length,
      itemBuilder: (BuildContext context, int index) {
        return SelectOptionCard(
          option: step.options[index],
          loading: isLoading,
          selected: _selected == step.options[index],
          onSelected: (SelectOption option) async {
            if (isLoading) {
              return;
            }
            setState(() {
              isLoading = true;
              _selected = option;
            });

            widget
                .onNextPress(StepResult(stepId: step.id, value: option.value));

            setState(() {
              isLoading = false;
            });
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: Dimens.space12,
        );
      },
    );
  }
}
