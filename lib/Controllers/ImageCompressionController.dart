import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompressionController {

  /// يضغط الصورة ويغير حجمها لتتناسب مع ارتفاع محدد
  ///
  /// @param image صورة بصيغة Uint8List
  /// @param targetHeight الارتفاع المستهدف للصورة النهائية
  /// @param quality جودة الصورة النهائية (0-100)
  /// @return الصورة المضغوطة بعد تغيير الحجم (Uint8List?)
  Future<Uint8List?> compressImageForHeight({
    required Uint8List? image,
    int targetHeight = 256,
    int quality = 100,
  }) async {
    if (image == null) return null;

    if (kDebugMode) {
      print("Original image size: ${(image.lengthInBytes / 1024).toInt()} KB");
    }

    // 1. فك الصورة بواسطة مكتبة image
    img.Image? originalImage = img.decodeImage(image);
    if (originalImage == null) return null;

    // 2. تغيير الحجم مع الحفاظ على نسبة العرض/الارتفاع
    img.Image resizedImage = _resizeImage(originalImage, targetHeight: targetHeight);

    // 3. تحويل الصورة مرة أخرى إلى Uint8List بصيغة PNG أو JPEG
    Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resizedImage));

    // 4. ضغط الصورة باستخدام flutter_image_compress
    Uint8List? compressedBytes = await FlutterImageCompress.compressWithList(
      resizedBytes,
      quality: quality,
      format: CompressFormat.png, // يمكنك تغييره إلى JPEG إذا أردت
    );

    if (kDebugMode ) {
      print("Compressed image size: ${(compressedBytes.lengthInBytes / 1024).toInt()} KB");
    }

    return compressedBytes;
  }

  /// تقوم بتغيير حجم الصورة مع الحفاظ على نسبة العرض إلى الارتفاع
  img.Image _resizeImage(img.Image originalImage, {required int targetHeight}) {
    final double ratio = originalImage.width / originalImage.height;
    final int newWidth = (targetHeight * ratio).round();
    return img.copyResize(originalImage, width: newWidth, height: targetHeight);
  }
}
