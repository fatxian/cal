import '../../calendar/models/calendar_event_category.dart';

class RuleBasedCategoryService {
  const RuleBasedCategoryService();

  CalendarEventCategory? suggestCategory(String title) {
    final lowerTitle = title.toLowerCase();

    if (_containsAny(lowerTitle, [
      'gym',
      'run',
      'workout',
      'exercise',
      'walk',
      'yoga',
    ])) {
      return CalendarEventCategory.exercise;
    }

    if (_containsAny(lowerTitle, [
      'rest',
      'break',
      'nap',
      'recovery',
      'meditation',
    ])) {
      return CalendarEventCategory.rest;
    }

    if (_containsAny(lowerTitle, [
      'friend',
      'rocky',
      'social',
      'party',
      'hangout',
      'date night',
    ])) {
      return CalendarEventCategory.social;
    }

    if (_containsAny(lowerTitle, [
      'meeting',
      'seminar',
      'supervisor',
      'tutorial',
      'study',
      'dissertation',
      'research',
      'library',
      'coursework',
      'project',
      'lecture',
      'class',
      'work',
      'shift',
      'barista',
      'job',
      'creative',
      'writing',
    ])) {
      return CalendarEventCategory.focus;
    }

    if (_containsAny(lowerTitle, [
      'lunch',
      'dinner',
      'coffee',
      'brunch',
      'meal',
      'doctor',
      'therapy',
      'dentist',
      'health',
      'appointment',
      'errand',
      'admin',
      'shopping',
      'groceries',
      'laundry',
    ])) {
      return CalendarEventCategory.lifeAdmin;
    }

    return null;
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }
}
