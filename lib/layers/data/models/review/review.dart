import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pookabu/layers/data/models/user/app_user.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  factory Review({
    required int id,
    required AppUser? user,
    required Toilet? toilet,
    required double cleanliness,
    required double safety,
    required double management,
    required double convenience,
    required String comment,
    required DateTime modified_at,
    required DateTime created_at,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
