import 'dart:convert';

import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/shared/entities/form/step.dart';

class InformationStep implements Step {
  @override
  String id;
  @override
  String title;
  @override
  String? description;

  @override
  CreateToiletParam? params;

  InformationStep({
    required this.id,
    required this.title,
    this.description,
    this.params,
  });

  factory InformationStep.fromJson(Map<String, dynamic> json) =>
      InformationStep(
        id: json["id"],
        title: json["title"],
        params: json['params'],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        'params': params,
        "description": description,
      };
}
