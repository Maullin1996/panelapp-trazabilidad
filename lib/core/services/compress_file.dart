import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> compressFile(String filePath) async {
  final dir = await getTemporaryDirectory();
  final targetPath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

  final result = await FlutterImageCompress.compressAndGetFile(
    filePath,
    targetPath,
    quality: 80, // calidad 0–100
    minWidth: 768, // opcional: ancho mínimo
    minHeight: 768, // opcional: alto mínimo
    rotate: 0, // opcional: rotación si la foto viene rotada
  );
  return result?.path;
}
