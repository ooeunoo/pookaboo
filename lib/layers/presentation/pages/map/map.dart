import 'dart:convert';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/data/models/toilet/custom_marker.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/presentation/bloc/map/map_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/map/map_utils.dart';
import 'package:pookabu/layers/presentation/cubit/app/app_cubit.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/navigation_modal.dart';
import 'package:pookabu/shared/constant/assets.dart';
import 'package:pookabu/shared/constant/config.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/service/admob/admob_service.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/utils/helper/debounce_helper.dart';
import 'package:pookabu/shared/utils/helper/vibration_helper.dart';
import 'package:pookabu/shared/widgets/common/app_chip.dart';
import 'package:pookabu/shared/widgets/common/app_snak_bar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  bool isOpenDetailSheet = false;
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  late KakaoMapController _controller;
  Marker? _myMarker;

  List<ToiletFilter> _filtered = [];

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showBottomSheet(BuildContext context, Toilet toilet) async {
    setState(() {
      isOpenDetailSheet = true;
    });
    showFlexibleBottomSheet(
      context: context,
      anchors: [0.3, 1],
      initHeight: 0.3,
      isDismissible: true,
      isExpand: true,
      isSafeArea: true,
      isModal: true,
      bottomSheetBorderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(20), topStart: Radius.circular(20)),
      draggableScrollableController: DraggableScrollableController(),
      builder: (BuildContext context, ScrollController scrollController,
          double offset) {
        return DetailSheet(
          offset: offset,
          toilet: toilet,
          controller: scrollController,
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          isOpenDetailSheet = false;
        });
      }
    });
  }

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: AdmobService.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> _clear() async {
    await _controller.clearMarker();
    await _controller.clearCustomOverlay();
    await _controller.clearMarkerClusterer();
    await _controller.clearPolyline();
  }

  Future<void> _drawMarker(Set<CustomMarker> markers,
      {bool showMyMarker = true}) async {
    List<CustomMarker> markerList = markers.toList();
    _drawCluster(markerList);

    if (showMyMarker) {
      _drawMyMarker();
    } else {
      _removeMyMarker();
    }
  }

  void _drawCluster(List<CustomMarker> markers) {
    _controller.webViewController
        .runJavaScript('''${getAddCustomMarkersClusterScripts()}
      addCustomMarkersCluster(${jsonEncode(markers.map((marker) => marker.toJson()).toList())})''');
  }

  Future<void> _drawPolyline(Set<Polyline> polylines) async {
    await _controller.addPolyline(polylines: polylines.toList());
  }

  Future<void> _drawMyMarker() async {
    if (_myMarker != null) {
      await _controller.addMarker(markers: [_myMarker!]);
    }
  }

  Future<void> _removeMyMarker() async {
    await _controller.clearMarker();
  }

  void _updateVisibleOfBottomNavigation(bool state) {
    context.read<AppCubit>().updateBottomNavigationVisible(state);
  }

  void _moveToCenter(LatLng loc) {
    _controller.setLevel(Zoom.building.index);
    _controller.panTo(loc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) async {
        // 내 위치 이동 & 길찾기 종료
        if (state is MovedMyPositionState) {
          _myMarker = state.myMarker;
          context.read<MapBloc>().add(GetNearByToiletMarkersEvent());
        }
        if (state is StoppedToiletNavigationState) {
          _updateVisibleOfBottomNavigation(true);
          context.read<MapBloc>().add(GetNearByToiletMarkersEvent());
        }
        // 주변 화장실 마커 불러오기 완료
        else if (state is LoadedNearByToiletMarkersState) {
          await _clear();
          await _drawMarker(state.markers);
        }
        // 선택 화장실 불러오기 완료
        else if (state is LoadedSelectedToiletState) {
          _showBottomSheet(context, state.toilet);
        }
        // 선택 화장실 길 정보 불러오기 완료
        else if (state is LoadedToiletNavigationState) {
          await _clear();

          // 마커 및 경로 그리기
          Set<CustomMarker> markers = {};
          markers.addAll({state.startMarker, state.endMarker});
          await _drawPolyline(state.polylines);
          await _drawMarker(markers, showMyMarker: false);
          _moveToCenter(state.startMarker.latLng);

          _updateVisibleOfBottomNavigation(false);
        }
        // 클러스터 줌
        else if (state is ZoomToClusterState) {
          await _clear();
          await _drawMarker(state.markers);
        }
        // 필터 업데이트
        else if (state is UpdatedFilterState) {
          _filtered = state.filters;
          _debouncer.run(
              () => context.read<MapBloc>().add(GetNearByToiletMarkersEvent()));
        } else if (state is ErrorNavigationState) {
          context.back();
          NotifyLocationPermissionSnackBar(context);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            KakaoMap(
              currentLevel: Zoom.street.level,
              maxLevel: Zoom.city.index,
              center: Config.initialCenter,
              onMapCreated: ((controller) async {
                _controller = controller;

                context
                    .read<MapBloc>()
                    .add(MapCreateEvent(controller: controller));
              }),
              onCustomOverlayTap: (String customOverlayId, LatLng latLng) {
                if (!isOpenDetailSheet &&
                    state is! LoadedToiletNavigationState) {
                  context.read<MapBloc>().add(SelecteToiletMarkerEvent(
                      toiletId: int.parse(customOverlayId)));
                }
              },
              onCenterChangeCallback: (LatLng latLng, int zoomLevel) {
                if (!isOpenDetailSheet &&
                    state is! LoadedToiletNavigationState) {
                  _debouncer.run(() => context
                      .read<MapBloc>()
                      .add(GetNearByToiletMarkersEvent()));
                }
              },
            ),

            ////////////////////////////////////
            ///  BACK BUTTON (STOP DIRECTION)
            ///////////////////////////////////
            if (state is LoadedToiletNavigationState) ...{
              Positioned(
                  left: Dimens.space20,
                  top: Dimens.statusbarHeight(context) + Dimens.space8,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      context.read<MapBloc>().add(StopNavigationEvent());
                    },
                    child: Container(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      padding: EdgeInsets.all(Dimens.space8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.space12),
                        border: Border.all(
                            width: Dimens.space1, color: Palette.coolGrey03),
                        // gap: const EdgeInsets.all(10),
                        color: Palette.white,
                      ),
                      child: SvgPicture.asset(
                        Assets.arrowLeft,
                        width: Dimens.space24,
                        height: Dimens.space24,
                      ),
                    ),
                  )),
            },

            ////////////////////////////////////
            ///  FILTER CHIP
            ///////////////////////////////////
            if (state is! LoadedToiletNavigationState) ...{
              Positioned(
                left: Dimens.space20,
                top: Dimens.statusbarHeight(context) + Dimens.space8,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ToiletFilter.values.map((filter) {
                      return Padding(
                        padding: EdgeInsets.only(right: Dimens.space4),
                        child: AppChip(
                          text: filter.text,
                          icon: filter.icon,
                          isSelected: _filtered.contains(filter),
                          onTap: () {
                            onMediumVibration();
                            context
                                .read<MapBloc>()
                                .add(UpdateToiletFilterEvent(filter: filter));
                          },
                        ),
                      );
                    }).toList()),
              ),
            },

            ////////////////////////////////////
            ///  MY POISITION BUTTON
            ///////////////////////////////////
            if (state is! LoadedToiletNavigationState) ...{
              Positioned(
                  right: Dimens.space20,
                  bottom: Dimens.bottomBarHeight(context) + Dimens.space60,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      onMediumVibration();

                      context.read<MapBloc>().add(MoveToMyPositionEvent());
                    },
                    child: Container(
                      width: Dimens.space40,
                      height: Dimens.space40,
                      padding: EdgeInsets.all(Dimens.space8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimens.space12),
                        border: Border.all(
                            width: Dimens.space1, color: Palette.coolGrey03),
                        color: Palette.white,
                      ),
                      child: SvgPicture.asset(
                        Assets.currentPosition,
                        width: Dimens.space24,
                        height: Dimens.space24,
                      ),
                    ),
                  )),
            },

            ////////////////////////////////////
            ///  Navigation
            ///////////////////////////////////
            if (state is LoadedToiletNavigationState) ...{
              Positioned(
                  bottom: Dimens.bottomBarHeight(context) + Dimens.space60,
                  left: Dimens.zero,
                  right: Dimens.zero,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Palette.coolGrey12,
                          borderRadius: BorderRadius.circular(Dimens.space16),
                          border: Border.all(
                            color: Palette.coolGrey13,
                            width: Dimens.space1,
                          ),
                        ),
                        height: Dimens.space155,
                        child: NavigationModal(
                            toilet: state.toilet, time: state.time)),
                  )),
            },

            if (_bannerAd != null) ...{
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: _bannerAd!.size.height.toDouble(),
                    child: _isLoaded ? AdWidget(ad: _bannerAd!) : null,
                  ),
                ),
              )
            }
          ],
        );
      },
    );
  }
}
