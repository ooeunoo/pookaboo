import 'package:flutter/material.dart';
import 'package:pookabu/shared/entities/form/data_step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/form/material/form_container.dart';
import 'package:pookabu/shared/widgets/form/material/form_button.dart';
import 'package:pookabu/shared/widgets/form/material/form_description.dart';
import 'package:pookabu/shared/widgets/form/material/form_header.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';

class AppDataForm extends StatefulWidget {
  final DataStep step;
  final void Function(StepResult? result) onNextPress;
  final void Function() onBackPress;

  const AppDataForm(
      {super.key,
      required this.onNextPress,
      required this.onBackPress,
      required this.step});

  @override
  State<AppDataForm> createState() => _DataFormState();
}

class _DataFormState extends State<AppDataForm> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool isLoading = false;

  DataStep get step => widget.step;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
          Padding(
            padding: EdgeInsets.only(top: Dimens.space24),
            child: GestureDetector(
              child: TextField(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(height: Dimens.space20 / Dimens.space16),
                enabled: !isLoading,
                focusNode: _focusNode,
                decoration: _decoration(context),
                controller: _controller,
                keyboardType: textInputType,
                textAlign: TextAlign.center,
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (_) {
                  setState(() {});
                },
              ),
            ),
          ),
          const Spacer(),
          FormButton(
            disable: _controller.text.isEmpty,
            onNextPress: widget.onNextPress,
            onBackPress: widget.onBackPress,
            result: StepResult(
              stepId: step.id,
              value: resultValue,
            ),
          ),
          // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  InputDecoration _decoration(BuildContext context) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: Dimens.space16,
        horizontal: Dimens.space8,
      ),
      focusedBorder: OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.circular(Dimens.space4),
        borderSide: const BorderSide(color: Palette.coolGrey05),
      ),
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Palette.coolGrey05),
          borderRadius: BorderRadius.all(Radius.circular(Dimens.space4))),
    );
  }

  dynamic get resultValue {
    switch (step.type) {
      case InputDataType.text:
      case InputDataType.textMultiline:
      case InputDataType.name:
      case InputDataType.email:
        return _controller.text;
      case InputDataType.numberInt:
        return int.tryParse(_controller.text);
      case InputDataType.numberDouble:
        return double.tryParse(_controller.text);
    }
  }

  TextInputType get textInputType {
    switch (step.type) {
      case InputDataType.text:
        return TextInputType.text;
      case InputDataType.textMultiline:
        return TextInputType.multiline;
      case InputDataType.numberInt:
        return TextInputType.number;
      case InputDataType.numberDouble:
        return const TextInputType.numberWithOptions(
          decimal: true,
        );
      case InputDataType.email:
        return TextInputType.emailAddress;
      case InputDataType.name:
        return TextInputType.name;
    }
  }
}
