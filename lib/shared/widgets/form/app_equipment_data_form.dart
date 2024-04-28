import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pookabu/shared/entities/form/multi_data_step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/utils/logging/log.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';
import 'package:pookabu/shared/widgets/common/app_done.dart';
import 'package:pookabu/shared/widgets/common/app_text_input.dart';
import 'package:pookabu/shared/widgets/form/material/form_container.dart';
import 'package:pookabu/shared/widgets/form/material/form_button.dart';
import 'package:pookabu/shared/widgets/form/material/form_description.dart';
import 'package:pookabu/shared/widgets/form/material/form_header.dart';
import 'package:pookabu/shared/constant/enum.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class AppEquipmentDataForm extends StatefulWidget {
  final EquipmentDataStep step;
  final void Function(StepResult? result) onNextPress;
  final void Function() onBackPress;
  final bool isSeperateGender;

  const AppEquipmentDataForm(
      {super.key,
      required this.onNextPress,
      required this.onBackPress,
      required this.step,
      required this.isSeperateGender});

  @override
  State<AppEquipmentDataForm> createState() => _MultiDataFormState();
}

class _MultiDataFormState extends State<AppEquipmentDataForm>
    with SingleTickerProviderStateMixin {
  EquipmentDataStep get step => widget.step;
  bool get isSeperateGender => widget.isSeperateGender;

  late TabController _tabController;
  late List<List<FocusNode>> _maleNodes;
  late List<List<TextEditingController>> _maleCons;
  late List<List<FocusNode>> _femaleNodes;
  late List<List<TextEditingController>> _femaleCons;
  late List<List<FocusNode>> _commonNodes;
  late List<List<TextEditingController>> _commonCons;

  @override
  void initState() {
    super.initState();

    if (isSeperateGender) {
      _tabController = TabController(length: 2, vsync: this);

      _maleNodes =
          List.generate(3, (i) => List.generate(3, (j) => FocusNode()));
      _maleCons = List.generate(
          3, (i) => List.generate(3, (j) => TextEditingController()));

      _femaleNodes =
          List.generate(2, (i) => List.generate(3, (j) => FocusNode()));
      _femaleCons = List.generate(
          2, (i) => List.generate(3, (j) => TextEditingController()));
    } else {
      _commonNodes =
          List.generate(3, (i) => List.generate(3, (j) => FocusNode()));
      _commonCons = List.generate(
          3, (i) => List.generate(3, (j) => TextEditingController()));
    }
  }

  @override
  void dispose() {
    final List<List<FocusNode>> allFocusNodes = [];
    final List<List<TextEditingController>> allControllers = [];
    if (isSeperateGender) {
      _tabController.dispose();
      allControllers.addAll([..._maleCons, ..._femaleCons]);
      allFocusNodes.addAll([..._maleNodes, ..._femaleNodes]);
    } else {
      allControllers.addAll([..._commonCons]);
      allFocusNodes.addAll([..._commonNodes]);
    }

    for (var row in allFocusNodes) {
      for (var node in row) {
        node.dispose();
      }
    }

    for (var row in allControllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      step: step,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          FormHeader(title: step.title),
          AppSpacerV(value: Dimens.space50),
          if (isSeperateGender) ...{
            Expanded(
                child: _buildGenderForm(
                    _maleCons, _maleNodes, _femaleCons, _femaleNodes)),
          } else ...{
            Expanded(
              child: _buildCommonForm(_commonCons, _commonNodes),
            )
          },
          FormButton(
            onNextPress: widget.onNextPress,
            onBackPress: widget.onBackPress,
            result: StepResult(
              stepId: step.id,
              value: _resultValue(),
              // value: resultValue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonForm(List<List<TextEditingController>> contollers,
      List<List<FocusNode>> nodes) {
    return Column(
      children: [
        const Text(
          "공용 화장실",
        ),
        AppSpacerV(value: Dimens.space20),
        _buildCommon(contollers, nodes),
      ],
    );
  }

  Widget _buildGenderForm(
      List<List<TextEditingController>> maleContollers,
      List<List<FocusNode>> maleNodes,
      List<List<TextEditingController>> femalecontollers,
      List<List<FocusNode>> femlaeNodes) {
    return Column(
      children: [
        const Text(
          "남녀 분리 화장실",
        ),
        const AppSpacerV(),
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '남성'),
            Tab(text: '여성'),
          ],
        ),
        AppSpacerV(value: Dimens.space20),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMale(maleContollers, maleNodes),
              _buildFemale(femalecontollers, femlaeNodes),
            ],
          ),
        )
      ],
    );
  }

  Table _buildMale(List<List<TextEditingController>> controllers,
      List<List<FocusNode>> focusNodes) {
    return Table(
      children: [
        _buildHeader(['', '일반', '어린이', '장애인']),
        _buildUrninal(controllers[0], focusNodes[0]),
        _buildSeat(controllers[1], focusNodes[1]),
        _buildWashbasin(controllers[2][0], focusNodes[2][0])
      ],
    );
  }

  Table _buildFemale(List<List<TextEditingController>> controllers,
      List<List<FocusNode>> focusNodes) {
    return Table(
      children: [
        _buildHeader(['', '일반', '어린이', '장애인']),
        _buildSeat(controllers[0], focusNodes[0]),
        _buildWashbasin(controllers[1][0], focusNodes[1][0])
      ],
    );
  }

  Table _buildCommon(List<List<TextEditingController>> controllers,
      List<List<FocusNode>> focusNodes) {
    return Table(
      children: [
        _buildHeader(['', '일반', '어린이', '장애인']),
        _buildUrninal(controllers[0], focusNodes[0]),
        _buildSeat(controllers[1], focusNodes[1]),
        _buildWashbasin(controllers[2][0], focusNodes[2][0])
      ],
    );
  }

  TableRow _buildHeader(List<String> headers) {
    return TableRow(
        children: List.generate(
            headers.length,
            (index) => TableCell(
                    child: Center(
                  child: Text(headers[index]),
                ))));
  }

  TableRow _buildUrninal(
      List<TextEditingController> controllers, List<FocusNode> focusNodes) {
    return TableRow(children: [
      const TableCell(
        verticalAlignment: TableCellVerticalAlignment.bottom,
        child: Center(child: Text('소변기 💦')),
      ),
      ...List.generate(
        3,
        (index) => _countInput(controllers[index], focusNodes[index]),
      )
    ]);
  }

  TableRow _buildSeat(
      List<TextEditingController> controllers, List<FocusNode> focusNodes) {
    return TableRow(children: [
      const TableCell(
        verticalAlignment: TableCellVerticalAlignment.bottom,
        child: Center(child: Text('좌변기 🚽')),
      ),
      ...List.generate(
        3,
        (index) => _countInput(controllers[index], focusNodes[index]),
      )
    ]);
  }

  TableRow _buildWashbasin(
      TextEditingController controller, FocusNode focusNode) {
    return TableRow(children: [
      const TableCell(
        verticalAlignment: TableCellVerticalAlignment.bottom,
        child: Center(child: Text('세면대 🚰')),
      ),
      _countInput(controller, focusNode),
      ...List.generate(2, (index) => Container())
    ]);
  }

  Widget _countInput(TextEditingController controller, FocusNode node) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: TextField(
          onTapOutside: (event) {
            node.unfocus();
          },
          decoration: const InputDecoration(
            counterText: "",
          ),
          onChanged: (_) {
            setState(() {});
          },
          controller: controller,
          maxLength: 2,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          focusNode: node,
          textInputAction: TextInputAction.next),
    );
  }

  Map<String, List<int>> _resultValue() {
    switch (isSeperateGender) {
      case true:
        return {
          "urinal": [
            int.parse(
                _maleCons[0][0].text.isEmpty ? '0' : _maleCons[0][0].text),
            0,
            0,
          ],
          'child_urinal': [
            int.parse(
                _maleCons[0][1].text.isEmpty ? '0' : _maleCons[0][1].text),
            0,
            0,
          ],
          "disable_urinal": [
            int.parse(
                _maleCons[0][2].text.isEmpty ? '0' : _maleCons[0][2].text),
            0,
            0
          ],
          "seat": [
            int.parse(
                _maleCons[1][0].text.isEmpty ? '0' : _maleCons[1][0].text),
            int.parse(
                _femaleCons[0][0].text.isEmpty ? '0' : _femaleCons[0][0].text),
            0,
          ],
          "child_seat": [
            int.parse(
                _maleCons[1][1].text.isEmpty ? '0' : _maleCons[1][1].text),
            int.parse(
                _femaleCons[0][1].text.isEmpty ? '0' : _femaleCons[0][1].text),
            0,
          ],
          "disable_seat": [
            int.parse(
                _maleCons[1][2].text.isEmpty ? '0' : _maleCons[1][2].text),
            int.parse(
                _femaleCons[0][2].text.isEmpty ? '0' : _femaleCons[0][2].text),
            0,
          ],
          "washbasin": [
            int.parse(
                _maleCons[2][0].text.isEmpty ? '0' : _maleCons[2][0].text),
            int.parse(
                _femaleCons[1][0].text.isEmpty ? '0' : _femaleCons[1][0].text),
            0,
          ],
        };
      case false:
        return {
          "urinal": [
            0,
            0,
            int.parse(
                _commonCons[0][0].text.isEmpty ? '0' : _commonCons[0][0].text)
          ],
          'child_urinal': [
            0,
            0,
            int.parse(
                _commonCons[0][1].text.isEmpty ? '0' : _commonCons[0][1].text)
          ],
          "disable_urinal": [
            0,
            0,
            int.parse(
                _commonCons[0][2].text.isEmpty ? '0' : _commonCons[0][2].text)
          ],
          "seat": [
            0,
            0,
            int.parse(
                _commonCons[1][0].text.isEmpty ? '0' : _commonCons[1][0].text)
          ],
          "child_seat": [
            0,
            0,
            int.parse(
                _commonCons[1][1].text.isEmpty ? '0' : _commonCons[1][1].text)
          ],
          "disable_seat": [
            0,
            0,
            int.parse(
                _commonCons[1][2].text.isEmpty ? '0' : _commonCons[1][2].text)
          ],
          "washbasin": [
            0,
            0,
            int.parse(
                _commonCons[2][0].text.isEmpty ? '0' : _commonCons[2][0].text)
          ],
        };
    }
  }
}
