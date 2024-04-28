import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/styles/theme.dart';

class AppTextInput extends StatefulWidget {
  const AppTextInput(
      {super.key,
      this.curFocusNode,
      this.nextFocusNode,
      this.hint,
      this.hintStyle,
      this.validator,
      this.onChanged,
      this.keyboardType,
      this.textInputAction,
      this.obscureText,
      this.controller,
      this.onTap,
      this.textAlign,
      this.enable,
      this.inputFormatter,
      this.minLine,
      this.maxLine,
      this.suffixText,
      this.suffixIcon,
      this.prefixIcon,
      this.isHintVisible = true,
      this.prefixText,
      this.hintText,
      this.autofillHints,
      this.semantic,
      this.maxLength,
      this.onTapOutside,
      this.scrollPadding,
      this.verticalMargin = 8});

  final FocusNode? curFocusNode;
  final FocusNode? nextFocusNode;
  final String? hint;
  final TextStyle? hintStyle;
  final Function(String)? validator;
  final Function(String)? onChanged;
  final Function? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final bool? obscureText;
  final int? minLine;
  final int? maxLine;
  final Widget? suffixIcon;
  final TextAlign? textAlign;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatter;
  final bool isHintVisible;
  final String? suffixText;
  final Widget? prefixIcon;
  final String? prefixText;
  final String? hintText;
  final Iterable<String>? autofillHints;
  final String? semantic;
  final int? maxLength;
  final TapRegionCallback? onTapOutside;
  final double verticalMargin;
  final EdgeInsets? scrollPadding;

  @override
  _TextFState createState() => _TextFState();
}

class _TextFState extends State<AppTextInput> {
  bool isFocus = false;
  String currentVal = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: widget.verticalMargin),
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
            margin: EdgeInsets.symmetric(vertical: widget.verticalMargin),
            child: Semantics(
              label: widget.semantic,
              child: TextFormField(
                key: widget.key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autofillHints: widget.autofillHints,
                enabled: widget.enable,
                obscureText: widget.obscureText ?? false,
                focusNode: widget.curFocusNode,
                keyboardType: widget.keyboardType,
                controller: widget.controller,
                textInputAction: widget.textInputAction,
                textAlign: widget.textAlign ?? TextAlign.start,
                minLines: widget.minLine ?? 1,
                maxLines: widget.maxLine ?? 10,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatter,
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyMedium,
                cursorColor: Palette.coolGrey01,
                onTapOutside: widget.onTapOutside,
                scrollPadding:
                    widget.scrollPadding ?? const EdgeInsets.all(20.0),
                decoration: InputDecoration(
                  counterText: '',
                  prefixText: widget.prefixText,
                  alignLabelWithHint: true,
                  isDense: true,
                  hintText: widget.hintText,
                  hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),

                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.suffixText != null)
                        Text(
                          widget.suffixText!,
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      if (widget.suffixIcon != null) widget.suffixIcon!,
                    ],
                  ),
                  // suffixText: widget.suffixText,
                  // suffixIcon: widget.suffixIcon,
                  suffixIconConstraints: BoxConstraints(
                    minHeight: Dimens.space24,
                    maxHeight: Dimens.space24,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.space12),
                    child: widget.prefixIcon,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minHeight: Dimens.space24,
                    maxHeight: Dimens.space24,
                  ),
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
                    borderSide: BorderSide(color: Theme.of(context).cardColor),
                  ),
                  errorStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                validator: widget.validator as String? Function(String?)?,
                onChanged: widget.onChanged,
                onTap: widget.onTap as void Function()?,
                onFieldSubmitted: (value) {
                  setState(() {
                    fieldFocusChange(
                      context,
                      widget.curFocusNode ?? FocusNode(),
                      widget.nextFocusNode,
                    );
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode? nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
