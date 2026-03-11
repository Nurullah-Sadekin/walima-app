import 'dart:io';

import 'package:dio/dio.dart';

class UploadMediaRequestBody {
  UploadMediaRequestBody({
    required this.filePath,
    required this.alt,
    required this.caption,
    required this.description,
    this.isPrimary = true,
  });

  final String filePath;
  final String alt;
  final String caption;
  final String description;
  final bool isPrimary;

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
    });
  }
}
