import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookabu/layers/data/models/user/app_user.dart';
import 'package:pookabu/layers/domain/entities/user/create_user_inquiry_params.dart';
import 'package:pookabu/layers/domain/entities/user/update_user_params.dart';
import 'package:pookabu/layers/domain/usecases/user/user_usecase.dart';
import 'package:pookabu/shared/service/storage/secure_storage.dart';
import 'package:pookabu/shared/utils/logging/log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final SecureStorage _secureStorage;
  final UserUseCase _authUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final CreateUserInquireUseCase _createUserInquireUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  StreamSubscription<User?>? _userSubscription;

  UserBloc(this._secureStorage, this._authUseCase, this._updateUserUseCase,
      this._createUserInquireUseCase, this._deleteUserUseCase)
      : super(InitialState()) {
    on<CheckRequestedEvent>(_onCheckedRequestEvent);
    on<SignInWithKakaoEvent>(_onSignInWithKakaoEvent);
    on<ChangedUserEvent>(_onChangedUserEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<CreateUserInquiryEvent>(_onCreateUserInquiryEvent);
    on<DeleteUserEvent>(_onDeleteUserEvent);

    _startUserSubscription();
  }

  Future<void> _onCheckedRequestEvent(
      CheckRequestedEvent event, Emitter<UserState> emit) async {
    AppUser? appUser = await _authUseCase.getSignedInUser();
    appUser != null
        ? await _triggerBeforeAuthenticatedState(emit, appUser)
        : await _triggerBeforeUnAuthenticatedState(emit);
  }

  Future<void> _onSignInWithKakaoEvent(
      SignInWithKakaoEvent event, Emitter<UserState> emit) async {
    emit(LoadInProgressState());

    try {
      await _authUseCase.signInWithKakao();
      AppUser? appUser = await _authUseCase.getSignedInUser();
      if (appUser != null) {
        await _triggerBeforeAuthenticatedState(emit, appUser);
      }
    } catch (_) {
      await _triggerBeforeUnAuthenticatedState(emit);
    }
  }

  Future<void> _onChangedUserEvent(
      ChangedUserEvent event, Emitter<UserState> emit) async {
    if (event.user != null) {
      AppUser? appUser = await _authUseCase.getSignedInUser();
      if (appUser != null) {
        await _triggerBeforeAuthenticatedState(emit, appUser);
      }
    } else {
      await _triggerBeforeUnAuthenticatedState(emit);
    }
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<UserState> emit) async {
    try {
      await _authUseCase.signOut();
      await _triggerBeforeUnAuthenticatedState(emit);
    } catch (e) {}
  }

  Future<void> _onDeleteUserEvent(
      DeleteUserEvent event, Emitter<UserState> emit) async {
    try {
      await _deleteUserUseCase
          .call(event.userId)
          .whenComplete(() => _secureStorage.removePersistedSession());
      await _triggerBeforeUnAuthenticatedState(emit);
    } catch (e) {}
  }

  Future<void> _onUpdateUserEvent(
      UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      final response = await _updateUserUseCase.call(event.params);

      await response.fold((l) => null, (r) async {
        await _triggerBeforeAuthenticatedState(emit, r);
      });
    } catch (e) {}
  }

  Future<void> _onCreateUserInquiryEvent(
      CreateUserInquiryEvent event, Emitter<UserState> emit) async {
    try {
      await _createUserInquireUseCase.call(event.params);
    } catch (e) {
      log.e(e);
    }
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
      Emitter<UserState> emit, AppUser user) async {
    await _secureStorage
        .write(StorageKeys.loggedInUser, user.id)
        .whenComplete(() => emit(AuthenticatedState(user: user)));
  }

  Future<void> _triggerBeforeUnAuthenticatedState(
      Emitter<UserState> emit) async {
    await _secureStorage
        .write(StorageKeys.loggedInUser, null)
        .whenComplete(() => emit(UnAuthenticatedState()));
  }
}
