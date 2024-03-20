import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;
import 'package:pookaboo/layers/data/datasources/user_remote_datasource.dart';
import 'package:pookaboo/layers/data/models/user/app_user.dart';
import 'package:pookaboo/layers/domain/entities/user/create_user_inquiry_params.dart';
import 'package:pookaboo/layers/domain/entities/user/update_user_params.dart';
import 'package:pookaboo/layers/domain/repositories/user/user_repository.dart';
import 'package:pookaboo/shared/constant/config.dart';
import 'package:pookaboo/shared/constant/enum.dart';
import 'package:pookaboo/shared/error/failure.dart';
import 'package:pookaboo/shared/service/supabase/supabase_service.dart';
import 'package:pookaboo/shared/utils/logging/log.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource userRemoteDatasource;

  UserRepositoryImpl(this.userRemoteDatasource);

  @override
  Future<Either<Failure, bool>> createUserInquiryImpl(
      CreateUserInquiryParams params) async {
    return userRemoteDatasource.createUserInquiryDatasource(params);
  }

  @override
  String getAccessTokenImpl() {
    return userRemoteDatasource.getAccessTokenDatasource();
  }

  @override
  Stream<User?> getCurrentUserImpl() {
    return userRemoteDatasource.getCurrentUserDatasource();
  }

  @override
  Future<AppUser?> getSignedInUserImpl() {
    return userRemoteDatasource.getSignedInUserDatasource();
  }

  @override
  Future<bool> signInWithKakaoImpl() {
    return userRemoteDatasource.signInWithKakaoDatasource();
  }

  @override
  Future<void> signOutImpl() {
    return userRemoteDatasource.signOutDatasource();
  }

  @override
  Future<Either<Failure, AppUser>> updateUserImpl(UpdateUserParams params) {
    return userRemoteDatasource.updateUserDatasource(params);
  }
}
