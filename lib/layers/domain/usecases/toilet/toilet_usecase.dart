import 'package:dartz/dartz.dart';
import 'package:pookabu/layers/data/models/route/route.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/get_nearby_toilets_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/update_toilet_main_image_params.dart';
import 'package:pookabu/layers/domain/entities/toilet/upload_toilet_images_params.dart';
import 'package:pookabu/layers/domain/repositories/toilet/toilet_repository.dart';
import 'package:pookabu/shared/error/failure.dart';
import 'package:pookabu/shared/usecase/usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

////////////////////////////////////////////////
// Get Routes
////////////////////////////////////////////////
class GetRoutesUseCase extends UseCase<GetRouteFormatResponse, GetRouteParams> {
  final ToiletRepository _repo;

  GetRoutesUseCase(this._repo);

  @override
  Future<Either<Failure, GetRouteFormatResponse>> call(GetRouteParams params) {
    return _repo.getRoutes(params);
  }
}

////////////////////////////////////////////////
// Get Near By Toilet
////////////////////////////////////////////////
class GetNearByToiletsUseCase
    extends UseCase<List<Toilet>, GetNearByToiletsParams> {
  final ToiletRepository _repo;

  GetNearByToiletsUseCase(this._repo);

  @override
  Future<Either<Failure, List<Toilet>>> call(GetNearByToiletsParams params) {
    return _repo.getNearByToiletsImpl(params);
  }
}

////////////////////////////////////////////////
// Get Toilet By Id
////////////////////////////////////////////////
class GetToiletByIdUseCase extends UseCase<Toilet, int> {
  final ToiletRepository _repo;

  GetToiletByIdUseCase(this._repo);

  @override
  Future<Either<Failure, Toilet>> call(int params) {
    return _repo.getToiletByIdImpl(params);
  }
}

////////////////////////////////////////////////
// Upload Toilet Images
////////////////////////////////////////////////
class UploadToiletImagesUseCase
    extends UseCase<bool, UploadToiletImagesParams> {
  final ToiletRepository _repo;

  UploadToiletImagesUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(UploadToiletImagesParams params) {
    return _repo.uploadToiletImagesImpl(params);
  }
}

////////////////////////////////////////////////
// Create Toilet Proposal
////////////////////////////////////////////////
class CreateToiletProposalUseCase extends UseCase<bool, CreateToiletParam> {
  final ToiletRepository _repo;

  CreateToiletProposalUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(CreateToiletParam params) {
    return _repo.createToiletProposalImpl(params);
  }
}

////////////////////////////////////////////////
// Get Toilet Images
////////////////////////////////////////////////
class GetToiletImagesUseCase extends UseCase<List<String>, int> {
  final ToiletRepository _repo;

  GetToiletImagesUseCase(this._repo);

  @override
  Future<Either<Failure, List<String>>> call(int params) {
    return _repo.getToiletImagesImpl(params);
  }
}

////////////////////////////////////////////////
// Update Toilet Main Images
////////////////////////////////////////////////
class UpdateToiletMainImageUseCase
    extends UseCase<bool, UpdateToiletMainImageParams> {
  final ToiletRepository _repo;

  UpdateToiletMainImageUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(UpdateToiletMainImageParams params) {
    return _repo.updateToiletMainImageImpl(params);
  }
}
