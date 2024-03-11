import 'package:flutter/material.dart';
import 'package:pookaboo/layers/map/data/models/toilet.dart';
import 'package:pookaboo/shared/widgets/app_spacer_h.dart';
import 'package:pookaboo/shared/widgets/app_text.dart';

class ToiletBottomSheetLocation extends StatefulWidget {
  final Toilet toilet;

  const ToiletBottomSheetLocation(this.toilet, {super.key});

  @override
  State<ToiletBottomSheetLocation> createState() =>
      _ToiletBottomSheetLocationState();
}

class _ToiletBottomSheetLocationState extends State<ToiletBottomSheetLocation> {
  late String locationTip;

  @override
  void initState() {
    super.initState();
    locationTip = widget.toilet.location_tip == ''
        ? '위치 정보 없음'
        : widget.toilet.location_tip;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText("도보 1분", style: Theme.of(context).textTheme.bodySmall!),
            const AppSpacerH(),
            AppText("|", style: Theme.of(context).textTheme.labelLarge!),
            const AppSpacerH(),
            AppText(locationTip, style: Theme.of(context).textTheme.labelLarge!)
          ],
        )
      ],
    );
  }
}
