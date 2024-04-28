import 'dart:io';

import 'package:flutter/material.dart' hide Step;
import 'package:image_picker/image_picker.dart';
import 'package:pookabu/shared/entities/form/picutre_step.dart';
import 'package:pookabu/shared/entities/form/step_result.dart';
import 'package:pookabu/shared/service/image_picker/image_picker_service.dart';
import 'package:pookabu/shared/widgets/form/material/form_container.dart';
import 'package:pookabu/shared/widgets/form/material/form_button.dart';
import 'package:pookabu/shared/widgets/form/material/form_header.dart';
import 'package:pookabu/shared/constant/assets.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/utils/logging/log.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_h.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';

class AppPictureForm extends StatefulWidget {
  final PictureStep step;
  final void Function(StepResult? result) onNextPress;
  final void Function() onBackPress;

  const AppPictureForm({
    super.key,
    required this.step,
    required this.onNextPress,
    required this.onBackPress,
  });

  @override
  State<AppPictureForm> createState() => _PictureFormState();
}

class _PictureFormState extends State<AppPictureForm> {
  final List<XFile> _images = [];
  final ImagePickerService _pickerServiece = ImagePickerService();

  PictureStep get step => widget.step;

  void _uploadImages(ImageSource imageSource) async {
    try {
      List<XFile> images = await _pickerServiece.getImages(imageSource);

      setState(() {
        _images.addAll(images.map((XFile file) => XFile(file.path)));
      });
    } catch (e) {
      await _pickerServiece.askPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      step: widget.step,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          FormHeader(title: widget.step.title),
          if (widget.step.description?.isNotEmpty == true)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                    ),
                    child: Text(widget.step.description!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              ],
            ),

          /////////////////////////////////////////////////////////////////////////////////
          ////// Image Swipe
          const Spacer(),
          /////////////////////////////////////////////////////////////////////////////////
          Container(
              height: Dimens.bigImageW,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Stack(
                children: [
                  if (_images.isEmpty) ...{
                    SizedBox(
                      width: context.widthInPercent(100),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.space12),
                        child: Image.asset(
                          Assets.noImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  } else ...{
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.isEmpty ? 1 : _images.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              width: Dimens.bigImageW,
                              margin: const EdgeInsets.only(right: 10.0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.space12),
                                child: Image.file(
                                  File(_images[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: Dimens.space8,
                              right: Dimens.space20,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _images.removeAt(index);
                                  });
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  }
                ],
              )),
          AppSpacerV(value: Dimens.space20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AppButton(
                  title: '사진첩',
                  color: Palette.coolGrey12,
                  titleColor: Palette.white,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    _uploadImages(ImageSource.gallery);
                  },
                ),
              ),
              const AppSpacerH(),
              Expanded(
                  child: AppButton(
                      title: '카메라',
                      color: Palette.coolGrey12,
                      titleColor: Palette.white,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        _uploadImages(ImageSource.camera);
                      }))
            ],
          ),
          const Spacer(),
          FormButton(
            onNextPress: widget.onNextPress,
            onBackPress: widget.onBackPress,
            result: StepResult(
                stepId: step.id,
                value: _images.map((image) => File(image.path)).toList()),
          ),
        ],
      ),
    );
  }

  // Future getImage(ImageSource imageSource) async {
  //   try {
  //     List<XFile> files = [];

  //     if (imageSource == ImageSource.gallery) {
  //       files = await _picker.pickMultiImage();
  //     } else {
  //       XFile? picturedImage = await _picker.pickImage(source: imageSource);
  //       files.add(picturedImage);
  //     }

  //     setState(() {
  //       _images.addAll(files.map((XFile file) => XFile(file.path)));
  //     });
  //   } catch (e) {}
  // }
}
