class ResearchDataExport {
  const ResearchDataExport({
    required this.participantCode,
    required this.fileName,
    required this.contents,
  });

  final String participantCode;
  final String fileName;
  final String contents;
}
