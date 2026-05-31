import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<Uint8List?> pickImage() async {
    final xfile = await _picker.pickImage(
      source: kIsWeb ? ImageSource.camera : ImageSource.gallery,
      imageQuality: kIsWeb ? 80 : 100,
    );
    if (xfile == null) return null;
    if (kIsWeb) return xfile.readAsBytes();
    return _compressMobile(xfile.path);
  }

  Future<Uint8List?> _compressMobile(String path) async {
    return FlutterImageCompress.compressWithFile(
      path,
      quality: 80,
      minWidth: 768,
      minHeight: 768,
    );
  }
}
