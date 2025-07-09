import 'dart:typed_data';
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  final String cloudName = 'dwkdgesqj';
  final String uploadPreset = 'flutter_whatsapp';

  Future<String?> uploadToCloudinary({
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'upload_preset': uploadPreset,
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      final response = await _dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200) {
        return response.data['secure_url'];
      } else {
        print("❌ Upload failed: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("❌ Upload error: $e");
      return null;
    }
  }

  Future<String?> pickAndUploadImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked == null) return null;

    final bytes = await picked.readAsBytes();
    return await uploadToCloudinary(fileName: picked.name, fileBytes: bytes);
  }
}
