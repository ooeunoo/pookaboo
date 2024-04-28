import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pookabu/layers/data/models/user/app_user.dart';
import 'package:pookabu/layers/domain/entities/user/update_user_params.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';
import 'package:pookabu/shared/widgets/common/app_snak_bar.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';
import 'package:pookabu/shared/widgets/common/app_text_input.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  AppUser? user;

  final _nicknameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();

  final _nicknameFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _genderFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _setupFocusListeners();

    _refresh();
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

  void _setupFocusListeners() {
    _nicknameFocusNode.addListener(() {
      if (_nicknameFocusNode.hasFocus) {
        _ageFocusNode.unfocus();
        _genderFocusNode.unfocus();
      }
      setState(() {});
    });

    _ageFocusNode.addListener(() {
      if (_ageFocusNode.hasFocus) {
        _nicknameFocusNode.unfocus();
        _genderFocusNode.unfocus();
      }
      setState(() {});
    });

    _genderFocusNode.addListener(() {
      if (_genderFocusNode.hasFocus) {
        _nicknameFocusNode.unfocus();
        _ageFocusNode.unfocus();
      }
      setState(() {});
    });
    setState(() {});
  }

  void _refresh() {
    UserState state = context.read<UserBloc>().state;
    if (state is AuthenticatedState) {
      setState(() {
        user = state.user;
      });

      _nicknameController.text = user?.nickname ?? "";
      _ageController.text = user?.age.toString() ?? "";
      _genderController.text =
          user!.isMale() ? Gender.male.name : Gender.female.name;
    }
  }

  void _confirmUpdate() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.space16))),
              backgroundColor: Palette.coolGrey10,
              content: SizedBox(
                  width: context.widthInPercent(95),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSpacerV(),
                      AppText('저장할까요?',
                          style: Theme.of(context).textTheme.bodyMedium!),
                      AppSpacerV(value: Dimens.space20),
                      AppText('바꾼 정보를 저장합니다.',
                          style: Theme.of(context).textTheme.labelLarge!),
                      AppSpacerV(value: Dimens.space20),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                                title: '아니요',
                                titleColor: Palette.coolGrey03,
                                color: Colors.transparent,
                                onPressed: () {
                                  context.back();
                                }),
                          ),
                          const AppSpacerH(),
                          Expanded(
                            child: AppButton(
                                title: '네',
                                titleColor: Palette.coolGrey12,
                                color: Palette.lemon01,
                                onPressed: () {
                                  _onUpdate();
                                  context.back();
                                }),
                          )
                        ],
                      )
                    ],
                  )));
        });
  }

  void _onUpdate() async {
    UpdateUserParams params = UpdateUserParams(
        user_id: user!.id,
        nickname: _nicknameController.text,
        age: _ageController.text,
        gender: _genderController.text == Gender.male.name ? 0 : 1);

    context.read<UserBloc>().add(UpdateUserEvent(params: params));

    context.pop();
    NotifyAfterEditProfileSnackBar(context);
  }

  String get nicknamechanged =>
      '${user?.nickname} and ${_nicknameController.text}';

  bool get isChanged =>
      user?.nickname != _nicknameController.text ||
      user?.age.toString() != _ageController.text ||
      Gender.values[user!.gender!].name != _genderController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: Dimens.space16),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.back();
              },
            ),
          ),
          title: AppText(
            '내 정보 수정',
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
        ),
        body: BlocConsumer<UserBloc, UserState>(listener: (context, state) {
          if (state is AuthenticatedState) {
            _refresh();
          }
        }, builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimens.space20, horizontal: Dimens.space20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextInput(
                  hint: '프로필명',
                  hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: _nicknameFocusNode.hasFocus
                          ? Palette.lemon04
                          : Palette.coolGrey05),
                  controller: _nicknameController,
                  curFocusNode: _nicknameFocusNode,
                  nextFocusNode: _ageFocusNode,
                  maxLength: 12,
                  maxLine: 1,
                  onTapOutside: (_) {
                    _nicknameFocusNode.unfocus();
                  },
                ),
                const AppSpacerV(),
                Column(
                  children: [
                    AppTextInput(
                      hint: '나이',
                      hintStyle: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(
                              color: _ageFocusNode.hasFocus
                                  ? Palette.lemon04
                                  : Palette.coolGrey05),
                      controller: _ageController,
                      curFocusNode: _ageFocusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      onTapOutside: (_) {
                        _ageFocusNode.unfocus();
                      },
                    ),
                  ],
                ),
                const AppSpacerV(),
                _genderForm(context),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                          disable: !isChanged,
                          title: '수정완료',
                          onPressed: _confirmUpdate),
                    )
                  ],
                )
              ],
            ),
          );
        }));
  }

  Widget _genderForm(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("성별",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: _genderFocusNode.hasFocus
                      ? Palette.lemon04
                      : Palette.coolGrey05)),
          const AppSpacerV(),
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
          )
        ],
      ),
    );
  }

  bool _isSelected(Gender gender) {
    return _genderController.text == gender.name;
  }
}
