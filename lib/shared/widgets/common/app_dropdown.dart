import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/styles/theme.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';

class AppDropDown<T> extends StatefulWidget {
  const AppDropDown(
      {super.key,
      required this.value,
      required this.items,
      required this.onChanged,
      this.isHintVisible = true,
      this.prefixIcon,
      this.focusNode,
      this.hint,
      this.semantic,
      this.hintStyle});
  final T value;
  final List<DropdownMenuItem<T>> items;
  final bool isHintVisible;
  final ValueChanged<T?>? onChanged;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final String? hint;
  final TextStyle? hintStyle;
  final String? semantic;

  @override
  _AppDropDownState<T> createState() => _AppDropDownState();
}

class _AppDropDownState<T> extends State<AppDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: Dimens.space8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: widget.isHintVisible,
            child: Text(
              widget.hint ?? "",
              style: widget.hintStyle,
              // style: Theme.of(context).textTheme.labelSmall?.copyWith(
              //       height: 0.1,
              //     ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: Dimens.space8),
            child: Semantics(
              label: widget.semantic,
              child: ButtonTheme(
                key: widget.key,
                alignedDropdown: true,
                child: DropdownButtonFormField<T>(
                  isExpanded: true,
                  focusNode: widget.focusNode,
                  dropdownColor: Palette.coolGrey12,
                  icon: const Icon(Icons.arrow_drop_down),
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    counterText: '',
                    // prefixText: widget.prefixText,
                    alignLabelWithHint: true,
                    isDense: true,
                    // hintText: widget.hintText,
                    hintStyle:
                        Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                    // suffix: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     if (widget.suffixText != null)
                    //       Text(
                    //         widget.suffixText!,
                    //         style: TextStyle(
                    //           color: Theme.of(context).hintColor,
                    //         ),
                    //       ),
                    //     if (widget.suffixIcon != null) widget.suffixIcon!,
                    //   ],
                    // ),
                    // suffixText: widget.suffixText,
                    // suffixIcon: widget.suffixIcon,
                    // suffixIconConstraints: BoxConstraints(
                    //   minHeight: Dimens.space24,
                    //   maxHeight: Dimens.space24,
                    // ),
                    // prefixIcon: Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: Dimens.space12),
                    //   child: widget.prefixIcon,
                    // ),
                    // prefixIconConstraints: BoxConstraints(
                    //   minHeight: Dimens.space24,
                    //   maxHeight: Dimens.space24,
                    // ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: Dimens.space12,
                      horizontal: Dimens.space16,
                    ),
                    enabledBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(Dimens.space12),
                      borderSide: const BorderSide(color: Palette.coolGrey09),
                    ),
                    disabledBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(Dimens.space12),
                      borderSide:
                          BorderSide(color: Theme.of(context).cardColor),
                    ),
                    errorStyle: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                          color:
                              Theme.of(context).extension<PookabuColors>()!.red,
                        ),
                    focusedErrorBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(Dimens.space12),
                      borderSide: const BorderSide(color: Palette.coolGrey05),
                      // borderSide: BorderSide(
                      //   color:
                      //       Theme.of(context).extension<PookabuColors>()!.red!,
                      // ),
                    ),
                    errorBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(Dimens.space12),
                      borderSide: const BorderSide(color: Palette.coolGrey05),
                      // borderSide: BorderSide(
                      //   color:
                      //       Theme.of(context).extension<PookabuColors>()!.red!,
                      // ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(Dimens.space12),
                      borderSide: const BorderSide(color: Palette.coolGrey05),
                      // borderSide: BorderSide(
                      //   color:
                      //       Theme.of(context).extension<PookabuColors>()!.pink!,
                      // ),
                    ),
                  ),
                  value: widget.value,
                  items: widget.items,
                  onChanged: widget.onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
