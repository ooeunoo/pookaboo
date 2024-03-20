import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookaboo/layers/data/models/coord/coord.dart';
import 'package:pookaboo/layers/data/models/route/route.dart';
import 'package:pookaboo/layers/data/models/toilet/toilet.dart';
import 'package:pookaboo/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pookaboo/layers/domain/usecases/review/review_usecase.dart';
import 'package:pookaboo/layers/domain/usecases/map/map_usecase.dart';
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
  final CreateToiletReviewUseCase _createToiletReviewUseCase;
  final GetRoutesUseCase _getRoutesUseCase;

  /////////////////////////////////
  /// Event Mapping
  ////////////////////////////////
  MapBloc(
      this._geolocatorService,
      this._getNearByToiletsUseCase,
      this._getToiletByIdUseCase,
      this._createToiletReviewUseCase,
      this._getRoutesUseCase)
      : super(InitialState()) {
    on<MapCreateEvent>(_onMapCreateEvent);
    on<GetNearByToiletsEvent>(_onGetNearByToiletsEvent);
    on<ClickToClusterEvent>(_onClickToClusterEvent);
    on<MoveToMyPositionEvent>(_onMoveToMyPositionEvent);
    on<SelecteToiletMarkerEvent>(_onSelecteToiletMarkerEvent);
    on<StartNavigationEvent>(_onStartNavigationEvent);
    on<StopNavigationEvent>(_onStopNavigationEvent);
    on<UpdateToiletFilterEvent>(_onUpdateToiletFilterEvent);
  }

  /////////////////////////////////
  /// Property
  ////////////////////////////////

  late KakaoMapController _mapController;
  late final List<ToiletFilter> _filters = [];
  late Set<CustomOverlay> _markers = {};
  late Set<Polyline> _polylines = {};

  /////////////////////////////////
  /// [MapCreateEvent] Event Handler
  ////////////////////////////////
  Future<void> _onMapCreateEvent(
      MapCreateEvent event, Emitter<MapState> emit) async {
    _mapController = event.controller;
    emit(MapCreatedState(controller: _mapController));
  }

  /////////////////////////////////
  /// [GetNearByToiletsEvent] Event Handler
  ////////////////////////////////
  Future<void> _onGetNearByToiletsEvent(
    GetNearByToiletsEvent event,
    Emitter<MapState> emit,
  ) async {
    try {
      LatLngBounds bounds = await _mapController.getBounds();
      GetNearByToiletsParams params = GetNearByToiletsParams(
          bounds: bounds,
          passwordFilter: _hasFillter(ToiletFilter.password),
          timeFilter: _hasFillter(ToiletFilter.time),
          genderFilter: _hasFillter(ToiletFilter.gender));

      final response = await _getNearByToiletsUseCase(params);
      response.fold((left) {
        log.e(left);
      }, (right) async {
        _markers = right.map<CustomOverlay>((toilet) {
          return CustomOverlay(
              isClickable: true,
              customOverlayId: toilet.id.toString(),
              latLng: LatLng(toilet.lat!, toilet.lng!),
              content: getDefaultMarkerInnerText(toilet.type, toilet.rating!));
        }).toSet();

        emit(LoadedToiletMarkersState(markers: _markers));
      });
    } catch (e) {
      log.e(e);
    }
  }

  /////////////////////////////////
  /// [MoveToMyPositionEvent] Event Handler
  ////////////////////////////////
  Future<void> _onMoveToMyPositionEvent(
      MoveToMyPositionEvent event, Emitter<MapState> emit) async {
    try {
      final Position position = await _geolocatorService.getPosition();
      LatLng myPosition = LatLng(position.latitude, position.longitude);
      _mapController.panTo(myPosition);
      emit(MovedMyPositionState(loc: myPosition));
    } catch (e) {
      await _geolocatorService.askPermission();
      log.e(e);
    }
  }

  /////////////////////////////////
  /// [ClickToClusterEvent] Event Handler
  ////////////////////////////////
  Future<void> _onClickToClusterEvent(
      ClickToClusterEvent event, Emitter<MapState> emit) async {
    try {
      int zoomLevel = event.zoomLevel;
      LatLng loc = event.loc;
      LatLng position = LatLng(loc.latitude, loc.longitude);
      await _mapController.panTo(position);
      if (zoomLevel > 1) {
        await _mapController.setLevel(zoomLevel - 1);
      }
      emit(ZoomToClusterState(markers: _markers));
    } catch (e) {
      log.e(e);
    }
  }

  /////////////////////////////////
  /// [SelecteToiletMarkerEvent] Event Handler
  ////////////////////////////////
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
  /// [StartDirectionEvent] Event Handler
  ////////////////////////////////
  Future<void> _onStartNavigationEvent(
      StartNavigationEvent event, Emitter<MapState> emit) async {
    emit(SearchingToiletNavigationState());
    Toilet toilet = event.toilet;
    try {
      final Position position = await _geolocatorService.getPosition();
      LatLng mpLoc = LatLng(position.latitude, position.longitude);
      LatLng tpLoc = LatLng(toilet.lat!, toilet.lng!);

      Document mp = coordconvWGS84ToWCONGNAMUL(
        mpLoc.longitude,
        mpLoc.latitude,
      );
      Document tp = coordconvWGS84ToWCONGNAMUL(tpLoc.longitude, tpLoc.latitude);

      GetRouteParams params = GetRouteParams(
          sName: '나의 위치',
          sX: mp.x,
          sY: mp.y,
          eName: toilet.name,
          eX: tp.x,
          eY: tp.y,
          ids: '11277825,434235');

      final response = await _getRoutesUseCase.call(params);

      await response.fold((l) {
        log.e(l);
      }, (r) async {
        _polylines = {
          Polyline(
              polylineId: 'polyline',
              points: r.points.map((route) {
                return LatLng(route.y, route.x);
              }).toList(),
              strokeColor: const Color(0xff0078FF),
              strokeWidth: 10,
              strokeStyle: StrokeStyle.solid)
        };

        CustomOverlay startMarker = CustomOverlay(
            customOverlayId: 'start',
            latLng: mpLoc,
            content: getStartMarkerInnerText());

        CustomOverlay endMarer = CustomOverlay(
            customOverlayId: toilet.id.toString(),
            latLng: tpLoc,
            content: getEndMarkerInnerText(toilet.type));

        emit(LoadedToiletNavigationState(
            startMarker: startMarker,
            endMarker: endMarer,
            toilet: toilet,
            polylines: _polylines,
            time: r.time));
      });
    } catch (e) {
      log.e(e);
    }
  }

  /////////////////////////////////
  /// [EndDirectionEvent] Event Handler
  ////////////////////////////////
  Future<void> _onStopNavigationEvent(
      StopNavigationEvent event, Emitter<MapState> emit) async {
    emit(StoppedToiletNavigationState());
    // final Position position = await _geolocatorService.getPosition();
    // LatLng myPosition = LatLng(position.latitude, position.longitude);
    // _mapController.panTo(myPosition);
    // emit(MovedMyPositionState(loc: myPosition));
  }

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
