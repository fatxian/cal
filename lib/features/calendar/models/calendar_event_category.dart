enum CalendarEventCategory {
  focus('Focus'),
  social('Social'),
  exercise('Exercise'),
  rest('Rest'),
  lifeAdmin('Life Admin'),
  notSure('Not sure');

  const CalendarEventCategory(this.label);

  final String label;
}
