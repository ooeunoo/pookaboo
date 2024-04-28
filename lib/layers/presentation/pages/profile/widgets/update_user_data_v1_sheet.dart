import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pookabu/layers/data/models/user/app_user.dart';
import 'package:pookabu/layers/domain/entities/user/update_user_params.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/shared/entities/form/select_option.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/utils/helper/validate_helper.dart';
import 'package:pookabu/shared/utils/logging/log.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';
import 'package:pookabu/shared/widgets/common/app_dropdown.dart';
import 'package:pookabu/shared/widgets/common/app_snak_bar.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';
import 'package:pookabu/shared/widgets/common/app_text_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookabu/shared/widgets/form/material/select_option_card.dart';

enum UpdateStep {
  nickname,
  age,
  gender,
}

class UpdateUserDataV1Sheet extends StatefulWidget {
  const UpdateUserDataV1Sheet({super.key});

  @override
  State<UpdateUserDataV1Sheet> createState() => _UpdateUserDataV1SheetState();
}

class _UpdateUserDataV1SheetState extends State<UpdateUserDataV1Sheet> {
  UpdateStep step = UpdateStep.nickname;

  final _nicknameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController(text: Gender.male.ko);

  final _nicknameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _genderFocusNode = FocusNode();

  late bool _isValidNickname = false;
  late bool _isValidAge = false;

  String? _nickname;
  String? _age;
  int? _gender;

  @override
  void initState() {
    _nicknameFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _nicknameFocusNode.dispose();
    _ageController.dispose();
    _ageFocusNode.dispose();
    _genderController.dispose();
    _genderFocusNode.dispose();
    super.dispose();
  }

  void _nextStep() {
    setState(() {
      if (step == UpdateStep.nickname) {
        _nickname = _nicknameController.text;
        step = UpdateStep.age;
        _ageFocusNode.requestFocus();
      } else if (step == UpdateStep.age) {
        _age = _ageController.text;
        step = UpdateStep.gender;
      } else if (step == UpdateStep.gender) {
        _gender = _genderController.text == Gender.male.ko ? 0 : 1;

        _updateUserMetadata();
      }
    });
  }

  Future<void> _updateUserMetadata() async {
    UserState state = context.read<UserBloc>().state;
    if (state is AuthenticatedState) {
      UpdateUserParams params = UpdateUserParams(
        user_id: state.user.id,
        nickname: _nickname!,
        age: _age!.toString(),
        gender: _gender,
        version: UserVersion.profileupdated.index,
      );

      context.read<UserBloc>().add(UpdateUserEvent(params: params));
      NotifyAfterEditProfileSnackBar(context);
      NotifyGuideProfileEditSnackBar(context);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimens.space36, horizontal: Dimens.space20),
        child: Column(
          children: [
            if (step == UpdateStep.nickname) ...{_stepNickname()},
            if (step == UpdateStep.age) ...{_stepAge()},
            if (step == UpdateStep.gender) ...{_stepGender()},
          ],
        ));
  }

  Widget _stepNickname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('프로필 명을 수정해주세요.',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith()),
        const AppSpacerV(),
        AppText("솔직한 의견을 남기기에 실명이 부담스럽다면 재밌는 프로필명으로 바꿔 보세요.",
            style: Theme.of(context).textTheme.labelLarge!),
        AppTextInput(
            key: const Key('nickname'),
            hintText: '프로필 명',
            controller: _nicknameController,
            curFocusNode: _nicknameFocusNode,
            nextFocusNode: _ageFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            validator: (String? v) => isValidNickname(v),
            onChanged: (String value) {
              setState(() {
                _isValidNickname = isValidNickname(value) == null;
              });
            }),
        const AppSpacerV(),
        AppButton(
            title: '다음',
            disable: !_isValidNickname,
            onPressed: () {
              _nextStep();
            }),
        const AppSpacerV(),
      ],
    );
  }

  Widget _stepAge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('나이를 입력해주세요',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith()),
        const AppSpacerV(),
        AppText("연령대에 맞는 콘텐츠를 제공해드릴게요.",
            style: Theme.of(context).textTheme.labelLarge!),
        AppTextInput(
          key: const Key('age'),
          hintText: '나이',
          controller: _ageController,
          curFocusNode: _ageFocusNode,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          suffixText: '세',
          validator: (String? value) => isValidAge(value),
          onChanged: (value) {
            setState(() {
              if (value.startsWith('0') && value.length > 1) {
                _ageController.text = int.parse(value).toString();
              }
              _isValidAge = isValidAge(_ageController.text) == null;
            });
          },
        ),
        const AppSpacerV(),
        AppButton(
            title: '다음',
            disable: !_isValidAge,
            onPressed: () {
              _nextStep();
            }),
      ],
    );
  }

  Widget _stepGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('성별을 선택해주세요.',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith()),
        const AppSpacerV(),
        AppText("성별에 맞는 콘텐츠를 제공해드릴게요.",
            style: Theme.of(context).textTheme.labelLarge!),
        AppSpacerV(value: Dimens.space20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelMedium!,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.space12,
                      horizontal: Dimens.space16,
                    ),
                    backgroundColor: _isSelected(Gender.male)
                        ? Palette.coolGrey02
                        : Palette.coolGrey12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimens.space12,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _genderController.text = Gender.male.name;
                    });
                  },
                  child: Text("남성",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: _isSelected(Gender.male)
                              ? Palette.coolGrey12
                              : Palette.coolGrey02))),
            ),
            AppSpacerH(
              value: Dimens.space20,
            ),
            Expanded(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelMedium!,
                    padding: EdgeInsets.symmetric(
                      vertical: Dimens.space12,
                      horizontal: Dimens.space16,
                    ),
                    backgroundColor: _isSelected(Gender.female)
                        ? Palette.coolGrey02
                        : Palette.coolGrey12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimens.space12,
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _genderController.text = Gender.female.name;
                    });
                  },
                  child: Text("여성",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: _isSelected(Gender.female)
                              ? Palette.coolGrey12
                              : Palette.coolGrey02))),
            ),
          ],
        ),
        AppSpacerV(value: Dimens.space40),
        AppButton(
            title: '완료',
            disable: false,
            onPressed: () {
              _nextStep();
            }),
      ],
    );
  }

  bool _isSelected(Gender gender) {
    return _genderController.text == gender.name;
  }
}
