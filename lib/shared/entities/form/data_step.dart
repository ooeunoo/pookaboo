import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/shared/entities/form/step.dart';
import 'package:pookabu/shared/constant/enum.dart';

class DataStep implements Step {
  @override
  String id;
  @override
  String title;
  @override
  String? description;
  InputDataType type;
  String? dateFormat;

  @override
  CreateToiletParam? params;

  DataStep(
      {required this.id,
      required this.title,
      this.description,
      required this.type,
      this.dateFormat,
      this.params});

  factory DataStep.fromJson(Map<String, dynamic> json) => DataStep(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      type: json['type'],
      params: json['params'],
      dateFormat: json['dateFormat']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "type": type,
        'params': params,
        "dateFormat": dateFormat
      };
}
