import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pookabu/shared/service/storage/secure_storage.dart';

part 'setting_state.dart';
part 'setting_cubit.freezed.dart';

class SettingsCubit extends Cubit<SettingState> {
  final SecureStorage secureStorage;

  SettingsCubit(this.secureStorage) : super(SettingState(type: "ko"));

  Future<void> updateTheme(ActiveTheme activeTheme) async {
    await secureStorage.write(StorageKeys.theme, activeTheme.name);

    final locale = await secureStorage.get(StorageKeys.locale);
    emit(
      SettingState(
        activeTheme: activeTheme,
        type: locale ?? "ko",
      ),
    );
  }

  Future<void> updateLanguage(String type) async {
    /// Update locale code
    await secureStorage.write(StorageKeys.locale, type);

    final ActiveTheme activeTheme = await getActiveTheme();
    emit(SettingState(type: type, activeTheme: activeTheme));
  }

  Future<ActiveTheme> getActiveTheme() async {
    final theme = await secureStorage.get(StorageKeys.theme);
    final locale = await secureStorage.get(StorageKeys.locale);

    final activeTheme = ActiveTheme.values.singleWhere(
      (element) => element.name == (theme ?? ActiveTheme.system.name),
    );

    emit(
      SettingState(
        activeTheme: activeTheme,
        type: locale ?? "ko",
      ),
    );
    return activeTheme;
  }
}
