import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';

part 'create_toilet_params.freezed.dart';
part 'create_toilet_params.g.dart';

@freezed
class CreateToiletParam with _$CreateToiletParam {
  factory CreateToiletParam({
    required String user_id,
    required String name,
    required int type,
    required bool gender,
    required bool password,
    required String password_tip,
    required String address,
    required String road_address,
    required String location_tip,
    required String city,
    required String coordinates, // to coordinates
    required bool paper,
    required bool towel,
    required bool soap,
    required bool powder_room,
    required bool hand_dry,
    required bool vending,
    required bool diaper,
    required bool bell,
    required List<int> urinal,
    required List<int> child_urinal,
    required List<int> disable_urinal,
    required List<int> seat,
    required List<int> child_seat,
    required List<int> disable_seat,
    required List<int> washbasin,
    required OperateTime mon,
    required OperateTime tue,
    required OperateTime wed,
    required OperateTime thu,
    required OperateTime fri,
    required OperateTime sat,
    required OperateTime sun,
    @JsonKey(includeToJson: false, includeFromJson: false) List<File>? images,
  }) = _CreateToiletParam;

  factory CreateToiletParam.fromJson(Map<String, dynamic> json) =>
      _$CreateToiletParamFromJson(json);

  static CreateToiletParam getEmpty() {
    return CreateToiletParam(
        user_id: '',
        name: '',
        type: 0,
        gender: false,
        password: false,
        password_tip: '',
        address: '',
        road_address: '',
        location_tip: '',
        city: '',
        coordinates: '',
        paper: false,
        towel: false,
        soap: false,
        powder_room: false,
        hand_dry: false,
        vending: false,
        diaper: false,
        bell: false,
        urinal: [0, 0, 0],
        child_urinal: [0, 0, 0],
        disable_urinal: [0, 0, 0],
        seat: [0, 0, 0],
        child_seat: [0, 0, 0],
        disable_seat: [0, 0, 0],
        washbasin: [0, 0, 0],
        mon: OperateTime(open: null, close: null),
        tue: OperateTime(open: null, close: null),
        wed: OperateTime(open: null, close: null),
        thu: OperateTime(open: null, close: null),
        fri: OperateTime(open: null, close: null),
        sat: OperateTime(open: null, close: null),
        sun: OperateTime(open: null, close: null),
        images: []);
  }
}
