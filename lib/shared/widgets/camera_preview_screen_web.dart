import 'dart:typed_data';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import '../../core/theme/utils/tokens.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  web.HTMLVideoElement? _videoElement;
  web.MediaStream? _stream;
  bool _isInitialized = false;
  bool _hasError = false;
  Uint8List? _capturedBytes;
  bool _usingFrontCamera = false;
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'camera-preview-$hashCode';

    // Crear el video element una sola vez
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

      // Siempre reutilizamos el mismo videoElement
      _videoElement!.srcObject = stream;
      await _videoElement!.play().toDart;

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _usingFrontCamera = frontCamera;
        });
      }
    } catch (e) {
      debugPrint('Error iniciando cámara web: $e');
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _capturePhoto() {
    final video = _videoElement;
    if (video == null) return;

    final canvas = web.HTMLCanvasElement();
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;

    final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
    ctx.drawImage(video, 0, 0);

    final dataUrl = canvas.toDataURL('image/jpeg', 0.85.toJS);
    final base64Str = dataUrl.substring(dataUrl.indexOf(',') + 1);
    final bytes = base64Decode(base64Str);
    setState(() => _capturedBytes = bytes);
  }

  void _retake() => setState(() => _capturedBytes = null);

  void _confirm() {
    if (_capturedBytes == null) return;
    _stopStream();
    final base64Str = base64Encode(_capturedBytes!);
    Navigator.pop(context, 'data:image/jpeg;base64,$base64Str');
  }

  void _stopStream() {
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Video siempre en el árbol ──
          if (_isInitialized) HtmlElementView(viewType: _viewId),

          // ── Loading ──
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

          // ── Preview encima del video ──
          if (_capturedBytes != null)
            Positioned.fill(
              child: Image.memory(_capturedBytes!, fit: BoxFit.cover),
            ),

          // ── UI: preview confirmación ──
          if (_capturedBytes != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 0,
              right: 0,
              child: const Center(child: _PillLabel(text: 'Vista previa')),
            ),

          if (_capturedBytes != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomBar(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CircleAction(
                        icon: Icons.refresh_rounded,
                        size: 24,
                        onTap: _retake,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Repetir',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CircleAction(
                        icon: Icons.check_rounded,
                        size: 28,
                        filled: true,
                        onTap: _confirm,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Usar foto',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // ── UI: captura ──
          if (_capturedBytes == null && _isInitialized)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomBar(
                children: [
                  _CircleAction(
                    icon: Icons.close_rounded,
                    size: 22,
                    onTap: () {
                      _stopStream();
                      Navigator.pop(context);
                    },
                  ),
                  _ShutterButton(onTap: _capturePhoto),
                  _CircleAction(
                    icon: Icons.cameraswitch_rounded,
                    size: 22,
                    onTap: _switchCamera,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Bottom bar ──────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final List<Widget> children;
  const _BottomBar({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        32,
        20,
        32,
        MediaQuery.of(context).padding.bottom + 28,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

// ── Widgets de apoyo ────────────────────────────────────────────────────────

class _ShutterButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ShutterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final bool filled;

  const _CircleAction({
    required this.icon,
    required this.onTap,
    this.size = 22,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled
              ? AppColors.primaryPanelaBrown
              : Colors.white.withAlpha(30),
          border: Border.all(
            color: filled
                ? AppColors.primaryPanelaBrown
                : Colors.white.withAlpha(80),
            width: 1.5,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}

class _PillLabel extends StatelessWidget {
  final String text;
  const _PillLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
