import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/shared/entities/form/step.dart';

class PictureStep implements Step {
  @override
  String id;
  @override
  String title;
  @override
  String? description;

  @override
  CreateToiletParam? params;

  PictureStep({
    required this.id,
    required this.title,
    this.description,
    this.params,
  });

  factory PictureStep.fromJson(Map<String, dynamic> json) => PictureStep(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        params: json['params'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        'params': params,
        "description": description,
      };
}
