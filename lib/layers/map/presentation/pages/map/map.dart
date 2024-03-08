import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookaboo/layers/map/data/models/toilet.dart';
import 'package:pookaboo/layers/map/presentation/bloc/map_bloc.dart';
import 'package:pookaboo/shared/constant/images.dart';
import 'package:pookaboo/shared/localization/generated/message.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/utils/logging/log.dart';
import 'package:pookaboo/shared/widgets/app_chip.dart';
import 'package:pookaboo/shared/widgets/app_spacer_h.dart';

// 최초 중심
LatLng initialCenter = LatLng(37.584690, 127.046502);

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Set<Marker> markers = {};

  void _showBottomSheet(BuildContext context, Toilet toilet) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.3,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          snapSizes: const [0.3, 0.9],
          snap: true,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: const Column(
                children: [Text("hello")],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (context, MapState state) {
        return Stack(
          children: [
            ////////////////////////////////////
            ///  KAKAO MAP
            ///////////////////////////////////
            BlocListener<MapBloc, MapState>(
              listener: (context, state) {
                // 초기화 상태라면 내 위치로 이동하기
                if (state is MapCreatedState) {
                  context.read<MapBloc>().add(MoveToMyPositionEvent());
                } else if (state is MovedMapState) {
                  context.read<MapBloc>().add(GetNearByToiletsEvent());
                } else if (state is LoadedToiletMarkersState) {
                  markers = state.markers;
                } else if (state is LoadedSelectedToiletState) {
                  _showBottomSheet(context, state.toilet);
                }
              },
              child: KakaoMap(
                  center: initialCenter,
                  onMapTap: (LatLng loc) {
                    context.read<MapBloc>().add(GetNearByToiletsEvent());
                  },
                  onMapCreated: ((controller) async {
                    context
                        .read<MapBloc>()
                        .add(MapCreateEvent(controller: controller));
                  }),
                  onMarkerTap: (markerId, _, __) {
                    context.read<MapBloc>().add(SelecteToiletMarkerEvent(
                        toiletId: int.parse(markerId)));
                  },
                  markers: markers.toList()),
            ),
            ////////////////////////////////////
            ///  FILTER CHIP
            ///////////////////////////////////
            Positioned(
              left: Dimens.space20,
              top: Dimens.statusbarHeight(context) + Dimens.space8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppChip(
                    text: Messages.of(context)!.toiletFilterTime,
                    icon: SvgPicture.asset(
                      Images.alarm,
                    ),
                    isSelected: false,
                    onChanged: (isSelected) {
                      // 필터 선택 이벤트 발생
                    },
                  ),
                  AppSpacerH(value: Dimens.space8),
                  AppChip(
                    text: Messages.of(context)!.toiletFilterGender,
                    icon: SvgPicture.asset(Images.gender),
                    isSelected: false,
                    onChanged: (isSelected) {},
                  ),
                  AppSpacerH(value: Dimens.space8),
                  AppChip(
                    text: Messages.of(context)!.toiletFilterPassword,
                    icon: SvgPicture.asset(Images.key),
                    isSelected: false,
                    onChanged: (isSelected) {
                      // 필터 선택 이벤트 발생
                    },
                  ),
                ],
              ),
            ),
            Positioned(
                right: Dimens.space20,
                bottom: Dimens.bottomBarHeight(context) + Dimens.space24,
                child: GestureDetector(
                  onTap: () {
                    context.read<MapBloc>().add(MoveToMyPositionEvent());
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(width: 1, color: const Color(0xFFD3D7DF)),
                      // gap: const EdgeInsets.all(10),
                      color: Colors.white,
                    ),
                    child: SvgPicture.asset(
                      Images.currentPosition,
                      width: 24, // SVG 이미지의 너비 조정 가능
                      height: 24, // SVG 이미지의 높이 조정 가능
                    ),
                  ),
                ))
          ],
        );
      },
    );
  }
}
