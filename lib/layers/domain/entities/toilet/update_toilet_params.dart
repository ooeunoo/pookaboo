import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';

part 'update_toilet_params.freezed.dart';
part 'update_toilet_params.g.dart';

@freezed
class UpdateToiletParam with _$UpdateToiletParam {
  UpdateToiletParam._();

  factory UpdateToiletParam({
    required String toilet_id,
    String? name,
    int? type,
    bool? gender,
    bool? password,
    String? password_tip,
    String? address,
    String? road_address,
    String? location_tip,
    String? city,
    String? coordinates,
    bool? paper,
    bool? towel,
    bool? soap,
    bool? powder_room,
    bool? hand_dry,
    bool? vending,
    bool? diaper,
    bool? bell,
    List<int>? urinal,
    List<int>? child_urinal,
    List<int>? disable_urinal,
    List<int>? seat,
    List<int>? child_seat,
    List<int>? disable_seat,
    List<int>? washbasin,
    OperateTime? mon,
    OperateTime? tue,
    OperateTime? wed,
    OperateTime? thu,
    OperateTime? fri,
    OperateTime? sat,
    OperateTime? sun,
    @JsonKey(includeToJson: false, includeFromJson: false) List<File>? images,
  }) = _UpdateToiletParam;

  factory UpdateToiletParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateToiletParamFromJson(json);
}
