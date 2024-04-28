import 'package:dartz/dartz.dart';
import 'package:pookabu/layers/data/datasources/kakao_remote_datasource.dart';
import 'package:pookabu/layers/data/datasources/toilet_remote_datasource.dart';
import 'package:pookabu/layers/data/models/route/route.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/update_toilet_main_image_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/upload_toilet_images_params.dart';
import 'package:pookabu/layers/domain/repositories/toilet/toilet_repository.dart';
import 'package:pookabu/shared/error/failure.dart';

class ToiletRepositoryImpl implements ToiletRepository {
  final ToiletRemoteDatasource toiletRemoteDatasource;
  final KakaoRemoteDatasource kakaoRemoteDatasource;

  const ToiletRepositoryImpl(
      this.toiletRemoteDatasource, this.kakaoRemoteDatasource);

  @override
  Future<Either<Failure, List<Toilet>>> getNearByToiletsImpl(
      GetNearByToiletsParams params) async {
    return toiletRemoteDatasource.getNearByToiletsDatasource(params);
  }

  @override
  Future<Either<Failure, Toilet>> getToiletByIdImpl(int id) async {
    return toiletRemoteDatasource.getToiletByIdDatasource(id);
  }

  @override
  Future<Either<Failure, GetRouteFormatResponse>> getRoutes(
      GetRouteParams params) async {
    return kakaoRemoteDatasource.getRoutes(params);
  }

  @override
  Future<Either<Failure, bool>> uploadToiletImagesImpl(
      UploadToiletImagesParams params) async {
    return toiletRemoteDatasource.uploadToiletImagesDatasource(params);
  }

  @override
  Future<Either<Failure, bool>> createToiletProposalImpl(
      CreateToiletParam params) async {
    final response =
        await toiletRemoteDatasource.createToiletProposalDatasource(params);
    return response;
  }

  @override
  Future<Either<Failure, List<String>>> getToiletImagesImpl(
      int toiletId) async {
    final response =
        await toiletRemoteDatasource.getToiletImagesDatasource(toiletId);
    return response;
  }

  @override
  Future<Either<Failure, bool>> updateToiletMainImageImpl(
      UpdateToiletMainImageParams params) async {
    final response =
        await toiletRemoteDatasource.updateToiletMainImageDatasource(params);
    return response;
  }
}
