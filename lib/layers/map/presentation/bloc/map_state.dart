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
class MovedMapState extends MapState {
  @override
  List<Object> get props => [];
}

/////////////////////////////////
/// Searching Toilet
////////////////////////////////
class SearchingToiletState extends MapState {
  @override
  List<Object> get props => [];
}

/////////////////////////////////
/// Loaded Toilet Marker
////////////////////////////////
class LoadedToiletMarkerState extends MapState {
  final Set<Marker> markers;

  LoadedToiletMarkerState({required this.markers});

  @override
  List<Object> get props => [markers];
}

/////////////////////////////////
/// Loaded Selected Toilet Information
////////////////////////////////
class LoadedSelectedToiletInformationState extends MapState {
  final Set<Marker> markers;

  LoadedSelectedToiletInformationState({required this.markers});

  @override
  List<Object> get props => [markers];
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
