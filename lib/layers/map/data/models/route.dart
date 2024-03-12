// To parse this JSON data, do
//
//     final Route = RouteFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'route.freezed.dart';
part 'route.g.dart';

@freezed
class GetRouteParams with _$GetRouteParams {
  const factory GetRouteParams({
    required String sName,
    required int sX,
    required int sY,
    required String eName,
    required int eX,
    required int eY,
    required int ids,
  }) = _GetRouteParams;

  factory GetRouteParams.fromJson(Map<String, dynamic> json) =>
      _$GetRouteParamsFromJson(json);
}

@freezed
class GetRouteResponse with _$GetRouteResponse {
  const factory GetRouteResponse({
    required List<Direction> directions,
    required Bound bound,
    required String resultCode,
  }) = _GetRouteResponse;

  factory GetRouteResponse.fromJson(Map<String, dynamic> json) =>
      _$GetRouteResponseFromJson(json);
}

@freezed
class Bound with _$Bound {
  const factory Bound({
    required int top,
    required int left,
    required int bottom,
    required int right,
  }) = _Bound;

  factory Bound.fromJson(Map<String, dynamic> json) => _$BoundFromJson(json);
}

@freezed
class Direction with _$Direction {
  const factory Direction({
    required String routeMode,
    required Bound bound,
    required String resultCode,
    required int length,
    required int time,
    required List<Section> sections,
    required GroupInfoMap groupInfoMap,
  }) = _Direction;

  factory Direction.fromJson(Map<String, dynamic> json) =>
      _$DirectionFromJson(json);
}

@freezed
class GroupInfoMap with _$GroupInfoMap {
  const factory GroupInfoMap() = _GroupInfoMap;

  factory GroupInfoMap.fromJson(Map<String, dynamic> json) =>
      _$GroupInfoMapFromJson(json);
}

@freezed
class Section with _$Section {
  const factory Section({
    required List<GuideList> guideList,
    required String resultCode,
    required int length,
    required String calories,
    required int time,
    required Facilities facilities,
  }) = _Section;

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
}

@freezed
class Facilities with _$Facilities {
  const factory Facilities({
    required int stair,
    required int underground,
    required int bridge,
  }) = _Facilities;

  factory Facilities.fromJson(Map<String, dynamic> json) =>
      _$FacilitiesFromJson(json);
}

@freezed
class GuideList with _$GuideList {
  const factory GuideList({
    required RotationCode rotationCode,
    required String guideMent,
    required String groupId,
    required int x,
    Link? link,
    required int y,
    required GuideCode guideCode,
    required int seq,
    RoadView? roadView,
    Poi? poi,
    String? crossName,
  }) = _GuideList;

  factory GuideList.fromJson(Map<String, dynamic> json) =>
      _$GuideListFromJson(json);
}

enum GuideCode {
  END,
  ENTER_CROSSWALK,
  ENTER_DOUBLE_CROSSWALK,
  EXIT_CROSSWALK,
  NONE,
  START,
  TURN_CROSSROAD
}

final guideCodeValues = EnumValues({
  "END": GuideCode.END,
  "ENTER_CROSSWALK": GuideCode.ENTER_CROSSWALK,
  "ENTER_DOUBLE_CROSSWALK": GuideCode.ENTER_DOUBLE_CROSSWALK,
  "EXIT_CROSSWALK": GuideCode.EXIT_CROSSWALK,
  "NONE": GuideCode.NONE,
  "START": GuideCode.START,
  "TURN_CROSSROAD": GuideCode.TURN_CROSSROAD
});

@freezed
class Link with _$Link {
  const factory Link({
    required bool existCenterLine,
    required int length,
    required int time,
    required String points,
    String? roadName,
  }) = _Link;

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
}

@freezed
class Poi with _$Poi {
  const factory Poi({
    required double x,
    required String confirmId,
    required double y,
    required String placeName,
  }) = _Poi;

  factory Poi.fromJson(Map<String, dynamic> json) => _$PoiFromJson(json);
}

@freezed
class RoadView with _$RoadView {
  const factory RoadView({
    required String filename,
    required int panoid,
    required int x,
    required int y,
    required int pan,
  }) = _RoadView;

  factory RoadView.fromJson(Map<String, dynamic> json) =>
      _$RoadViewFromJson(json);
}

enum RotationCode { STRAIGHT, TURN_LEFT, TURN_RIGHT }

final rotationCodeValues = EnumValues({
  "STRAIGHT": RotationCode.STRAIGHT,
  "TURN_LEFT": RotationCode.TURN_LEFT,
  "TURN_RIGHT": RotationCode.TURN_RIGHT
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
