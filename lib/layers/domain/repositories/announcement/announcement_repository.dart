import 'package:dartz/dartz.dart';
import 'package:pookabu/layers/data/models/announcement/announcement.dart';
import 'package:pookabu/layers/data/models/review/review.dart';
import 'package:pookabu/layers/domain/entities/review/create_review_params.dart';
import 'package:pookabu/shared/error/failure.dart';

abstract class AnnouncementRepository {
  Future<Either<Failure, List<Announcement>>> getAnnouncementsImpl();
}
