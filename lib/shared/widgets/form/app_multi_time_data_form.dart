import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pookabu/shared/entities/form/multi_time_data_step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/widgets/form/material/time_data_modal.dart';
import 'package:pookabu/shared/widgets/form/material/form_container.dart';
import 'package:pookabu/shared/widgets/form/material/form_button.dart';
import 'package:pookabu/shared/widgets/form/material/form_header.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

const String _dateFormat = 'd MMMM yyyy';
const String _timeFormat = 'HH:mm';
const String _dateTimeFormat = 'd MMMM yyyy HH:mm';

class AppMultiTimeDataForm extends StatefulWidget {
  final MultiTimeDataStep step;
  final void Function(StepResult? result) onNextPress;
  final void Function() onBackPress;

  const AppMultiTimeDataForm(
      {super.key,
      required this.onNextPress,
      required this.onBackPress,
      required this.step});

  @override
  State<AppMultiTimeDataForm> createState() => _MultiTimeDataFormState();
}

class _MultiTimeDataFormState extends State<AppMultiTimeDataForm> {
  late List<List<TextEditingController>> _controllers;
  late List<List<FocusNode>> _focusNodes;

  bool isLoading = false;

  MultiTimeDataStep get step => widget.step;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(step.options.length,
        (_) => [TextEditingController(), TextEditingController()]);
    _focusNodes = List.generate(
        step.options.length, (index) => [FocusNode(), FocusNode()]);
  }

  @override
  void dispose() {
    for (var cons in _controllers) {
      for (var c in cons) {
        c.dispose();
      }
    }
    for (var foc in _focusNodes) {
      for (var f in foc) {
        f.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      step: step,
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FormHeader(title: step.title),
              const AppSpacerV(),
              ...List.generate(step.options.length, (index) {
                final option = step.options[index];
                return Padding(
                  padding: EdgeInsets.only(top: Dimens.space10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppText(
                        option.label,
                        style: Theme.of(context).textTheme.bodySmall!,
                      ),
                      GestureDetector(
                        onTap: !isLoading
                            ? () async {
                                await _showDatePicker(context, index, 0);
                              }
                            : null,
                        child: AbsorbPointer(
                          absorbing: isDatePicker,
                          child: SizedBox(
                            width: Dimens.space100,
                            child: TextField(
                              focusNode: _focusNodes[index][0],
                              controller: _controllers[index][0],
                              style: Theme.of(context).textTheme.bodySmall!,
                              enabled: !isLoading,
                              decoration: _decoration(context),
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
                      ),
                      AppText('-',
                          style: Theme.of(context).textTheme.bodyLarge!),
                      GestureDetector(
                        onTap: !isLoading
                            ? () async {
                                await _showDatePicker(context, index, 1);
                              }
                            : null,
                        child: AbsorbPointer(
                          absorbing: isDatePicker,
                          child: SizedBox(
                            width: Dimens.space100,
                            child: TextField(
                              focusNode: _focusNodes[index][1],
                              controller: _controllers[index][1],
                              style: Theme.of(context).textTheme.bodySmall!,
                              enabled: !isLoading,
                              decoration: _decoration(context),
                              textAlign: TextAlign.center,
                              keyboardType: textInputType,
                              onTapOutside: (_) {
                                FocusScope.of(context).unfocus();
                              },
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              AppSpacerV(value: Dimens.space20),
              FormButton(
                onNextPress: widget.onNextPress,
                onBackPress: widget.onBackPress,
                result: StepResult(
                  stepId: step.id,
                  value: resultValue,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
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

  Future<void> _showDatePicker(
      BuildContext context, int index, int inner) async {
    final DateFormat dateFormat = DateFormat(dateFormatPattern);
    DateTime? selected;

    String dayKo = WeekKey.values[index].ko;
    String timeKo = inner == 0 ? '- 오픈 시간' : '- 마감 시간';

    String helperText = '$dayKo $timeKo';

    if (step.type == InputTimeDataType.date) {
      selected = await showPlatformDatePicker(
        context,
        // initialDate: initialDate,
        onDateTimeChanged: (DateTime selectedDate) {},
      );
    } else if (step.type == InputTimeDataType.time) {
      final TimeOfDay? timeOfDay = await showPlatformTimePicker(
        context,
        // initialDate: initialDate,
        helperText: helperText,
        onDateTimeChanged: (DateTime selectedDate) {},
      );
      if (timeOfDay != null) {
        selected = DateTime(0, 0, 0, timeOfDay.hour, timeOfDay.minute);
      }
    } else if (step.type == InputTimeDataType.dateAndTime) {
      selected = await showPlatformDateAndTimePicker(
        context,
        // initialDate: initialDate,
        onDateTimeChanged: (DateTime selectedDate) {},
      );
    }

    if (selected != null) {
      setState(() {
        _controllers[index][inner].text = dateFormat.format(selected!);
      });
    }

    // _requestNextDatePicker(context, index, inner);
  }

  void _requestNextDatePicker(BuildContext context, int index, int inner) {
    int nextIndex = inner == 1 ? index + 1 : index;
    int nextInner = inner == 1 ? 0 : inner + 1;

    if (nextIndex <= step.options.length - 1) {
      _showDatePicker(context, nextIndex, nextInner);
    }
  }

  TextInputType get textInputType {
    switch (step.type) {
      case InputTimeDataType.date:
      case InputTimeDataType.time:
      case InputTimeDataType.dateAndTime:
        return TextInputType.datetime;
    }
  }

  String get dateFormatPattern {
    if (step.dateFormat?.isNotEmpty == true) {
      return step.dateFormat!;
    }
    switch (step.type) {
      case InputTimeDataType.date:
        return _dateFormat;
      case InputTimeDataType.time:
        return _timeFormat;
      case InputTimeDataType.dateAndTime:
        return _dateTimeFormat;
      default:
        throw UnsupportedError('Wrong step type for date picker');
    }
  }

  bool get isDatePicker =>
      step.type == InputTimeDataType.date ||
      step.type == InputTimeDataType.time ||
      step.type == InputTimeDataType.dateAndTime;

  dynamic get resultValue {
    switch (step.type) {
      case InputTimeDataType.date:
      case InputTimeDataType.dateAndTime:
      case InputTimeDataType.time:
        Map<String, Map<String, String?>> values = {};
        for (int index = 0; index < _controllers.length; index++) {
          final option = step.options[index];
          final open = _controllers[index][0].text;
          final close = _controllers[index][1].text;

          values[option.id] = {
            "open": open != "" ? open : null,
            "close": close != "" ? close : null,
          };
        }
        return values;
    }
  }
}
