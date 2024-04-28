import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pookabu/layers/data/models/user/app_user.dart';

part 'update_user_params.freezed.dart';
part 'update_user_params.g.dart';

@freezed
class UpdateUserParams with _$UpdateUserParams {
  factory UpdateUserParams({
    required String user_id,
    @Default(null) String? nickname,
    @Default(null) String? phone,
    @Default(null) int? gender,
    @Default(null) String? age,
    @Default(null) int? version,
  }) = _UpdateUserParams;

  factory UpdateUserParams.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserParamsFromJson(json);
}
