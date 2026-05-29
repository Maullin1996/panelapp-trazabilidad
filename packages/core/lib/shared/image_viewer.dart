import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/shared/utils/spacing.dart';
import 'package:core/shared/widgets/stage_image_widget.dart';

class ImageViewer extends StatelessWidget {
  final String image;
  const ImageViewer({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: StageImageWidget(imageUrl: image)),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.close, size: 60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
