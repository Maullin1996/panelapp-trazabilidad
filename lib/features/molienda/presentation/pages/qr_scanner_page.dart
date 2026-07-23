import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web/web.dart' as web;
import 'package:zxing_lib/common.dart';
import 'package:zxing_lib/qrcode.dart';
import 'package:zxing_lib/zxing.dart';

import 'package:registro_panela/features/molienda/presentation/providers/molienda_providers.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';

class QrScannerPage extends ConsumerStatefulWidget {
  const QrScannerPage({super.key});

  @override
  ConsumerState<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends ConsumerState<QrScannerPage> {
  final QRCodeReader _reader = QRCodeReader();
  web.HTMLVideoElement? _videoElement;
  web.MediaStream? _stream;
  Timer? _scanTimer;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isProcessing = false;
  bool _usingFrontCamera = false;
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'qr-scanner-$hashCode';

    final video = web.HTMLVideoElement();
    video.autoplay = true;
    video.setAttribute('playsinline', 'true');
    video.style.width = '100%';
    video.style.height = '100%';
    video.style.objectFit = 'cover';

    ui_web.platformViewRegistry.registerViewFactory(_viewId, (_) => video);

    _videoElement = video;
    _initCamera();
  }

  Future<void> _initCamera({bool frontCamera = false}) async {
    _stopStream();

    if (!_isInitialized) {
      setState(() => _hasError = false);
    }

    try {
      final facingMode = frontCamera ? 'user' : 'environment';

      final constraints = {
        'video': {'facingMode': facingMode},
        'audio': false,
      }.jsify();

      final stream = await web.window.navigator.mediaDevices
          .getUserMedia(constraints as web.MediaStreamConstraints)
          .toDart;

      _stream = stream;
      _videoElement!.srcObject = stream;
      await _videoElement!.play().toDart;

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _usingFrontCamera = frontCamera;
        });
        _startScanTimer();
      }
    } catch (e) {
      debugPrint('Error iniciando cámara web: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _startScanTimer() {
    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(
      const Duration(milliseconds: 600),
      (_) => _scanFrame(),
    );
  }

  Future<void> _scanFrame() async {
    if (_isProcessing) return;

    final video = _videoElement;
    if (video == null || video.videoWidth == 0 || video.videoHeight == 0) {
      return;
    }

    final width = video.videoWidth;
    final height = video.videoHeight;

    final canvas = web.HTMLCanvasElement()
      ..width = width
      ..height = height;
    final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
    ctx.drawImage(video, 0, 0);

    final rgba = ctx.getImageData(0, 0, width, height).data.toDart;
    final pixels = List<int>.generate(width * height, (i) {
      final offset = i * 4;
      return (rgba[offset] << 16) | (rgba[offset + 1] << 8) | rgba[offset + 2];
    }, growable: false);

    String? qrToken;
    try {
      final source = RGBLuminanceSource(width, height, pixels);
      final bitmap = BinaryBitmap(HybridBinarizer(source));
      qrToken = _reader.decode(bitmap).text;
    } on ReaderException {
      return;
    } catch (_) {
      return;
    }

    if (qrToken.isEmpty) return;
    await _handleQrToken(qrToken);
  }

  Future<void> _handleQrToken(String qrToken) async {
    _scanTimer?.cancel();
    setState(() => _isProcessing = true);

    try {
      final entrega = await ref
          .read(moliendaRepositoryProvider)
          .getEntregaByQrToken(qrToken);

      if (!mounted) return;

      if (entrega == null) {
        CustomSnackBar.show(
          context,
          message: 'No se encontró ninguna entrega con este código QR',
          status: SnackbarStatus.error,
        );
        setState(() => _isProcessing = false);
        _startScanTimer();
        return;
      }

      _stopStream();
      context.pushReplacementNamed(
        'loteDetail',
        pathParameters: {'produccionId': entrega.produccionId},
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        message: 'Error al buscar la entrega',
        status: SnackbarStatus.error,
      );
      setState(() => _isProcessing = false);
      _startScanTimer();
    }
  }

  void _stopStream() {
    _scanTimer?.cancel();
    _stream?.getTracks().toDart.forEach((t) => t.stop());
    _stream = null;
  }

  void _switchCamera() {
    _initCamera(frontCamera: !_usingFrontCamera);
  }

  @override
  void dispose() {
    _stopStream();
    _videoElement?.srcObject = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.white54, size: 48),
              const SizedBox(height: 16),
              const Text(
                'No se pudo acceder a la cámara.\nVerifica los permisos del navegador.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Volver',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch_rounded),
            onPressed: _switchCamera,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_isInitialized) HtmlElementView(viewType: _viewId),

          if (!_isInitialized && !_hasError)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    'Iniciando cámara…',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),

          if (_isInitialized) const Center(child: _QrViewfinder()),

          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Buscando entrega…',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QrViewfinder extends StatelessWidget {
  const _QrViewfinder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
