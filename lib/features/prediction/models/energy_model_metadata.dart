class EnergyModelMetadata {
  const EnergyModelMetadata({
    required this.modelVersion,
    required this.modelSource,
    required this.featureVersion,
    required this.targetVersion,
    required this.createdAt,
  });

  final String modelVersion;
  final String modelSource;
  final String featureVersion;
  final String targetVersion;
  final DateTime createdAt;
}
