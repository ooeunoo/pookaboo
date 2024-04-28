import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/domain/entities/toilet/create_toilet_params.dart';
import 'package:pookabu/layers/presentation/bloc/toilet/toilet_bloc.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/entities/form/confirm_step.dart';
import 'package:pookabu/shared/entities/form/data_option.dart';
import 'package:pookabu/shared/entities/form/data_step.dart';
import 'package:pookabu/shared/entities/form/information_step.dart';
import 'package:pookabu/shared/entities/form/map_step.dart';
import 'package:pookabu/shared/entities/form/multi_data_step.dart';
import 'package:pookabu/shared/entities/form/multi_select_step.dart';
import 'package:pookabu/shared/entities/form/multi_time_data_step.dart';
import 'package:pookabu/shared/entities/form/picutre_step.dart';
import 'package:pookabu/shared/entities/form/select_option.dart';
import 'package:pookabu/shared/entities/form/single_select_step.dart';
import 'package:pookabu/shared/entities/form/step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/router/app_routes.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';
import 'package:pookabu/shared/widgets/form/app_confirm_form.dart';
import 'package:pookabu/shared/widgets/form/app_data_form.dart';
import 'package:pookabu/shared/widgets/form/app_information_form.dart';
import 'package:pookabu/shared/widgets/form/app_map_form.dart';
import 'package:pookabu/shared/widgets/form/app_equipment_data_form.dart';
import 'package:pookabu/shared/widgets/form/app_multi_select_form.dart';
import 'package:pookabu/shared/widgets/form/app_multi_time_data_form.dart';
import 'package:pookabu/shared/widgets/form/app_picture_form.dart';
import 'package:pookabu/shared/widgets/form/app_single_select_form.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

class ToiletProposal extends StatefulWidget {
  final String userId;

  const ToiletProposal({
    super.key,
    required this.userId,
  });

  @override
  State<ToiletProposal> createState() => _SurveyFlowState();
}

class _SurveyFlowState extends State<ToiletProposal> {
  final PageController _controller = PageController();
  CreateToiletParam params = CreateToiletParam.getEmpty();

  @override
  void initState() {
    super.initState();
  }

