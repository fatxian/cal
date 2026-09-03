import '../models/model_update_result.dart';
import '../models/training_sample.dart';
import 'batch_logistic_trainer.dart';
import 'energy_model_service.dart';
import 'prediction_dataset_service.dart';

class PersonalisedModelUpdateService {
  const PersonalisedModelUpdateService({
    required this.datasetService,
    required this.energyModelService,
    this.trainer = const BatchLogisticTrainer(),
  });

  final PredictionDatasetService datasetService;
  final EnergyModelService energyModelService;
  final BatchLogisticTrainer trainer;

  Future<ModelUpdateResult> updateModelIfReady({DateTime? updatedAt}) async {
    final samples = await datasetService.loadCompletedSamples();
    // require at least seven observations and both binary outcome classes
    // before retraining from all accumulated samples
    final readiness = _checkReadiness(samples);
    if (readiness != null) return readiness;

    try {
      final personalisedModel = trainer.train(samples);

      await energyModelService.saveActiveModel(
        parameters: personalisedModel,
        modelSource: EnergyModelSource.personalisedLogistic,
        savedAt: updatedAt,
      );

      return ModelUpdateResult(
        status: ModelUpdateStatus.updated,
        sampleCount: samples.length,
      );
    } catch (error) {
      return ModelUpdateResult(
        status: ModelUpdateStatus.trainingFailed,
        sampleCount: samples.length,
        message: error.toString(),
      );
    }
  }

  ModelUpdateResult? _checkReadiness(List<TrainingSample> samples) {
    if (samples.length < trainer.minimumSampleCount) {
      return ModelUpdateResult(
        status: ModelUpdateStatus.notEnoughSamples,
        sampleCount: samples.length,
      );
    }

    final labels = samples.map((sample) => sample.lowEnergyLabel).toSet();
    if (!labels.contains(0) || !labels.contains(1)) {
      return ModelUpdateResult(
        status: ModelUpdateStatus.missingClassBalance,
        sampleCount: samples.length,
      );
    }

    return null;
  }
}
