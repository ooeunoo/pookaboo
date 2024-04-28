import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/domain/entities/toilet/update_toilet_main_image_params.dart';
import 'package:pookabu/layers/presentation/bloc/toilet/toilet_bloc.dart';
import 'package:pookabu/shared/constant/assets.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/extension/string.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

class ImageSwiper extends StatefulWidget {
  final Toilet toilet;
  final List<String> images;
  final bool isOwner;

  const ImageSwiper({
    super.key,
    required this.images,
    required this.toilet,
    this.isOwner = false,
  });

  @override
  State<ImageSwiper> createState() => _ImageSwiperState();
}

class _ImageSwiperState extends State<ImageSwiper> {
  Toilet get toilet => widget.toilet;
  List<String> get images => widget.images;
  bool get isOwner => widget.isOwner;

  String? _mainUrl;
  List<String> _sortedImages = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sortingUrl();
  }

  void _sortingUrl() {
    List<String> urls = List.from(images);

    for (String img in urls) {
      if (img.extractValueFromUrl() == 'main') {
        setState(() {
          _mainUrl = img;
        });
        break;
      }
    }

    if (_mainUrl != null && urls.isNotEmpty) {
      urls.remove(_mainUrl);
      urls.insert(0, _mainUrl!);
    }
    setState(() {
      _sortedImages = urls;
    });
  }

  void onUpdateMainImage(String url) {
    context.read<ToiletBloc>().add(UpdateToiletMainImageEvent(
            params: UpdateToiletMainImageParams(
          has_main: _mainUrl != null,
          toilet_id: toilet.id.toString(),
          file_name: url.extractValueFromUrl(),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<ToiletBloc, ToiletState>(builder: (context, state) {
          if (state is LoadingToiletImagesState) {
            return SizedBox(
                height: Dimens.bigImageW,
                // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: const Center(
                    child: CircularProgressIndicator(
                  color: Palette.lemon01,
                )));
          } else {
            return Container(
              height: Dimens.bigImageW,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: _sortedImages.isEmpty
                  ? noImageContainer()
                  : imagesContainer(_sortedImages),
            );
          }
        })
      ],
    );
  }

  Widget imagesContainer(List<String> images) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.isEmpty ? 1 : images.length,
      itemBuilder: (context, index) {
        bool isMain = images[index].extractValueFromUrl() == 'main';

        return Stack(
          children: [
            Container(
              width: Dimens.bigImageW,
              margin: const EdgeInsets.only(right: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.space12),
                child: Image.network(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (isOwner) ...{
              Positioned(
                top: Dimens.space8,
                left: Dimens.space10,
                child: GestureDetector(
                  onTap: () {
                    onUpdateMainImage(images[index]);
                  },
                  child: Icon(
                    Icons.star,
                    color: isMain ? Colors.yellow : Colors.white,
                  ),
                ),
              ),
            }
          ],
        );
      },
    );
  }

  Widget noImageContainer() {
    return Container(
        height: Dimens.bigImageW,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SizedBox(
          width: context.widthInPercent(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimens.space12),
            child: Image.asset(
              Assets.noImage,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
