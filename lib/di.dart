import 'package:get_it/get_it.dart';
import 'package:pookaboo/layers/app/presentation/cubit/navigation_cubit.dart';
import 'package:pookaboo/layers/setting/presentation/cubit/setting_cubit.dart';
import 'package:pookaboo/shared/services/hive/main_box.dart';

GetIt sl = GetIt.instance;

Future<void> serviceLocator({
  bool isUnitTest = false,
  bool isHiveEnable = true,
  String prefixBox = '',
}) async {
  /// For unit testing only
  if (isUnitTest) {
    await sl.reset();
  }
  // sl.registerSingleton<DioClient>(DioClient(isUnitTest: isUnitTest));
  _dataSources();
  _repositories();
  _bloc();
  _useCase();
  _cubit();
  if (isHiveEnable) {
    await _initHiveBoxes(
      isUnitTest: isUnitTest,
      prefixBox: prefixBox,
    );
  }
}

Future<void> _initHiveBoxes({
  bool isUnitTest = false,
  String prefixBox = '',
}) async {
  await MainBoxMixin.initHive(prefixBox);
  sl.registerSingleton<MainBoxMixin>(MainBoxMixin());
}

/// Register repositories
void _repositories() {
  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(sl(), sl()),
  // );
  // sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(sl()));
}

/// Register dataSources
void _dataSources() {
  // sl.registerLazySingleton<AuthRemoteDatasource>(
  //   () => AuthRemoteDatasourceImpl(sl()),
  // );
  // sl.registerLazySingleton<UsersRemoteDatasource>(
  //   () => UsersRemoteDatasourceImpl(sl()),
  // );
}

void _useCase() {
  /// Auth
  // sl.registerLazySingleton(() => PostLogin(sl()));
  // sl.registerLazySingleton(() => PostRegister(sl()));

  // /// Users
  // sl.registerLazySingleton(() => GetUsers(sl()));
}

void _bloc() {}

void _cubit() {
  // /// Auth
  // sl.registerFactory(() => RegisterCubit(sl()));
  // sl.registerFactory(() => AuthCubit(sl()));

  // /// Users
  sl.registerFactory(() => NavigationCubit());
  sl.registerFactory(() => SettingsCubit());
  // sl.registerFactory(() => MainCubit());
}