import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/shared/entities/form/data_option.dart';
import 'package:pookabu/shared/entities/form/step.dart';
import 'package:pookabu/shared/constant/enum.dart';

class EquipmentDataStep implements Step {
  @override
  String id;
  @override
  String title;
  @override
  String? description;
  InputDataType type;
  bool? isGenderSeperate;

  List<DataOption> options;

  @override
  CreateToiletParam? params;

  EquipmentDataStep(
      {required this.id,
      required this.title,
      this.description,
      required this.options,
      required this.type,
      this.params,
      this.isGenderSeperate});

  factory EquipmentDataStep.fromJson(Map<String, dynamic> json) =>
      EquipmentDataStep(
          id: json["id"],
          title: json["title"],
          options: json["options"],
          description: json["description"],
          type: json["type"],
          params: json['params'],
          isGenderSeperate: json['isGenderSeperate']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "options": options,
        "description": description,
        "type": type,
        'params': params,
        'isGenderSeperate': isGenderSeperate
      };
}
