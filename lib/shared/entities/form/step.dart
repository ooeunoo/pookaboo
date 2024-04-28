import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';

abstract class Step {
  String get id;
  String get title;
  String? get description;

  CreateToiletParam? get params;
}
