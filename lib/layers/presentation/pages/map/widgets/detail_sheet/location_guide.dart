import 'package:flutter/material.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class LocationGuide extends StatefulWidget {
  final Toilet toilet;
  final int? time;
  final bool isExpand;

  const LocationGuide({
    super.key,
    required this.toilet,
    this.time,
    this.isExpand = false,
  });

  @override
  State<LocationGuide> createState() => _LocationGuideState();
}

class _LocationGuideState extends State<LocationGuide> {
  late String locationTip;

  @override
  void initState() {
    super.initState();
    // 로직 수정 locationtip > address > road_address
    locationTip = widget.toilet.location_tip.isNotEmpty
        ? widget.toilet.location_tip
        : widget.toilet.address != ""
            ? widget.toilet.address
            : widget.toilet.road_address != ""
                ? widget.toilet.address
                : "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.time != null) ...{
                AppText("도보 ${widget.time}분",
                    style: Theme.of(context).textTheme.bodySmall!),
                const AppSpacerH(),
                AppText("|", style: Theme.of(context).textTheme.labelLarge!),
                const AppSpacerH()
              },
              SizedBox(
                  width: widget.time != null
                      ? context.widthInPercent(50)
                      : context.widthInPercent(85),
                  child: AppText(locationTip,
                      maxLines: widget.isExpand ? 5 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge!)),
            ],
          )
        ],
      ),
    );
  }
}
