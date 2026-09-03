class EnergyMood {
  const EnergyMood({required this.assetPath, required this.label});

  final String assetPath;
  final String label;

  static EnergyMood fromScore(int score) {
    return switch (score) {
      1 => const EnergyMood(
        assetPath: 'assets/images/emoji_1.png',
        label: 'Running on empty',
      ),
      2 => const EnergyMood(
        assetPath: 'assets/images/emoji_2.png',
        label: 'Pretty drained',
      ),
      3 => const EnergyMood(
        assetPath: 'assets/images/emoji_3.png',
        label: 'Hanging in there',
      ),
      4 => const EnergyMood(
        assetPath: 'assets/images/emoji_4.png',
        label: 'Feeling good',
      ),
      _ => const EnergyMood(
        assetPath: 'assets/images/emoji_5.png',
        label: 'Full of energy',
      ),
    };
  }
}
