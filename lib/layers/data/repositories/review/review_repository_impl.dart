import 'package:dartz/dartz.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/data/datasources/kakao_remote_datasource.dart';
import 'package:pookabu/layers/data/datasources/toilet_remote_datasource.dart';
import 'package:pookabu/layers/data/models/coord/coord.dart';
import 'package:pookabu/layers/data/models/review/review.dart';
import 'package:pookabu/layers/data/models/route/route.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/domain/entities/review/create_review_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:pookabu/layers/domain/repositories/toilet/toilet_repository.dart';
import 'package:pookabu/layers/domain/repositories/review/review_repository.dart';
import 'package:pookabu/shared/error/failure.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ToiletRemoteDatasource toiletRemoteDatasource;

  const ReviewRepositoryImpl(this.toiletRemoteDatasource);

  @override
  Future<Either<Failure, bool>> createToiletReviewImpl(
      CreateReviewParams params) async {
    final response =
        await toiletRemoteDatasource.createToiletReviewDatasource(params);
    return response;
  }

  @override
  Future<Either<Failure, List<Review>>> getToiletReviewsByToiletIdImpl(
      int toiletId) async {
    final response = await toiletRemoteDatasource
        .getToiletReviewsByToiletIdDatasource(toiletId);
    return response;
  }

  @override
  Future<Either<Failure, List<Review>>> getToiletReviewsByUserIdImpl(
      String userId) async {
    final response =
        await toiletRemoteDatasource.getToiletReviewsByUserIdDatasource(userId);
    return response;
  }

  @override
  Future<Either<Failure, bool>> deleteToiletReviewsByReviewIdImpl(
      int reviewId) async {
    final response = await toiletRemoteDatasource
        .deleteToiletReviewsByReviewIdDatasource(reviewId);
    return response;
  }
}
