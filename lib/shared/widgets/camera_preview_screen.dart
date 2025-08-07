import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:registro_panela/shared/utils/spacing.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  String? _previewImagePath;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(firstCamera, ResolutionPreset.medium);

    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture;

    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final directory = await getTemporaryDirectory();
      final imagePath = path.join(directory.path, '${DateTime.now()}.jpg');
      final file = await _controller.takePicture();
      await file.saveTo(imagePath);
      setState(() {
        _previewImagePath = imagePath;
      });
    } catch (_) {}
  }

  void _cancelPreview() {
    setState(() {
      _previewImagePath = null;
    });
  }

  void _confirmPhoto() {
    if (_previewImagePath != null) {
      Navigator.pop(context, _previewImagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black45,
      body: _previewImagePath != null
          ? Stack(
              children: [
                Image.file(
                  File(_previewImagePath!),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    child: IconButton(
                      onPressed: _confirmPhoto,
                      icon: Icon(Icons.check, size: 50),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    child: IconButton(
                      onPressed: _cancelPreview,
                      icon: Icon(Icons.refresh, size: 50),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                Center(child: CameraPreview(_controller)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, size: 50),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    child: IconButton(
                      onPressed: _takePicture,
                      icon: Icon(Icons.camera, size: 50),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}


// final savedFile = await File(file.path).copy(imagePath);
//       if (!mounted) return;
//       Navigator.pop(context, savedFile.path);