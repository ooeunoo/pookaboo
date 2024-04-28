import 'package:get_it/get_it.dart';
import 'package:pookabu/layers/data/datasources/announcement_remote_datasource.dart';
import 'package:pookabu/layers/data/datasources/user_remote_datasource.dart';
import 'package:pookabu/layers/data/repositories/announcement/announcement_repository_impl.dart';
import 'package:pookabu/layers/domain/repositories/announcement/announcement_repository.dart';
import 'package:pookabu/layers/domain/usecases/announcement/announcement_usecase.dart';
import 'package:pookabu/layers/presentation/bloc/announcement/announcement_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/toilet/toilet_bloc.dart';
import 'package:pookabu/layers/presentation/cubit/app/app_cubit.dart';
import 'package:pookabu/layers/data/repositories/user/user_repository_impl.dart';
import 'package:pookabu/layers/domain/repositories/user/user_repository.dart';
import 'package:pookabu/layers/domain/usecases/user/user_usecase.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/layers/data/datasources/kakao_remote_datasource.dart';
import 'package:pookabu/layers/data/datasources/toilet_remote_datasource.dart';
import 'package:pookabu/layers/data/repositories/toilet/toilet_repository_impl.dart';
import 'package:pookabu/layers/data/repositories/review/review_repository_impl.dart';
import 'package:pookabu/layers/data/repositories/visitation/visitation_repository_impl.dart';
import 'package:pookabu/layers/domain/repositories/toilet/toilet_repository.dart';
import 'package:pookabu/layers/domain/repositories/review/review_repository.dart';
import 'package:pookabu/layers/domain/repositories/visitation/visitation_repository.dart';
import 'package:pookabu/layers/domain/usecases/review/review_usecase.dart';
import 'package:pookabu/layers/domain/usecases/toilet/toilet_usecase.dart';
import 'package:pookabu/layers/domain/usecases/visitation/visitation_usecase.dart';
import 'package:pookabu/layers/presentation/bloc/map/map_bloc.dart';
import 'package:pookabu/layers/presentation/cubit/settings/setting_cubit.dart';
import 'package:pookabu/layers/presentation/bloc/review/review_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/visitation/visitation_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/profile/profile_bloc.dart';
import 'package:pookabu/shared/service/geolocator/geolocator_service.dart';
import 'package:pookabu/shared/service/kakao/kakao_map_service.dart';
import 'package:pookabu/shared/service/kakao/kakao_service.dart';
import 'package:pookabu/shared/service/storage/secure_storage.dart';
import 'package:pookabu/shared/service/supabase/supabase_service.dart';

GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  await _initAppLocalStorages();

  await _service();
  await _dataSources();
  await _repositories();
  await _useCase();
  await _cubit();
  await _bloc();
}

Future<void> _initAppLocalStorages() async {
  sl.registerSingleton<SecureStorage>(SecureStorage());
}

Future<void> _repositories() async {
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ToiletRepository>(
      () => ToiletRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl(sl()));
  sl.registerLazySingleton<VisitationRepository>(
      () => VisitationRepositoryImpl(sl()));
  sl.registerLazySingleton<AnnouncementRepository>(
      () => AnnouncementRepositoryImpl(sl()));
}

Future<void> _dataSources() async {
  sl.registerLazySingleton<ToiletRemoteDatasource>(
      () => ToiletRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<UserRemoteDatasource>(
      () => UserRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<AnnouncementRemoteDatasource>(
      () => AnnouncementRemoteDatasourceImpl(sl()));
  sl.registerLazySingleton<KakaoRemoteDatasource>(
      () => KakaoRemoteDatasourceImpl());
}

Future<void> _useCase() async {
  // auth
  sl.registerLazySingleton<UserUseCase>(() => UserUseCase(sl()));
  sl.registerLazySingleton<UpdateUserUseCase>(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton<CreateUserInquireUseCase>(
      () => CreateUserInquireUseCase(sl()));
  sl.registerLazySingleton<DeleteUserUseCase>(() => DeleteUserUseCase(sl()));

  // map
  sl.registerLazySingleton<GetNearByToiletsUseCase>(
      () => GetNearByToiletsUseCase(sl()));
  sl.registerLazySingleton<GetToiletByIdUseCase>(
      () => GetToiletByIdUseCase(sl()));
  sl.registerLazySingleton<GetRoutesUseCase>(() => GetRoutesUseCase(sl()));

  // review
  sl.registerLazySingleton<CreateToiletReviewUseCase>(
      () => CreateToiletReviewUseCase(sl()));
  sl.registerLazySingleton<GetToiletReviewsByToiletIdUseCase>(
      () => GetToiletReviewsByToiletIdUseCase(sl()));
  sl.registerLazySingleton<GetToiletReviewsByUserIdUseCase>(
      () => GetToiletReviewsByUserIdUseCase(sl()));
  sl.registerLazySingleton<DeleteToiletReviewsByReviewIdUseCase>(
      () => DeleteToiletReviewsByReviewIdUseCase(sl()));

  // visitation
  sl.registerLazySingleton<CreateToiletVisitationUseCase>(
      () => CreateToiletVisitationUseCase(sl()));
  sl.registerLazySingleton<GetToiletVisitationsByUserIdUseCase>(
      () => GetToiletVisitationsByUserIdUseCase(sl()));

  sl.registerLazySingleton<GetAnnouncementsUseCase>(
      () => GetAnnouncementsUseCase(sl()));

  // Toilet
  sl.registerLazySingleton<CreateToiletProposalUseCase>(
      () => CreateToiletProposalUseCase(sl()));
  sl.registerLazySingleton<UploadToiletImagesUseCase>(
      () => UploadToiletImagesUseCase(sl()));
  sl.registerLazySingleton<GetToiletImagesUseCase>(
      () => GetToiletImagesUseCase(sl()));
  sl.registerLazySingleton<UpdateToiletMainImageUseCase>(
      () => UpdateToiletMainImageUseCase(sl()));
}

Future<void> _bloc() async {
  sl.registerFactory(() => UserBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => MapBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => ReviewBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => VisitataionBloc(sl(), sl()));
  sl.registerFactory(() => ProfileBloc());
  sl.registerFactory(() => ToiletBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => AnnouncementBloc(sl()));
}

Future<void> _cubit() async {
  sl.registerFactory(() => AppCubit());
  sl.registerFactory(() => SettingsCubit(sl()));
}

Future<void> _service() async {
  // Supabase
  await SupabaseService.init(sl());
  sl.registerSingleton<SupabaseService>(SupabaseService());

  // Kakao
  await KakaoService.init();
  sl.registerSingleton<KakaoService>(KakaoService());

  // Kakao Map
  await KakaoMapService.init();
  sl.registerSingleton<KakaoMapService>(KakaoMapService());

  // Geolocator
  sl.registerSingleton<GeolocatorService>(GeolocatorService());
}
