import 'dart:convert';

import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/entities/form/data_step.dart';
import 'package:pookabu/shared/entities/form/select_option.dart';
import 'package:pookabu/shared/entities/form/step.dart';

class SingleSelectStep implements Step {
  @override
  String id;
  @override
  String title;
  @override
  String? description;

  List<SelectOption> options;

  @override
  CreateToiletParam? params;

  SingleSelectStep({
    required this.id,
    required this.title,
    required this.options,
    this.description,
    this.params,
  });

  factory SingleSelectStep.fromJson(Map<String, dynamic> json) =>
      SingleSelectStep(
        id: json["id"],
        title: json["title"],
        options: json["options"],
        description: json["description"],
        params: json["params"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "options": options,
        "description": description,
        'params': params
      };
}
