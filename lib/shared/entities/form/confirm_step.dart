import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/shared/entities/form/step.dart';

class ConfirmStep implements Step {
  @override
  String id;
  @override
  String title;
  @override
  String? description;
  String? image;

  @override
  CreateToiletParam? params;

  ConfirmStep(
      {required this.id,
      required this.title,
      this.description,
      this.image,
      this.params});

  factory ConfirmStep.fromJson(Map<String, dynamic> json) => ConfirmStep(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        params: json['params'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        'image': image,
        'params': params,
      };
}
