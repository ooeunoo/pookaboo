import 'package:dartz/dartz.dart';
import 'package:pookabu/layers/data/datasources/toilet_remote_datasource.dart';
import 'package:pookabu/layers/data/models/visitation/visitation.dart';
import 'package:pookabu/layers/domain/entities/visitation/create_visitation_params.dart';
import 'package:pookabu/layers/domain/repositories/visitation/visitation_repository.dart';
import 'package:pookabu/shared/error/failure.dart';

class VisitationRepositoryImpl implements VisitationRepository {
  final ToiletRemoteDatasource toiletRemoteDatasource;

  const VisitationRepositoryImpl(this.toiletRemoteDatasource);

  @override
  Future<Either<Failure, bool>> createToiletVisitationImpl(
      CreateVisitationParams params) async {
    final response =
        await toiletRemoteDatasource.createToiletVisitationDatasource(params);
    return response;
  }

  @override
  Future<Either<Failure, List<Visitation>>> getToiletVisitationsByUserIdImpl(
      String userId) async {
    final response = await toiletRemoteDatasource
        .getToiletVisitationsByUserIdDatasource(userId);
    return response;
  }
}
