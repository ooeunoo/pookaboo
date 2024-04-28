import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookaboo/layers/data/models/coord/coord.dart';
import 'package:pookaboo/layers/data/models/route/route.dart';
import 'package:pookaboo/layers/data/models/toilet/custom_marker.dart';
import 'package:pookaboo/layers/data/models/toilet/toilet.dart';
import 'package:pookaboo/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pookaboo/layers/domain/usecases/toilet/toilet_usecase.dart';
import 'package:pookaboo/shared/constant/assets.dart';
import 'package:pookaboo/shared/constant/config.dart';
import 'package:pookaboo/shared/constant/enum.dart';
import 'package:pookaboo/shared/service/geolocator/geolocator_service.dart';
import 'package:pookaboo/shared/utils/helper/coord_helper.dart';
import 'package:pookaboo/shared/utils/logging/log.dart';
import 'package:pookaboo/layers/presentation/bloc/map/map_utils.dart';

part 'map_state.dart';
part 'map_event.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  /////////////////////////////////
  /// Service
  ////////////////////////////////
  final GeolocatorService _geolocatorService;

  /////////////////////////////////
  /// UseCase
  ////////////////////////////////
  final GetNearByToiletsUseCase _getNearByToiletsUseCase;
  final GetToiletByIdUseCase _getToiletByIdUseCase;
  final GetRoutesUseCase _getRoutesUseCase;

  /////////////////////////////////
  /// Event Mapping
  ////////////////////////////////
  MapBloc(this._geolocatorService, this._getNearByToiletsUseCase,
      this._getToiletByIdUseCase, this._getRoutesUseCase)
      : super(InitialState()) {
    on<MapCreateEvent>(_onMapCreateEvent);
    on<GetNearByToiletMarkersEvent>(_onGetNearByToiletMarkersEvent);
    // on<ClickToClusterEvent>(_onClickToClusterEvent);
    on<MoveToMyPositionEvent>(_onMoveToMyPositionEvent);
    on<SelecteToiletMarkerEvent>(_onSelecteToiletMarkerEvent);
    on<StartNavigationEvent>(_onStartNavigationEvent);
    on<LoadNavigationEvent>(_onLoadNavigationEvent);
    on<StopNavigationEvent>(_onStopNavigationEvent);
    on<UpdateToiletFilterEvent>(_onUpdateToiletFilterEvent);
  }

  /////////////////////////////////
  /// Property
  ////////////////////////////////
  late KakaoMapController _mapController;
  final List<ToiletFilter> _filters = [];

  StreamSubscription<Position>? _streamPosition;

  @override
  Future<void> close() {
    _streamPosition?.cancel();
    return super.close();
  }

  /////////////////////////////////
  Future<void> _onMapCreateEvent(
      MapCreateEvent event, Emitter<MapState> emit) async {
    _mapController = event.controller;

    bool locationPermission = await _geolocatorService.hasPermission();
    if (locationPermission) {
      // 내위치로 이동하기
      await _onMoveToMyPositionEvent(MoveToMyPositionEvent(), emit);
    } else {
      // 현재 위치 주변 화장실 찾긴
      await _onGetNearByToiletMarkersEvent(GetNearByToiletMarkersEvent(), emit);
    }
  }

  /////////////////////////////////
  Future<void> _onGetNearByToiletMarkersEvent(
    GetNearByToiletMarkersEvent event,
    Emitter<MapState> emit,
  ) async {
    try {
      LatLng loc = await _mapController.getCenter();

      GetNearByToiletsParams params = GetNearByToiletsParams(
          loc: loc,
          radius: 2000,
          passwordFilter: _hasFillter(ToiletFilter.password),
          timeFilter: _hasFillter(ToiletFilter.time),
          genderFilter: _hasFillter(ToiletFilter.gender));

      final response = await _getNearByToiletsUseCase.call(params);
      Set<CustomMarker> markers = {};
      response.fold((left) {}, (right) async {
        markers = right.map<CustomMarker>((toilet) {
          return CustomMarker(
              id: toilet.id.toString(),
              isClickable: true,
              latLng: LatLng(toilet.lat!, toilet.lng!),
              content: getDefaultMarkerInnerText(toilet.type, toilet.rating!));
        }).toSet();

        emit(LoadedNearByToiletMarkersState(markers: markers));
      });
    } catch (e) {
      log.e(e);
    }
  }

  /////////////////////////////////
  Future<void> _onMoveToMyPositionEvent(
      MoveToMyPositionEvent event, Emitter<MapState> emit) async {
    try {
      bool hasPermission = await _geolocatorService.hasPermission();
      if (!hasPermission) {
        emit(ErrorNavigationState());
        return;
      }

      final Position position = await _geolocatorService.getPosition();
      LatLng myPosition = LatLng(position.latitude, position.longitude);
      Marker myMarker = Marker(
          markerId: '나의 위치',
          latLng: LatLng(myPosition.latitude, myPosition.longitude),
          markerImageSrc: Assets.myMarkerImage);
      _mapController.panTo(myPosition);
      emit(MovedMyPositionState(myMarker: myMarker));
    } catch (e) {
      await _geolocatorService.askPermission();
      log.e(e);
    }
  }

  ////////////////////////////////
  // Future<void> _onClickToClusterEvent(
  //     ClickToClusterEvent event, Emitter<MapState> emit) async {
  //   try {
  //     int zoomLevel = event.zoomLevel;
  //     LatLng loc = event.loc;
  //     LatLng position = LatLng(loc.latitude, loc.longitude);
  //     await _mapController.panTo(position);
  //     if (zoomLevel > 1) {
  //       await _mapController.setLevel(zoomLevel - 1);
  //     }
  //     emit(ZoomToClusterState(markers: _markers));
  //   } catch (e) {
  //     log.e(e);
  //   }
  // }

  /////////////////////////////////
  Future<void> _onSelecteToiletMarkerEvent(
      SelecteToiletMarkerEvent event, Emitter<MapState> emit) async {
    try {
      final int toiletId = event.toiletId;
      final response = await _getToiletByIdUseCase.call(toiletId);

      response.fold((l) {
        log.e(l);
      }, (r) {
        emit(LoadedSelectedToiletState(toilet: r));
      });
    } catch (e) {
      log.e(e);
    }
  }

  /////////////////////////////////
  FutureOr<void> _onStartNavigationEvent(
      StartNavigationEvent event, Emitter<MapState> emit) async {
    emit(SearchingToiletNavigationState());
    Toilet toilet = event.toilet;
    try {
      bool hasPermission = await _geolocatorService.hasPermission();
      if (!hasPermission) {
        emit(ErrorNavigationState());
        return;
      }

      _streamPosition =
          _geolocatorService.getPositionStream().listen((position) async {
        LatLng mpLoc = LatLng(position.latitude, position.longitude);
        LatLng tpLoc = LatLng(toilet.lat!, toilet.lng!);

        Document mp = coordconvWGS84ToWCONGNAMUL(
          mpLoc.longitude,
          mpLoc.latitude,
        );
        Document tp =
            coordconvWGS84ToWCONGNAMUL(tpLoc.longitude, tpLoc.latitude);

        GetRouteParams params = GetRouteParams(
            sName: '나의 위치',
            sX: mp.x,
            sY: mp.y,
            eName: toilet.name,
            eX: tp.x,
            eY: tp.y,
            ids: Config.routeIds);

        final response = await _getRoutesUseCase.call(params);

        response.fold((l) {
          log.e(l);
        }, (r) {
          int time = r.time;
          Set<Polyline> polylines = {
            Polyline(
                polylineId: 'polyline',
                points: r.points.map((route) {
                  return LatLng(route.y, route.x);
                }).toList(),
                strokeColor: const Color(0xff0078FF),
                strokeWidth: 10,
                strokeStyle: StrokeStyle.solid)
          };
          CustomMarker startMarker = CustomMarker(
              id: 'start', latLng: mpLoc, content: getStartMarkerInnerText());

          CustomMarker endMarker = CustomMarker(
              id: toilet.id.toString(),
              latLng: tpLoc,
              content: getEndMarkerInnerText(toilet.type));

          add(LoadNavigationEvent(
              toilet: toilet,
              startMarker: startMarker,
              endMarker: endMarker,
              polylines: polylines,
              time: time));
        });
      });
    } catch (e) {
      log.e(e);
    }
  }

  Future<void> _onLoadNavigationEvent(
      LoadNavigationEvent event, Emitter<MapState> emit) async {
    emit(LoadedToiletNavigationState(
        startMarker: event.startMarker,
        endMarker: event.endMarker,
        toilet: event.toilet,
        polylines: event.polylines,
        time: event.time));
  }

  /////////////////////////////////
  Future<void> _onStopNavigationEvent(
      StopNavigationEvent event, Emitter<MapState> emit) async {
    _streamPosition?.cancel();
    emit(StoppedToiletNavigationState());
  }

  /////////////////////////////////
  Future<void> _onUpdateToiletFilterEvent(
      UpdateToiletFilterEvent event, Emitter<MapState> emit) async {
    ToiletFilter selectFilter = event.filter;
    if (_filters.contains(selectFilter)) {
      _filters.remove(selectFilter);
    } else {
      _filters.add(selectFilter);
    }
    emit(UpdatedFilterState(filters: _filters));
  }

  bool _hasFillter(ToiletFilter filter) {
    return _filters.contains(filter);
  }
}
