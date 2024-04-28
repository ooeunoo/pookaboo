import 'dart:convert';

import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/shared/entities/form/data_option.dart';
import 'package:pookabu/shared/entities/form/data_step.dart';
import 'package:pookabu/shared/entities/form/select_option.dart';
import 'package:pookabu/shared/entities/form/step.dart';
import 'package:pookabu/shared/constant/enum.dart';

class MultiTimeDataStep implements Step {
  @override
  String id;
  @override
  String title;
  @override
  String? description;
  InputTimeDataType type;
  String? dateFormat;

  List<DataOption> options;

  @override
  CreateToiletParam? params;

  MultiTimeDataStep({
    required this.id,
    required this.title,
    this.description,
    required this.options,
    required this.type,
    this.dateFormat,
    this.params,
  });

  factory MultiTimeDataStep.fromJson(Map<String, dynamic> json) =>
      MultiTimeDataStep(
        id: json["id"],
        title: json["title"],
        options: json["options"],
        description: json["description"],
        type: json["type"],
        params: json['params'],
        dateFormat: json["dateFormat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "options": options,
        "description": description,
        "type": type,
        'params': params,
        "dateFormat": dateFormat
      };
}
