import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pookaboo/layers/domain/entities/toilet/upload_toilet_images_params.dart';
import 'package:pookaboo/layers/presentation/bloc/toilet/toilet_bloc.dart';
import 'package:pookaboo/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookaboo/layers/data/models/toilet/toilet.dart';
import 'package:pookaboo/layers/presentation/pages/map/widgets/detail_sheet/information_tab/amenity_container.dart';
import 'package:pookaboo/layers/presentation/pages/map/widgets/detail_sheet/information_tab/convenience_container.dart';
import 'package:pookaboo/layers/presentation/pages/map/widgets/detail_sheet/information_tab/equipment_container.dart';
import 'package:pookaboo/layers/presentation/pages/map/widgets/detail_sheet/information_tab/image_swiper.dart';
import 'package:pookaboo/shared/constant/enum.dart';
import 'package:pookaboo/shared/service/image_picker/image_picker_service.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/styles/palette.dart';
import 'package:pookaboo/shared/utils/logging/log.dart';
import 'package:pookaboo/shared/widgets/common/app_button.dart';
import 'package:pookaboo/shared/widgets/common/app_divider.dart';
import 'package:pookaboo/shared/widgets/common/app_spacer_v.dart';
import 'package:pookaboo/shared/widgets/common/app_text.dart';

class DetailSheetInformation extends StatefulWidget {
  final Toilet toilet;

  const DetailSheetInformation(this.toilet, {super.key});

  @override
  State<DetailSheetInformation> createState() => _DetailSheetInformationState();
}

class _DetailSheetInformationState extends State<DetailSheetInformation> {
  Toilet get toilet => widget.toilet;

  final ImagePickerService _pickerService = ImagePickerService();

  late bool isOwner = false;

  late List<String> _images = [];
  late final List<Map<String, dynamic>> _equipments = [];
  late final List<Map<String, dynamic>> _conveniences = [];
  late final List<Map<String, dynamic>> _amenities = [];

  // only Owner
  late final List<XFile> _uploadImages = [];

