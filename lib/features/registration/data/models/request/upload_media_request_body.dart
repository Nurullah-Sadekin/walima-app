import 'dart:io';

import 'package:dio/dio.dart';

class UploadMediaRequestBody {
  UploadMediaRequestBody({
    required this.filePath,
    required this.alt,
    required this.caption,
    required this.description,
    this.isPrimary = true,
    this.resourceType,
    this.resource,
  });

  final String filePath;
  final String alt;
  final String caption;
  final String description;
  final bool isPrimary;
  final String? resourceType;
  final String? resource;

  Future<FormData> toFormData() async {
    final normalizedPath = filePath.trim();
    final fileName = normalizedPath.split(Platform.pathSeparator).last;

    return FormData.fromMap({
      'file': await MultipartFile.fromFile(
        normalizedPath,
        filename: fileName,
      ),
      'alt': alt,
      'caption': caption,
      'description': description,
      'isPrimary': isPrimary.toString(),
      if (resourceType != null && resourceType!.trim().isNotEmpty)
        'resourceType': resourceType!.trim(),
      if (resource != null && resource!.trim().isNotEmpty)
        'resource': resource!.trim(),
    });
  }
}
