import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookaboo/layers/map/presentation/bloc/map_bloc.dart';
import 'package:pookaboo/shared/constant/images.dart';
import 'package:pookaboo/shared/localization/generated/message.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
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
  late KakaoMapController _mapController;

  // void _getVisibleRegionBounds() async {
  //   //LatLngBounds{sw: LatLng{latitude: 33.44726741665278, longitude: 126.56857014538832}, ne: LatLng{latitude: 33.45412509132144, longitude: 126.57276324214196}}
  //   LatLngBounds bound = await _controller.getBounds();
  //   print('bound $bound');
  // }

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
                // if (state is MapCenterChangedState) {
                //   // 블록에서 받은 새로운 지도 중심을 사용하여 지도를 이동합니다.
                //   _moveMapToCenter(context, state.newCenter);
                // }
              },
              child: KakaoMap(
                center: initialCenter,
                onMapCreated: ((controller) async {
                  _mapController = controller;

                  setState(() {});
                }), // onMapTap: (latLng) {
                // print(latLng);
                // 사용자가 지도를 탭하면 블록에 새로운 지도 중심을 전달합니다.
                // context
                //     .read<MapBloc>()
                //     .add(MapCenterChangedEvent(newCenter: latLng));
                // },
              ),
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
                    context.read<MapBloc>().add(
                        MoveToMyPositionEvent(mapController: _mapController));
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