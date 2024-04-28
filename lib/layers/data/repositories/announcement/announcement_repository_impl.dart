import 'package:dartz/dartz.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/data/datasources/announcement_remote_datasource.dart';
import 'package:pookabu/layers/data/datasources/kakao_remote_datasource.dart';
import 'package:pookabu/layers/data/datasources/toilet_remote_datasource.dart';
import 'package:pookabu/layers/data/models/announcement/announcement.dart';
import 'package:pookabu/layers/data/models/coord/coord.dart';
import 'package:pookabu/layers/data/models/review/review.dart';
import 'package:pookabu/layers/data/models/route/route.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/domain/entities/review/create_review_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:pookabu/layers/domain/repositories/announcement/announcement_repository.dart';
import 'package:pookabu/layers/domain/repositories/toilet/toilet_repository.dart';
import 'package:pookabu/layers/domain/repositories/review/review_repository.dart';
import 'package:pookabu/shared/error/failure.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDatasource announcementRemoteDatasource;

  const AnnouncementRepositoryImpl(this.announcementRemoteDatasource);

  @override
  Future<Either<Failure, List<Announcement>>> getAnnouncementsImpl() async {
    final response =
        await announcementRemoteDatasource.getAnnouncementsDatasource();
    return response;
  }
}
