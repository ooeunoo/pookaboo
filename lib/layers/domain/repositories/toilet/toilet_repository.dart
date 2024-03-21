import 'package:dartz/dartz.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookaboo/layers/data/models/coord/coord.dart';
import 'package:pookaboo/layers/data/models/route/route.dart';
import 'package:pookaboo/layers/data/models/toilet/toilet.dart';
import 'package:pookaboo/layers/domain/entities/review/create_review_params.dart';
import 'package:pookaboo/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookaboo/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:pookaboo/layers/domain/entities/toilet/upload_toilet_images_params.dart';
import 'package:pookaboo/shared/error/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
}
