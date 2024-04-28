import 'dart:convert';

import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/shared/entities/form/select_option.dart';
import 'package:pookabu/shared/entities/form/step.dart';

class MultiSelectStep implements Step {
  @override
  String id;
  @override
  String title;
  @override
  String? description;

  List<SelectOption> options;
  int? maxOptionsSelected;
  int? minOptionsSelected;

  @override
  CreateToiletParam? params;

  MultiSelectStep({
    required this.id,
    required this.title,
    required this.options,
    this.description,
    this.params,
    this.maxOptionsSelected,
    this.minOptionsSelected,
  });

  factory MultiSelectStep.fromJson(Map<String, dynamic> json) =>
      MultiSelectStep(
        id: json["id"],
        title: json["title"],
        options: json["options"],
        description: json["description"],
        params: json['params'],
        maxOptionsSelected: json["maxOptionsSelected"],
        minOptionsSelected: json["minOptionsSelected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "options": options,
        "description": description,
        'params': params,
        "maxOptionsSelected": maxOptionsSelected,
        "minOptionsSelected": minOptionsSelected,
      };
}
