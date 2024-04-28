import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pookabu/shared/utils/logging/log.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ActiveTheme {
  light(ThemeMode.light),
  dark(ThemeMode.dark),
  system(ThemeMode.system);

  final ThemeMode mode;

  const ActiveTheme(this.mode);
}

enum StorageKeys {
  token,
  language,
  theme,
  locale,
  loggedInUser,
  initProfile,
  ;
}

class SecureStorage extends LocalStorage {
  final storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() async {
    return storage.read(key: supabasePersistSessionKey);
  }

  @override
  Future<bool> hasAccessToken() async {
    return storage.containsKey(key: supabasePersistSessionKey);
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    return storage.write(
        key: supabasePersistSessionKey, value: persistSessionString);
  }

  @override
  Future<void> removePersistedSession() async {
    return storage.delete(key: supabasePersistSessionKey);
  }

  Future<void> write<T>(StorageKeys key, dynamic value) async {
    await storage.write(key: key.name, value: value.toString());
  }

  Future<void> delete(StorageKeys key) async {
    await storage.delete(key: key.name);
  }

  Future<String?> get(StorageKeys key) async {
    String? r = await storage.read(key: key.name);
    return _convertNull(r ?? "null");
  }

  String? _convertNull(String r) {
    return r == "null" ? null : r;
  }
}
