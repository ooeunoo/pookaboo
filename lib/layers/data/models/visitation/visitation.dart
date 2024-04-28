import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pookabu/layers/data/models/user/app_user.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';

part 'visitation.freezed.dart';
part 'visitation.g.dart';

@freezed
class Visitation with _$Visitation {
  factory Visitation({
    required int id,
    required AppUser? user,
    required Toilet toilet,
    required bool reviewed,
    required DateTime created_at,
  }) = _Visitation;

  factory Visitation.fromJson(Map<String, dynamic> json) =>
      _$VisitationFromJson(json);
}
