
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../constants.dart';

class ImageUploadController {


  Future<void> uploadImageFromBytes(Uint8List imageBytes) async {
    final uri = Uri.parse('$SERVER_URL/upload');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'image', // اسم الحقل في السيرفر
        imageBytes,
        filename: 'upload.png', // اسم افتراضي
        contentType: MediaType('image', 'png'), // أو 'jpeg' حسب نوع الصورة
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      print('Uploaded: $respStr');
    } else {
      print('Upload failed: ${response.statusCode}');
    }
  }
}
