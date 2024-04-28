import 'package:dartz/dartz.dart';
import 'package:pookabu/layers/data/models/announcement/announcement.dart';
import 'package:pookabu/shared/error/failure.dart';
import 'package:pookabu/shared/service/supabase/supabase_service.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

enum AnnouncementTable {
  announcement('announcement'),
  ;

  const AnnouncementTable(this.name);

  final String name;
}

abstract class AnnouncementRemoteDatasource {
  Future<Either<Failure, List<Announcement>>> getAnnouncementsDatasource();
}

class AnnouncementRemoteDatasourceImpl implements AnnouncementRemoteDatasource {
  final SupabaseService _supabaseService;

  AnnouncementRemoteDatasourceImpl(this._supabaseService);

  @override
  Future<Either<Failure, List<Announcement>>>
      getAnnouncementsDatasource() async {
    try {
      final data = await _supabaseService.client
          .from('announcement')
          .select('*')
          .order('created_at', ascending: true);

      log.d(data);
      final List<Announcement> announcements =
          data.map((json) => Announcement.fromJson(json)).toList();

      return Right(announcements);
    } catch (e) {
      log.e(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
