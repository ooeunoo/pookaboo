// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateUserParamsImpl _$$UpdateUserParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateUserParamsImpl(
      nickname: json['nickname'] as String? ?? null,
      phone: json['phone'] as String? ?? null,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']) ?? null,
      age: json['age'] as String? ?? null,
    );

Map<String, dynamic> _$$UpdateUserParamsImplToJson(
        _$UpdateUserParamsImpl instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'phone': instance.phone,
      'gender': _$GenderEnumMap[instance.gender],
      'age': instance.age,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
};
