import 'package:dartz/dartz.dart';
import 'package:pookabu/layers/data/models/announcement/announcement.dart';
import 'package:pookabu/layers/domain/repositories/announcement/announcement_repository.dart';
import 'package:pookabu/shared/error/failure.dart';
import 'package:pookabu/shared/usecase/usecase.dart';

class GetAnnouncementsUseCase extends UseCase<List<Announcement>, Null> {
  final AnnouncementRepository _repo;

  GetAnnouncementsUseCase(this._repo);

  @override
  Future<Either<Failure, List<Announcement>>> call(params) {
    return _repo.getAnnouncementsImpl();
  }
}
