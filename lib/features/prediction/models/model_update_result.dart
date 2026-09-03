enum ModelUpdateStatus {
  updated,
  notEnoughSamples,
  missingClassBalance,
  trainingFailed,
}

class ModelUpdateResult {
  const ModelUpdateResult({
    required this.status,
    required this.sampleCount,
    this.message,
  });

  final ModelUpdateStatus status;
  final int sampleCount;
  final String? message;

  bool get didUpdate => status == ModelUpdateStatus.updated;
}