  void _onSave() {
    context.read<ToiletBloc>().add(CreateToiletProposalEvent(
        params: params.copyWith(user_id: widget.userId)));

    context.go(AppRoutes.profile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Stack(children: [
          PageView.builder(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (BuildContext context, int index) {
              return _mapStep(context, steps[index]);
            },
          ),
        ]);
      },
    );
  }

  Widget _mapStep(BuildContext context, Step step) {
    switch (step.runtimeType) {
      case const (InformationStep):
        return AppInformationForm(
          step: step as InformationStep,
          onNextPress: _onPressNextButton,
        );
      case const (SingleSelectStep):
        return AppSingleSelectForm(
          step: step as SingleSelectStep,
          onNextPress: _onPressNextButton,
          onBackPress: _onPressBackButton,
        );
      case const (DataStep):
        return AppDataForm(
          step: step as DataStep,
          onNextPress: _onPressNextButton,
          onBackPress: _onPressBackButton,
        );
      case const (MultiSelectStep):
        return AppMultiSelectForm(
            step: step as MultiSelectStep,
            onNextPress: _onPressNextButton,
            onBackPress: _onPressBackButton);
      case const (EquipmentDataStep):
        bool isSeperateGender = false;
        if (params.gender == true) {
          isSeperateGender = true;
        }
        return AppEquipmentDataForm(
            step: step as EquipmentDataStep,
            isSeperateGender: isSeperateGender,
            onNextPress: _onPressNextButton,
            onBackPress: _onPressBackButton);
      case const (MultiTimeDataStep):
        return AppMultiTimeDataForm(
            step: step as MultiTimeDataStep,
            onNextPress: _onPressNextButton,
            onBackPress: _onPressBackButton);
      case const (MapStep):
        return AppMapForm(
            step: step as MapStep,
            onNextPress: _onPressNextButton,
            onBackPress: _onPressBackButton);
      case const (PictureStep):
        return AppPictureForm(
            step: step as PictureStep,
            onNextPress: _onPressNextButton,
            onBackPress: _onPressBackButton);
      case const (ConfirmStep):
        return AppConfirmForm(
          step: step as ConfirmStep,
          onNextPress: _onPressNextButton,
        );
      default:
        return Container();
    }
  }

  void _onPressNextButton(StepResult? result) {
    if (result != null) {
      setState(() {
        params = _updateParamsWithKey(params, result);
      });
    }

    if (_controller.page?.toInt() == steps.length - 1) {
      _onSave();
    }

    // 다음 페이지 이동
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _onPressBackButton() {
    if (_controller.page?.toInt() == 0) {
      return;
    }

    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  CreateToiletParam _updateParamsWithKey(
      CreateToiletParam params, StepResult result) {
    String key = result.stepId;

    dynamic value = result.value;
    switch (key) {
      case 'name':
        return params.copyWith(name: value as String);
      case 'type':
        return params.copyWith(type: value as int);
      case 'gender':
        return params.copyWith(gender: value as bool);
      case 'password':
        return params.copyWith(password: value as bool);
      case 'password_tip':
        return params.copyWith(password_tip: value as String);
      case 'address':
        return params.copyWith(address: value as String);
      case 'road_address':
        return params.copyWith(road_address: value as String);
      case 'location_tip':
        return params.copyWith(location_tip: value as String);
      case 'city':
        return params.copyWith(city: value as String);
      case 'coordinates':
        return params.copyWith(
            coordinates: "POINT(${value.longitude} ${value.latitude})");
      case 'convenience':
        if (value.contains('paper')) {
          return params.copyWith(paper: true);
        }
        if (value.contains('towel')) {
          return params.copyWith(towel: true);
        }
        if (value.contains('soap')) {
          return params.copyWith(soap: true);
        }
        if (value.contains('powder_room')) {
          return params.copyWith(powder_room: true);
        }
        if (value.contains('hand_dry')) {
          return params.copyWith(hand_dry: true);
        }
        if (value.contains('vending')) {
          return params.copyWith(vending: true);
        }
        if (value.contains('diaper')) {
          return params.copyWith(diaper: true);
        }
        if (value.contains('bell')) {
          return params.copyWith(bell: true);
        }
      case 'time':
        return params.copyWith(
          mon: OperateTime(
              open: value['mon']['open'], close: value['mon']['close']),
          tue: OperateTime(
              open: value['tue']['open'], close: value['tue']['close']),
          wed: OperateTime(
              open: value['wed']['open'], close: value['wed']['close']),
          thu: OperateTime(
              open: value['thu']['open'], close: value['thu']['close']),
          fri: OperateTime(
              open: value['fri']['open'], close: value['fri']['close']),
          sat: OperateTime(
              open: value['sat']['open'], close: value['sat']['close']),
          sun: OperateTime(
              open: value['sun']['open'], close: value['sun']['close']),
        );
      case 'equipment':
        return params.copyWith(
          urinal: value["urinal"],
          child_urinal: value["child_urinal"],
          disable_urinal: value["disable_urinal"],
          seat: value["seat"],
          child_seat: value["child_seat"],
          disable_seat: value["disable_seat"],
          washbasin: value["washbasin"],
        );
      case 'images':
        return params.copyWith(images: value);
      case 'map':
        LatLng loc = value;
        return params.copyWith(
            coordinates: 'POINT(${loc.longitude} ${loc.latitude})');
      default:
        return params;
    }

    return params;
  }
}

List<Step> get steps => [
      InformationStep(
          id: 'Intro',
          title: '새로운 화장실 등록해볼까요?',
          description: '먼저 화장실의 위치가 어디인지 알려주세요!'),
      //////////////
      MapStep(
        id: 'coordinates',
        title: '',
      ),
      ////////////////////
      DataStep(
          id: 'name',
          title: '화장실 이름을 알려주세요',
          description: "등록된 이름은 다른 사용자에게도 동일하게 표시돼요.",
          type: InputDataType.text),
      ////////////////////
      SingleSelectStep(
          id: 'type',
          title: '화장실이 어떤 곳에 있나요?',
          description: "",
          options: [
            SelectOption(text: '빌딩', value: 0),
            SelectOption(text: '카페', value: 1),
          ]),
      //////////////////
      SingleSelectStep(
        id: 'password',
        title: '🔒 잠금이 걸려있나요?',
        description: "",
        options: [
          SelectOption(text: '잠김', value: true),
          SelectOption(text: '안잠김', value: false),
        ],
        // expandCondition: SelectOption(text: '잠김', value: true),
        // expandId: 'password_tip',
        // expandType: InputDataType.text,
      ),
      //////////////////
      // DataStep(
      //     id: 'password_tip',
      //     title: '화장실이 잠금되어있다면 열 수있는 방법이 있나요?',
      //     description: "예를 들어, 스타벅스 카운터에 문의, 빌딩 관리자에게 요청",
      //     type: InputDataType.text),
      ////////////////////
      SingleSelectStep(
          id: 'gender',
          title: '👫 화장실은 남녀가 분리되어있나요?',
          description: "",
          options: [
            SelectOption(text: '공용', value: false),
            SelectOption(text: '남녀분리', value: true),
          ]),
      ///////////////////////
      MultiSelectStep(
          id: 'convenience',
          title: '화장실에 있는 편의시설을 알려주세요!',
          description: "",
          options: [
            ...ConvenienceKey.values.map((value) {
              return SelectOption(
                  text: '${value.emoji} ${value.name}', value: value.key);
            }),
            ...AmenityKey.values.map((value) {
              return SelectOption(
                  text: '${value.emoji} ${value.name}', value: value.key);
            })
          ]),
      //////////////////
      EquipmentDataStep(
          id: 'equipment',
          title: '화장실에 있는 시설 개수를 알려주세요!',
          description: "",
          type: InputDataType.numberInt,
          options: [
            ...EquipmentKey.values.expand((value) {
              List<DataOption> options = [];
              for (var (key, label) in value.keys) {
                options.add(DataOption(id: key, label: label));
              }
              return options;
            })
          ]),
      ////////////////////
      MultiTimeDataStep(
        id: 'time',
        title: '화장실의 운영시간을 알려주세요!',
        description: "",
        type: InputTimeDataType.time,
        dateFormat: "HH:mm",
        options: [
          ...WeekKey.values.map((value) {
            return DataOption(id: value.key, label: value.ko);
          })
        ],
      ),
      ////////////////////
      PictureStep(id: 'images', title: '화장실 이미지를 올려주세요'),
      ////////////////////
      ConfirmStep(
          id: 'confirm',
          title: '등록이 완료되었습니다!',
          description: '빠른 시일 내에 검토 후 등록 완료됩니다.',
          image: '')
    ];

void _passToNextPage(PageController controller, int curIndex) {
  controller.animateToPage(curIndex + 1,
      duration: const Duration(milliseconds: 300), curve: Curves.ease);
}

void _passToPrevPage(PageController controller, int curIndex) {
  controller.animateToPage(curIndex - 1,
      duration: const Duration(milliseconds: 300), curve: Curves.ease);
}
