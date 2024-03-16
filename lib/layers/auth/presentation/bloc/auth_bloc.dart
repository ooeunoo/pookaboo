import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookaboo/layers/auth/domain/entities/update_user_params.dart';
import 'package:pookaboo/layers/auth/domain/usecases/auth_usecase.dart';
import 'package:pookaboo/shared/constant/enum.dart';
import 'package:pookaboo/shared/service/storage/secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorage _secureStorage;
  final AuthUseCase _authUseCase;

  StreamSubscription<User?>? _userSubscription;

  AuthBloc(this._secureStorage, this._authUseCase) : super(InitialState()) {
    on<InitialCheckRequestedEvent>(_onInitialCheckedRequestEvent);
    on<SignInWithKakaoEvent>(_onSignInWithKakaoEvent);
    on<ChangedUserEvent>(_onChangedUserEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<UpdateUserEvent>(_onUpdateUserEvent);

    _startUserSubscription();
  }

  Future<void> _onInitialCheckedRequestEvent(
      InitialCheckRequestedEvent event, Emitter<AuthState> emit) async {
    User? signedInUser = _authUseCase.getSignedInUser();
    signedInUser != null
        ? await _triggerBeforeAuthenticatedState(emit, signedInUser)
        : await _triggerBeforeUnAuthenticatedState(emit);
  }

  Future<void> _onSignInWithKakaoEvent(
      SignInWithKakaoEvent event, Emitter<AuthState> emit) async {
    emit(LoadInProgressState());

    try {
      bool response = await _authUseCase.signInWithKakao();
      User? user = _authUseCase.getSignedInUser();

      if (response && user != null) {
        await _triggerBeforeAuthenticatedState(emit, user);
      }
    } catch (_) {
      await _triggerBeforeUnAuthenticatedState(emit);
    }
  }

  Future<void> _onChangedUserEvent(
      ChangedUserEvent event, Emitter<AuthState> emit) async {
    event.user != null
        ? await _triggerBeforeAuthenticatedState(emit, event.user!)
        : await _triggerBeforeUnAuthenticatedState(emit);
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _authUseCase.signOut();
      await _triggerBeforeUnAuthenticatedState(emit);
    } catch (e) {}
  }

  Future<void> _onUpdateUserEvent(
      UpdateUserEvent event, Emitter<AuthState> emit) async {
    try {
      await _authUseCase.updateUser(event.params).whenComplete(() =>
          _secureStorage.write(
              StorageKeys.isUpdateUserMetadata, UpdateUserMetadataState.done));
    } catch (e) {}
  }

  void _startUserSubscription() => _userSubscription = _authUseCase
      .getCurrentUser()
      .listen((user) => add(ChangedUserEvent(user: user)));

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  Future<void> _triggerBeforeAuthenticatedState(
      Emitter<AuthState> emit, User user) async {
    await _secureStorage
        .write(StorageKeys.isLogin, LoginState.loggedIn.name)
        .whenComplete(() => emit(AuthenticatedState(user: user)));
  }

  Future<void> _triggerBeforeUnAuthenticatedState(
      Emitter<AuthState> emit) async {
    await _secureStorage
        .write(StorageKeys.isLogin, LoginState.notLoggedIn.name)
        .whenComplete(() => emit(UnAuthenticatedState()));
  }
}
