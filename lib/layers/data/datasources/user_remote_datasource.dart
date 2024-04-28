import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:pookaboo/layers/data/models/review/review.dart';
import 'package:pookaboo/layers/data/models/toilet/toilet.dart';
import 'package:pookaboo/layers/data/models/user/app_user.dart';
import 'package:pookaboo/layers/data/models/visitation/visitation.dart';
import 'package:pookaboo/layers/domain/entities/review/create_review_params.dart';
import 'package:pookaboo/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookaboo/layers/domain/entities/user/create_user_inquiry_params.dart';
import 'package:pookaboo/layers/domain/entities/user/update_user_params.dart';
import 'package:pookaboo/layers/domain/entities/visitation/create_visitation_params.dart';
import 'package:pookaboo/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:pookaboo/shared/constant/config.dart';
import 'package:pookaboo/shared/error/failure.dart';
import 'package:pookaboo/shared/service/supabase/supabase_service.dart';
import 'package:pookaboo/shared/utils/logging/log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UserTable {
  user('user'),
  inquiry('user_inquiry');

  const UserTable(this.name);

  final String name;
}

abstract class UserRemoteDatasource {
  Future<bool> signInWithKakaoDatasource();

  Future<void> signOutDatasource();

  Stream<User?> getCurrentUserDatasource();

  Future<AppUser?> getSignedInUserDatasource();

  String getAccessTokenDatasource();

  Future<Either<Failure, AppUser>> updateUserDatasource(
      UpdateUserParams params);

  Future<Either<Failure, bool>> createUserInquiryDatasource(
      CreateUserInquiryParams params);

  Future<Either<Failure, bool>> deleteUserDatasource(String userId);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final SupabaseService _supabaseService;

  UserRemoteDatasourceImpl(this._supabaseService);

  @override
  Future<Either<Failure, AppUser>> updateUserDatasource(
      UpdateUserParams params) async {
    try {
      Map<String, dynamic> metadata = {};

      if (params.nickname != null) {
        metadata['nickname'] = params.nickname;
      }
      if (params.phone != null) {
        metadata['phone'] = params.phone;
      }
      if (params.age != null) {
        metadata['age'] = params.age;
      }

      if (params.gender != null) {
        metadata['gender'] = params.gender;
      }

      if (params.version != null) {
        metadata['version'] = params.version;
      }

      final user = await _supabaseService.client
          .from(UserTable.user.name)
          .update(metadata)
          .match({'id': params.user_id})
          .select()
          .single();

      return Right(AppUser.fromJson(user));
    } catch (e) {
      LongPrint(e.toString());
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createUserInquiryDatasource(
      CreateUserInquiryParams params) async {
    try {
      await _supabaseService.client
          .from(UserTable.inquiry.name)
          .insert(params.toJson());
      return const Right(true);
    } catch (e) {
      log.e(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  String getAccessTokenDatasource() {
    return _supabaseService.client.auth.currentSession?.accessToken ?? "";
  }

  @override
  Stream<User?> getCurrentUserDatasource() {
    return _supabaseService.client.auth.onAuthStateChange.map((event) {
      return event.session?.user;
    });
  }

  @override
  Future<bool> signInWithKakaoDatasource() async {
    final bool response = await _supabaseService.client.auth.signInWithOAuth(
      OAuthProvider.kakao,
    );

    return response;
  }

  @override
  Future<void> signOutDatasource() async {
    await _supabaseService.client.auth.signOut();
  }

  @override
  Future<AppUser?> getSignedInUserDatasource() async {
    User? user = _supabaseService.client.auth.currentUser;
    return user == null ? null : await _getAppUser(user.id);
  }

  Future<AppUser?> _getAppUser(String userId) async {
    final data = await _supabaseService.client
        .from(UserTable.user.name)
        .select('*')
        .eq('id', userId)
        .single();

    final AppUser user = AppUser.fromJson(data);
    return user;
  }

  @override
  Future<Either<Failure, bool>> deleteUserDatasource(String userId) async {
    try {
      await _supabaseService.client
          .from(UserTable.user.name)
          .delete()
          .eq('id', userId);

      return const Right(true);
    } catch (e) {
      log.e(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
