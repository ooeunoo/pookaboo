import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/shared/entities/form/step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';

class MapStep implements Step {
  @override
  String id;
  @override
  String title;
  @override
  String? description;

  @override
  CreateToiletParam? params;

  MapStep(
      {required this.id, required this.title, this.description, this.params});

  factory MapStep.fromJson(Map<String, dynamic> json) => MapStep(
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
