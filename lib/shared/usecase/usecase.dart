import 'package:dartz/dartz.dart';
import 'package:pookabu/shared/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class NoFailureUseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Class to handle when useCase don't need params
class NoParams {}
