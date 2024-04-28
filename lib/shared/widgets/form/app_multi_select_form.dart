import 'package:flutter/material.dart' hide Step;
import 'package:pookabu/shared/entities/form/multi_select_step.dart';
import 'package:pookabu/shared/entities/form/select_option.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/form/material/form_container.dart';
import 'package:pookabu/shared/widgets/form/material/form_button.dart';
import 'package:pookabu/shared/widgets/form/material/form_description.dart';
import 'package:pookabu/shared/widgets/form/material/form_header.dart';
import 'package:pookabu/shared/widgets/form/material/select_option_card.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';

class AppMultiSelectForm extends StatefulWidget {
  final MultiSelectStep step;
  final void Function(StepResult? result) onNextPress;
  final void Function() onBackPress;

  const AppMultiSelectForm(
      {super.key,
      required this.step,
      required this.onNextPress,
      required this.onBackPress});

  @override
  _MultiSelectFormState createState() => _MultiSelectFormState();
}

class _MultiSelectFormState extends State<AppMultiSelectForm> {
  bool isLoading = false;
  final List<dynamic> _selected = [];

  MultiSelectStep get step => widget.step;

  bool get minimumItemsSelected =>
      step.minOptionsSelected == null ||
      _selected.length >= step.minOptionsSelected!;

  bool get maximumItemsSelected =>
      step.maxOptionsSelected != null &&
      _selected.length == step.maxOptionsSelected!;

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      step: step,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const AppSpacerV(),
          FormHeader(title: step.title),
          if (step.description?.isNotEmpty == true)
            FormDescription(description: step.description!),
          AppSpacerV(value: Dimens.space40),
          _options(context),
          const Spacer(),
          FormButton(
              onNextPress: widget.onNextPress,
              onBackPress: widget.onBackPress,
              result: StepResult(stepId: step.id, value: _selected)),
          // const SizedBox(),
        ],
      ),
    );
  }

  Widget _options(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 12.0,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 6),
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: step.options.length,
      itemBuilder: (BuildContext context, int index) {
        bool isSelected = _selected.contains(step.options[index].value);
        return SelectOptionCard.multi(
          option: step.options[index],
          loading: isLoading,
          optionTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isSelected ? Palette.coolGrey12 : Palette.coolGrey02),
          enabled: !maximumItemsSelected,
          selected: _selected.contains(step.options[index].value),
          onSelected: (SelectOption option) async {
            setState(() {
              if (isSelected) {
                _selected.remove(option.value);
              } else {
                _selected.add(option.value);
              }
            });
          },
        );
      },
    );
  }
}
