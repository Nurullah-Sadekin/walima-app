import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/global/components/custom_back_appbar.dart';
import 'package:flutter_boilerplate/core/utils/image_viewer.dart';

class UpperLayer extends StatelessWidget { // Additional children to add below

  const UpperLayer({
    super.key,
    required this.imagePath,
    this.imageWidth = 110,
    this.imageHeight = 110,
    this.verticalPadding = 16.0,
    this.spacing = 10.0,

  });
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final double verticalPadding;
  final double spacing;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomBackAppBar(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ShowImage(
            imagePath: imagePath,
            width: imageWidth,
            height: imageHeight,
          ),
        ),
        SizedBox(height: spacing),
      ],
    );
  }
}