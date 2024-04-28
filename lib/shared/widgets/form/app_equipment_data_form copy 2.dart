import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pookabu/shared/entities/form/multi_data_step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';
import 'package:pookabu/shared/widgets/common/app_text_input.dart';
import 'package:pookabu/shared/widgets/form/material/form_container.dart';
import 'package:pookabu/shared/widgets/form/material/form_button.dart';
import 'package:pookabu/shared/widgets/form/material/form_header.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class AppEquipmentDataForm extends StatefulWidget {
  final EquipmentDataStep step;
  final void Function(StepResult? result) onNextPress;
  final void Function() onBackPress;

  const AppEquipmentDataForm(
      {super.key,
      required this.onNextPress,
      required this.onBackPress,
      required this.step});

  @override
  State<AppEquipmentDataForm> createState() => _MultiDataFormState();
}

class _MultiDataFormState extends State<AppEquipmentDataForm> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  bool isLoading = false;

  EquipmentDataStep get step => widget.step;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
        step.options.length, (_) => TextEditingController(text: '0'));
    _focusNodes = List.generate(step.options.length, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      step: step,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          FormHeader(title: step.title),
          const AppSpacerV(),
          _tableOfMale()
          // ...List.generate(step.options.length, (index) {
          //   final option = step.options[index];
          //   return Padding(
          //     padding: EdgeInsets.only(top: Dimens.space24),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         AppText(
          //           option.label,
          //           style: Theme.of(context).textTheme.bodyMedium!,
          //         ),
          //         const AppSpacerH(),
          //         GestureDetector(
          //           onTap: !isLoading ? () => _requestFocus(index) : null,
          //           child: AbsorbPointer(
          //             child: SizedBox(
          //               width: Dimens.space100,
          //               child: TextField(
          //                 focusNode: _focusNodes[index],
          //                 controller: _controllers[index],
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .bodyMedium!
          //                     .copyWith(
          //                         height: Dimens.space20 / Dimens.space16),
          //                 enabled: !isLoading,
          //                 decoration: _decoration(context),
          //                 textInputAction: TextInputAction.next,
          //                 keyboardType: textInputType,
          //                 inputFormatters: textInputFormatter,
          //                 textAlign: TextAlign.center,
          //                 onTapOutside: (_) {
          //                   FocusScope.of(context).unfocus();
          //                 },
          //                 onChanged: (_) {
          //                   setState(() {});
          //                 },
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // }),
          ,
          const Spacer(),
          FormButton(
            disable: _controllers.any((controller) => controller.text.isEmpty),
            onNextPress: widget.onNextPress,
            onBackPress: widget.onBackPress,
            result: StepResult(
              stepId: step.id,
              value: resultValue,
            ),
          ),
        ],
      ),
    );
  }

  void _requestFocus(int index) {
    if (_focusNodes[index].hasFocus) {
      _focusNodes[index].unfocus();
    } else {
      _focusNodes[index].requestFocus();
    }
  }

  Widget _tableOfMale() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Palette.coolGrey11),
          children: [
            TableCell(
              child: AppText(
                '',
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ),
            TableCell(
              child: AppText(
                '일반',
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ),
            TableCell(
              child: AppText(
                '어린이용',
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ),
            TableCell(
              child: AppText(
                '장애인용',
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ),
          ],
        ),
        // Data rows
        const TableRow(
          children: [
            TableCell(
              child: Text(''),
            ),
            TableCell(
              child: AppTextInput(
                verticalMargin: 0,
              ),
            ),
            TableCell(
              child: AppTextInput(
                verticalMargin: 0,
              ),
            ),
            TableCell(
              child: AppTextInput(
                verticalMargin: 0,
              ),
            ),
          ],
        ),
        // Add more data rows
        const TableRow(
          children: [
            TableCell(
              child: Text(''),
            ),
            TableCell(
              child: AppTextInput(
                verticalMargin: 0,
              ),
            ),
            TableCell(
              child: AppTextInput(
                verticalMargin: 0,
              ),
            ),
            TableCell(
              child: AppTextInput(
                verticalMargin: 0,
              ),
            ),
          ],
        ),
      ],
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
        return _controllers.map((controller) => controller.text).toList();
      case InputDataType.numberInt:
        Map<String, int?> values = {};
        for (int index = 0; index < _controllers.length; index++) {
          final option = step.options[index];
          final value = int.tryParse(_controllers[index].text);
          values[option.id] = value;
        }
        return values;
      case InputDataType.numberDouble:
        Map<String, double?> values = {};
        for (int index = 0; index < _controllers.length; index++) {
          final option = step.options[index];
          final value = double.tryParse(_controllers[index].text);
          values[option.id] = value;
        }
        return values;
    }
  }

  TextInputType get textInputType {
    switch (step.type) {
      case InputDataType.text:
        return TextInputType.text;
      case InputDataType.textMultiline:
        return TextInputType.multiline;
      case InputDataType.numberInt:
        return const TextInputType.numberWithOptions(signed: true);
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

  List<TextInputFormatter>? get textInputFormatter {
    switch (step.type) {
      case InputDataType.numberInt:
        return [FilteringTextInputFormatter.digitsOnly];
      case InputDataType.text:
      case InputDataType.textMultiline:
      case InputDataType.numberDouble:
      case InputDataType.email:
      case InputDataType.name:
        return null;
    }
    return null;
  }
}
