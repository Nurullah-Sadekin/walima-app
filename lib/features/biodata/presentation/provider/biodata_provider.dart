import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:walima_llc/core/providers/base_change_notifier.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/features/biodata/data/repository/biodata_repository.dart';
import 'package:walima_llc/features/biodata/domain/model/biodata_document.dart';
import 'package:walima_llc/features/biodata/domain/utils/biodata_formatter.dart';
import 'package:walima_llc/features/biodata/domain/utils/biodata_pdf_builder.dart';

class BioDataProvider extends BaseChangeNotifier {
  BiodataDocument? biodata;
  BiodataTemplate selectedTemplate = BiodataTemplate.mainBioData;
  BioDataScreenState screenState = BioDataScreenState.loading;
  bool isGenerating = false;
  String? errorMessage;

  bool get isLoading => screenState == BioDataScreenState.loading;

  Future<void> loadBiodata() async {
    screenState = BioDataScreenState.loading;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await BiodataRepository.getBiodataProfile();
      biodata = BiodataFormatter.fromApi(data);
      screenState = BioDataScreenState.complete;
    } catch (error) {
      biodata = null;
      errorMessage = error.toString().replaceFirst('Exception: ', '');
      screenState = BioDataScreenState.complete;
    }

    notifyListeners();
  }

  void selectTemplate(BiodataTemplate template) {
    if (selectedTemplate == template) return;
    selectedTemplate = template;
    notifyListeners();
  }

  Future<Uint8List> buildPdf() {
    final currentBiodata = biodata;
    if (currentBiodata == null) {
      throw StateError('Biodata is not loaded');
    }
    return BiodataPdfBuilder.build(
      biodata: currentBiodata,
      template: selectedTemplate,
    );
  }

  Future<void> sharePdf(BuildContext context) async {
    await _runPdfAction(context, () async {
      final currentBiodata = biodata!;
      final bytes = await buildPdf();
      await Printing.sharePdf(
        bytes: bytes,
        filename: BiodataPdfBuilder.fileNameFor(currentBiodata),
      );
    });
  }

  Future<void> savePdf(BuildContext context) async {
    await _runPdfAction(context, () async {
      final currentBiodata = biodata!;
      await Printing.layoutPdf(
        name: BiodataPdfBuilder.fileNameFor(currentBiodata),
        onLayout: (_) => buildPdf(),
      );
    });
  }

  Future<void> _runPdfAction(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    if (biodata == null || isGenerating) return;
    isGenerating = true;
    notifyListeners();

    try {
      await action();
    } catch (_) {
      if (!context.mounted) return;
      await DialogUtils.showErrorDialog(
        context: context,
        message: 'Unable to generate biodata PDF. Please try again.',
      );
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }
}

enum BioDataScreenState {
  loading,
  complete,
}
