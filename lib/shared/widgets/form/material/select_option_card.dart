import 'package:flutter/material.dart';
import 'package:pookabu/shared/entities/form/select_option.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';

class SelectOptionCard extends StatelessWidget {
  final SelectOption option;
  final Function(SelectOption option) onSelected;
  final bool selected;
  final bool loading;
  final bool multi;
  final bool enabled;
  final double height;
  final TextStyle? optionTextStyle;

  const SelectOptionCard(
      {super.key,
      required this.option,
      required this.onSelected,
      this.selected = false,
      this.loading = false,
      this.multi = false,
      this.enabled = true,
      this.optionTextStyle,
      this.height = 12.0});

  const SelectOptionCard.multi(
      {super.key,
      required this.option,
      required this.onSelected,
      this.selected = false,
      this.loading = false,
      this.enabled = true,
      this.optionTextStyle,
      this.height = 3.0})
      : multi = true;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelMedium!,
        padding: EdgeInsets.symmetric(
          vertical: height,
          horizontal: Dimens.space16,
        ),
        backgroundColor: _getBackgroundColor(context),
        disabledBackgroundColor: Palette.coolGrey01,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            Dimens.space12,
          ),
        ),
      ),
      onPressed: (!enabled && !selected) || loading
          ? null
          : () {
              onSelected(option);
            },
      child:
          loading && selected && !multi ? _loading(context) : _title(context),
    );
  }

  Widget _loading(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: _title(context),
        ),
        SizedBox(width: Dimens.space12),
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          option.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: optionTextStyle ??
              Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: selected ? Palette.coolGrey12 : Palette.coolGrey02),
        ),
        if (option.description?.isNotEmpty == true)
          Padding(
            padding: EdgeInsets.only(top: Dimens.space4),
            child: Text(
              option.description!,
              style: Theme.of(context).textTheme.labelLarge!,
            ),
          ),
      ],
    );
  }

  Color _getSelectedColor(BuildContext context) {
    return Palette.coolGrey02;
  }

  Color? _getBackgroundColor(BuildContext context) {
    if (!enabled && !selected) {
      return Palette.coolGrey12;
    } else if (selected) {
      return _getSelectedColor(context);
    }
    return Palette.coolGrey12;
  }
}
