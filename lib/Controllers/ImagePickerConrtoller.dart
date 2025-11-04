// image_picker_controller.dart
import 'dart:typed_data';
import 'dart:io' show File, Platform;
import 'package:file_picker/file_picker.dart';

class ImagePickerController {
  Uint8List? imageBytes;

  Future<Uint8List?> pickImage() async {
    imageBytes =null;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      final file = result.files.first;

      if (file.bytes != null) {
        imageBytes = file.bytes;
      } else if (file.path != null && Platform.isWindows) {
        imageBytes = await File(file.path!).readAsBytes();
      }
    }
    return imageBytes;
  }

  bool get hasImage => imageBytes != null;
}
