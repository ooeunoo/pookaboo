import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookabu/layers/data/models/review/review.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pookabu/layers/domain/entities/review/create_review_params.dart';
import 'package:pookabu/layers/domain/usecases/review/review_usecase.dart';
import 'package:pookabu/shared/utils/helper/time_helper.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

part 'review_state.dart';
part 'review_event.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  /////////////////////////////////
  /// UseCase
  ////////////////////////////////
  final CreateToiletReviewUseCase _createToiletReviewUseCase;
  final GetToiletReviewsByToiletIdUseCase _getToiletReviewsByToiletIdUseCase;
  final GetToiletReviewsByUserIdUseCase _getToiletReviewsByUserIdUseCase;
  final DeleteToiletReviewsByReviewIdUseCase
      _deleteToiletReviewsByReviewIdUseCase;

  /////////////////////////////////
  /// Event Mapping
  ////////////////////////////////
  ReviewBloc(
      this._createToiletReviewUseCase,
      this._getToiletReviewsByToiletIdUseCase,
      this._getToiletReviewsByUserIdUseCase,
      this._deleteToiletReviewsByReviewIdUseCase)
      : super(InitialState()) {
    on<CreateToiletReviewEvent>(_onCreateToiletReviewEvent);
    on<GetToiletReviewsByUserIdEvent>(_onGetToiletReviewsByUserIdEvent);
    on<GetToiletReviewsByToiletIdEvent>(_onGetToiletReviewsByToiletIdEvent);
    on<DeleteToiletReviewsByReviewIdEvent>(
        _onDeleteToiletReviewsByReviewIdEvent);
  }

  /////////////////////////////////
  /// Property
  ////////////////////////////////

  /////////////////////////////////
  /// [CreateToiletReviewEvent] Event Handler
  ////////////////////////////////
  Future<void> _onCreateToiletReviewEvent(
      CreateToiletReviewEvent event, Emitter<ReviewState> emit) async {
    try {
      final response = await _createToiletReviewUseCase.call(event.params);
      response.fold((l) {}, (r) {
        emit(SuccessCreateToiletReviewState());
      });
    } catch (e) {
      log.e(e);
    }
  }

  /////////////////////////////////
  /// [GetToiletReviewsByToiletIdEvent] Event Handler
  ////////////////////////////////
  Future<void> _onGetToiletReviewsByToiletIdEvent(
      GetToiletReviewsByToiletIdEvent event, Emitter<ReviewState> emit) async {
    try {
      final response =
          await _getToiletReviewsByToiletIdUseCase.call(event.toilet_id);
      response.fold((l) {
        log.e(l);
      }, (r) {
        emit(LoadedToiletReviewsByToiletIdState(reviews: r));
      });
    } catch (e) {}
  }

  /////////////////////////////////
  /// [GetToiletReviewsByUserIdEvent] Event Handler
  ////////////////////////////////
  Future<void> _onGetToiletReviewsByUserIdEvent(
      GetToiletReviewsByUserIdEvent event, Emitter<ReviewState> emit) async {
    try {
      final response =
          await _getToiletReviewsByUserIdUseCase.call(event.user_id);
      response.fold((l) {
        log.e(l);
      }, (r) {
        emit(LoadedToiletReviewsByUserIdState(reviews: r));
      });
    } catch (e) {}
  }

  Future<void> _onDeleteToiletReviewsByReviewIdEvent(
      DeleteToiletReviewsByReviewIdEvent event,
      Emitter<ReviewState> emit) async {
    try {
      final response =
          await _deleteToiletReviewsByReviewIdUseCase.call(event.reviewId);
      response.fold((l) {
        log.e(l);
      }, (r) {
        emit(SuccessDeleteToiletReviewState());
      });
    } catch (e) {}
  }
}
