import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/shared/widgets/camera_preview_screen.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> captureFromCamera(BuildContext context) async {
    if (kIsWeb) {
      final xfile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      return xfile?.readAsBytes();
    }

    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const CameraPreviewScreen()),
    );
    if (imagePath == null) return null;
    return _compressMobile(imagePath);
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
