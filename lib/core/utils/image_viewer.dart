import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class ShowImage extends StatefulWidget {
  ///a [ShowImage] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  const ShowImage({
    super.key,
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
    this.placeHolder = 'assets/pngs/no_image.png',
    this.placeHolderWidget,
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

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: widget.alignment != null
          ? Align(
              alignment: widget.alignment!,
              child: _buildWidget(),
            )
          : _buildWidget(),
    );
  }

  Widget _buildWidget() {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  Widget _buildCircleImage() {
    if (widget.radius != null) {
      return ClipRRect(
        borderRadius: widget.radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  Widget _buildImageWithBorder() {
    if (widget.border != null) {
      return Container(
        decoration: BoxDecoration(
          border: widget.border,
          borderRadius: widget.radius,
        ),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (widget.imagePath != null) {
      switch (widget.imagePath!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: SvgPicture.asset(
              widget.imagePath!,
              height: widget.height,
              width: widget.width,
              fit: widget.fit ?? BoxFit.contain,
              // replaced deprecated 'color' with colorFilter for SvgPicture
              colorFilter: widget.color != null ? ColorFilter.mode(widget.color!, BlendMode.srcIn) : null,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(widget.imagePath!),
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.cover,
            // use color + colorBlendMode for tinting (compatible)
            color: widget.color,
            colorBlendMode: widget.color != null ? BlendMode.srcIn : BlendMode.srcIn,
          );
        case ImageType.network:
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
            child: Image.network(
              widget.imagePath ?? '',
              height: widget.height,
              width: widget.width,
              fit: widget.fit ?? BoxFit.cover,
              // use color + colorBlendMode for tinting
              color: widget.color,
              colorBlendMode: widget.color != null ? BlendMode.srcIn : BlendMode.srcIn,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: AppColors.primary,
                      height: widget.height,
                      width: widget.width,
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Center(
                  child: widget.errorImagePath != null
                      ? Image.asset(
                          widget.errorImagePath!,
                          height: widget.height,
                          width: widget.width,
                          fit: widget.fit ?? BoxFit.cover,
                          // use color + colorBlendMode for tinting
                          color: widget.color,
                          colorBlendMode: widget.color != null ? BlendMode.srcIn : BlendMode.srcIn,
                        )
                      : const Icon(Icons.production_quantity_limits),
                );
              },
            ),
          );
        case ImageType.png:
        default:
          return Image.asset(
            widget.imagePath!,
            height: widget.height,
            width: widget.width,
            fit: widget.fit ?? BoxFit.cover,
            // use color + colorBlendMode for tinting
            color: widget.color,
            colorBlendMode: widget.color != null ? BlendMode.srcIn : BlendMode.srcIn,
          );
      }
    } else {
      return widget.placeHolderWidget == null
          ? Image.asset(
              widget.placeHolder,
              height: widget.height,
              width: widget.width,
              fit: widget.fit ?? BoxFit.cover,
              // use color + colorBlendMode for tinting
              color: widget.color,
              colorBlendMode: widget.color != null ? BlendMode.srcIn : BlendMode.srcIn,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return ShowImage(imagePath: widget.placeHolder, fit: BoxFit.contain, height: 16, width: 16);
              },
            )
          : widget.placeHolderWidget!;
    }
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (startsWith('file://')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }
