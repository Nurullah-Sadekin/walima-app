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
    this.isTrailing = false,
    this.trailingText,
    this.onTrailingTap,
    this.isShowAppbar,
  });
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final double verticalPadding;
  final double spacing;
  final bool? isTrailing;
  final String? trailingText;
  final VoidCallback? onTrailingTap;
  final bool? isShowAppbar;




  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         isShowAppbar ?? true
             ? CustomBackAppBar(
              isTrailing: isTrailing,
              trailingText: trailingText,
              onTrailingTap: onTrailingTap,
              isShowAppbar: isShowAppbar ?? true,
            ) : const  SizedBox.shrink(),
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