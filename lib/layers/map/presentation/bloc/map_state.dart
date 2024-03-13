part of 'map_bloc.dart';

@immutable
abstract class MapState extends Equatable {}

/////////////////////////////////
/// Initial
////////////////////////////////
class InitialState extends MapState {
  @override
  List<Object> get props => [];
}

/////////////////////////////////
/// Map Created
////////////////////////////////
class MapCreatedState extends MapState {
  final KakaoMapController controller;

  MapCreatedState({required this.controller});

  @override
  List<Object> get props => [controller];
}

/////////////////////////////////
/// Moved Map
////////////////////////////////
class MovedMyPositionState extends MapState {
  final LatLng loc;

  MovedMyPositionState({required this.loc});

  @override
  List<Object> get props => [loc];
}

/////////////////////////////////
/// Searching Toilet
////////////////////////////////
class SearchingToiletState extends MapState {
  @override
  List<Object> get props => [];
}

/////////////////////////////////
/// Loaded Toilet Markers
////////////////////////////////
class LoadedToiletMarkersState extends MapState {
  final Set<Marker> markers;

  LoadedToiletMarkersState({required this.markers});

  @override
  List<Object> get props => [markers];
}

/////////////////////////////////
/// Loaded Selected Toilet
////////////////////////////////
class LoadedSelectedToiletState extends MapState {
  final Toilet toilet;

  LoadedSelectedToiletState({required this.toilet});

  @override
  List<Object> get props => [toilet];
}

/////////////////////////////////
/// Searching Toilet Direction
////////////////////////////////
class SearchingToiletDirectionState extends MapState {
  @override
  List<Object> get props => [];
}

/////////////////////////////////
/// Loaded Toilet Direction
////////////////////////////////
class LoadedToiletDirectionState extends MapState {
  final GetRouteFormatResponse routes;

  LoadedToiletDirectionState({required this.routes});

  @override
  List<Object> get props => [routes];
}

/////////////////////////////////
/// Error
////////////////////////////////
class ErrorState extends MapState {
  final String message;

  ErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
