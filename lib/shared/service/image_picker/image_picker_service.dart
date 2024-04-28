import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pookabu/shared/utils/logging/log.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>> getImages(ImageSource imageSource) async {
    List<XFile> files = [];

    if (imageSource == ImageSource.gallery) {
      files = await _picker.pickMultiImage();
    } else {
      XFile? picturedImage = await _picker.pickImage(source: imageSource);
      if (picturedImage != null) {
        files.add(picturedImage);
      }
    }

    return files;
  }

  Future<bool> hasPermission() async {
    if (await Permission.mediaLibrary.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  askPermission() async {
    if (!await Permission.mediaLibrary.isGranted) {
      openAppSettings();
    }
  }
}
