import 'package:pookaboo/layers/auth/domain/entities/update_user_params.dart';
import 'package:pookaboo/shared/constant/enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<bool> signInWithKakao();
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<void> signUpWithEmailAndPassword(
      {required String email, required String password});
  Future<void> signOut();
  Stream<User?> getCurrentUser();
  Future<User?> updateUser(UpdateUserParams params);
  User? getSignedInUser();
  String getAccessToken();
}
