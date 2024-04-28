import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookabu/layers/data/models/announcement/announcement.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pookabu/layers/domain/usecases/announcement/announcement_usecase.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

part 'announcement_state.dart';
part 'announcement_event.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  /////////////////////////////////
  /// UseCase
  ////////////////////////////////
  final GetAnnouncementsUseCase _getAnnouncementsUseCase;

  /////////////////////////////////
  /// Event Mapping
  ////////////////////////////////
  AnnouncementBloc(
    this._getAnnouncementsUseCase,
  ) : super(InitialState()) {
    on<GetAnnouncementsEvent>(_onGetAnnouncementsEvent);
  }

  /////////////////////////////////
  /// Property
  ////////////////////////////////

  /////////////////////////////////
  /// [CreateToiletVisitationEvent] Event Handler
  ////////////////////////////////
  Future<void> _onGetAnnouncementsEvent(
      GetAnnouncementsEvent event, Emitter<AnnouncementState> emit) async {
    try {
      final response = await _getAnnouncementsUseCase.call(null);
      response.fold((l) {
        log.e(l);
      }, (r) {
        emit(LoadedAnnouncementsState(announcements: r));
      });
    } catch (e) {}
  }
}
