// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_review_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateReviewParamsImpl _$$CreateReviewParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateReviewParamsImpl(
      toiletId: json['toiletId'] as int,
      userId: json['userId'] as String,
      cleanliness: json['cleanliness'] as int? ?? 0,
      convenience: json['convenience'] as int? ?? 0,
      safety: json['safety'] as int? ?? 0,
      management: json['management'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
    );

Map<String, dynamic> _$$CreateReviewParamsImplToJson(
        _$CreateReviewParamsImpl instance) =>
    <String, dynamic>{
      'toiletId': instance.toiletId,
      'userId': instance.userId,
      'cleanliness': instance.cleanliness,
      'convenience': instance.convenience,
      'safety': instance.safety,
      'management': instance.management,
      'comment': instance.comment,
    };