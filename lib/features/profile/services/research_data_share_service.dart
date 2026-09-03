import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../research/services/research_data_export_service.dart';

class ResearchDataShareService {
  const ResearchDataShareService({required this.exportService});

  final ResearchDataExportService exportService;

  Future<void> createAndShare({required Rect shareOrigin}) async {
    late final File exportFile;
    try {
      final export = await exportService.createExport();
      final exportDirectory = await getTemporaryDirectory();
      exportFile = File(p.join(exportDirectory.path, export.fileName));
      await exportFile.writeAsString(export.contents, flush: true);
    } on StateError {
      rethrow;
    } catch (error) {
      throw ResearchDataShareException(
        stage: ResearchDataShareStage.preparing,
        cause: error,
      );
    }

    try {
      await SharePlus.instance.share(
        ShareParams(
          title: 'Cal research data',
          subject: 'Cal research data export',
          files: [XFile(exportFile.path, mimeType: 'application/json')],
          sharePositionOrigin: shareOrigin,
        ),
      );
    } catch (error) {
      throw ResearchDataShareException(
        stage: ResearchDataShareStage.sharing,
        cause: error,
      );
    }
  }
}

enum ResearchDataShareStage { preparing, sharing }

class ResearchDataShareException implements Exception {
  const ResearchDataShareException({required this.stage, required this.cause});

  final ResearchDataShareStage stage;
  final Object cause;

  @override
  String toString() => 'ResearchDataShareException($stage, $cause)';
}
