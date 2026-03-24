import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_compress_platform_interface/flutter_image_compress_platform_interface.dart';
import 'package:registro_panela/core/services/compress_file.dart';

class _FakeCompressPlatform extends FlutterImageCompressPlatform {
  _FakeCompressPlatform({this.result});

  XFile? result;

  @override
  FlutterImageCompressValidator get validator =>
      FlutterImageCompressValidator(const MethodChannel('fake'));

  @override
  Future<void> showNativeLog(bool value) async {}

  @override
  Future<XFile?> compressAndGetFile(
    String path,
    String targetPath, {
    int minWidth = 1920,
    int minHeight = 1080,
    int inSampleSize = 1,
    int quality = 95,
    int rotate = 0,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
    int numberOfRetries = 5,
  }) async {
    return result;
  }

  @override
  Future<Uint8List> compressWithList(
    Uint8List image, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
    int inSampleSize = 1,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> compressWithFile(
    String path, {
    int minWidth = 1920,
    int minHeight = 1080,
    int inSampleSize = 1,
    int quality = 95,
    int rotate = 0,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
    int numberOfRetries = 5,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List?> compressAssetImage(
    String assetName, {
    int minWidth = 1920,
    int minHeight = 1080,
    int quality = 95,
    int rotate = 0,
    bool autoCorrectionAngle = true,
    CompressFormat format = CompressFormat.jpeg,
    bool keepExif = false,
  }) {
    throw UnimplementedError();
  }

  @override
  void ignoreCheckSupportPlatform(bool bool) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  late FlutterImageCompressPlatform originalPlatform;

  setUp(() {
    originalPlatform = FlutterImageCompressPlatform.instance;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
          if (call.method == 'getTemporaryDirectory') {
            return 'C:/tmp';
          }
          return null;
        });
  });

  tearDown(() {
    FlutterImageCompressPlatform.instance = originalPlatform;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('compressFile returns compressed path', () async {
    final fake = _FakeCompressPlatform(result: XFile('C:/tmp/out.jpg'));
    FlutterImageCompressPlatform.instance = fake;

    final result = await compressFile('C:/input.jpg');

    expect(result, 'C:/tmp/out.jpg');
  });

  test('compressFile returns null when compression fails', () async {
    final fake = _FakeCompressPlatform(result: null);
    FlutterImageCompressPlatform.instance = fake;

    final result = await compressFile('C:/input.jpg');

    expect(result, isNull);
  });
}
