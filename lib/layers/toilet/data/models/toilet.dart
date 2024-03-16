import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'toilet.freezed.dart';
part 'toilet.g.dart';

@freezed
class Toilet with _$Toilet {
  factory Toilet({
    required int id,
    required String name,
    required int type,
    required bool visible,
    required bool gender,
    required bool password,
    @Default("") String password_tip,
    @Default(0) int reviews,
    required String location_type,
    required String address,
    required String road_address,
    required String location_tip,
    required String city,
    required double? lat,
    required double? lng,
    Convenience? convenience,
    Equipment? equipment,
    Rating? rating,
    Time? time,
  }) = _Toilet;

  factory Toilet.fromJson(Map<String, dynamic> json) => _$ToiletFromJson(json);
}

@freezed
class Convenience with _$Convenience {
  factory Convenience({
    required bool paper,
    required bool towel,
    required bool soap,
    required bool powder_room,
    required bool hand_dry,
    required bool vending,
    required bool diaper,
    required bool bell,
  }) = _Convenience;

  factory Convenience.fromJson(Map<String, dynamic> json) =>
      _$ConvenienceFromJson(json);
}

@freezed
class Equipment with _$Equipment {
  factory Equipment({
    required String urinal,
    required String child_urinal,
    required String disable_urinal,
    required String seat,
    required String child_seat,
    required String disable_seat,
    required String washbasin,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);
}

@freezed
class Rating with _$Rating {
  factory Rating({
    required double cleanliness,
    required double safety,
    required double convenience,
    required double management,
  }) = _Rating;

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  static double getAverageRating(Rating rating) {
    double cleanliness = rating.cleanliness;
    double management = rating.management;
    double convenience = rating.convenience;
    double safety = rating.safety;

    double averageRating =
        (cleanliness + management + convenience + safety) / 4;

    return double.parse(averageRating.toStringAsFixed(1));
  }
}

@freezed
class Time with _$Time {
  factory Time({
    required OperateTime mon,
    required OperateTime tue,
    required OperateTime wed,
    required OperateTime thu,
    required OperateTime fri,
    required OperateTime sat,
    required OperateTime sun,
  }) = _Time;

  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);
}

@freezed
class OperateTime with _$OperateTime {
  factory OperateTime({
    required String? open,
    required String? close,
  }) = _OperateTime;

  factory OperateTime.fromJson(Map<String, dynamic> json) =>
      _$OperateTimeFromJson(json);
}
