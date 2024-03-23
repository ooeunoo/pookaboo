part of 'map_bloc.dart';

@immutable
abstract class MapState {}

/////////////////////////////////
/// Initial
////////////////////////////////
class InitialState extends MapState {}

/////////////////////////////////
/// Map Created
////////////////////////////////
class MapCreatedState extends MapState {
  final KakaoMapController controller;

  MapCreatedState({required this.controller});
}

/////////////////////////////////
/// Moved Map
////////////////////////////////
class MovedMyPositionState extends MapState {
  final Marker myMarker;

  MovedMyPositionState({required this.myMarker});
}

/////////////////////////////////
/// Searching Toilet
////////////////////////////////
class SearchingToiletState extends MapState {}

/////////////////////////////////
/// Loaded Toilet Markers
////////////////////////////////
class LoadedNearByToiletMarkersState extends MapState {
  final Set<CustomMarker> markers;
  @override
  LoadedNearByToiletMarkersState({required this.markers});
}

/////////////////////////////////
/// Loaded Selected Toilet
////////////////////////////////
class LoadedSelectedToiletState extends MapState {
  final Toilet toilet;

  LoadedSelectedToiletState({required this.toilet});
}

/////////////////////////////////
/// Searching Toilet Direction
////////////////////////////////
class SearchingToiletNavigationState extends MapState {}

/////////////////////////////////
/// Loaded Toilet Direction
////////////////////////////////
class LoadedToiletNavigationState extends MapState {
  final CustomMarker startMarker;
  final CustomMarker endMarker;
  final Toilet toilet;
  final Set<Polyline> polylines;
  final int time;

  LoadedToiletNavigationState(
      {required this.startMarker,
      required this.endMarker,
      required this.toilet,
      required this.polylines,
      required this.time});
}

/////////////////////////////////
/// Zoom To Cluster
////////////////////////////////
class ZoomToClusterState extends MapState {
  final Set<CustomMarker> markers;

  ZoomToClusterState({required this.markers});
}

/////////////////////////////////
/// Zoom To Cluster
////////////////////////////////
class UpdatedFilterState extends MapState {
  final List<ToiletFilter> filters;

  UpdatedFilterState({required this.filters});
}

/////////////////////////////////
/// Stopped Toilet AppState
////////////////////////////////
class StoppedToiletNavigationState extends MapState {}

/////////////////////////////////
/// Error
////////////////////////////////
class ErrorNavigationState extends MapState {}
