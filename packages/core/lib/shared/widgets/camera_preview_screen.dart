import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../utils/tokens.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({super.key});

  @override
  State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen>
    with SingleTickerProviderStateMixin {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  String? _previewImagePath;
  late AnimationController _shutterAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _shutterAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.85,
      upperBound: 1.0,
      value: 1.0,
    );
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    await _initializeControllerFuture;
    if (mounted) setState(() => _isCameraInitialized = true);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _shutterAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      // Animación del obturador
      await _shutterAnimation.reverse();
      await _shutterAnimation.forward();
      HapticFeedback.lightImpact();

      final directory = await getTemporaryDirectory();
      final imagePath = path.join(directory.path, '${DateTime.now()}.jpg');
      final file = await _controller.takePicture();
      await file.saveTo(imagePath);
      if (mounted) setState(() => _previewImagePath = imagePath);
    } catch (_) {}
  }

  void _cancelPreview() => setState(() => _previewImagePath = null);

  void _confirmPhoto() {
    if (_previewImagePath != null) Navigator.pop(context, _previewImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _isCameraInitialized
            ? _previewImagePath != null
                  ? _PreviewView(
                      imagePath: _previewImagePath!,
                      onConfirm: _confirmPhoto,
                      onRetake: _cancelPreview,
                    )
                  : _CaptureView(
                      controller: _controller,
                      shutterAnimation: _shutterAnimation,
                      onCapture: _takePicture,
                      onClose: () => Navigator.pop(context),
                    )
            : const _LoadingView(),
      ),
    );
  }
}

// ── Vista: cargando cámara ──────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
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
    );
  }
}

// ── Vista: captura ──────────────────────────────────────────────────────────

class _CaptureView extends StatelessWidget {
  final CameraController controller;
  final AnimationController shutterAnimation;
  final VoidCallback onCapture;
  final VoidCallback onClose;

  const _CaptureView({
    required this.controller,
    required this.shutterAnimation,
    required this.onCapture,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Preview de cámara
        CameraPreview(controller),

        // Esquinas decorativas (visor)
        const Positioned.fill(child: _ViewfinderCorners()),

        // Barra inferior
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
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
                stops: [0.0, 1.0],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Cerrar
                _CircleAction(
                  icon: Icons.close_rounded,
                  size: 22,
                  onTap: onClose,
                ),

                // Obturador
                ScaleTransition(
                  scale: shutterAnimation,
                  child: _ShutterButton(onTap: onCapture),
                ),

                // Placeholder simétrico
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Vista: previsualización ─────────────────────────────────────────────────

class _PreviewView extends StatelessWidget {
  final String imagePath;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  const _PreviewView({
    required this.imagePath,
    required this.onConfirm,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagen
        Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        // Etiqueta superior
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 0,
          right: 0,
          child: const Center(child: _PillLabel(text: 'Vista previa')),
        ),

        // Barra de acciones inferior
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              40,
              28,
              40,
              MediaQuery.of(context).padding.bottom + 36,
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
              children: [
                // Repetir
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CircleAction(
                      icon: Icons.refresh_rounded,
                      size: 24,
                      onTap: onRetake,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Repetir',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),

                // Usar foto
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CircleAction(
                      key: const Key('camera-preview-screen-confirme-photo'),
                      icon: Icons.check_rounded,
                      size: 28,
                      filled: true,
                      onTap: onConfirm,
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
        ),
      ],
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
      key: const Key('camera-preview-screen-take-photo'),
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
    super.key,
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

class _ViewfinderCorners extends StatelessWidget {
  const _ViewfinderCorners();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _CornersPainter());
  }
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(200)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const margin = 44.0;
    const cornerLen = 22.0;
    final r = margin.toDouble();

    // Esquina superior izquierda
    canvas.drawLine(Offset(r, margin + cornerLen), Offset(r, margin), paint);
    canvas.drawLine(Offset(margin, r), Offset(margin + cornerLen, r), paint);

    // Esquina superior derecha
    canvas.drawLine(
      Offset(size.width - r, margin),
      Offset(size.width - r, margin + cornerLen),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, r),
      Offset(size.width - margin - cornerLen, r),
      paint,
    );

    // Esquina inferior izquierda
    canvas.drawLine(
      Offset(r, size.height - margin),
      Offset(r, size.height - margin - cornerLen),
      paint,
    );
    canvas.drawLine(
      Offset(margin, size.height - r),
      Offset(margin + cornerLen, size.height - r),
      paint,
    );

    // Esquina inferior derecha
    canvas.drawLine(
      Offset(size.width - r, size.height - margin),
      Offset(size.width - r, size.height - margin - cornerLen),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, size.height - r),
      Offset(size.width - margin - cornerLen, size.height - r),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
