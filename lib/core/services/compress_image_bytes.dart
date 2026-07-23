import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

/// Compresses [bytes] to JPEG so neither dimension exceeds [maxDimension]
/// pixels, at the given [quality] (0–100).
Future<Uint8List> compressImageBytes(
  Uint8List bytes, {
  int maxDimension = 800,
  int quality = 75,
}) async {
  final result = await FlutterImageCompress.compressWithList(
    bytes,
    minWidth: maxDimension,
    minHeight: maxDimension,
    quality: quality,
    format: CompressFormat.jpeg,
  );
  return result;
}
