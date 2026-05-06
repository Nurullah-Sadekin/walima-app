
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:walima_llc/core/config/text_responsive.dart';
import 'package:walima_llc/core/constants/app_colors.dart';
import 'package:walima_llc/core/constants/app_image.dart';
import 'package:walima_llc/core/utils/image_viewer.dart';

class ImageCarousel extends StatefulWidget {

  const ImageCarousel({
    super.key,
    required this.images,
    this.height,
    this.viewportFraction = 1.0,
    this.autoPlay = false,
    this.showDots = true,
    this.showCounter = true,
    this.enlargeCenterPage = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.dotActiveColor,
    this.dotInactiveColor,
    this.dotSize,
    this.activeDotWidth,
    this.counterPadding,
    this.imageBorderRadius,
  });

  final List<CarouselImage> images;
  final double? height;
  final double viewportFraction;
  final bool autoPlay;
  final bool showDots;
  final bool showCounter;
  final bool enlargeCenterPage;
  final Duration autoPlayInterval;
  final Color? dotActiveColor;
  final Color? dotInactiveColor;
  final double? dotSize;
  final double? activeDotWidth;
  final EdgeInsetsGeometry? counterPadding;
  final BorderRadiusGeometry? imageBorderRadius;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final dotActiveColor = widget.dotActiveColor ?? AppColors.primary;
    final dotInactiveColor = widget.dotInactiveColor ?? AppColors.disable;
    final dotSize = widget.dotSize ?? 10.0;
    final activeDotWidth = widget.activeDotWidth ?? 20.0;
    final borderRadius = widget.imageBorderRadius ?? BorderRadius.circular(12);

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final height = widget.height ??
                MediaQuery.of(context).size.height * 0.65;

            return CarouselSlider.builder(
              itemCount: widget.images.length,
              itemBuilder: (context, index, realIndex) {
                final imageData = widget.images[index];
                return ClipRRect(
                  borderRadius: borderRadius,
                  child: Stack(
                    children: [
                      // Base image
                      ShowImage(
                        imagePath: imageData.imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: height,
                      ),

                      // Blur overlay if enabled
                      if (imageData.isBlur)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: borderRadius,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.disable,
                                  borderRadius: borderRadius,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // Counter overlay
                      if (widget.showCounter)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: widget.counterPadding ??
                                const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.disableDark,
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Row(
                              spacing: 4,
                              children: [
                                ShowImage(
                                  imagePath: AppImages.photoIcon,
                                  width: TextSize.font14(context),
                                  height: TextSize.font14(context),
                                  fit: BoxFit.fitWidth,
                                  color: AppColors.white,
                                ),
                                Text(
                                  '${index + 1}/${widget.images.length}',
                                  style: TextStyle(
                                    fontSize: TextSize.font12(context),
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: widget.autoPlay,
                autoPlayInterval: widget.autoPlayInterval,
                enlargeCenterPage: widget.enlargeCenterPage,
                viewportFraction: widget.viewportFraction,
                height: height,
                onPageChanged: (index, reason) =>
                    setState(() => _currentImageIndex = index),
              ),
            );
          },
        ),

        // Dots indicator
        if (widget.showDots)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                final isActive = _currentImageIndex == index;
                final dotWidth = isActive ? activeDotWidth : dotSize;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: dotWidth,
                  height: dotSize,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(dotSize / 2),
                    color: isActive ? dotActiveColor : dotInactiveColor,
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

// Model class for carousel images
class CarouselImage {

  const CarouselImage({
    required this.imagePath,
    this.isBlur = false,
  });
  final String imagePath;
  final bool isBlur;
}