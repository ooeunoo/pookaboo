import 'package:dartz/dartz.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/data/models/coord/coord.dart';
import 'package:pookabu/layers/data/models/route/route.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/data/models/visitation/visitation.dart';
import 'package:pookabu/layers/domain/entities/review/create_review_params.dart';
import 'package:pookabu/layers/domain/entities/visitation/create_visitation_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:pookabu/shared/error/failure.dart';

abstract class VisitationRepository {
  Future<Either<Failure, bool>> createToiletVisitationImpl(
      CreateVisitationParams params);

  Future<Either<Failure, List<Visitation>>> getToiletVisitationsByUserIdImpl(
      String userId);
}
