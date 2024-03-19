import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pookaboo/layers/domain/entities/form/step/data_step.dart';
import 'package:pookaboo/layers/domain/entities/form/step/multi_data_step.dart';
import 'package:pookaboo/layers/domain/entities/form/step/multi_time_data_step.dart';
import 'package:pookaboo/layers/domain/entities/form/step/step_result.dart';
import 'package:pookaboo/layers/presentation/pages/forms/form_widget/data_modal.dart';
import 'package:pookaboo/layers/presentation/pages/forms/form_widget/form_container.dart';
import 'package:pookaboo/layers/presentation/pages/forms/form_widget/form_button.dart';
import 'package:pookaboo/shared/constant/enum.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/styles/palette.dart';
import 'package:pookaboo/shared/utils/logging/log.dart';
import 'package:pookaboo/shared/widgets/common/app_spacer_h.dart';
import 'package:pookaboo/shared/widgets/common/app_spacer_v.dart';
import 'package:pookaboo/shared/widgets/common/app_text.dart';

const String _dateFormat = 'd MMMM yyyy';
const String _timeFormat = 'HH:mm';
const String _dateTimeFormat = 'd MMMM yyyy HH:mm';

class MultiTimeDataForm extends StatefulWidget {
  final MultiTimeDataStep step;
  final void Function(StepResult? result) onNextPress;
  final void Function() onBackPress;

  const MultiTimeDataForm(
      {super.key,
      required this.onNextPress,
      required this.onBackPress,
      required this.step});

  @override
  State<MultiTimeDataForm> createState() => _MultiTimeDataFormState();
}

class _MultiTimeDataFormState extends State<MultiTimeDataForm> {
  late List<List<TextEditingController>> _controllers;
  late List<List<FocusNode>> _focusNodes;
  late List<List<DateTime?>> _results;

  bool isLoading = false;

  MultiTimeDataStep get step => widget.step;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(step.options.length,
        (_) => [TextEditingController(), TextEditingController()]);
    _focusNodes = List.generate(
        step.options.length, (index) => [FocusNode(), FocusNode()]);
    _results = List.generate(step.options.length, (_) => [null, null]);
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
              Row(
                children: [
                  Expanded(
                    child: AppText(
                      step.title,
                      align: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: Dimens.headerLarge),
                    ),
                  ),
                ],
              ),
              ...List.generate(step.options.length, (index) {
                final option = step.options[index];
                return Padding(
                  padding: EdgeInsets.only(top: Dimens.space24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppText(
                        option.label,
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                      GestureDetector(
                        onTap: !isLoading
                            ? () {
                                _showDatePicker(context, index, 0);
                              }
                            : null,
                        child: AbsorbPointer(
                          absorbing: isDatePicker,
                          child: SizedBox(
                            width: Dimens.space100,
                            child: TextField(
                              focusNode: _focusNodes[index][0],
                              controller: _controllers[index][0],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      height: Dimens.space20 / Dimens.space16),
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
                      AppText('~',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  height: Dimens.space20 / Dimens.space16)),
                      GestureDetector(
                        onTap: !isLoading
                            ? () {
                                _showDatePicker(context, index, 1);
                              }
                            : null,
                        child: AbsorbPointer(
                          absorbing: isDatePicker,
                          child: SizedBox(
                            width: Dimens.space100,
                            child: TextField(
                              focusNode: _focusNodes[index][1],
                              controller: _controllers[index][1],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      height: Dimens.space20 / Dimens.space16),
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

  // void _requestFocus(int index) {
  //   final tuple = _focusNodes[index];
  //   if (tuple.$1.hasFocus) {
  //     tuple.$1.unfocus();
  //   } else {
  //     tuple.$1.requestFocus();
  //   }
  // }

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

    final DateTime initialDate = DateTime.now();
    setState(() {
      _results[index][inner] = initialDate;
      _controllers[index][inner].text = dateFormat.format(initialDate);
    });

    if (step.type == InputTimeDataType.date) {
      await showPlatformDatePicker(
        context,
        initialDate: initialDate,
        onDateTimeChanged: (DateTime selectedDate) {
          selected = selectedDate;
          setState(() {
            _controllers[index][inner].text = dateFormat.format(selectedDate);
          });
        },
      );
      if (selected != null) {
        selected = DateUtils.dateOnly(selected!);
      }
    } else if (step.type == InputTimeDataType.time) {
      await showPlatformTimePicker(
        context,
        initialDate: initialDate,
        onDateTimeChanged: (DateTime selectedDate) {
          selected = DateTime(0, 0, 0, selectedDate.hour, selectedDate.minute);
          setState(() {
            _controllers[index][inner].text = dateFormat.format(selectedDate);
          });
        },
      );
      if (selected != null) {
        selected = DateTime(0, 0, 0, selected!.hour, selected!.minute);
      }
    } else if (step.type == InputTimeDataType.dateAndTime) {
      await showPlatformDateAndTimePicker(
        context,
        initialDate: initialDate,
        onDateTimeChanged: (DateTime selectedDate) {
          selected = selectedDate;
          setState(() {
            _controllers[index][inner].text = dateFormat.format(selectedDate);
          });
        },
      );
    }

    if (selected != null) {
      setState(() {
        _results[index][inner] = selected;
      });
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
        final DateFormat dateFormat = DateFormat(dateFormatPattern);

        Map<String, Map<String, String?>> values = {};
        for (int index = 0; index < _results.length; index++) {
          final option = step.options[index];
          DateTime? open = _results[index][0];
          DateTime? close = _results[index][0];

          values[option.id] = {
            "open": open != null ? dateFormat.format(open) : null,
            "close": close != null ? dateFormat.format(close) : null,
          };
        }
        return values;
    }
  }
}
