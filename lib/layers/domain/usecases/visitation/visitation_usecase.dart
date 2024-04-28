import 'package:dartz/dartz.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/data/models/visitation/visitation.dart';
import 'package:pookabu/layers/domain/entities/review/create_review_params.dart';
import 'package:pookabu/layers/domain/entities/visitation/create_visitation_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:pookabu/layers/domain/repositories/toilet/toilet_repository.dart';
import 'package:pookabu/layers/domain/repositories/review/review_repository.dart';
import 'package:pookabu/layers/domain/repositories/visitation/visitation_repository.dart';
import 'package:pookabu/shared/error/failure.dart';
import 'package:pookabu/shared/usecase/usecase.dart';

class CreateToiletVisitationUseCase
    extends UseCase<bool, CreateVisitationParams> {
  final VisitationRepository _repo;

  CreateToiletVisitationUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(CreateVisitationParams params) {
    return _repo.createToiletVisitationImpl(params);
  }
}

class GetToiletVisitationsByUserIdUseCase
    extends UseCase<List<Visitation>, String> {
  final VisitationRepository _repo;

  GetToiletVisitationsByUserIdUseCase(this._repo);

  @override
  Future<Either<Failure, List<Visitation>>> call(String params) {
    return _repo.getToiletVisitationsByUserIdImpl(params);
  }
}
