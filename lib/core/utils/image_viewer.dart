import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class ShowImage extends StatelessWidget {

  ///a [ShowImage] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  const ShowImage({super.key,
    this.imagePath,
    this.errorImagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'packages/sheba_pay_sdk/assets/images/image_not_found.png',
    this.placeHolderWidget,
    this.isCircle = false,
  });
  final String? imagePath;
  final String? errorImagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final Widget? placeHolderWidget;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: alignment != null
          ? Align(
        alignment: alignment!,
        child: _buildWidget(),
      )
          : _buildWidget(),
    );
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    // If isCircle is true render a circular image (ignore radius in that case)
    if (isCircle) {
      if (border != null) {
        // If border provided, apply circular BoxDecoration and clip image with ClipOval
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: border,
          ),
          child: ClipOval(child: _buildImageView()),
        );
      } else {
        return ClipOval(child: _buildImageView());
      }
    }

    // Default (non-circle) behavior: preserve existing rounded-rect logic
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
        case ImageType.network:
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
            child: Image.network(
              imagePath ?? "",
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              color: color,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Image.asset(
                      "packages/sheba_pay_sdk/assets/images/profile_placeholder.png",
                      fit: BoxFit.fill,
                      height: height,
                      width: width,
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Center(
                  child: errorImagePath != null
                      ? Image.asset(
                          errorImagePath!,
                          height: height,
                          width: width,
                          fit: fit ?? BoxFit.cover,
                          color: color,
                        )
                      : const Icon(Icons.production_quantity_limits),
                );
              },
            ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          );
      }
    } else {
      return placeHolderWidget == null
          ? Image.asset(
              placeHolder,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              color: color,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return ShowImage(imagePath: placeHolder, fit: BoxFit.contain, height: 16, width: 16);
              },
            )
          : placeHolderWidget!;
    }
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      return ImageType.network;
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }
