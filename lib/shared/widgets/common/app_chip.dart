import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';

class AppChip extends StatefulWidget {
  final String text;
  final String icon;
  final bool isSelected;
  final Function()? onTap;

  const AppChip({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  @override
  _AppChipState createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  late bool isSelected;

  @override
  Widget build(BuildContext context) {
    isSelected = widget.isSelected;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: Chip(
        labelPadding: EdgeInsets.zero,
        backgroundColor:
            isSelected ? Palette.coolGrey08 : Palette.coolGrey01, // 배경색 투명 설정
        padding: EdgeInsets.zero, // 기존 패딩 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(
            width: 1, // 테두리 두께
            color: widget.isSelected
                ? Palette.coolGrey08
                : Palette.coolGrey02, // 선택 여부에 따른 테두리 색상 변경
          ),
        ),
        label: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.space8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(widget.icon,
                  colorFilter: ColorFilter.mode(
                      widget.isSelected ? Palette.white : Palette.coolGrey08,
                      BlendMode.srcIn)),
              AppSpacerH(value: Dimens.space4),
              Text(widget.text,
                  textAlign: TextAlign.center,
                  style: widget.isSelected
                      ? Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Palette.white)
                      : Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: Palette.coolGrey09)),
              AppSpacerH(value: Dimens.space1)
            ],
          ),
        ),
      ),
    );
  }
}
