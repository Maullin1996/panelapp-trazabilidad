import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/shared/widgets/camera_preview_screen.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> captureFromCamera(BuildContext context) async {
    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const CameraPreviewScreen()),
    );
    if (imagePath == null) return null;

    if (kIsWeb) {
      return imagePath.startsWith('data:') ? _base64ToBytes(imagePath) : null;
    }
    return _compressMobile(imagePath);
  }

  Uint8List? _base64ToBytes(String dataUrl) {
    final comma = dataUrl.indexOf(',');
    if (comma == -1) return null;
    return base64Decode(dataUrl.substring(comma + 1));
  }

  Future<Uint8List?> captureFromGallery() async {
    final xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: kIsWeb ? 80 : 100,
    );
    if (xfile == null) return null;

    if (kIsWeb) {
      return xfile.readAsBytes();
    }
    return _compressMobile(xfile.path);
  }

  Future<Uint8List?> _compressMobile(String path) async {
    final result = await FlutterImageCompress.compressWithFile(
      path,
      quality: 80,
      minWidth: 768,
      minHeight: 768,
    );
    return result;
  }
}
