import 'package:dartz/dartz.dart';
import 'package:pookabu/layers/data/models/coord/coord.dart';
import 'package:pookabu/layers/data/models/route/route.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/update_toilet_main_image_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/upload_toilet_images_params.dart';
import 'package:pookabu/shared/error/failure.dart';

abstract class ToiletRepository {
  Future<Either<Failure, List<Toilet>>> getNearByToiletsImpl(
      GetNearByToiletsParams params);

  Future<Either<Failure, Toilet>> getToiletByIdImpl(int id);

  Future<Either<Failure, GetRouteFormatResponse>> getRoutes(
      GetRouteParams params);

  Future<Either<Failure, bool>> createToiletProposalImpl(
      CreateToiletParam params);

  Future<Either<Failure, List<String>>> getToiletImagesImpl(int toiletId);

  Future<Either<Failure, bool>> uploadToiletImagesImpl(
      UploadToiletImagesParams params);

  Future<Either<Failure, bool>> updateToiletMainImageImpl(
      UpdateToiletMainImageParams params);
}