  @override
  void initState() {
    super.initState();
    _checkOwner();
    _fetchImages();
    _fetchEquipments();
    _fetchConveiences();
    _fetchAmenities();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimens.space100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /////////////////////////////////////////////////////////////////////////////////
          ////// Image Swipe
          /////////////////////////////////////////////////////////////////////////////////
          BlocConsumer<ToiletBloc, ToiletState>(
              listener: (context, state) async {
            if (state is SuccessUploadToiletImagesState) {
              _fetchImages();
            }
            if (state is LoadedToiletImagesState) {
              setState(() {
                _images = state.images;
              });
            }
          }, builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ImageSwiper(
                  images: _images,
                  isOwner: isOwner,
                ),
                // 관리자라면 사진 올리기 버튼!
                if (isOwner) ...{
                  if (_uploadImages.isNotEmpty) ...{
                    Column(
                      children: [
                        const AppSpacerV(),
                        Container(
                          height: Dimens.space100,
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: _uploadImageSwiper(toilet.id, _uploadImages),
                        ),
                        const AppSpacerV(),
                      ],
                    )
                  },
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
                    child: AppButton(
                      // width: Dimens.space100,
                      height: Dimens.space30,
                      title: '사진 올리기',
                      titleStyle: Theme.of(context).textTheme.labelMedium!,
                      color: Palette.coolGrey07,
                      onPressed: () async {
                        List<XFile> files =
                            await _pickerService.getImages(ImageSource.gallery);
                        log.d(files);
                        setState(() {
                          _uploadImages.addAll(files);
                        });
                      },
                    ),
                  )
                },
              ],
            );
          }),
          AppSpacerV(value: Dimens.space30),
          /////////////////////////////////////////////////////////////////////////////////
          ////// Equipment
          /////////////////////////////////////////////////////////////////////////////////
          EquipmentContainer(equipments: _equipments),
          /////////////////////////////////////////////////////////////////////////////////
          ////// Convenience
          /////////////////////////////////////////////////////////////////////////////////
          if (_conveniences.isNotEmpty) ...{
            AppSpacerV(value: Dimens.space30),
            const AppDivider(),
            AppSpacerV(value: Dimens.space30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
              child: AppText("편의시설",
                  style: Theme.of(context).textTheme.bodyMedium!),
            ),
            AppSpacerV(value: Dimens.space30),
            ConvenienceContainer(conveniences: _conveniences),
          },
          /////////////////////////////////////////////////////////////////////////////////
          ////// Amenity
          /////////////////////////////////////////////////////////////////////////////////
          if (_amenities.isNotEmpty) ...{
            AppSpacerV(value: Dimens.space30),
            const AppDivider(),
            AppSpacerV(value: Dimens.space30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
              child: AppText("어메니티",
                  style: Theme.of(context).textTheme.bodyMedium!),
            ),
            AppSpacerV(value: Dimens.space30),
            AmenityContainer(amenities: _amenities)
          },
        ],
      ),
    );
  }

  Widget _uploadImageSwiper(int toiletId, List<XFile> uploadImages) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: uploadImages.isEmpty ? 1 : uploadImages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              width: Dimens.space100,
              height: Dimens.space100,
              margin: const EdgeInsets.only(right: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.space12),
                child: Image.file(
                  File(uploadImages[index].path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: Dimens.space8,
              left: Dimens.space10,
              child: GestureDetector(
                onTap: () {
                  _removeUploadImages(index);
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
            Positioned(
              top: Dimens.space8,
              right: Dimens.space20,
              child: GestureDetector(
                onTap: () {
                  _onUploadImage(toiletId, index);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _fetchImages() {
    context.read<ToiletBloc>().add(GetToiletImagesEvent(toiletId: toilet.id));
  }

  void _fetchEquipments() {
    final state = context.read<UserBloc>().state;

    int? gender = 1;
    if (state is AuthenticatedState) {
      final user = state.user;
      gender = user.isMale() ? 1 : 2;
    }

    // equipment
    for (var equipment in EquipmentKey.values) {
      List<(String, String)> keys = equipment.keys;
      String emoji = equipment.emoji;
      String name = equipment.name;
      int count = 0;

      for (var (key, _) in keys) {
        List<int> equipmentsJson = toilet.equipment?.toJson()[key];
        List<int> equipments = equipmentsJson.map((item) => item).toList();

        bool seperate = toilet.gender;

        if (equipments.isNotEmpty) {
          count += equipments[seperate ? gender : 0];
        }
      }

      _equipments.add({
        'section': 'equipment',
        "emoji": emoji,
        "title": name,
        "value": count.toString()
      });
    }
  }

  void _fetchConveiences() {
    // convenience
    for (var convenience in ConvenienceKey.values) {
      String key = convenience.key;
      String emoji = convenience.emoji;
      String name = convenience.name;
      bool hasConvenience = toilet.convenience?.toJson()[key];
      if (hasConvenience) {
        _conveniences
            .add({'section': 'convenience', "emoji": emoji, "title": name});
      }
    }
  }

  void _fetchAmenities() {
    // amenity
    for (var amenity in AmenityKey.values) {
      String key = amenity.key;
      String emoji = amenity.emoji;
      String name = amenity.name;
      bool hasAmenity = toilet.convenience?.toJson()[key];

      if (hasAmenity) {
        _amenities.add({'section': 'amenity', "emoji": emoji, "title": name});
      }
    }
  }

  void _checkOwner() {
    final state = context.read<UserBloc>().state;
    if (state is AuthenticatedState) {
      isOwner = state.user.isOwner();
    }
  }

  void _onUploadImage(int toiletId, int index) {
    XFile image = _uploadImages[index];

    UploadToiletImagesParams params = UploadToiletImagesParams(images: [
      ImageFormData(
          filePath: image.path,
          storagePath: '/$toiletId/${DateTime.now().millisecondsSinceEpoch}')
    ]);

    log.d(image.path);
    context.read<ToiletBloc>().add(UploadToiletImagesEvent(params: params));

    _removeUploadImages(index);
  }

  void _removeUploadImages(int index) {
    setState(() {
      if (_uploadImages.length > index) {
        _uploadImages.removeAt(index);
      }
    });
  }
}
