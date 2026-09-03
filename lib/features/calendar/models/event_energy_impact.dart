enum EventEnergyImpact {
  decreased(1, 'Decreased'),
  unchanged(2, 'No change'),
  increased(3, 'Increased');

  const EventEnergyImpact(this.score, this.label);

  final int score;
  final String label;

  static EventEnergyImpact? fromScore(int? score) {
    if (score == null) return null;

    for (final value in EventEnergyImpact.values) {
      if (value.score == score) return value;
    }

    return null;
  }
}
