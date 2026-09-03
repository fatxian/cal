// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EventUserDataItemsTable extends EventUserDataItems
    with TableInfo<$EventUserDataItemsTable, EventUserDataItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventUserDataItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventKeyMeta = const VerificationMeta(
    'eventKey',
  );
  @override
  late final GeneratedColumn<String> eventKey = GeneratedColumn<String>(
    'event_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyImpactScoreMeta = const VerificationMeta(
    'energyImpactScore',
  );
  @override
  late final GeneratedColumn<int> energyImpactScore = GeneratedColumn<int>(
    'energy_impact_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventKey,
    source,
    externalId,
    date,
    category,
    energyImpactScore,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_user_data_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventUserDataItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_key')) {
      context.handle(
        _eventKeyMeta,
        eventKey.isAcceptableOrUnknown(data['event_key']!, _eventKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_eventKeyMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('energy_impact_score')) {
      context.handle(
        _energyImpactScoreMeta,
        energyImpactScore.isAcceptableOrUnknown(
          data['energy_impact_score']!,
          _energyImpactScoreMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventUserDataItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventUserDataItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_key'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      energyImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_impact_score'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EventUserDataItemsTable createAlias(String alias) {
    return $EventUserDataItemsTable(attachedDatabase, alias);
  }
}

class EventUserDataItem extends DataClass
    implements Insertable<EventUserDataItem> {
  final int id;
  final String eventKey;
  final String source;
  final String? externalId;
  final String date;
  final String? category;
  final int? energyImpactScore;
  final DateTime updatedAt;
  const EventUserDataItem({
    required this.id,
    required this.eventKey,
    required this.source,
    this.externalId,
    required this.date,
    this.category,
    this.energyImpactScore,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_key'] = Variable<String>(eventKey);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || energyImpactScore != null) {
      map['energy_impact_score'] = Variable<int>(energyImpactScore);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EventUserDataItemsCompanion toCompanion(bool nullToAbsent) {
    return EventUserDataItemsCompanion(
      id: Value(id),
      eventKey: Value(eventKey),
      source: Value(source),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      date: Value(date),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      energyImpactScore: energyImpactScore == null && nullToAbsent
          ? const Value.absent()
          : Value(energyImpactScore),
      updatedAt: Value(updatedAt),
    );
  }

  factory EventUserDataItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventUserDataItem(
      id: serializer.fromJson<int>(json['id']),
      eventKey: serializer.fromJson<String>(json['eventKey']),
      source: serializer.fromJson<String>(json['source']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      date: serializer.fromJson<String>(json['date']),
      category: serializer.fromJson<String?>(json['category']),
      energyImpactScore: serializer.fromJson<int?>(json['energyImpactScore']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventKey': serializer.toJson<String>(eventKey),
      'source': serializer.toJson<String>(source),
      'externalId': serializer.toJson<String?>(externalId),
      'date': serializer.toJson<String>(date),
      'category': serializer.toJson<String?>(category),
      'energyImpactScore': serializer.toJson<int?>(energyImpactScore),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EventUserDataItem copyWith({
    int? id,
    String? eventKey,
    String? source,
    Value<String?> externalId = const Value.absent(),
    String? date,
    Value<String?> category = const Value.absent(),
    Value<int?> energyImpactScore = const Value.absent(),
    DateTime? updatedAt,
  }) => EventUserDataItem(
    id: id ?? this.id,
    eventKey: eventKey ?? this.eventKey,
    source: source ?? this.source,
    externalId: externalId.present ? externalId.value : this.externalId,
    date: date ?? this.date,
    category: category.present ? category.value : this.category,
    energyImpactScore: energyImpactScore.present
        ? energyImpactScore.value
        : this.energyImpactScore,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EventUserDataItem copyWithCompanion(EventUserDataItemsCompanion data) {
    return EventUserDataItem(
      id: data.id.present ? data.id.value : this.id,
      eventKey: data.eventKey.present ? data.eventKey.value : this.eventKey,
      source: data.source.present ? data.source.value : this.source,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      energyImpactScore: data.energyImpactScore.present
          ? data.energyImpactScore.value
          : this.energyImpactScore,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventUserDataItem(')
          ..write('id: $id, ')
          ..write('eventKey: $eventKey, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('energyImpactScore: $energyImpactScore, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventKey,
    source,
    externalId,
    date,
    category,
    energyImpactScore,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventUserDataItem &&
          other.id == this.id &&
          other.eventKey == this.eventKey &&
          other.source == this.source &&
          other.externalId == this.externalId &&
          other.date == this.date &&
          other.category == this.category &&
          other.energyImpactScore == this.energyImpactScore &&
          other.updatedAt == this.updatedAt);
}

class EventUserDataItemsCompanion extends UpdateCompanion<EventUserDataItem> {
  final Value<int> id;
  final Value<String> eventKey;
  final Value<String> source;
  final Value<String?> externalId;
  final Value<String> date;
  final Value<String?> category;
  final Value<int?> energyImpactScore;
  final Value<DateTime> updatedAt;
  const EventUserDataItemsCompanion({
    this.id = const Value.absent(),
    this.eventKey = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.energyImpactScore = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EventUserDataItemsCompanion.insert({
    this.id = const Value.absent(),
    required String eventKey,
    required String source,
    this.externalId = const Value.absent(),
    required String date,
    this.category = const Value.absent(),
    this.energyImpactScore = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : eventKey = Value(eventKey),
       source = Value(source),
       date = Value(date);
  static Insertable<EventUserDataItem> custom({
    Expression<int>? id,
    Expression<String>? eventKey,
    Expression<String>? source,
    Expression<String>? externalId,
    Expression<String>? date,
    Expression<String>? category,
    Expression<int>? energyImpactScore,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventKey != null) 'event_key': eventKey,
      if (source != null) 'source': source,
      if (externalId != null) 'external_id': externalId,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (energyImpactScore != null) 'energy_impact_score': energyImpactScore,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EventUserDataItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? eventKey,
    Value<String>? source,
    Value<String?>? externalId,
    Value<String>? date,
    Value<String?>? category,
    Value<int?>? energyImpactScore,
    Value<DateTime>? updatedAt,
  }) {
    return EventUserDataItemsCompanion(
      id: id ?? this.id,
      eventKey: eventKey ?? this.eventKey,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      date: date ?? this.date,
      category: category ?? this.category,
      energyImpactScore: energyImpactScore ?? this.energyImpactScore,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventKey.present) {
      map['event_key'] = Variable<String>(eventKey.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (energyImpactScore.present) {
      map['energy_impact_score'] = Variable<int>(energyImpactScore.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventUserDataItemsCompanion(')
          ..write('id: $id, ')
          ..write('eventKey: $eventKey, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('energyImpactScore: $energyImpactScore, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CachedCalendarEventItemsTable extends CachedCalendarEventItems
    with TableInfo<$CachedCalendarEventItemsTable, CachedCalendarEventItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCalendarEventItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventKeyMeta = const VerificationMeta(
    'eventKey',
  );
  @override
  late final GeneratedColumn<String> eventKey = GeneratedColumn<String>(
    'event_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyImpactScoreMeta = const VerificationMeta(
    'energyImpactScore',
  );
  @override
  late final GeneratedColumn<int> energyImpactScore = GeneratedColumn<int>(
    'energy_impact_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAllDayMeta = const VerificationMeta(
    'isAllDay',
  );
  @override
  late final GeneratedColumn<bool> isAllDay = GeneratedColumn<bool>(
    'is_all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventKey,
    source,
    externalId,
    date,
    title,
    startTime,
    endTime,
    category,
    energyImpactScore,
    isAllDay,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_calendar_event_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCalendarEventItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_key')) {
      context.handle(
        _eventKeyMeta,
        eventKey.isAcceptableOrUnknown(data['event_key']!, _eventKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_eventKeyMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('energy_impact_score')) {
      context.handle(
        _energyImpactScoreMeta,
        energyImpactScore.isAcceptableOrUnknown(
          data['energy_impact_score']!,
          _energyImpactScoreMeta,
        ),
      );
    }
    if (data.containsKey('is_all_day')) {
      context.handle(
        _isAllDayMeta,
        isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCalendarEventItem map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCalendarEventItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_key'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      energyImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_impact_score'],
      ),
      isAllDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_all_day'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedCalendarEventItemsTable createAlias(String alias) {
    return $CachedCalendarEventItemsTable(attachedDatabase, alias);
  }
}

class CachedCalendarEventItem extends DataClass
    implements Insertable<CachedCalendarEventItem> {
  final int id;
  final String eventKey;
  final String source;
  final String? externalId;
  final String date;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String? category;
  final int? energyImpactScore;
  final bool isAllDay;
  final DateTime updatedAt;
  const CachedCalendarEventItem({
    required this.id,
    required this.eventKey,
    required this.source,
    this.externalId,
    required this.date,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.category,
    this.energyImpactScore,
    required this.isAllDay,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_key'] = Variable<String>(eventKey);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || externalId != null) {
      map['external_id'] = Variable<String>(externalId);
    }
    map['date'] = Variable<String>(date);
    map['title'] = Variable<String>(title);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || energyImpactScore != null) {
      map['energy_impact_score'] = Variable<int>(energyImpactScore);
    }
    map['is_all_day'] = Variable<bool>(isAllDay);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedCalendarEventItemsCompanion toCompanion(bool nullToAbsent) {
    return CachedCalendarEventItemsCompanion(
      id: Value(id),
      eventKey: Value(eventKey),
      source: Value(source),
      externalId: externalId == null && nullToAbsent
          ? const Value.absent()
          : Value(externalId),
      date: Value(date),
      title: Value(title),
      startTime: Value(startTime),
      endTime: Value(endTime),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      energyImpactScore: energyImpactScore == null && nullToAbsent
          ? const Value.absent()
          : Value(energyImpactScore),
      isAllDay: Value(isAllDay),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedCalendarEventItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCalendarEventItem(
      id: serializer.fromJson<int>(json['id']),
      eventKey: serializer.fromJson<String>(json['eventKey']),
      source: serializer.fromJson<String>(json['source']),
      externalId: serializer.fromJson<String?>(json['externalId']),
      date: serializer.fromJson<String>(json['date']),
      title: serializer.fromJson<String>(json['title']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      category: serializer.fromJson<String?>(json['category']),
      energyImpactScore: serializer.fromJson<int?>(json['energyImpactScore']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventKey': serializer.toJson<String>(eventKey),
      'source': serializer.toJson<String>(source),
      'externalId': serializer.toJson<String?>(externalId),
      'date': serializer.toJson<String>(date),
      'title': serializer.toJson<String>(title),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'category': serializer.toJson<String?>(category),
      'energyImpactScore': serializer.toJson<int?>(energyImpactScore),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedCalendarEventItem copyWith({
    int? id,
    String? eventKey,
    String? source,
    Value<String?> externalId = const Value.absent(),
    String? date,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    Value<String?> category = const Value.absent(),
    Value<int?> energyImpactScore = const Value.absent(),
    bool? isAllDay,
    DateTime? updatedAt,
  }) => CachedCalendarEventItem(
    id: id ?? this.id,
    eventKey: eventKey ?? this.eventKey,
    source: source ?? this.source,
    externalId: externalId.present ? externalId.value : this.externalId,
    date: date ?? this.date,
    title: title ?? this.title,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    category: category.present ? category.value : this.category,
    energyImpactScore: energyImpactScore.present
        ? energyImpactScore.value
        : this.energyImpactScore,
    isAllDay: isAllDay ?? this.isAllDay,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedCalendarEventItem copyWithCompanion(
    CachedCalendarEventItemsCompanion data,
  ) {
    return CachedCalendarEventItem(
      id: data.id.present ? data.id.value : this.id,
      eventKey: data.eventKey.present ? data.eventKey.value : this.eventKey,
      source: data.source.present ? data.source.value : this.source,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      category: data.category.present ? data.category.value : this.category,
      energyImpactScore: data.energyImpactScore.present
          ? data.energyImpactScore.value
          : this.energyImpactScore,
      isAllDay: data.isAllDay.present ? data.isAllDay.value : this.isAllDay,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCalendarEventItem(')
          ..write('id: $id, ')
          ..write('eventKey: $eventKey, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('energyImpactScore: $energyImpactScore, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventKey,
    source,
    externalId,
    date,
    title,
    startTime,
    endTime,
    category,
    energyImpactScore,
    isAllDay,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCalendarEventItem &&
          other.id == this.id &&
          other.eventKey == this.eventKey &&
          other.source == this.source &&
          other.externalId == this.externalId &&
          other.date == this.date &&
          other.title == this.title &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.category == this.category &&
          other.energyImpactScore == this.energyImpactScore &&
          other.isAllDay == this.isAllDay &&
          other.updatedAt == this.updatedAt);
}

class CachedCalendarEventItemsCompanion
    extends UpdateCompanion<CachedCalendarEventItem> {
  final Value<int> id;
  final Value<String> eventKey;
  final Value<String> source;
  final Value<String?> externalId;
  final Value<String> date;
  final Value<String> title;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String?> category;
  final Value<int?> energyImpactScore;
  final Value<bool> isAllDay;
  final Value<DateTime> updatedAt;
  const CachedCalendarEventItemsCompanion({
    this.id = const Value.absent(),
    this.eventKey = const Value.absent(),
    this.source = const Value.absent(),
    this.externalId = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.category = const Value.absent(),
    this.energyImpactScore = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CachedCalendarEventItemsCompanion.insert({
    this.id = const Value.absent(),
    required String eventKey,
    required String source,
    this.externalId = const Value.absent(),
    required String date,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    this.category = const Value.absent(),
    this.energyImpactScore = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : eventKey = Value(eventKey),
       source = Value(source),
       date = Value(date),
       title = Value(title),
       startTime = Value(startTime),
       endTime = Value(endTime);
  static Insertable<CachedCalendarEventItem> custom({
    Expression<int>? id,
    Expression<String>? eventKey,
    Expression<String>? source,
    Expression<String>? externalId,
    Expression<String>? date,
    Expression<String>? title,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? category,
    Expression<int>? energyImpactScore,
    Expression<bool>? isAllDay,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventKey != null) 'event_key': eventKey,
      if (source != null) 'source': source,
      if (externalId != null) 'external_id': externalId,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (category != null) 'category': category,
      if (energyImpactScore != null) 'energy_impact_score': energyImpactScore,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CachedCalendarEventItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? eventKey,
    Value<String>? source,
    Value<String?>? externalId,
    Value<String>? date,
    Value<String>? title,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<String?>? category,
    Value<int?>? energyImpactScore,
    Value<bool>? isAllDay,
    Value<DateTime>? updatedAt,
  }) {
    return CachedCalendarEventItemsCompanion(
      id: id ?? this.id,
      eventKey: eventKey ?? this.eventKey,
      source: source ?? this.source,
      externalId: externalId ?? this.externalId,
      date: date ?? this.date,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      energyImpactScore: energyImpactScore ?? this.energyImpactScore,
      isAllDay: isAllDay ?? this.isAllDay,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventKey.present) {
      map['event_key'] = Variable<String>(eventKey.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (energyImpactScore.present) {
      map['energy_impact_score'] = Variable<int>(energyImpactScore.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCalendarEventItemsCompanion(')
          ..write('id: $id, ')
          ..write('eventKey: $eventKey, ')
          ..write('source: $source, ')
          ..write('externalId: $externalId, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('energyImpactScore: $energyImpactScore, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ManualCalendarEventItemsTable extends ManualCalendarEventItems
    with TableInfo<$ManualCalendarEventItemsTable, ManualCalendarEventItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManualCalendarEventItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _energyImpactScoreMeta = const VerificationMeta(
    'energyImpactScore',
  );
  @override
  late final GeneratedColumn<int> energyImpactScore = GeneratedColumn<int>(
    'energy_impact_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    title,
    startTime,
    endTime,
    category,
    energyImpactScore,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manual_calendar_event_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ManualCalendarEventItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('energy_impact_score')) {
      context.handle(
        _energyImpactScoreMeta,
        energyImpactScore.isAcceptableOrUnknown(
          data['energy_impact_score']!,
          _energyImpactScoreMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ManualCalendarEventItem map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManualCalendarEventItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      energyImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_impact_score'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ManualCalendarEventItemsTable createAlias(String alias) {
    return $ManualCalendarEventItemsTable(attachedDatabase, alias);
  }
}

class ManualCalendarEventItem extends DataClass
    implements Insertable<ManualCalendarEventItem> {
  final int id;
  final String date;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String category;
  final int? energyImpactScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ManualCalendarEventItem({
    required this.id,
    required this.date,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.category,
    this.energyImpactScore,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['title'] = Variable<String>(title);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || energyImpactScore != null) {
      map['energy_impact_score'] = Variable<int>(energyImpactScore);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ManualCalendarEventItemsCompanion toCompanion(bool nullToAbsent) {
    return ManualCalendarEventItemsCompanion(
      id: Value(id),
      date: Value(date),
      title: Value(title),
      startTime: Value(startTime),
      endTime: Value(endTime),
      category: Value(category),
      energyImpactScore: energyImpactScore == null && nullToAbsent
          ? const Value.absent()
          : Value(energyImpactScore),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ManualCalendarEventItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManualCalendarEventItem(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      title: serializer.fromJson<String>(json['title']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      category: serializer.fromJson<String>(json['category']),
      energyImpactScore: serializer.fromJson<int?>(json['energyImpactScore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'title': serializer.toJson<String>(title),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'category': serializer.toJson<String>(category),
      'energyImpactScore': serializer.toJson<int?>(energyImpactScore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ManualCalendarEventItem copyWith({
    int? id,
    String? date,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    String? category,
    Value<int?> energyImpactScore = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ManualCalendarEventItem(
    id: id ?? this.id,
    date: date ?? this.date,
    title: title ?? this.title,
    startTime: startTime ?? this.startTime,
    endTime: endTime ?? this.endTime,
    category: category ?? this.category,
    energyImpactScore: energyImpactScore.present
        ? energyImpactScore.value
        : this.energyImpactScore,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ManualCalendarEventItem copyWithCompanion(
    ManualCalendarEventItemsCompanion data,
  ) {
    return ManualCalendarEventItem(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      title: data.title.present ? data.title.value : this.title,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      category: data.category.present ? data.category.value : this.category,
      energyImpactScore: data.energyImpactScore.present
          ? data.energyImpactScore.value
          : this.energyImpactScore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManualCalendarEventItem(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('energyImpactScore: $energyImpactScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    title,
    startTime,
    endTime,
    category,
    energyImpactScore,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManualCalendarEventItem &&
          other.id == this.id &&
          other.date == this.date &&
          other.title == this.title &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.category == this.category &&
          other.energyImpactScore == this.energyImpactScore &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ManualCalendarEventItemsCompanion
    extends UpdateCompanion<ManualCalendarEventItem> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> title;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String> category;
  final Value<int?> energyImpactScore;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ManualCalendarEventItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.title = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.category = const Value.absent(),
    this.energyImpactScore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ManualCalendarEventItemsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required String category,
    this.energyImpactScore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date),
       title = Value(title),
       startTime = Value(startTime),
       endTime = Value(endTime),
       category = Value(category);
  static Insertable<ManualCalendarEventItem> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? title,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? category,
    Expression<int>? energyImpactScore,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (title != null) 'title': title,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (category != null) 'category': category,
      if (energyImpactScore != null) 'energy_impact_score': energyImpactScore,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ManualCalendarEventItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<String>? title,
    Value<DateTime>? startTime,
    Value<DateTime>? endTime,
    Value<String>? category,
    Value<int?>? energyImpactScore,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ManualCalendarEventItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      energyImpactScore: energyImpactScore ?? this.energyImpactScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (energyImpactScore.present) {
      map['energy_impact_score'] = Variable<int>(energyImpactScore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManualCalendarEventItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('title: $title, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('energyImpactScore: $energyImpactScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyReflectionItemsTable extends DailyReflectionItems
    with TableInfo<$DailyReflectionItemsTable, DailyReflectionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyReflectionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _energyScoreMeta = const VerificationMeta(
    'energyScore',
  );
  @override
  late final GeneratedColumn<int> energyScore = GeneratedColumn<int>(
    'energy_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intentionCompletionScoreMeta =
      const VerificationMeta('intentionCompletionScore');
  @override
  late final GeneratedColumn<int> intentionCompletionScore =
      GeneratedColumn<int>(
        'intention_completion_score',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _intentionHelpfulnessScoreMeta =
      const VerificationMeta('intentionHelpfulnessScore');
  @override
  late final GeneratedColumn<int> intentionHelpfulnessScore =
      GeneratedColumn<int>(
        'intention_helpfulness_score',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    energyScore,
    intentionCompletionScore,
    intentionHelpfulnessScore,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_reflection_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyReflectionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('energy_score')) {
      context.handle(
        _energyScoreMeta,
        energyScore.isAcceptableOrUnknown(
          data['energy_score']!,
          _energyScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_energyScoreMeta);
    }
    if (data.containsKey('intention_completion_score')) {
      context.handle(
        _intentionCompletionScoreMeta,
        intentionCompletionScore.isAcceptableOrUnknown(
          data['intention_completion_score']!,
          _intentionCompletionScoreMeta,
        ),
      );
    }
    if (data.containsKey('intention_helpfulness_score')) {
      context.handle(
        _intentionHelpfulnessScoreMeta,
        intentionHelpfulnessScore.isAcceptableOrUnknown(
          data['intention_helpfulness_score']!,
          _intentionHelpfulnessScoreMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyReflectionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyReflectionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      energyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}energy_score'],
      )!,
      intentionCompletionScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intention_completion_score'],
      ),
      intentionHelpfulnessScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intention_helpfulness_score'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyReflectionItemsTable createAlias(String alias) {
    return $DailyReflectionItemsTable(attachedDatabase, alias);
  }
}

class DailyReflectionItem extends DataClass
    implements Insertable<DailyReflectionItem> {
  final int id;
  final String date;
  final int energyScore;
  final int? intentionCompletionScore;
  final int? intentionHelpfulnessScore;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyReflectionItem({
    required this.id,
    required this.date,
    required this.energyScore,
    this.intentionCompletionScore,
    this.intentionHelpfulnessScore,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['energy_score'] = Variable<int>(energyScore);
    if (!nullToAbsent || intentionCompletionScore != null) {
      map['intention_completion_score'] = Variable<int>(
        intentionCompletionScore,
      );
    }
    if (!nullToAbsent || intentionHelpfulnessScore != null) {
      map['intention_helpfulness_score'] = Variable<int>(
        intentionHelpfulnessScore,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyReflectionItemsCompanion toCompanion(bool nullToAbsent) {
    return DailyReflectionItemsCompanion(
      id: Value(id),
      date: Value(date),
      energyScore: Value(energyScore),
      intentionCompletionScore: intentionCompletionScore == null && nullToAbsent
          ? const Value.absent()
          : Value(intentionCompletionScore),
      intentionHelpfulnessScore:
          intentionHelpfulnessScore == null && nullToAbsent
          ? const Value.absent()
          : Value(intentionHelpfulnessScore),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyReflectionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyReflectionItem(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      energyScore: serializer.fromJson<int>(json['energyScore']),
      intentionCompletionScore: serializer.fromJson<int?>(
        json['intentionCompletionScore'],
      ),
      intentionHelpfulnessScore: serializer.fromJson<int?>(
        json['intentionHelpfulnessScore'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'energyScore': serializer.toJson<int>(energyScore),
      'intentionCompletionScore': serializer.toJson<int?>(
        intentionCompletionScore,
      ),
      'intentionHelpfulnessScore': serializer.toJson<int?>(
        intentionHelpfulnessScore,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyReflectionItem copyWith({
    int? id,
    String? date,
    int? energyScore,
    Value<int?> intentionCompletionScore = const Value.absent(),
    Value<int?> intentionHelpfulnessScore = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyReflectionItem(
    id: id ?? this.id,
    date: date ?? this.date,
    energyScore: energyScore ?? this.energyScore,
    intentionCompletionScore: intentionCompletionScore.present
        ? intentionCompletionScore.value
        : this.intentionCompletionScore,
    intentionHelpfulnessScore: intentionHelpfulnessScore.present
        ? intentionHelpfulnessScore.value
        : this.intentionHelpfulnessScore,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyReflectionItem copyWithCompanion(DailyReflectionItemsCompanion data) {
    return DailyReflectionItem(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      energyScore: data.energyScore.present
          ? data.energyScore.value
          : this.energyScore,
      intentionCompletionScore: data.intentionCompletionScore.present
          ? data.intentionCompletionScore.value
          : this.intentionCompletionScore,
      intentionHelpfulnessScore: data.intentionHelpfulnessScore.present
          ? data.intentionHelpfulnessScore.value
          : this.intentionHelpfulnessScore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyReflectionItem(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('energyScore: $energyScore, ')
          ..write('intentionCompletionScore: $intentionCompletionScore, ')
          ..write('intentionHelpfulnessScore: $intentionHelpfulnessScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    energyScore,
    intentionCompletionScore,
    intentionHelpfulnessScore,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyReflectionItem &&
          other.id == this.id &&
          other.date == this.date &&
          other.energyScore == this.energyScore &&
          other.intentionCompletionScore == this.intentionCompletionScore &&
          other.intentionHelpfulnessScore == this.intentionHelpfulnessScore &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyReflectionItemsCompanion
    extends UpdateCompanion<DailyReflectionItem> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> energyScore;
  final Value<int?> intentionCompletionScore;
  final Value<int?> intentionHelpfulnessScore;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DailyReflectionItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.energyScore = const Value.absent(),
    this.intentionCompletionScore = const Value.absent(),
    this.intentionHelpfulnessScore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyReflectionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int energyScore,
    this.intentionCompletionScore = const Value.absent(),
    this.intentionHelpfulnessScore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date),
       energyScore = Value(energyScore);
  static Insertable<DailyReflectionItem> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? energyScore,
    Expression<int>? intentionCompletionScore,
    Expression<int>? intentionHelpfulnessScore,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (energyScore != null) 'energy_score': energyScore,
      if (intentionCompletionScore != null)
        'intention_completion_score': intentionCompletionScore,
      if (intentionHelpfulnessScore != null)
        'intention_helpfulness_score': intentionHelpfulnessScore,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyReflectionItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<int>? energyScore,
    Value<int?>? intentionCompletionScore,
    Value<int?>? intentionHelpfulnessScore,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DailyReflectionItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      energyScore: energyScore ?? this.energyScore,
      intentionCompletionScore:
          intentionCompletionScore ?? this.intentionCompletionScore,
      intentionHelpfulnessScore:
          intentionHelpfulnessScore ?? this.intentionHelpfulnessScore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (energyScore.present) {
      map['energy_score'] = Variable<int>(energyScore.value);
    }
    if (intentionCompletionScore.present) {
      map['intention_completion_score'] = Variable<int>(
        intentionCompletionScore.value,
      );
    }
    if (intentionHelpfulnessScore.present) {
      map['intention_helpfulness_score'] = Variable<int>(
        intentionHelpfulnessScore.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyReflectionItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('energyScore: $energyScore, ')
          ..write('intentionCompletionScore: $intentionCompletionScore, ')
          ..write('intentionHelpfulnessScore: $intentionHelpfulnessScore, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyIntentionItemsTable extends DailyIntentionItems
    with TableInfo<$DailyIntentionItemsTable, DailyIntentionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyIntentionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _selectedFactorMeta = const VerificationMeta(
    'selectedFactor',
  );
  @override
  late final GeneratedColumn<String> selectedFactor = GeneratedColumn<String>(
    'selected_factor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factorTypeMeta = const VerificationMeta(
    'factorType',
  );
  @override
  late final GeneratedColumn<String> factorType = GeneratedColumn<String>(
    'factor_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unspecified'),
  );
  static const VerificationMeta _selectedAdjustmentMeta =
      const VerificationMeta('selectedAdjustment');
  @override
  late final GeneratedColumn<String> selectedAdjustment =
      GeneratedColumn<String>(
        'selected_adjustment',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _adjustmentTypeMeta = const VerificationMeta(
    'adjustmentType',
  );
  @override
  late final GeneratedColumn<String> adjustmentType = GeneratedColumn<String>(
    'adjustment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unspecified'),
  );
  static const VerificationMeta _adjustmentStartTimeMeta =
      const VerificationMeta('adjustmentStartTime');
  @override
  late final GeneratedColumn<DateTime> adjustmentStartTime =
      GeneratedColumn<DateTime>(
        'adjustment_start_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _adjustmentEndTimeMeta = const VerificationMeta(
    'adjustmentEndTime',
  );
  @override
  late final GeneratedColumn<DateTime> adjustmentEndTime =
      GeneratedColumn<DateTime>(
        'adjustment_end_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _calendarSnapshotKeyMeta =
      const VerificationMeta('calendarSnapshotKey');
  @override
  late final GeneratedColumn<String> calendarSnapshotKey =
      GeneratedColumn<String>(
        'calendar_snapshot_key',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant(''),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    selectedFactor,
    factorType,
    selectedAdjustment,
    adjustmentType,
    adjustmentStartTime,
    adjustmentEndTime,
    calendarSnapshotKey,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_intention_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyIntentionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('selected_factor')) {
      context.handle(
        _selectedFactorMeta,
        selectedFactor.isAcceptableOrUnknown(
          data['selected_factor']!,
          _selectedFactorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedFactorMeta);
    }
    if (data.containsKey('factor_type')) {
      context.handle(
        _factorTypeMeta,
        factorType.isAcceptableOrUnknown(data['factor_type']!, _factorTypeMeta),
      );
    }
    if (data.containsKey('selected_adjustment')) {
      context.handle(
        _selectedAdjustmentMeta,
        selectedAdjustment.isAcceptableOrUnknown(
          data['selected_adjustment']!,
          _selectedAdjustmentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedAdjustmentMeta);
    }
    if (data.containsKey('adjustment_type')) {
      context.handle(
        _adjustmentTypeMeta,
        adjustmentType.isAcceptableOrUnknown(
          data['adjustment_type']!,
          _adjustmentTypeMeta,
        ),
      );
    }
    if (data.containsKey('adjustment_start_time')) {
      context.handle(
        _adjustmentStartTimeMeta,
        adjustmentStartTime.isAcceptableOrUnknown(
          data['adjustment_start_time']!,
          _adjustmentStartTimeMeta,
        ),
      );
    }
    if (data.containsKey('adjustment_end_time')) {
      context.handle(
        _adjustmentEndTimeMeta,
        adjustmentEndTime.isAcceptableOrUnknown(
          data['adjustment_end_time']!,
          _adjustmentEndTimeMeta,
        ),
      );
    }
    if (data.containsKey('calendar_snapshot_key')) {
      context.handle(
        _calendarSnapshotKeyMeta,
        calendarSnapshotKey.isAcceptableOrUnknown(
          data['calendar_snapshot_key']!,
          _calendarSnapshotKeyMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyIntentionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyIntentionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      selectedFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_factor'],
      )!,
      factorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}factor_type'],
      )!,
      selectedAdjustment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_adjustment'],
      )!,
      adjustmentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adjustment_type'],
      )!,
      adjustmentStartTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}adjustment_start_time'],
      ),
      adjustmentEndTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}adjustment_end_time'],
      ),
      calendarSnapshotKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_snapshot_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyIntentionItemsTable createAlias(String alias) {
    return $DailyIntentionItemsTable(attachedDatabase, alias);
  }
}

class DailyIntentionItem extends DataClass
    implements Insertable<DailyIntentionItem> {
  final int id;
  final String date;
  final String selectedFactor;
  final String factorType;
  final String selectedAdjustment;
  final String adjustmentType;
  final DateTime? adjustmentStartTime;
  final DateTime? adjustmentEndTime;
  final String calendarSnapshotKey;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyIntentionItem({
    required this.id,
    required this.date,
    required this.selectedFactor,
    required this.factorType,
    required this.selectedAdjustment,
    required this.adjustmentType,
    this.adjustmentStartTime,
    this.adjustmentEndTime,
    required this.calendarSnapshotKey,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['selected_factor'] = Variable<String>(selectedFactor);
    map['factor_type'] = Variable<String>(factorType);
    map['selected_adjustment'] = Variable<String>(selectedAdjustment);
    map['adjustment_type'] = Variable<String>(adjustmentType);
    if (!nullToAbsent || adjustmentStartTime != null) {
      map['adjustment_start_time'] = Variable<DateTime>(adjustmentStartTime);
    }
    if (!nullToAbsent || adjustmentEndTime != null) {
      map['adjustment_end_time'] = Variable<DateTime>(adjustmentEndTime);
    }
    map['calendar_snapshot_key'] = Variable<String>(calendarSnapshotKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyIntentionItemsCompanion toCompanion(bool nullToAbsent) {
    return DailyIntentionItemsCompanion(
      id: Value(id),
      date: Value(date),
      selectedFactor: Value(selectedFactor),
      factorType: Value(factorType),
      selectedAdjustment: Value(selectedAdjustment),
      adjustmentType: Value(adjustmentType),
      adjustmentStartTime: adjustmentStartTime == null && nullToAbsent
          ? const Value.absent()
          : Value(adjustmentStartTime),
      adjustmentEndTime: adjustmentEndTime == null && nullToAbsent
          ? const Value.absent()
          : Value(adjustmentEndTime),
      calendarSnapshotKey: Value(calendarSnapshotKey),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyIntentionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyIntentionItem(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      selectedFactor: serializer.fromJson<String>(json['selectedFactor']),
      factorType: serializer.fromJson<String>(json['factorType']),
      selectedAdjustment: serializer.fromJson<String>(
        json['selectedAdjustment'],
      ),
      adjustmentType: serializer.fromJson<String>(json['adjustmentType']),
      adjustmentStartTime: serializer.fromJson<DateTime?>(
        json['adjustmentStartTime'],
      ),
      adjustmentEndTime: serializer.fromJson<DateTime?>(
        json['adjustmentEndTime'],
      ),
      calendarSnapshotKey: serializer.fromJson<String>(
        json['calendarSnapshotKey'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'selectedFactor': serializer.toJson<String>(selectedFactor),
      'factorType': serializer.toJson<String>(factorType),
      'selectedAdjustment': serializer.toJson<String>(selectedAdjustment),
      'adjustmentType': serializer.toJson<String>(adjustmentType),
      'adjustmentStartTime': serializer.toJson<DateTime?>(adjustmentStartTime),
      'adjustmentEndTime': serializer.toJson<DateTime?>(adjustmentEndTime),
      'calendarSnapshotKey': serializer.toJson<String>(calendarSnapshotKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyIntentionItem copyWith({
    int? id,
    String? date,
    String? selectedFactor,
    String? factorType,
    String? selectedAdjustment,
    String? adjustmentType,
    Value<DateTime?> adjustmentStartTime = const Value.absent(),
    Value<DateTime?> adjustmentEndTime = const Value.absent(),
    String? calendarSnapshotKey,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyIntentionItem(
    id: id ?? this.id,
    date: date ?? this.date,
    selectedFactor: selectedFactor ?? this.selectedFactor,
    factorType: factorType ?? this.factorType,
    selectedAdjustment: selectedAdjustment ?? this.selectedAdjustment,
    adjustmentType: adjustmentType ?? this.adjustmentType,
    adjustmentStartTime: adjustmentStartTime.present
        ? adjustmentStartTime.value
        : this.adjustmentStartTime,
    adjustmentEndTime: adjustmentEndTime.present
        ? adjustmentEndTime.value
        : this.adjustmentEndTime,
    calendarSnapshotKey: calendarSnapshotKey ?? this.calendarSnapshotKey,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyIntentionItem copyWithCompanion(DailyIntentionItemsCompanion data) {
    return DailyIntentionItem(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      selectedFactor: data.selectedFactor.present
          ? data.selectedFactor.value
          : this.selectedFactor,
      factorType: data.factorType.present
          ? data.factorType.value
          : this.factorType,
      selectedAdjustment: data.selectedAdjustment.present
          ? data.selectedAdjustment.value
          : this.selectedAdjustment,
      adjustmentType: data.adjustmentType.present
          ? data.adjustmentType.value
          : this.adjustmentType,
      adjustmentStartTime: data.adjustmentStartTime.present
          ? data.adjustmentStartTime.value
          : this.adjustmentStartTime,
      adjustmentEndTime: data.adjustmentEndTime.present
          ? data.adjustmentEndTime.value
          : this.adjustmentEndTime,
      calendarSnapshotKey: data.calendarSnapshotKey.present
          ? data.calendarSnapshotKey.value
          : this.calendarSnapshotKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyIntentionItem(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('selectedFactor: $selectedFactor, ')
          ..write('factorType: $factorType, ')
          ..write('selectedAdjustment: $selectedAdjustment, ')
          ..write('adjustmentType: $adjustmentType, ')
          ..write('adjustmentStartTime: $adjustmentStartTime, ')
          ..write('adjustmentEndTime: $adjustmentEndTime, ')
          ..write('calendarSnapshotKey: $calendarSnapshotKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    selectedFactor,
    factorType,
    selectedAdjustment,
    adjustmentType,
    adjustmentStartTime,
    adjustmentEndTime,
    calendarSnapshotKey,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyIntentionItem &&
          other.id == this.id &&
          other.date == this.date &&
          other.selectedFactor == this.selectedFactor &&
          other.factorType == this.factorType &&
          other.selectedAdjustment == this.selectedAdjustment &&
          other.adjustmentType == this.adjustmentType &&
          other.adjustmentStartTime == this.adjustmentStartTime &&
          other.adjustmentEndTime == this.adjustmentEndTime &&
          other.calendarSnapshotKey == this.calendarSnapshotKey &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyIntentionItemsCompanion extends UpdateCompanion<DailyIntentionItem> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> selectedFactor;
  final Value<String> factorType;
  final Value<String> selectedAdjustment;
  final Value<String> adjustmentType;
  final Value<DateTime?> adjustmentStartTime;
  final Value<DateTime?> adjustmentEndTime;
  final Value<String> calendarSnapshotKey;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DailyIntentionItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.selectedFactor = const Value.absent(),
    this.factorType = const Value.absent(),
    this.selectedAdjustment = const Value.absent(),
    this.adjustmentType = const Value.absent(),
    this.adjustmentStartTime = const Value.absent(),
    this.adjustmentEndTime = const Value.absent(),
    this.calendarSnapshotKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyIntentionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String selectedFactor,
    this.factorType = const Value.absent(),
    required String selectedAdjustment,
    this.adjustmentType = const Value.absent(),
    this.adjustmentStartTime = const Value.absent(),
    this.adjustmentEndTime = const Value.absent(),
    this.calendarSnapshotKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date),
       selectedFactor = Value(selectedFactor),
       selectedAdjustment = Value(selectedAdjustment);
  static Insertable<DailyIntentionItem> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? selectedFactor,
    Expression<String>? factorType,
    Expression<String>? selectedAdjustment,
    Expression<String>? adjustmentType,
    Expression<DateTime>? adjustmentStartTime,
    Expression<DateTime>? adjustmentEndTime,
    Expression<String>? calendarSnapshotKey,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (selectedFactor != null) 'selected_factor': selectedFactor,
      if (factorType != null) 'factor_type': factorType,
      if (selectedAdjustment != null) 'selected_adjustment': selectedAdjustment,
      if (adjustmentType != null) 'adjustment_type': adjustmentType,
      if (adjustmentStartTime != null)
        'adjustment_start_time': adjustmentStartTime,
      if (adjustmentEndTime != null) 'adjustment_end_time': adjustmentEndTime,
      if (calendarSnapshotKey != null)
        'calendar_snapshot_key': calendarSnapshotKey,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyIntentionItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<String>? selectedFactor,
    Value<String>? factorType,
    Value<String>? selectedAdjustment,
    Value<String>? adjustmentType,
    Value<DateTime?>? adjustmentStartTime,
    Value<DateTime?>? adjustmentEndTime,
    Value<String>? calendarSnapshotKey,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DailyIntentionItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      selectedFactor: selectedFactor ?? this.selectedFactor,
      factorType: factorType ?? this.factorType,
      selectedAdjustment: selectedAdjustment ?? this.selectedAdjustment,
      adjustmentType: adjustmentType ?? this.adjustmentType,
      adjustmentStartTime: adjustmentStartTime ?? this.adjustmentStartTime,
      adjustmentEndTime: adjustmentEndTime ?? this.adjustmentEndTime,
      calendarSnapshotKey: calendarSnapshotKey ?? this.calendarSnapshotKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (selectedFactor.present) {
      map['selected_factor'] = Variable<String>(selectedFactor.value);
    }
    if (factorType.present) {
      map['factor_type'] = Variable<String>(factorType.value);
    }
    if (selectedAdjustment.present) {
      map['selected_adjustment'] = Variable<String>(selectedAdjustment.value);
    }
    if (adjustmentType.present) {
      map['adjustment_type'] = Variable<String>(adjustmentType.value);
    }
    if (adjustmentStartTime.present) {
      map['adjustment_start_time'] = Variable<DateTime>(
        adjustmentStartTime.value,
      );
    }
    if (adjustmentEndTime.present) {
      map['adjustment_end_time'] = Variable<DateTime>(adjustmentEndTime.value);
    }
    if (calendarSnapshotKey.present) {
      map['calendar_snapshot_key'] = Variable<String>(
        calendarSnapshotKey.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyIntentionItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('selectedFactor: $selectedFactor, ')
          ..write('factorType: $factorType, ')
          ..write('selectedAdjustment: $selectedAdjustment, ')
          ..write('adjustmentType: $adjustmentType, ')
          ..write('adjustmentStartTime: $adjustmentStartTime, ')
          ..write('adjustmentEndTime: $adjustmentEndTime, ')
          ..write('calendarSnapshotKey: $calendarSnapshotKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyFeatureSnapshotItemsTable extends DailyFeatureSnapshotItems
    with TableInfo<$DailyFeatureSnapshotItemsTable, DailyFeatureSnapshotItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyFeatureSnapshotItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisStartHourMeta = const VerificationMeta(
    'analysisStartHour',
  );
  @override
  late final GeneratedColumn<int> analysisStartHour = GeneratedColumn<int>(
    'analysis_start_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _analysisEndHourMeta = const VerificationMeta(
    'analysisEndHour',
  );
  @override
  late final GeneratedColumn<int> analysisEndHour = GeneratedColumn<int>(
    'analysis_end_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _predictionPhaseMeta = const VerificationMeta(
    'predictionPhase',
  );
  @override
  late final GeneratedColumn<String> predictionPhase = GeneratedColumn<String>(
    'prediction_phase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calculationVersionMeta =
      const VerificationMeta('calculationVersion');
  @override
  late final GeneratedColumn<int> calculationVersion = GeneratedColumn<int>(
    'calculation_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calendarSnapshotKeyMeta =
      const VerificationMeta('calendarSnapshotKey');
  @override
  late final GeneratedColumn<String> calendarSnapshotKey =
      GeneratedColumn<String>(
        'calendar_snapshot_key',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _totalEventCountMeta = const VerificationMeta(
    'totalEventCount',
  );
  @override
  late final GeneratedColumn<int> totalEventCount = GeneratedColumn<int>(
    'total_event_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allDayEventCountMeta = const VerificationMeta(
    'allDayEventCount',
  );
  @override
  late final GeneratedColumn<int> allDayEventCount = GeneratedColumn<int>(
    'all_day_event_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalScheduledMinutesMeta =
      const VerificationMeta('totalScheduledMinutes');
  @override
  late final GeneratedColumn<int> totalScheduledMinutes = GeneratedColumn<int>(
    'total_scheduled_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _busyMinutesMeta = const VerificationMeta(
    'busyMinutes',
  );
  @override
  late final GeneratedColumn<int> busyMinutes = GeneratedColumn<int>(
    'busy_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusMinutesMeta = const VerificationMeta(
    'focusMinutes',
  );
  @override
  late final GeneratedColumn<int> focusMinutes = GeneratedColumn<int>(
    'focus_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _socialMinutesMeta = const VerificationMeta(
    'socialMinutes',
  );
  @override
  late final GeneratedColumn<int> socialMinutes = GeneratedColumn<int>(
    'social_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lifeAdminMinutesMeta = const VerificationMeta(
    'lifeAdminMinutes',
  );
  @override
  late final GeneratedColumn<int> lifeAdminMinutes = GeneratedColumn<int>(
    'life_admin_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseMinutesMeta = const VerificationMeta(
    'exerciseMinutes',
  );
  @override
  late final GeneratedColumn<int> exerciseMinutes = GeneratedColumn<int>(
    'exercise_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restMinutesMeta = const VerificationMeta(
    'restMinutes',
  );
  @override
  late final GeneratedColumn<int> restMinutes = GeneratedColumn<int>(
    'rest_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backToBackEventCountMeta =
      const VerificationMeta('backToBackEventCount');
  @override
  late final GeneratedColumn<int> backToBackEventCount = GeneratedColumn<int>(
    'back_to_back_event_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _freeMinutesMeta = const VerificationMeta(
    'freeMinutes',
  );
  @override
  late final GeneratedColumn<int> freeMinutes = GeneratedColumn<int>(
    'free_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longestGapBetweenActivitiesMinutesMeta =
      const VerificationMeta('longestGapBetweenActivitiesMinutes');
  @override
  late final GeneratedColumn<int> longestGapBetweenActivitiesMinutes =
      GeneratedColumn<int>(
        'longest_gap_between_activities_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _maxConsecutiveBlockMinutesMeta =
      const VerificationMeta('maxConsecutiveBlockMinutes');
  @override
  late final GeneratedColumn<int> maxConsecutiveBlockMinutes =
      GeneratedColumn<int>(
        'max_consecutive_block_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    capturedAt,
    analysisStartHour,
    analysisEndHour,
    predictionPhase,
    calculationVersion,
    calendarSnapshotKey,
    totalEventCount,
    allDayEventCount,
    totalScheduledMinutes,
    busyMinutes,
    focusMinutes,
    socialMinutes,
    lifeAdminMinutes,
    exerciseMinutes,
    restMinutes,
    backToBackEventCount,
    freeMinutes,
    longestGapBetweenActivitiesMinutes,
    maxConsecutiveBlockMinutes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_feature_snapshot_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyFeatureSnapshotItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('analysis_start_hour')) {
      context.handle(
        _analysisStartHourMeta,
        analysisStartHour.isAcceptableOrUnknown(
          data['analysis_start_hour']!,
          _analysisStartHourMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analysisStartHourMeta);
    }
    if (data.containsKey('analysis_end_hour')) {
      context.handle(
        _analysisEndHourMeta,
        analysisEndHour.isAcceptableOrUnknown(
          data['analysis_end_hour']!,
          _analysisEndHourMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analysisEndHourMeta);
    }
    if (data.containsKey('prediction_phase')) {
      context.handle(
        _predictionPhaseMeta,
        predictionPhase.isAcceptableOrUnknown(
          data['prediction_phase']!,
          _predictionPhaseMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_predictionPhaseMeta);
    }
    if (data.containsKey('calculation_version')) {
      context.handle(
        _calculationVersionMeta,
        calculationVersion.isAcceptableOrUnknown(
          data['calculation_version']!,
          _calculationVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calculationVersionMeta);
    }
    if (data.containsKey('calendar_snapshot_key')) {
      context.handle(
        _calendarSnapshotKeyMeta,
        calendarSnapshotKey.isAcceptableOrUnknown(
          data['calendar_snapshot_key']!,
          _calendarSnapshotKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calendarSnapshotKeyMeta);
    }
    if (data.containsKey('total_event_count')) {
      context.handle(
        _totalEventCountMeta,
        totalEventCount.isAcceptableOrUnknown(
          data['total_event_count']!,
          _totalEventCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalEventCountMeta);
    }
    if (data.containsKey('all_day_event_count')) {
      context.handle(
        _allDayEventCountMeta,
        allDayEventCount.isAcceptableOrUnknown(
          data['all_day_event_count']!,
          _allDayEventCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allDayEventCountMeta);
    }
    if (data.containsKey('total_scheduled_minutes')) {
      context.handle(
        _totalScheduledMinutesMeta,
        totalScheduledMinutes.isAcceptableOrUnknown(
          data['total_scheduled_minutes']!,
          _totalScheduledMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalScheduledMinutesMeta);
    }
    if (data.containsKey('busy_minutes')) {
      context.handle(
        _busyMinutesMeta,
        busyMinutes.isAcceptableOrUnknown(
          data['busy_minutes']!,
          _busyMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_busyMinutesMeta);
    }
    if (data.containsKey('focus_minutes')) {
      context.handle(
        _focusMinutesMeta,
        focusMinutes.isAcceptableOrUnknown(
          data['focus_minutes']!,
          _focusMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_focusMinutesMeta);
    }
    if (data.containsKey('social_minutes')) {
      context.handle(
        _socialMinutesMeta,
        socialMinutes.isAcceptableOrUnknown(
          data['social_minutes']!,
          _socialMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_socialMinutesMeta);
    }
    if (data.containsKey('life_admin_minutes')) {
      context.handle(
        _lifeAdminMinutesMeta,
        lifeAdminMinutes.isAcceptableOrUnknown(
          data['life_admin_minutes']!,
          _lifeAdminMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lifeAdminMinutesMeta);
    }
    if (data.containsKey('exercise_minutes')) {
      context.handle(
        _exerciseMinutesMeta,
        exerciseMinutes.isAcceptableOrUnknown(
          data['exercise_minutes']!,
          _exerciseMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseMinutesMeta);
    }
    if (data.containsKey('rest_minutes')) {
      context.handle(
        _restMinutesMeta,
        restMinutes.isAcceptableOrUnknown(
          data['rest_minutes']!,
          _restMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_restMinutesMeta);
    }
    if (data.containsKey('back_to_back_event_count')) {
      context.handle(
        _backToBackEventCountMeta,
        backToBackEventCount.isAcceptableOrUnknown(
          data['back_to_back_event_count']!,
          _backToBackEventCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backToBackEventCountMeta);
    }
    if (data.containsKey('free_minutes')) {
      context.handle(
        _freeMinutesMeta,
        freeMinutes.isAcceptableOrUnknown(
          data['free_minutes']!,
          _freeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_freeMinutesMeta);
    }
    if (data.containsKey('longest_gap_between_activities_minutes')) {
      context.handle(
        _longestGapBetweenActivitiesMinutesMeta,
        longestGapBetweenActivitiesMinutes.isAcceptableOrUnknown(
          data['longest_gap_between_activities_minutes']!,
          _longestGapBetweenActivitiesMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_longestGapBetweenActivitiesMinutesMeta);
    }
    if (data.containsKey('max_consecutive_block_minutes')) {
      context.handle(
        _maxConsecutiveBlockMinutesMeta,
        maxConsecutiveBlockMinutes.isAcceptableOrUnknown(
          data['max_consecutive_block_minutes']!,
          _maxConsecutiveBlockMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxConsecutiveBlockMinutesMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyFeatureSnapshotItem map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyFeatureSnapshotItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      analysisStartHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}analysis_start_hour'],
      )!,
      analysisEndHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}analysis_end_hour'],
      )!,
      predictionPhase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prediction_phase'],
      )!,
      calculationVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calculation_version'],
      )!,
      calendarSnapshotKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_snapshot_key'],
      )!,
      totalEventCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_event_count'],
      )!,
      allDayEventCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}all_day_event_count'],
      )!,
      totalScheduledMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_scheduled_minutes'],
      )!,
      busyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}busy_minutes'],
      )!,
      focusMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_minutes'],
      )!,
      socialMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}social_minutes'],
      )!,
      lifeAdminMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}life_admin_minutes'],
      )!,
      exerciseMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_minutes'],
      )!,
      restMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_minutes'],
      )!,
      backToBackEventCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}back_to_back_event_count'],
      )!,
      freeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}free_minutes'],
      )!,
      longestGapBetweenActivitiesMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest_gap_between_activities_minutes'],
      )!,
      maxConsecutiveBlockMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_consecutive_block_minutes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyFeatureSnapshotItemsTable createAlias(String alias) {
    return $DailyFeatureSnapshotItemsTable(attachedDatabase, alias);
  }
}

class DailyFeatureSnapshotItem extends DataClass
    implements Insertable<DailyFeatureSnapshotItem> {
  final int id;
  final String date;
  final DateTime capturedAt;
  final int analysisStartHour;
  final int analysisEndHour;
  final String predictionPhase;
  final int calculationVersion;
  final String calendarSnapshotKey;
  final int totalEventCount;
  final int allDayEventCount;
  final int totalScheduledMinutes;
  final int busyMinutes;
  final int focusMinutes;
  final int socialMinutes;
  final int lifeAdminMinutes;
  final int exerciseMinutes;
  final int restMinutes;
  final int backToBackEventCount;
  final int freeMinutes;
  final int longestGapBetweenActivitiesMinutes;
  final int maxConsecutiveBlockMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DailyFeatureSnapshotItem({
    required this.id,
    required this.date,
    required this.capturedAt,
    required this.analysisStartHour,
    required this.analysisEndHour,
    required this.predictionPhase,
    required this.calculationVersion,
    required this.calendarSnapshotKey,
    required this.totalEventCount,
    required this.allDayEventCount,
    required this.totalScheduledMinutes,
    required this.busyMinutes,
    required this.focusMinutes,
    required this.socialMinutes,
    required this.lifeAdminMinutes,
    required this.exerciseMinutes,
    required this.restMinutes,
    required this.backToBackEventCount,
    required this.freeMinutes,
    required this.longestGapBetweenActivitiesMinutes,
    required this.maxConsecutiveBlockMinutes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['analysis_start_hour'] = Variable<int>(analysisStartHour);
    map['analysis_end_hour'] = Variable<int>(analysisEndHour);
    map['prediction_phase'] = Variable<String>(predictionPhase);
    map['calculation_version'] = Variable<int>(calculationVersion);
    map['calendar_snapshot_key'] = Variable<String>(calendarSnapshotKey);
    map['total_event_count'] = Variable<int>(totalEventCount);
    map['all_day_event_count'] = Variable<int>(allDayEventCount);
    map['total_scheduled_minutes'] = Variable<int>(totalScheduledMinutes);
    map['busy_minutes'] = Variable<int>(busyMinutes);
    map['focus_minutes'] = Variable<int>(focusMinutes);
    map['social_minutes'] = Variable<int>(socialMinutes);
    map['life_admin_minutes'] = Variable<int>(lifeAdminMinutes);
    map['exercise_minutes'] = Variable<int>(exerciseMinutes);
    map['rest_minutes'] = Variable<int>(restMinutes);
    map['back_to_back_event_count'] = Variable<int>(backToBackEventCount);
    map['free_minutes'] = Variable<int>(freeMinutes);
    map['longest_gap_between_activities_minutes'] = Variable<int>(
      longestGapBetweenActivitiesMinutes,
    );
    map['max_consecutive_block_minutes'] = Variable<int>(
      maxConsecutiveBlockMinutes,
    );
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyFeatureSnapshotItemsCompanion toCompanion(bool nullToAbsent) {
    return DailyFeatureSnapshotItemsCompanion(
      id: Value(id),
      date: Value(date),
      capturedAt: Value(capturedAt),
      analysisStartHour: Value(analysisStartHour),
      analysisEndHour: Value(analysisEndHour),
      predictionPhase: Value(predictionPhase),
      calculationVersion: Value(calculationVersion),
      calendarSnapshotKey: Value(calendarSnapshotKey),
      totalEventCount: Value(totalEventCount),
      allDayEventCount: Value(allDayEventCount),
      totalScheduledMinutes: Value(totalScheduledMinutes),
      busyMinutes: Value(busyMinutes),
      focusMinutes: Value(focusMinutes),
      socialMinutes: Value(socialMinutes),
      lifeAdminMinutes: Value(lifeAdminMinutes),
      exerciseMinutes: Value(exerciseMinutes),
      restMinutes: Value(restMinutes),
      backToBackEventCount: Value(backToBackEventCount),
      freeMinutes: Value(freeMinutes),
      longestGapBetweenActivitiesMinutes: Value(
        longestGapBetweenActivitiesMinutes,
      ),
      maxConsecutiveBlockMinutes: Value(maxConsecutiveBlockMinutes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyFeatureSnapshotItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyFeatureSnapshotItem(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      analysisStartHour: serializer.fromJson<int>(json['analysisStartHour']),
      analysisEndHour: serializer.fromJson<int>(json['analysisEndHour']),
      predictionPhase: serializer.fromJson<String>(json['predictionPhase']),
      calculationVersion: serializer.fromJson<int>(json['calculationVersion']),
      calendarSnapshotKey: serializer.fromJson<String>(
        json['calendarSnapshotKey'],
      ),
      totalEventCount: serializer.fromJson<int>(json['totalEventCount']),
      allDayEventCount: serializer.fromJson<int>(json['allDayEventCount']),
      totalScheduledMinutes: serializer.fromJson<int>(
        json['totalScheduledMinutes'],
      ),
      busyMinutes: serializer.fromJson<int>(json['busyMinutes']),
      focusMinutes: serializer.fromJson<int>(json['focusMinutes']),
      socialMinutes: serializer.fromJson<int>(json['socialMinutes']),
      lifeAdminMinutes: serializer.fromJson<int>(json['lifeAdminMinutes']),
      exerciseMinutes: serializer.fromJson<int>(json['exerciseMinutes']),
      restMinutes: serializer.fromJson<int>(json['restMinutes']),
      backToBackEventCount: serializer.fromJson<int>(
        json['backToBackEventCount'],
      ),
      freeMinutes: serializer.fromJson<int>(json['freeMinutes']),
      longestGapBetweenActivitiesMinutes: serializer.fromJson<int>(
        json['longestGapBetweenActivitiesMinutes'],
      ),
      maxConsecutiveBlockMinutes: serializer.fromJson<int>(
        json['maxConsecutiveBlockMinutes'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'analysisStartHour': serializer.toJson<int>(analysisStartHour),
      'analysisEndHour': serializer.toJson<int>(analysisEndHour),
      'predictionPhase': serializer.toJson<String>(predictionPhase),
      'calculationVersion': serializer.toJson<int>(calculationVersion),
      'calendarSnapshotKey': serializer.toJson<String>(calendarSnapshotKey),
      'totalEventCount': serializer.toJson<int>(totalEventCount),
      'allDayEventCount': serializer.toJson<int>(allDayEventCount),
      'totalScheduledMinutes': serializer.toJson<int>(totalScheduledMinutes),
      'busyMinutes': serializer.toJson<int>(busyMinutes),
      'focusMinutes': serializer.toJson<int>(focusMinutes),
      'socialMinutes': serializer.toJson<int>(socialMinutes),
      'lifeAdminMinutes': serializer.toJson<int>(lifeAdminMinutes),
      'exerciseMinutes': serializer.toJson<int>(exerciseMinutes),
      'restMinutes': serializer.toJson<int>(restMinutes),
      'backToBackEventCount': serializer.toJson<int>(backToBackEventCount),
      'freeMinutes': serializer.toJson<int>(freeMinutes),
      'longestGapBetweenActivitiesMinutes': serializer.toJson<int>(
        longestGapBetweenActivitiesMinutes,
      ),
      'maxConsecutiveBlockMinutes': serializer.toJson<int>(
        maxConsecutiveBlockMinutes,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyFeatureSnapshotItem copyWith({
    int? id,
    String? date,
    DateTime? capturedAt,
    int? analysisStartHour,
    int? analysisEndHour,
    String? predictionPhase,
    int? calculationVersion,
    String? calendarSnapshotKey,
    int? totalEventCount,
    int? allDayEventCount,
    int? totalScheduledMinutes,
    int? busyMinutes,
    int? focusMinutes,
    int? socialMinutes,
    int? lifeAdminMinutes,
    int? exerciseMinutes,
    int? restMinutes,
    int? backToBackEventCount,
    int? freeMinutes,
    int? longestGapBetweenActivitiesMinutes,
    int? maxConsecutiveBlockMinutes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DailyFeatureSnapshotItem(
    id: id ?? this.id,
    date: date ?? this.date,
    capturedAt: capturedAt ?? this.capturedAt,
    analysisStartHour: analysisStartHour ?? this.analysisStartHour,
    analysisEndHour: analysisEndHour ?? this.analysisEndHour,
    predictionPhase: predictionPhase ?? this.predictionPhase,
    calculationVersion: calculationVersion ?? this.calculationVersion,
    calendarSnapshotKey: calendarSnapshotKey ?? this.calendarSnapshotKey,
    totalEventCount: totalEventCount ?? this.totalEventCount,
    allDayEventCount: allDayEventCount ?? this.allDayEventCount,
    totalScheduledMinutes: totalScheduledMinutes ?? this.totalScheduledMinutes,
    busyMinutes: busyMinutes ?? this.busyMinutes,
    focusMinutes: focusMinutes ?? this.focusMinutes,
    socialMinutes: socialMinutes ?? this.socialMinutes,
    lifeAdminMinutes: lifeAdminMinutes ?? this.lifeAdminMinutes,
    exerciseMinutes: exerciseMinutes ?? this.exerciseMinutes,
    restMinutes: restMinutes ?? this.restMinutes,
    backToBackEventCount: backToBackEventCount ?? this.backToBackEventCount,
    freeMinutes: freeMinutes ?? this.freeMinutes,
    longestGapBetweenActivitiesMinutes:
        longestGapBetweenActivitiesMinutes ??
        this.longestGapBetweenActivitiesMinutes,
    maxConsecutiveBlockMinutes:
        maxConsecutiveBlockMinutes ?? this.maxConsecutiveBlockMinutes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyFeatureSnapshotItem copyWithCompanion(
    DailyFeatureSnapshotItemsCompanion data,
  ) {
    return DailyFeatureSnapshotItem(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      analysisStartHour: data.analysisStartHour.present
          ? data.analysisStartHour.value
          : this.analysisStartHour,
      analysisEndHour: data.analysisEndHour.present
          ? data.analysisEndHour.value
          : this.analysisEndHour,
      predictionPhase: data.predictionPhase.present
          ? data.predictionPhase.value
          : this.predictionPhase,
      calculationVersion: data.calculationVersion.present
          ? data.calculationVersion.value
          : this.calculationVersion,
      calendarSnapshotKey: data.calendarSnapshotKey.present
          ? data.calendarSnapshotKey.value
          : this.calendarSnapshotKey,
      totalEventCount: data.totalEventCount.present
          ? data.totalEventCount.value
          : this.totalEventCount,
      allDayEventCount: data.allDayEventCount.present
          ? data.allDayEventCount.value
          : this.allDayEventCount,
      totalScheduledMinutes: data.totalScheduledMinutes.present
          ? data.totalScheduledMinutes.value
          : this.totalScheduledMinutes,
      busyMinutes: data.busyMinutes.present
          ? data.busyMinutes.value
          : this.busyMinutes,
      focusMinutes: data.focusMinutes.present
          ? data.focusMinutes.value
          : this.focusMinutes,
      socialMinutes: data.socialMinutes.present
          ? data.socialMinutes.value
          : this.socialMinutes,
      lifeAdminMinutes: data.lifeAdminMinutes.present
          ? data.lifeAdminMinutes.value
          : this.lifeAdminMinutes,
      exerciseMinutes: data.exerciseMinutes.present
          ? data.exerciseMinutes.value
          : this.exerciseMinutes,
      restMinutes: data.restMinutes.present
          ? data.restMinutes.value
          : this.restMinutes,
      backToBackEventCount: data.backToBackEventCount.present
          ? data.backToBackEventCount.value
          : this.backToBackEventCount,
      freeMinutes: data.freeMinutes.present
          ? data.freeMinutes.value
          : this.freeMinutes,
      longestGapBetweenActivitiesMinutes:
          data.longestGapBetweenActivitiesMinutes.present
          ? data.longestGapBetweenActivitiesMinutes.value
          : this.longestGapBetweenActivitiesMinutes,
      maxConsecutiveBlockMinutes: data.maxConsecutiveBlockMinutes.present
          ? data.maxConsecutiveBlockMinutes.value
          : this.maxConsecutiveBlockMinutes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyFeatureSnapshotItem(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('analysisStartHour: $analysisStartHour, ')
          ..write('analysisEndHour: $analysisEndHour, ')
          ..write('predictionPhase: $predictionPhase, ')
          ..write('calculationVersion: $calculationVersion, ')
          ..write('calendarSnapshotKey: $calendarSnapshotKey, ')
          ..write('totalEventCount: $totalEventCount, ')
          ..write('allDayEventCount: $allDayEventCount, ')
          ..write('totalScheduledMinutes: $totalScheduledMinutes, ')
          ..write('busyMinutes: $busyMinutes, ')
          ..write('focusMinutes: $focusMinutes, ')
          ..write('socialMinutes: $socialMinutes, ')
          ..write('lifeAdminMinutes: $lifeAdminMinutes, ')
          ..write('exerciseMinutes: $exerciseMinutes, ')
          ..write('restMinutes: $restMinutes, ')
          ..write('backToBackEventCount: $backToBackEventCount, ')
          ..write('freeMinutes: $freeMinutes, ')
          ..write(
            'longestGapBetweenActivitiesMinutes: $longestGapBetweenActivitiesMinutes, ',
          )
          ..write('maxConsecutiveBlockMinutes: $maxConsecutiveBlockMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    date,
    capturedAt,
    analysisStartHour,
    analysisEndHour,
    predictionPhase,
    calculationVersion,
    calendarSnapshotKey,
    totalEventCount,
    allDayEventCount,
    totalScheduledMinutes,
    busyMinutes,
    focusMinutes,
    socialMinutes,
    lifeAdminMinutes,
    exerciseMinutes,
    restMinutes,
    backToBackEventCount,
    freeMinutes,
    longestGapBetweenActivitiesMinutes,
    maxConsecutiveBlockMinutes,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyFeatureSnapshotItem &&
          other.id == this.id &&
          other.date == this.date &&
          other.capturedAt == this.capturedAt &&
          other.analysisStartHour == this.analysisStartHour &&
          other.analysisEndHour == this.analysisEndHour &&
          other.predictionPhase == this.predictionPhase &&
          other.calculationVersion == this.calculationVersion &&
          other.calendarSnapshotKey == this.calendarSnapshotKey &&
          other.totalEventCount == this.totalEventCount &&
          other.allDayEventCount == this.allDayEventCount &&
          other.totalScheduledMinutes == this.totalScheduledMinutes &&
          other.busyMinutes == this.busyMinutes &&
          other.focusMinutes == this.focusMinutes &&
          other.socialMinutes == this.socialMinutes &&
          other.lifeAdminMinutes == this.lifeAdminMinutes &&
          other.exerciseMinutes == this.exerciseMinutes &&
          other.restMinutes == this.restMinutes &&
          other.backToBackEventCount == this.backToBackEventCount &&
          other.freeMinutes == this.freeMinutes &&
          other.longestGapBetweenActivitiesMinutes ==
              this.longestGapBetweenActivitiesMinutes &&
          other.maxConsecutiveBlockMinutes == this.maxConsecutiveBlockMinutes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DailyFeatureSnapshotItemsCompanion
    extends UpdateCompanion<DailyFeatureSnapshotItem> {
  final Value<int> id;
  final Value<String> date;
  final Value<DateTime> capturedAt;
  final Value<int> analysisStartHour;
  final Value<int> analysisEndHour;
  final Value<String> predictionPhase;
  final Value<int> calculationVersion;
  final Value<String> calendarSnapshotKey;
  final Value<int> totalEventCount;
  final Value<int> allDayEventCount;
  final Value<int> totalScheduledMinutes;
  final Value<int> busyMinutes;
  final Value<int> focusMinutes;
  final Value<int> socialMinutes;
  final Value<int> lifeAdminMinutes;
  final Value<int> exerciseMinutes;
  final Value<int> restMinutes;
  final Value<int> backToBackEventCount;
  final Value<int> freeMinutes;
  final Value<int> longestGapBetweenActivitiesMinutes;
  final Value<int> maxConsecutiveBlockMinutes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DailyFeatureSnapshotItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.analysisStartHour = const Value.absent(),
    this.analysisEndHour = const Value.absent(),
    this.predictionPhase = const Value.absent(),
    this.calculationVersion = const Value.absent(),
    this.calendarSnapshotKey = const Value.absent(),
    this.totalEventCount = const Value.absent(),
    this.allDayEventCount = const Value.absent(),
    this.totalScheduledMinutes = const Value.absent(),
    this.busyMinutes = const Value.absent(),
    this.focusMinutes = const Value.absent(),
    this.socialMinutes = const Value.absent(),
    this.lifeAdminMinutes = const Value.absent(),
    this.exerciseMinutes = const Value.absent(),
    this.restMinutes = const Value.absent(),
    this.backToBackEventCount = const Value.absent(),
    this.freeMinutes = const Value.absent(),
    this.longestGapBetweenActivitiesMinutes = const Value.absent(),
    this.maxConsecutiveBlockMinutes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyFeatureSnapshotItemsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required DateTime capturedAt,
    required int analysisStartHour,
    required int analysisEndHour,
    required String predictionPhase,
    required int calculationVersion,
    required String calendarSnapshotKey,
    required int totalEventCount,
    required int allDayEventCount,
    required int totalScheduledMinutes,
    required int busyMinutes,
    required int focusMinutes,
    required int socialMinutes,
    required int lifeAdminMinutes,
    required int exerciseMinutes,
    required int restMinutes,
    required int backToBackEventCount,
    required int freeMinutes,
    required int longestGapBetweenActivitiesMinutes,
    required int maxConsecutiveBlockMinutes,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : date = Value(date),
       capturedAt = Value(capturedAt),
       analysisStartHour = Value(analysisStartHour),
       analysisEndHour = Value(analysisEndHour),
       predictionPhase = Value(predictionPhase),
       calculationVersion = Value(calculationVersion),
       calendarSnapshotKey = Value(calendarSnapshotKey),
       totalEventCount = Value(totalEventCount),
       allDayEventCount = Value(allDayEventCount),
       totalScheduledMinutes = Value(totalScheduledMinutes),
       busyMinutes = Value(busyMinutes),
       focusMinutes = Value(focusMinutes),
       socialMinutes = Value(socialMinutes),
       lifeAdminMinutes = Value(lifeAdminMinutes),
       exerciseMinutes = Value(exerciseMinutes),
       restMinutes = Value(restMinutes),
       backToBackEventCount = Value(backToBackEventCount),
       freeMinutes = Value(freeMinutes),
       longestGapBetweenActivitiesMinutes = Value(
         longestGapBetweenActivitiesMinutes,
       ),
       maxConsecutiveBlockMinutes = Value(maxConsecutiveBlockMinutes);
  static Insertable<DailyFeatureSnapshotItem> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<DateTime>? capturedAt,
    Expression<int>? analysisStartHour,
    Expression<int>? analysisEndHour,
    Expression<String>? predictionPhase,
    Expression<int>? calculationVersion,
    Expression<String>? calendarSnapshotKey,
    Expression<int>? totalEventCount,
    Expression<int>? allDayEventCount,
    Expression<int>? totalScheduledMinutes,
    Expression<int>? busyMinutes,
    Expression<int>? focusMinutes,
    Expression<int>? socialMinutes,
    Expression<int>? lifeAdminMinutes,
    Expression<int>? exerciseMinutes,
    Expression<int>? restMinutes,
    Expression<int>? backToBackEventCount,
    Expression<int>? freeMinutes,
    Expression<int>? longestGapBetweenActivitiesMinutes,
    Expression<int>? maxConsecutiveBlockMinutes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (analysisStartHour != null) 'analysis_start_hour': analysisStartHour,
      if (analysisEndHour != null) 'analysis_end_hour': analysisEndHour,
      if (predictionPhase != null) 'prediction_phase': predictionPhase,
      if (calculationVersion != null) 'calculation_version': calculationVersion,
      if (calendarSnapshotKey != null)
        'calendar_snapshot_key': calendarSnapshotKey,
      if (totalEventCount != null) 'total_event_count': totalEventCount,
      if (allDayEventCount != null) 'all_day_event_count': allDayEventCount,
      if (totalScheduledMinutes != null)
        'total_scheduled_minutes': totalScheduledMinutes,
      if (busyMinutes != null) 'busy_minutes': busyMinutes,
      if (focusMinutes != null) 'focus_minutes': focusMinutes,
      if (socialMinutes != null) 'social_minutes': socialMinutes,
      if (lifeAdminMinutes != null) 'life_admin_minutes': lifeAdminMinutes,
      if (exerciseMinutes != null) 'exercise_minutes': exerciseMinutes,
      if (restMinutes != null) 'rest_minutes': restMinutes,
      if (backToBackEventCount != null)
        'back_to_back_event_count': backToBackEventCount,
      if (freeMinutes != null) 'free_minutes': freeMinutes,
      if (longestGapBetweenActivitiesMinutes != null)
        'longest_gap_between_activities_minutes':
            longestGapBetweenActivitiesMinutes,
      if (maxConsecutiveBlockMinutes != null)
        'max_consecutive_block_minutes': maxConsecutiveBlockMinutes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyFeatureSnapshotItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<DateTime>? capturedAt,
    Value<int>? analysisStartHour,
    Value<int>? analysisEndHour,
    Value<String>? predictionPhase,
    Value<int>? calculationVersion,
    Value<String>? calendarSnapshotKey,
    Value<int>? totalEventCount,
    Value<int>? allDayEventCount,
    Value<int>? totalScheduledMinutes,
    Value<int>? busyMinutes,
    Value<int>? focusMinutes,
    Value<int>? socialMinutes,
    Value<int>? lifeAdminMinutes,
    Value<int>? exerciseMinutes,
    Value<int>? restMinutes,
    Value<int>? backToBackEventCount,
    Value<int>? freeMinutes,
    Value<int>? longestGapBetweenActivitiesMinutes,
    Value<int>? maxConsecutiveBlockMinutes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DailyFeatureSnapshotItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      capturedAt: capturedAt ?? this.capturedAt,
      analysisStartHour: analysisStartHour ?? this.analysisStartHour,
      analysisEndHour: analysisEndHour ?? this.analysisEndHour,
      predictionPhase: predictionPhase ?? this.predictionPhase,
      calculationVersion: calculationVersion ?? this.calculationVersion,
      calendarSnapshotKey: calendarSnapshotKey ?? this.calendarSnapshotKey,
      totalEventCount: totalEventCount ?? this.totalEventCount,
      allDayEventCount: allDayEventCount ?? this.allDayEventCount,
      totalScheduledMinutes:
          totalScheduledMinutes ?? this.totalScheduledMinutes,
      busyMinutes: busyMinutes ?? this.busyMinutes,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      socialMinutes: socialMinutes ?? this.socialMinutes,
      lifeAdminMinutes: lifeAdminMinutes ?? this.lifeAdminMinutes,
      exerciseMinutes: exerciseMinutes ?? this.exerciseMinutes,
      restMinutes: restMinutes ?? this.restMinutes,
      backToBackEventCount: backToBackEventCount ?? this.backToBackEventCount,
      freeMinutes: freeMinutes ?? this.freeMinutes,
      longestGapBetweenActivitiesMinutes:
          longestGapBetweenActivitiesMinutes ??
          this.longestGapBetweenActivitiesMinutes,
      maxConsecutiveBlockMinutes:
          maxConsecutiveBlockMinutes ?? this.maxConsecutiveBlockMinutes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (analysisStartHour.present) {
      map['analysis_start_hour'] = Variable<int>(analysisStartHour.value);
    }
    if (analysisEndHour.present) {
      map['analysis_end_hour'] = Variable<int>(analysisEndHour.value);
    }
    if (predictionPhase.present) {
      map['prediction_phase'] = Variable<String>(predictionPhase.value);
    }
    if (calculationVersion.present) {
      map['calculation_version'] = Variable<int>(calculationVersion.value);
    }
    if (calendarSnapshotKey.present) {
      map['calendar_snapshot_key'] = Variable<String>(
        calendarSnapshotKey.value,
      );
    }
    if (totalEventCount.present) {
      map['total_event_count'] = Variable<int>(totalEventCount.value);
    }
    if (allDayEventCount.present) {
      map['all_day_event_count'] = Variable<int>(allDayEventCount.value);
    }
    if (totalScheduledMinutes.present) {
      map['total_scheduled_minutes'] = Variable<int>(
        totalScheduledMinutes.value,
      );
    }
    if (busyMinutes.present) {
      map['busy_minutes'] = Variable<int>(busyMinutes.value);
    }
    if (focusMinutes.present) {
      map['focus_minutes'] = Variable<int>(focusMinutes.value);
    }
    if (socialMinutes.present) {
      map['social_minutes'] = Variable<int>(socialMinutes.value);
    }
    if (lifeAdminMinutes.present) {
      map['life_admin_minutes'] = Variable<int>(lifeAdminMinutes.value);
    }
    if (exerciseMinutes.present) {
      map['exercise_minutes'] = Variable<int>(exerciseMinutes.value);
    }
    if (restMinutes.present) {
      map['rest_minutes'] = Variable<int>(restMinutes.value);
    }
    if (backToBackEventCount.present) {
      map['back_to_back_event_count'] = Variable<int>(
        backToBackEventCount.value,
      );
    }
    if (freeMinutes.present) {
      map['free_minutes'] = Variable<int>(freeMinutes.value);
    }
    if (longestGapBetweenActivitiesMinutes.present) {
      map['longest_gap_between_activities_minutes'] = Variable<int>(
        longestGapBetweenActivitiesMinutes.value,
      );
    }
    if (maxConsecutiveBlockMinutes.present) {
      map['max_consecutive_block_minutes'] = Variable<int>(
        maxConsecutiveBlockMinutes.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyFeatureSnapshotItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('analysisStartHour: $analysisStartHour, ')
          ..write('analysisEndHour: $analysisEndHour, ')
          ..write('predictionPhase: $predictionPhase, ')
          ..write('calculationVersion: $calculationVersion, ')
          ..write('calendarSnapshotKey: $calendarSnapshotKey, ')
          ..write('totalEventCount: $totalEventCount, ')
          ..write('allDayEventCount: $allDayEventCount, ')
          ..write('totalScheduledMinutes: $totalScheduledMinutes, ')
          ..write('busyMinutes: $busyMinutes, ')
          ..write('focusMinutes: $focusMinutes, ')
          ..write('socialMinutes: $socialMinutes, ')
          ..write('lifeAdminMinutes: $lifeAdminMinutes, ')
          ..write('exerciseMinutes: $exerciseMinutes, ')
          ..write('restMinutes: $restMinutes, ')
          ..write('backToBackEventCount: $backToBackEventCount, ')
          ..write('freeMinutes: $freeMinutes, ')
          ..write(
            'longestGapBetweenActivitiesMinutes: $longestGapBetweenActivitiesMinutes, ',
          )
          ..write('maxConsecutiveBlockMinutes: $maxConsecutiveBlockMinutes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DailyPredictionItemsTable extends DailyPredictionItems
    with TableInfo<$DailyPredictionItemsTable, DailyPredictionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyPredictionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _featureSnapshotIdMeta = const VerificationMeta(
    'featureSnapshotId',
  );
  @override
  late final GeneratedColumn<int> featureSnapshotId = GeneratedColumn<int>(
    'feature_snapshot_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES daily_feature_snapshot_items (id)',
    ),
  );
  static const VerificationMeta _predictedCategoryMeta = const VerificationMeta(
    'predictedCategory',
  );
  @override
  late final GeneratedColumn<String> predictedCategory =
      GeneratedColumn<String>(
        'predicted_category',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _predictedScoreMeta = const VerificationMeta(
    'predictedScore',
  );
  @override
  late final GeneratedColumn<double> predictedScore = GeneratedColumn<double>(
    'predicted_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reasonsJsonMeta = const VerificationMeta(
    'reasonsJson',
  );
  @override
  late final GeneratedColumn<String> reasonsJson = GeneratedColumn<String>(
    'reasons_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _predictionVersionMeta = const VerificationMeta(
    'predictionVersion',
  );
  @override
  late final GeneratedColumn<String> predictionVersion =
      GeneratedColumn<String>(
        'prediction_version',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _agreementScoreMeta = const VerificationMeta(
    'agreementScore',
  );
  @override
  late final GeneratedColumn<int> agreementScore = GeneratedColumn<int>(
    'agreement_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _feedbackUpdatedAtMeta = const VerificationMeta(
    'feedbackUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> feedbackUpdatedAt =
      GeneratedColumn<DateTime>(
        'feedback_updated_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    featureSnapshotId,
    predictedCategory,
    predictedScore,
    reasonsJson,
    predictionVersion,
    agreementScore,
    feedbackUpdatedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_prediction_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyPredictionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('feature_snapshot_id')) {
      context.handle(
        _featureSnapshotIdMeta,
        featureSnapshotId.isAcceptableOrUnknown(
          data['feature_snapshot_id']!,
          _featureSnapshotIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_featureSnapshotIdMeta);
    }
    if (data.containsKey('predicted_category')) {
      context.handle(
        _predictedCategoryMeta,
        predictedCategory.isAcceptableOrUnknown(
          data['predicted_category']!,
          _predictedCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_predictedCategoryMeta);
    }
    if (data.containsKey('predicted_score')) {
      context.handle(
        _predictedScoreMeta,
        predictedScore.isAcceptableOrUnknown(
          data['predicted_score']!,
          _predictedScoreMeta,
        ),
      );
    }
    if (data.containsKey('reasons_json')) {
      context.handle(
        _reasonsJsonMeta,
        reasonsJson.isAcceptableOrUnknown(
          data['reasons_json']!,
          _reasonsJsonMeta,
        ),
      );
    }
    if (data.containsKey('prediction_version')) {
      context.handle(
        _predictionVersionMeta,
        predictionVersion.isAcceptableOrUnknown(
          data['prediction_version']!,
          _predictionVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_predictionVersionMeta);
    }
    if (data.containsKey('agreement_score')) {
      context.handle(
        _agreementScoreMeta,
        agreementScore.isAcceptableOrUnknown(
          data['agreement_score']!,
          _agreementScoreMeta,
        ),
      );
    }
    if (data.containsKey('feedback_updated_at')) {
      context.handle(
        _feedbackUpdatedAtMeta,
        feedbackUpdatedAt.isAcceptableOrUnknown(
          data['feedback_updated_at']!,
          _feedbackUpdatedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyPredictionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyPredictionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      featureSnapshotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}feature_snapshot_id'],
      )!,
      predictedCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}predicted_category'],
      )!,
      predictedScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}predicted_score'],
      ),
      reasonsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reasons_json'],
      )!,
      predictionVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prediction_version'],
      )!,
      agreementScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}agreement_score'],
      ),
      feedbackUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}feedback_updated_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DailyPredictionItemsTable createAlias(String alias) {
    return $DailyPredictionItemsTable(attachedDatabase, alias);
  }
}

class DailyPredictionItem extends DataClass
    implements Insertable<DailyPredictionItem> {
  final int id;
  final String date;
  final int featureSnapshotId;
  final String predictedCategory;
  final double? predictedScore;
  final String reasonsJson;
  final String predictionVersion;
  final int? agreementScore;
  final DateTime? feedbackUpdatedAt;
  final DateTime createdAt;
  const DailyPredictionItem({
    required this.id,
    required this.date,
    required this.featureSnapshotId,
    required this.predictedCategory,
    this.predictedScore,
    required this.reasonsJson,
    required this.predictionVersion,
    this.agreementScore,
    this.feedbackUpdatedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['feature_snapshot_id'] = Variable<int>(featureSnapshotId);
    map['predicted_category'] = Variable<String>(predictedCategory);
    if (!nullToAbsent || predictedScore != null) {
      map['predicted_score'] = Variable<double>(predictedScore);
    }
    map['reasons_json'] = Variable<String>(reasonsJson);
    map['prediction_version'] = Variable<String>(predictionVersion);
    if (!nullToAbsent || agreementScore != null) {
      map['agreement_score'] = Variable<int>(agreementScore);
    }
    if (!nullToAbsent || feedbackUpdatedAt != null) {
      map['feedback_updated_at'] = Variable<DateTime>(feedbackUpdatedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DailyPredictionItemsCompanion toCompanion(bool nullToAbsent) {
    return DailyPredictionItemsCompanion(
      id: Value(id),
      date: Value(date),
      featureSnapshotId: Value(featureSnapshotId),
      predictedCategory: Value(predictedCategory),
      predictedScore: predictedScore == null && nullToAbsent
          ? const Value.absent()
          : Value(predictedScore),
      reasonsJson: Value(reasonsJson),
      predictionVersion: Value(predictionVersion),
      agreementScore: agreementScore == null && nullToAbsent
          ? const Value.absent()
          : Value(agreementScore),
      feedbackUpdatedAt: feedbackUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(feedbackUpdatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory DailyPredictionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyPredictionItem(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      featureSnapshotId: serializer.fromJson<int>(json['featureSnapshotId']),
      predictedCategory: serializer.fromJson<String>(json['predictedCategory']),
      predictedScore: serializer.fromJson<double?>(json['predictedScore']),
      reasonsJson: serializer.fromJson<String>(json['reasonsJson']),
      predictionVersion: serializer.fromJson<String>(json['predictionVersion']),
      agreementScore: serializer.fromJson<int?>(json['agreementScore']),
      feedbackUpdatedAt: serializer.fromJson<DateTime?>(
        json['feedbackUpdatedAt'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'featureSnapshotId': serializer.toJson<int>(featureSnapshotId),
      'predictedCategory': serializer.toJson<String>(predictedCategory),
      'predictedScore': serializer.toJson<double?>(predictedScore),
      'reasonsJson': serializer.toJson<String>(reasonsJson),
      'predictionVersion': serializer.toJson<String>(predictionVersion),
      'agreementScore': serializer.toJson<int?>(agreementScore),
      'feedbackUpdatedAt': serializer.toJson<DateTime?>(feedbackUpdatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DailyPredictionItem copyWith({
    int? id,
    String? date,
    int? featureSnapshotId,
    String? predictedCategory,
    Value<double?> predictedScore = const Value.absent(),
    String? reasonsJson,
    String? predictionVersion,
    Value<int?> agreementScore = const Value.absent(),
    Value<DateTime?> feedbackUpdatedAt = const Value.absent(),
    DateTime? createdAt,
  }) => DailyPredictionItem(
    id: id ?? this.id,
    date: date ?? this.date,
    featureSnapshotId: featureSnapshotId ?? this.featureSnapshotId,
    predictedCategory: predictedCategory ?? this.predictedCategory,
    predictedScore: predictedScore.present
        ? predictedScore.value
        : this.predictedScore,
    reasonsJson: reasonsJson ?? this.reasonsJson,
    predictionVersion: predictionVersion ?? this.predictionVersion,
    agreementScore: agreementScore.present
        ? agreementScore.value
        : this.agreementScore,
    feedbackUpdatedAt: feedbackUpdatedAt.present
        ? feedbackUpdatedAt.value
        : this.feedbackUpdatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  DailyPredictionItem copyWithCompanion(DailyPredictionItemsCompanion data) {
    return DailyPredictionItem(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      featureSnapshotId: data.featureSnapshotId.present
          ? data.featureSnapshotId.value
          : this.featureSnapshotId,
      predictedCategory: data.predictedCategory.present
          ? data.predictedCategory.value
          : this.predictedCategory,
      predictedScore: data.predictedScore.present
          ? data.predictedScore.value
          : this.predictedScore,
      reasonsJson: data.reasonsJson.present
          ? data.reasonsJson.value
          : this.reasonsJson,
      predictionVersion: data.predictionVersion.present
          ? data.predictionVersion.value
          : this.predictionVersion,
      agreementScore: data.agreementScore.present
          ? data.agreementScore.value
          : this.agreementScore,
      feedbackUpdatedAt: data.feedbackUpdatedAt.present
          ? data.feedbackUpdatedAt.value
          : this.feedbackUpdatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyPredictionItem(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('featureSnapshotId: $featureSnapshotId, ')
          ..write('predictedCategory: $predictedCategory, ')
          ..write('predictedScore: $predictedScore, ')
          ..write('reasonsJson: $reasonsJson, ')
          ..write('predictionVersion: $predictionVersion, ')
          ..write('agreementScore: $agreementScore, ')
          ..write('feedbackUpdatedAt: $feedbackUpdatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    featureSnapshotId,
    predictedCategory,
    predictedScore,
    reasonsJson,
    predictionVersion,
    agreementScore,
    feedbackUpdatedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyPredictionItem &&
          other.id == this.id &&
          other.date == this.date &&
          other.featureSnapshotId == this.featureSnapshotId &&
          other.predictedCategory == this.predictedCategory &&
          other.predictedScore == this.predictedScore &&
          other.reasonsJson == this.reasonsJson &&
          other.predictionVersion == this.predictionVersion &&
          other.agreementScore == this.agreementScore &&
          other.feedbackUpdatedAt == this.feedbackUpdatedAt &&
          other.createdAt == this.createdAt);
}

class DailyPredictionItemsCompanion
    extends UpdateCompanion<DailyPredictionItem> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> featureSnapshotId;
  final Value<String> predictedCategory;
  final Value<double?> predictedScore;
  final Value<String> reasonsJson;
  final Value<String> predictionVersion;
  final Value<int?> agreementScore;
  final Value<DateTime?> feedbackUpdatedAt;
  final Value<DateTime> createdAt;
  const DailyPredictionItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.featureSnapshotId = const Value.absent(),
    this.predictedCategory = const Value.absent(),
    this.predictedScore = const Value.absent(),
    this.reasonsJson = const Value.absent(),
    this.predictionVersion = const Value.absent(),
    this.agreementScore = const Value.absent(),
    this.feedbackUpdatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DailyPredictionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int featureSnapshotId,
    required String predictedCategory,
    this.predictedScore = const Value.absent(),
    this.reasonsJson = const Value.absent(),
    required String predictionVersion,
    this.agreementScore = const Value.absent(),
    this.feedbackUpdatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date),
       featureSnapshotId = Value(featureSnapshotId),
       predictedCategory = Value(predictedCategory),
       predictionVersion = Value(predictionVersion);
  static Insertable<DailyPredictionItem> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? featureSnapshotId,
    Expression<String>? predictedCategory,
    Expression<double>? predictedScore,
    Expression<String>? reasonsJson,
    Expression<String>? predictionVersion,
    Expression<int>? agreementScore,
    Expression<DateTime>? feedbackUpdatedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (featureSnapshotId != null) 'feature_snapshot_id': featureSnapshotId,
      if (predictedCategory != null) 'predicted_category': predictedCategory,
      if (predictedScore != null) 'predicted_score': predictedScore,
      if (reasonsJson != null) 'reasons_json': reasonsJson,
      if (predictionVersion != null) 'prediction_version': predictionVersion,
      if (agreementScore != null) 'agreement_score': agreementScore,
      if (feedbackUpdatedAt != null) 'feedback_updated_at': feedbackUpdatedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DailyPredictionItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<int>? featureSnapshotId,
    Value<String>? predictedCategory,
    Value<double?>? predictedScore,
    Value<String>? reasonsJson,
    Value<String>? predictionVersion,
    Value<int?>? agreementScore,
    Value<DateTime?>? feedbackUpdatedAt,
    Value<DateTime>? createdAt,
  }) {
    return DailyPredictionItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      featureSnapshotId: featureSnapshotId ?? this.featureSnapshotId,
      predictedCategory: predictedCategory ?? this.predictedCategory,
      predictedScore: predictedScore ?? this.predictedScore,
      reasonsJson: reasonsJson ?? this.reasonsJson,
      predictionVersion: predictionVersion ?? this.predictionVersion,
      agreementScore: agreementScore ?? this.agreementScore,
      feedbackUpdatedAt: feedbackUpdatedAt ?? this.feedbackUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (featureSnapshotId.present) {
      map['feature_snapshot_id'] = Variable<int>(featureSnapshotId.value);
    }
    if (predictedCategory.present) {
      map['predicted_category'] = Variable<String>(predictedCategory.value);
    }
    if (predictedScore.present) {
      map['predicted_score'] = Variable<double>(predictedScore.value);
    }
    if (reasonsJson.present) {
      map['reasons_json'] = Variable<String>(reasonsJson.value);
    }
    if (predictionVersion.present) {
      map['prediction_version'] = Variable<String>(predictionVersion.value);
    }
    if (agreementScore.present) {
      map['agreement_score'] = Variable<int>(agreementScore.value);
    }
    if (feedbackUpdatedAt.present) {
      map['feedback_updated_at'] = Variable<DateTime>(feedbackUpdatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyPredictionItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('featureSnapshotId: $featureSnapshotId, ')
          ..write('predictedCategory: $predictedCategory, ')
          ..write('predictedScore: $predictedScore, ')
          ..write('reasonsJson: $reasonsJson, ')
          ..write('predictionVersion: $predictionVersion, ')
          ..write('agreementScore: $agreementScore, ')
          ..write('feedbackUpdatedAt: $feedbackUpdatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ForecastReflectionItemsTable extends ForecastReflectionItems
    with TableInfo<$ForecastReflectionItemsTable, ForecastReflectionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ForecastReflectionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _predictionIdMeta = const VerificationMeta(
    'predictionId',
  );
  @override
  late final GeneratedColumn<int> predictionId = GeneratedColumn<int>(
    'prediction_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES daily_prediction_items (id)',
    ),
  );
  static const VerificationMeta _supportiveFactorTypeMeta =
      const VerificationMeta('supportiveFactorType');
  @override
  late final GeneratedColumn<String> supportiveFactorType =
      GeneratedColumn<String>(
        'supportive_factor_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _supportiveFactorLabelMeta =
      const VerificationMeta('supportiveFactorLabel');
  @override
  late final GeneratedColumn<String> supportiveFactorLabel =
      GeneratedColumn<String>(
        'supportive_factor_label',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _demandingFactorTypeMeta =
      const VerificationMeta('demandingFactorType');
  @override
  late final GeneratedColumn<String> demandingFactorType =
      GeneratedColumn<String>(
        'demanding_factor_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _demandingFactorLabelMeta =
      const VerificationMeta('demandingFactorLabel');
  @override
  late final GeneratedColumn<String> demandingFactorLabel =
      GeneratedColumn<String>(
        'demanding_factor_label',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _modelSupportiveFactorTypeMeta =
      const VerificationMeta('modelSupportiveFactorType');
  @override
  late final GeneratedColumn<String> modelSupportiveFactorType =
      GeneratedColumn<String>(
        'model_supportive_factor_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _modelSupportiveFactorLabelMeta =
      const VerificationMeta('modelSupportiveFactorLabel');
  @override
  late final GeneratedColumn<String> modelSupportiveFactorLabel =
      GeneratedColumn<String>(
        'model_supportive_factor_label',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _modelDemandingFactorTypeMeta =
      const VerificationMeta('modelDemandingFactorType');
  @override
  late final GeneratedColumn<String> modelDemandingFactorType =
      GeneratedColumn<String>(
        'model_demanding_factor_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _modelDemandingFactorLabelMeta =
      const VerificationMeta('modelDemandingFactorLabel');
  @override
  late final GeneratedColumn<String> modelDemandingFactorLabel =
      GeneratedColumn<String>(
        'model_demanding_factor_label',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _revealedAtMeta = const VerificationMeta(
    'revealedAt',
  );
  @override
  late final GeneratedColumn<DateTime> revealedAt = GeneratedColumn<DateTime>(
    'revealed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    predictionId,
    supportiveFactorType,
    supportiveFactorLabel,
    demandingFactorType,
    demandingFactorLabel,
    modelSupportiveFactorType,
    modelSupportiveFactorLabel,
    modelDemandingFactorType,
    modelDemandingFactorLabel,
    revealedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forecast_reflection_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ForecastReflectionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('prediction_id')) {
      context.handle(
        _predictionIdMeta,
        predictionId.isAcceptableOrUnknown(
          data['prediction_id']!,
          _predictionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_predictionIdMeta);
    }
    if (data.containsKey('supportive_factor_type')) {
      context.handle(
        _supportiveFactorTypeMeta,
        supportiveFactorType.isAcceptableOrUnknown(
          data['supportive_factor_type']!,
          _supportiveFactorTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supportiveFactorTypeMeta);
    }
    if (data.containsKey('supportive_factor_label')) {
      context.handle(
        _supportiveFactorLabelMeta,
        supportiveFactorLabel.isAcceptableOrUnknown(
          data['supportive_factor_label']!,
          _supportiveFactorLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supportiveFactorLabelMeta);
    }
    if (data.containsKey('demanding_factor_type')) {
      context.handle(
        _demandingFactorTypeMeta,
        demandingFactorType.isAcceptableOrUnknown(
          data['demanding_factor_type']!,
          _demandingFactorTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_demandingFactorTypeMeta);
    }
    if (data.containsKey('demanding_factor_label')) {
      context.handle(
        _demandingFactorLabelMeta,
        demandingFactorLabel.isAcceptableOrUnknown(
          data['demanding_factor_label']!,
          _demandingFactorLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_demandingFactorLabelMeta);
    }
    if (data.containsKey('model_supportive_factor_type')) {
      context.handle(
        _modelSupportiveFactorTypeMeta,
        modelSupportiveFactorType.isAcceptableOrUnknown(
          data['model_supportive_factor_type']!,
          _modelSupportiveFactorTypeMeta,
        ),
      );
    }
    if (data.containsKey('model_supportive_factor_label')) {
      context.handle(
        _modelSupportiveFactorLabelMeta,
        modelSupportiveFactorLabel.isAcceptableOrUnknown(
          data['model_supportive_factor_label']!,
          _modelSupportiveFactorLabelMeta,
        ),
      );
    }
    if (data.containsKey('model_demanding_factor_type')) {
      context.handle(
        _modelDemandingFactorTypeMeta,
        modelDemandingFactorType.isAcceptableOrUnknown(
          data['model_demanding_factor_type']!,
          _modelDemandingFactorTypeMeta,
        ),
      );
    }
    if (data.containsKey('model_demanding_factor_label')) {
      context.handle(
        _modelDemandingFactorLabelMeta,
        modelDemandingFactorLabel.isAcceptableOrUnknown(
          data['model_demanding_factor_label']!,
          _modelDemandingFactorLabelMeta,
        ),
      );
    }
    if (data.containsKey('revealed_at')) {
      context.handle(
        _revealedAtMeta,
        revealedAt.isAcceptableOrUnknown(data['revealed_at']!, _revealedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_revealedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ForecastReflectionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ForecastReflectionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      predictionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prediction_id'],
      )!,
      supportiveFactorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supportive_factor_type'],
      )!,
      supportiveFactorLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supportive_factor_label'],
      )!,
      demandingFactorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}demanding_factor_type'],
      )!,
      demandingFactorLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}demanding_factor_label'],
      )!,
      modelSupportiveFactorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_supportive_factor_type'],
      ),
      modelSupportiveFactorLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_supportive_factor_label'],
      ),
      modelDemandingFactorType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_demanding_factor_type'],
      ),
      modelDemandingFactorLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_demanding_factor_label'],
      ),
      revealedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}revealed_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ForecastReflectionItemsTable createAlias(String alias) {
    return $ForecastReflectionItemsTable(attachedDatabase, alias);
  }
}

class ForecastReflectionItem extends DataClass
    implements Insertable<ForecastReflectionItem> {
  final int id;
  final String date;
  final int predictionId;
  final String supportiveFactorType;
  final String supportiveFactorLabel;
  final String demandingFactorType;
  final String demandingFactorLabel;
  final String? modelSupportiveFactorType;
  final String? modelSupportiveFactorLabel;
  final String? modelDemandingFactorType;
  final String? modelDemandingFactorLabel;
  final DateTime revealedAt;
  final DateTime updatedAt;
  const ForecastReflectionItem({
    required this.id,
    required this.date,
    required this.predictionId,
    required this.supportiveFactorType,
    required this.supportiveFactorLabel,
    required this.demandingFactorType,
    required this.demandingFactorLabel,
    this.modelSupportiveFactorType,
    this.modelSupportiveFactorLabel,
    this.modelDemandingFactorType,
    this.modelDemandingFactorLabel,
    required this.revealedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['prediction_id'] = Variable<int>(predictionId);
    map['supportive_factor_type'] = Variable<String>(supportiveFactorType);
    map['supportive_factor_label'] = Variable<String>(supportiveFactorLabel);
    map['demanding_factor_type'] = Variable<String>(demandingFactorType);
    map['demanding_factor_label'] = Variable<String>(demandingFactorLabel);
    if (!nullToAbsent || modelSupportiveFactorType != null) {
      map['model_supportive_factor_type'] = Variable<String>(
        modelSupportiveFactorType,
      );
    }
    if (!nullToAbsent || modelSupportiveFactorLabel != null) {
      map['model_supportive_factor_label'] = Variable<String>(
        modelSupportiveFactorLabel,
      );
    }
    if (!nullToAbsent || modelDemandingFactorType != null) {
      map['model_demanding_factor_type'] = Variable<String>(
        modelDemandingFactorType,
      );
    }
    if (!nullToAbsent || modelDemandingFactorLabel != null) {
      map['model_demanding_factor_label'] = Variable<String>(
        modelDemandingFactorLabel,
      );
    }
    map['revealed_at'] = Variable<DateTime>(revealedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ForecastReflectionItemsCompanion toCompanion(bool nullToAbsent) {
    return ForecastReflectionItemsCompanion(
      id: Value(id),
      date: Value(date),
      predictionId: Value(predictionId),
      supportiveFactorType: Value(supportiveFactorType),
      supportiveFactorLabel: Value(supportiveFactorLabel),
      demandingFactorType: Value(demandingFactorType),
      demandingFactorLabel: Value(demandingFactorLabel),
      modelSupportiveFactorType:
          modelSupportiveFactorType == null && nullToAbsent
          ? const Value.absent()
          : Value(modelSupportiveFactorType),
      modelSupportiveFactorLabel:
          modelSupportiveFactorLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(modelSupportiveFactorLabel),
      modelDemandingFactorType: modelDemandingFactorType == null && nullToAbsent
          ? const Value.absent()
          : Value(modelDemandingFactorType),
      modelDemandingFactorLabel:
          modelDemandingFactorLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(modelDemandingFactorLabel),
      revealedAt: Value(revealedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ForecastReflectionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ForecastReflectionItem(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      predictionId: serializer.fromJson<int>(json['predictionId']),
      supportiveFactorType: serializer.fromJson<String>(
        json['supportiveFactorType'],
      ),
      supportiveFactorLabel: serializer.fromJson<String>(
        json['supportiveFactorLabel'],
      ),
      demandingFactorType: serializer.fromJson<String>(
        json['demandingFactorType'],
      ),
      demandingFactorLabel: serializer.fromJson<String>(
        json['demandingFactorLabel'],
      ),
      modelSupportiveFactorType: serializer.fromJson<String?>(
        json['modelSupportiveFactorType'],
      ),
      modelSupportiveFactorLabel: serializer.fromJson<String?>(
        json['modelSupportiveFactorLabel'],
      ),
      modelDemandingFactorType: serializer.fromJson<String?>(
        json['modelDemandingFactorType'],
      ),
      modelDemandingFactorLabel: serializer.fromJson<String?>(
        json['modelDemandingFactorLabel'],
      ),
      revealedAt: serializer.fromJson<DateTime>(json['revealedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'predictionId': serializer.toJson<int>(predictionId),
      'supportiveFactorType': serializer.toJson<String>(supportiveFactorType),
      'supportiveFactorLabel': serializer.toJson<String>(supportiveFactorLabel),
      'demandingFactorType': serializer.toJson<String>(demandingFactorType),
      'demandingFactorLabel': serializer.toJson<String>(demandingFactorLabel),
      'modelSupportiveFactorType': serializer.toJson<String?>(
        modelSupportiveFactorType,
      ),
      'modelSupportiveFactorLabel': serializer.toJson<String?>(
        modelSupportiveFactorLabel,
      ),
      'modelDemandingFactorType': serializer.toJson<String?>(
        modelDemandingFactorType,
      ),
      'modelDemandingFactorLabel': serializer.toJson<String?>(
        modelDemandingFactorLabel,
      ),
      'revealedAt': serializer.toJson<DateTime>(revealedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ForecastReflectionItem copyWith({
    int? id,
    String? date,
    int? predictionId,
    String? supportiveFactorType,
    String? supportiveFactorLabel,
    String? demandingFactorType,
    String? demandingFactorLabel,
    Value<String?> modelSupportiveFactorType = const Value.absent(),
    Value<String?> modelSupportiveFactorLabel = const Value.absent(),
    Value<String?> modelDemandingFactorType = const Value.absent(),
    Value<String?> modelDemandingFactorLabel = const Value.absent(),
    DateTime? revealedAt,
    DateTime? updatedAt,
  }) => ForecastReflectionItem(
    id: id ?? this.id,
    date: date ?? this.date,
    predictionId: predictionId ?? this.predictionId,
    supportiveFactorType: supportiveFactorType ?? this.supportiveFactorType,
    supportiveFactorLabel: supportiveFactorLabel ?? this.supportiveFactorLabel,
    demandingFactorType: demandingFactorType ?? this.demandingFactorType,
    demandingFactorLabel: demandingFactorLabel ?? this.demandingFactorLabel,
    modelSupportiveFactorType: modelSupportiveFactorType.present
        ? modelSupportiveFactorType.value
        : this.modelSupportiveFactorType,
    modelSupportiveFactorLabel: modelSupportiveFactorLabel.present
        ? modelSupportiveFactorLabel.value
        : this.modelSupportiveFactorLabel,
    modelDemandingFactorType: modelDemandingFactorType.present
        ? modelDemandingFactorType.value
        : this.modelDemandingFactorType,
    modelDemandingFactorLabel: modelDemandingFactorLabel.present
        ? modelDemandingFactorLabel.value
        : this.modelDemandingFactorLabel,
    revealedAt: revealedAt ?? this.revealedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ForecastReflectionItem copyWithCompanion(
    ForecastReflectionItemsCompanion data,
  ) {
    return ForecastReflectionItem(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      predictionId: data.predictionId.present
          ? data.predictionId.value
          : this.predictionId,
      supportiveFactorType: data.supportiveFactorType.present
          ? data.supportiveFactorType.value
          : this.supportiveFactorType,
      supportiveFactorLabel: data.supportiveFactorLabel.present
          ? data.supportiveFactorLabel.value
          : this.supportiveFactorLabel,
      demandingFactorType: data.demandingFactorType.present
          ? data.demandingFactorType.value
          : this.demandingFactorType,
      demandingFactorLabel: data.demandingFactorLabel.present
          ? data.demandingFactorLabel.value
          : this.demandingFactorLabel,
      modelSupportiveFactorType: data.modelSupportiveFactorType.present
          ? data.modelSupportiveFactorType.value
          : this.modelSupportiveFactorType,
      modelSupportiveFactorLabel: data.modelSupportiveFactorLabel.present
          ? data.modelSupportiveFactorLabel.value
          : this.modelSupportiveFactorLabel,
      modelDemandingFactorType: data.modelDemandingFactorType.present
          ? data.modelDemandingFactorType.value
          : this.modelDemandingFactorType,
      modelDemandingFactorLabel: data.modelDemandingFactorLabel.present
          ? data.modelDemandingFactorLabel.value
          : this.modelDemandingFactorLabel,
      revealedAt: data.revealedAt.present
          ? data.revealedAt.value
          : this.revealedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ForecastReflectionItem(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('predictionId: $predictionId, ')
          ..write('supportiveFactorType: $supportiveFactorType, ')
          ..write('supportiveFactorLabel: $supportiveFactorLabel, ')
          ..write('demandingFactorType: $demandingFactorType, ')
          ..write('demandingFactorLabel: $demandingFactorLabel, ')
          ..write('modelSupportiveFactorType: $modelSupportiveFactorType, ')
          ..write('modelSupportiveFactorLabel: $modelSupportiveFactorLabel, ')
          ..write('modelDemandingFactorType: $modelDemandingFactorType, ')
          ..write('modelDemandingFactorLabel: $modelDemandingFactorLabel, ')
          ..write('revealedAt: $revealedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    predictionId,
    supportiveFactorType,
    supportiveFactorLabel,
    demandingFactorType,
    demandingFactorLabel,
    modelSupportiveFactorType,
    modelSupportiveFactorLabel,
    modelDemandingFactorType,
    modelDemandingFactorLabel,
    revealedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ForecastReflectionItem &&
          other.id == this.id &&
          other.date == this.date &&
          other.predictionId == this.predictionId &&
          other.supportiveFactorType == this.supportiveFactorType &&
          other.supportiveFactorLabel == this.supportiveFactorLabel &&
          other.demandingFactorType == this.demandingFactorType &&
          other.demandingFactorLabel == this.demandingFactorLabel &&
          other.modelSupportiveFactorType == this.modelSupportiveFactorType &&
          other.modelSupportiveFactorLabel == this.modelSupportiveFactorLabel &&
          other.modelDemandingFactorType == this.modelDemandingFactorType &&
          other.modelDemandingFactorLabel == this.modelDemandingFactorLabel &&
          other.revealedAt == this.revealedAt &&
          other.updatedAt == this.updatedAt);
}

class ForecastReflectionItemsCompanion
    extends UpdateCompanion<ForecastReflectionItem> {
  final Value<int> id;
  final Value<String> date;
  final Value<int> predictionId;
  final Value<String> supportiveFactorType;
  final Value<String> supportiveFactorLabel;
  final Value<String> demandingFactorType;
  final Value<String> demandingFactorLabel;
  final Value<String?> modelSupportiveFactorType;
  final Value<String?> modelSupportiveFactorLabel;
  final Value<String?> modelDemandingFactorType;
  final Value<String?> modelDemandingFactorLabel;
  final Value<DateTime> revealedAt;
  final Value<DateTime> updatedAt;
  const ForecastReflectionItemsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.predictionId = const Value.absent(),
    this.supportiveFactorType = const Value.absent(),
    this.supportiveFactorLabel = const Value.absent(),
    this.demandingFactorType = const Value.absent(),
    this.demandingFactorLabel = const Value.absent(),
    this.modelSupportiveFactorType = const Value.absent(),
    this.modelSupportiveFactorLabel = const Value.absent(),
    this.modelDemandingFactorType = const Value.absent(),
    this.modelDemandingFactorLabel = const Value.absent(),
    this.revealedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ForecastReflectionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required int predictionId,
    required String supportiveFactorType,
    required String supportiveFactorLabel,
    required String demandingFactorType,
    required String demandingFactorLabel,
    this.modelSupportiveFactorType = const Value.absent(),
    this.modelSupportiveFactorLabel = const Value.absent(),
    this.modelDemandingFactorType = const Value.absent(),
    this.modelDemandingFactorLabel = const Value.absent(),
    required DateTime revealedAt,
    this.updatedAt = const Value.absent(),
  }) : date = Value(date),
       predictionId = Value(predictionId),
       supportiveFactorType = Value(supportiveFactorType),
       supportiveFactorLabel = Value(supportiveFactorLabel),
       demandingFactorType = Value(demandingFactorType),
       demandingFactorLabel = Value(demandingFactorLabel),
       revealedAt = Value(revealedAt);
  static Insertable<ForecastReflectionItem> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<int>? predictionId,
    Expression<String>? supportiveFactorType,
    Expression<String>? supportiveFactorLabel,
    Expression<String>? demandingFactorType,
    Expression<String>? demandingFactorLabel,
    Expression<String>? modelSupportiveFactorType,
    Expression<String>? modelSupportiveFactorLabel,
    Expression<String>? modelDemandingFactorType,
    Expression<String>? modelDemandingFactorLabel,
    Expression<DateTime>? revealedAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (predictionId != null) 'prediction_id': predictionId,
      if (supportiveFactorType != null)
        'supportive_factor_type': supportiveFactorType,
      if (supportiveFactorLabel != null)
        'supportive_factor_label': supportiveFactorLabel,
      if (demandingFactorType != null)
        'demanding_factor_type': demandingFactorType,
      if (demandingFactorLabel != null)
        'demanding_factor_label': demandingFactorLabel,
      if (modelSupportiveFactorType != null)
        'model_supportive_factor_type': modelSupportiveFactorType,
      if (modelSupportiveFactorLabel != null)
        'model_supportive_factor_label': modelSupportiveFactorLabel,
      if (modelDemandingFactorType != null)
        'model_demanding_factor_type': modelDemandingFactorType,
      if (modelDemandingFactorLabel != null)
        'model_demanding_factor_label': modelDemandingFactorLabel,
      if (revealedAt != null) 'revealed_at': revealedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ForecastReflectionItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? date,
    Value<int>? predictionId,
    Value<String>? supportiveFactorType,
    Value<String>? supportiveFactorLabel,
    Value<String>? demandingFactorType,
    Value<String>? demandingFactorLabel,
    Value<String?>? modelSupportiveFactorType,
    Value<String?>? modelSupportiveFactorLabel,
    Value<String?>? modelDemandingFactorType,
    Value<String?>? modelDemandingFactorLabel,
    Value<DateTime>? revealedAt,
    Value<DateTime>? updatedAt,
  }) {
    return ForecastReflectionItemsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      predictionId: predictionId ?? this.predictionId,
      supportiveFactorType: supportiveFactorType ?? this.supportiveFactorType,
      supportiveFactorLabel:
          supportiveFactorLabel ?? this.supportiveFactorLabel,
      demandingFactorType: demandingFactorType ?? this.demandingFactorType,
      demandingFactorLabel: demandingFactorLabel ?? this.demandingFactorLabel,
      modelSupportiveFactorType:
          modelSupportiveFactorType ?? this.modelSupportiveFactorType,
      modelSupportiveFactorLabel:
          modelSupportiveFactorLabel ?? this.modelSupportiveFactorLabel,
      modelDemandingFactorType:
          modelDemandingFactorType ?? this.modelDemandingFactorType,
      modelDemandingFactorLabel:
          modelDemandingFactorLabel ?? this.modelDemandingFactorLabel,
      revealedAt: revealedAt ?? this.revealedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (predictionId.present) {
      map['prediction_id'] = Variable<int>(predictionId.value);
    }
    if (supportiveFactorType.present) {
      map['supportive_factor_type'] = Variable<String>(
        supportiveFactorType.value,
      );
    }
    if (supportiveFactorLabel.present) {
      map['supportive_factor_label'] = Variable<String>(
        supportiveFactorLabel.value,
      );
    }
    if (demandingFactorType.present) {
      map['demanding_factor_type'] = Variable<String>(
        demandingFactorType.value,
      );
    }
    if (demandingFactorLabel.present) {
      map['demanding_factor_label'] = Variable<String>(
        demandingFactorLabel.value,
      );
    }
    if (modelSupportiveFactorType.present) {
      map['model_supportive_factor_type'] = Variable<String>(
        modelSupportiveFactorType.value,
      );
    }
    if (modelSupportiveFactorLabel.present) {
      map['model_supportive_factor_label'] = Variable<String>(
        modelSupportiveFactorLabel.value,
      );
    }
    if (modelDemandingFactorType.present) {
      map['model_demanding_factor_type'] = Variable<String>(
        modelDemandingFactorType.value,
      );
    }
    if (modelDemandingFactorLabel.present) {
      map['model_demanding_factor_label'] = Variable<String>(
        modelDemandingFactorLabel.value,
      );
    }
    if (revealedAt.present) {
      map['revealed_at'] = Variable<DateTime>(revealedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ForecastReflectionItemsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('predictionId: $predictionId, ')
          ..write('supportiveFactorType: $supportiveFactorType, ')
          ..write('supportiveFactorLabel: $supportiveFactorLabel, ')
          ..write('demandingFactorType: $demandingFactorType, ')
          ..write('demandingFactorLabel: $demandingFactorLabel, ')
          ..write('modelSupportiveFactorType: $modelSupportiveFactorType, ')
          ..write('modelSupportiveFactorLabel: $modelSupportiveFactorLabel, ')
          ..write('modelDemandingFactorType: $modelDemandingFactorType, ')
          ..write('modelDemandingFactorLabel: $modelDemandingFactorLabel, ')
          ..write('revealedAt: $revealedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CalendarSyncItemsTable extends CalendarSyncItems
    with TableInfo<$CalendarSyncItemsTable, CalendarSyncItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarSyncItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSuccessfulSyncAtMeta =
      const VerificationMeta('lastSuccessfulSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulSyncAt =
      GeneratedColumn<DateTime>(
        'last_successful_sync_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _eventCountMeta = const VerificationMeta(
    'eventCount',
  );
  @override
  late final GeneratedColumn<int> eventCount = GeneratedColumn<int>(
    'event_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    source,
    lastSuccessfulSyncAt,
    eventCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_sync_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarSyncItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('last_successful_sync_at')) {
      context.handle(
        _lastSuccessfulSyncAtMeta,
        lastSuccessfulSyncAt.isAcceptableOrUnknown(
          data['last_successful_sync_at']!,
          _lastSuccessfulSyncAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSuccessfulSyncAtMeta);
    }
    if (data.containsKey('event_count')) {
      context.handle(
        _eventCountMeta,
        eventCount.isAcceptableOrUnknown(data['event_count']!, _eventCountMeta),
      );
    } else if (isInserting) {
      context.missing(_eventCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date, source};
  @override
  CalendarSyncItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarSyncItem(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      lastSuccessfulSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_successful_sync_at'],
      )!,
      eventCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_count'],
      )!,
    );
  }

  @override
  $CalendarSyncItemsTable createAlias(String alias) {
    return $CalendarSyncItemsTable(attachedDatabase, alias);
  }
}

class CalendarSyncItem extends DataClass
    implements Insertable<CalendarSyncItem> {
  final String date;
  final String source;
  final DateTime lastSuccessfulSyncAt;
  final int eventCount;
  const CalendarSyncItem({
    required this.date,
    required this.source,
    required this.lastSuccessfulSyncAt,
    required this.eventCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['source'] = Variable<String>(source);
    map['last_successful_sync_at'] = Variable<DateTime>(lastSuccessfulSyncAt);
    map['event_count'] = Variable<int>(eventCount);
    return map;
  }

  CalendarSyncItemsCompanion toCompanion(bool nullToAbsent) {
    return CalendarSyncItemsCompanion(
      date: Value(date),
      source: Value(source),
      lastSuccessfulSyncAt: Value(lastSuccessfulSyncAt),
      eventCount: Value(eventCount),
    );
  }

  factory CalendarSyncItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarSyncItem(
      date: serializer.fromJson<String>(json['date']),
      source: serializer.fromJson<String>(json['source']),
      lastSuccessfulSyncAt: serializer.fromJson<DateTime>(
        json['lastSuccessfulSyncAt'],
      ),
      eventCount: serializer.fromJson<int>(json['eventCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'source': serializer.toJson<String>(source),
      'lastSuccessfulSyncAt': serializer.toJson<DateTime>(lastSuccessfulSyncAt),
      'eventCount': serializer.toJson<int>(eventCount),
    };
  }

  CalendarSyncItem copyWith({
    String? date,
    String? source,
    DateTime? lastSuccessfulSyncAt,
    int? eventCount,
  }) => CalendarSyncItem(
    date: date ?? this.date,
    source: source ?? this.source,
    lastSuccessfulSyncAt: lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt,
    eventCount: eventCount ?? this.eventCount,
  );
  CalendarSyncItem copyWithCompanion(CalendarSyncItemsCompanion data) {
    return CalendarSyncItem(
      date: data.date.present ? data.date.value : this.date,
      source: data.source.present ? data.source.value : this.source,
      lastSuccessfulSyncAt: data.lastSuccessfulSyncAt.present
          ? data.lastSuccessfulSyncAt.value
          : this.lastSuccessfulSyncAt,
      eventCount: data.eventCount.present
          ? data.eventCount.value
          : this.eventCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarSyncItem(')
          ..write('date: $date, ')
          ..write('source: $source, ')
          ..write('lastSuccessfulSyncAt: $lastSuccessfulSyncAt, ')
          ..write('eventCount: $eventCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, source, lastSuccessfulSyncAt, eventCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarSyncItem &&
          other.date == this.date &&
          other.source == this.source &&
          other.lastSuccessfulSyncAt == this.lastSuccessfulSyncAt &&
          other.eventCount == this.eventCount);
}

class CalendarSyncItemsCompanion extends UpdateCompanion<CalendarSyncItem> {
  final Value<String> date;
  final Value<String> source;
  final Value<DateTime> lastSuccessfulSyncAt;
  final Value<int> eventCount;
  final Value<int> rowid;
  const CalendarSyncItemsCompanion({
    this.date = const Value.absent(),
    this.source = const Value.absent(),
    this.lastSuccessfulSyncAt = const Value.absent(),
    this.eventCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalendarSyncItemsCompanion.insert({
    required String date,
    required String source,
    required DateTime lastSuccessfulSyncAt,
    required int eventCount,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       source = Value(source),
       lastSuccessfulSyncAt = Value(lastSuccessfulSyncAt),
       eventCount = Value(eventCount);
  static Insertable<CalendarSyncItem> custom({
    Expression<String>? date,
    Expression<String>? source,
    Expression<DateTime>? lastSuccessfulSyncAt,
    Expression<int>? eventCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (source != null) 'source': source,
      if (lastSuccessfulSyncAt != null)
        'last_successful_sync_at': lastSuccessfulSyncAt,
      if (eventCount != null) 'event_count': eventCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalendarSyncItemsCompanion copyWith({
    Value<String>? date,
    Value<String>? source,
    Value<DateTime>? lastSuccessfulSyncAt,
    Value<int>? eventCount,
    Value<int>? rowid,
  }) {
    return CalendarSyncItemsCompanion(
      date: date ?? this.date,
      source: source ?? this.source,
      lastSuccessfulSyncAt: lastSuccessfulSyncAt ?? this.lastSuccessfulSyncAt,
      eventCount: eventCount ?? this.eventCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (lastSuccessfulSyncAt.present) {
      map['last_successful_sync_at'] = Variable<DateTime>(
        lastSuccessfulSyncAt.value,
      );
    }
    if (eventCount.present) {
      map['event_count'] = Variable<int>(eventCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarSyncItemsCompanion(')
          ..write('date: $date, ')
          ..write('source: $source, ')
          ..write('lastSuccessfulSyncAt: $lastSuccessfulSyncAt, ')
          ..write('eventCount: $eventCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InitialSetupItemsTable extends InitialSetupItems
    with TableInfo<$InitialSetupItemsTable, InitialSetupItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InitialSetupItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _researchParticipantCodeMeta =
      const VerificationMeta('researchParticipantCode');
  @override
  late final GeneratedColumn<String> researchParticipantCode =
      GeneratedColumn<String>(
        'research_participant_code',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _questionnaireVersionMeta =
      const VerificationMeta('questionnaireVersion');
  @override
  late final GeneratedColumn<String> questionnaireVersion =
      GeneratedColumn<String>(
        'questionnaire_version',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _typicalEnergyScoreMeta =
      const VerificationMeta('typicalEnergyScore');
  @override
  late final GeneratedColumn<int> typicalEnergyScore = GeneratedColumn<int>(
    'typical_energy_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _busyImpactScoreMeta = const VerificationMeta(
    'busyImpactScore',
  );
  @override
  late final GeneratedColumn<int> busyImpactScore = GeneratedColumn<int>(
    'busy_impact_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backToBackImpactScoreMeta =
      const VerificationMeta('backToBackImpactScore');
  @override
  late final GeneratedColumn<int> backToBackImpactScore = GeneratedColumn<int>(
    'back_to_back_impact_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longBlockImpactScoreMeta =
      const VerificationMeta('longBlockImpactScore');
  @override
  late final GeneratedColumn<int> longBlockImpactScore = GeneratedColumn<int>(
    'long_block_impact_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _freeGapImpactScoreMeta =
      const VerificationMeta('freeGapImpactScore');
  @override
  late final GeneratedColumn<int> freeGapImpactScore = GeneratedColumn<int>(
    'free_gap_impact_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _focusImpactScoreMeta = const VerificationMeta(
    'focusImpactScore',
  );
  @override
  late final GeneratedColumn<int> focusImpactScore = GeneratedColumn<int>(
    'focus_impact_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _socialImpactScoreMeta = const VerificationMeta(
    'socialImpactScore',
  );
  @override
  late final GeneratedColumn<int> socialImpactScore = GeneratedColumn<int>(
    'social_impact_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lifeAdminImpactScoreMeta =
      const VerificationMeta('lifeAdminImpactScore');
  @override
  late final GeneratedColumn<int> lifeAdminImpactScore = GeneratedColumn<int>(
    'life_admin_impact_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseImpactScoreMeta =
      const VerificationMeta('exerciseImpactScore');
  @override
  late final GeneratedColumn<int> exerciseImpactScore = GeneratedColumn<int>(
    'exercise_impact_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calendarUnderstandingScoreMeta =
      const VerificationMeta('calendarUnderstandingScore');
  @override
  late final GeneratedColumn<int> calendarUnderstandingScore =
      GeneratedColumn<int>(
        'calendar_understanding_score',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _schedulePredictionConfidenceScoreMeta =
      const VerificationMeta('schedulePredictionConfidenceScore');
  @override
  late final GeneratedColumn<int> schedulePredictionConfidenceScore =
      GeneratedColumn<int>(
        'schedule_prediction_confidence_score',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _questionnaireCompletedAtMeta =
      const VerificationMeta('questionnaireCompletedAt');
  @override
  late final GeneratedColumn<DateTime> questionnaireCompletedAt =
      GeneratedColumn<DateTime>(
        'questionnaire_completed_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _calendarSetupCompletedAtMeta =
      const VerificationMeta('calendarSetupCompletedAt');
  @override
  late final GeneratedColumn<DateTime> calendarSetupCompletedAt =
      GeneratedColumn<DateTime>(
        'calendar_setup_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _calendarSetupSkippedMeta =
      const VerificationMeta('calendarSetupSkipped');
  @override
  late final GeneratedColumn<bool> calendarSetupSkipped = GeneratedColumn<bool>(
    'calendar_setup_skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("calendar_setup_skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    researchParticipantCode,
    questionnaireVersion,
    typicalEnergyScore,
    busyImpactScore,
    backToBackImpactScore,
    longBlockImpactScore,
    freeGapImpactScore,
    focusImpactScore,
    socialImpactScore,
    lifeAdminImpactScore,
    exerciseImpactScore,
    calendarUnderstandingScore,
    schedulePredictionConfidenceScore,
    questionnaireCompletedAt,
    calendarSetupCompletedAt,
    calendarSetupSkipped,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'initial_setup_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InitialSetupItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('research_participant_code')) {
      context.handle(
        _researchParticipantCodeMeta,
        researchParticipantCode.isAcceptableOrUnknown(
          data['research_participant_code']!,
          _researchParticipantCodeMeta,
        ),
      );
    }
    if (data.containsKey('questionnaire_version')) {
      context.handle(
        _questionnaireVersionMeta,
        questionnaireVersion.isAcceptableOrUnknown(
          data['questionnaire_version']!,
          _questionnaireVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionnaireVersionMeta);
    }
    if (data.containsKey('typical_energy_score')) {
      context.handle(
        _typicalEnergyScoreMeta,
        typicalEnergyScore.isAcceptableOrUnknown(
          data['typical_energy_score']!,
          _typicalEnergyScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_typicalEnergyScoreMeta);
    }
    if (data.containsKey('busy_impact_score')) {
      context.handle(
        _busyImpactScoreMeta,
        busyImpactScore.isAcceptableOrUnknown(
          data['busy_impact_score']!,
          _busyImpactScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_busyImpactScoreMeta);
    }
    if (data.containsKey('back_to_back_impact_score')) {
      context.handle(
        _backToBackImpactScoreMeta,
        backToBackImpactScore.isAcceptableOrUnknown(
          data['back_to_back_impact_score']!,
          _backToBackImpactScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backToBackImpactScoreMeta);
    }
    if (data.containsKey('long_block_impact_score')) {
      context.handle(
        _longBlockImpactScoreMeta,
        longBlockImpactScore.isAcceptableOrUnknown(
          data['long_block_impact_score']!,
          _longBlockImpactScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_longBlockImpactScoreMeta);
    }
    if (data.containsKey('free_gap_impact_score')) {
      context.handle(
        _freeGapImpactScoreMeta,
        freeGapImpactScore.isAcceptableOrUnknown(
          data['free_gap_impact_score']!,
          _freeGapImpactScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_freeGapImpactScoreMeta);
    }
    if (data.containsKey('focus_impact_score')) {
      context.handle(
        _focusImpactScoreMeta,
        focusImpactScore.isAcceptableOrUnknown(
          data['focus_impact_score']!,
          _focusImpactScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_focusImpactScoreMeta);
    }
    if (data.containsKey('social_impact_score')) {
      context.handle(
        _socialImpactScoreMeta,
        socialImpactScore.isAcceptableOrUnknown(
          data['social_impact_score']!,
          _socialImpactScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_socialImpactScoreMeta);
    }
    if (data.containsKey('life_admin_impact_score')) {
      context.handle(
        _lifeAdminImpactScoreMeta,
        lifeAdminImpactScore.isAcceptableOrUnknown(
          data['life_admin_impact_score']!,
          _lifeAdminImpactScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lifeAdminImpactScoreMeta);
    }
    if (data.containsKey('exercise_impact_score')) {
      context.handle(
        _exerciseImpactScoreMeta,
        exerciseImpactScore.isAcceptableOrUnknown(
          data['exercise_impact_score']!,
          _exerciseImpactScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseImpactScoreMeta);
    }
    if (data.containsKey('calendar_understanding_score')) {
      context.handle(
        _calendarUnderstandingScoreMeta,
        calendarUnderstandingScore.isAcceptableOrUnknown(
          data['calendar_understanding_score']!,
          _calendarUnderstandingScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_calendarUnderstandingScoreMeta);
    }
    if (data.containsKey('schedule_prediction_confidence_score')) {
      context.handle(
        _schedulePredictionConfidenceScoreMeta,
        schedulePredictionConfidenceScore.isAcceptableOrUnknown(
          data['schedule_prediction_confidence_score']!,
          _schedulePredictionConfidenceScoreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schedulePredictionConfidenceScoreMeta);
    }
    if (data.containsKey('questionnaire_completed_at')) {
      context.handle(
        _questionnaireCompletedAtMeta,
        questionnaireCompletedAt.isAcceptableOrUnknown(
          data['questionnaire_completed_at']!,
          _questionnaireCompletedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionnaireCompletedAtMeta);
    }
    if (data.containsKey('calendar_setup_completed_at')) {
      context.handle(
        _calendarSetupCompletedAtMeta,
        calendarSetupCompletedAt.isAcceptableOrUnknown(
          data['calendar_setup_completed_at']!,
          _calendarSetupCompletedAtMeta,
        ),
      );
    }
    if (data.containsKey('calendar_setup_skipped')) {
      context.handle(
        _calendarSetupSkippedMeta,
        calendarSetupSkipped.isAcceptableOrUnknown(
          data['calendar_setup_skipped']!,
          _calendarSetupSkippedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InitialSetupItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InitialSetupItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      researchParticipantCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}research_participant_code'],
      ),
      questionnaireVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}questionnaire_version'],
      )!,
      typicalEnergyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}typical_energy_score'],
      )!,
      busyImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}busy_impact_score'],
      )!,
      backToBackImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}back_to_back_impact_score'],
      )!,
      longBlockImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_block_impact_score'],
      )!,
      freeGapImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}free_gap_impact_score'],
      )!,
      focusImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_impact_score'],
      )!,
      socialImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}social_impact_score'],
      )!,
      lifeAdminImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}life_admin_impact_score'],
      )!,
      exerciseImpactScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_impact_score'],
      )!,
      calendarUnderstandingScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calendar_understanding_score'],
      )!,
      schedulePredictionConfidenceScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schedule_prediction_confidence_score'],
      )!,
      questionnaireCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}questionnaire_completed_at'],
      )!,
      calendarSetupCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}calendar_setup_completed_at'],
      ),
      calendarSetupSkipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}calendar_setup_skipped'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InitialSetupItemsTable createAlias(String alias) {
    return $InitialSetupItemsTable(attachedDatabase, alias);
  }
}

class InitialSetupItem extends DataClass
    implements Insertable<InitialSetupItem> {
  final int id;
  final String? researchParticipantCode;
  final String questionnaireVersion;
  final int typicalEnergyScore;
  final int busyImpactScore;
  final int backToBackImpactScore;
  final int longBlockImpactScore;
  final int freeGapImpactScore;
  final int focusImpactScore;
  final int socialImpactScore;
  final int lifeAdminImpactScore;
  final int exerciseImpactScore;
  final int calendarUnderstandingScore;
  final int schedulePredictionConfidenceScore;
  final DateTime questionnaireCompletedAt;
  final DateTime? calendarSetupCompletedAt;
  final bool calendarSetupSkipped;
  final DateTime updatedAt;
  const InitialSetupItem({
    required this.id,
    this.researchParticipantCode,
    required this.questionnaireVersion,
    required this.typicalEnergyScore,
    required this.busyImpactScore,
    required this.backToBackImpactScore,
    required this.longBlockImpactScore,
    required this.freeGapImpactScore,
    required this.focusImpactScore,
    required this.socialImpactScore,
    required this.lifeAdminImpactScore,
    required this.exerciseImpactScore,
    required this.calendarUnderstandingScore,
    required this.schedulePredictionConfidenceScore,
    required this.questionnaireCompletedAt,
    this.calendarSetupCompletedAt,
    required this.calendarSetupSkipped,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || researchParticipantCode != null) {
      map['research_participant_code'] = Variable<String>(
        researchParticipantCode,
      );
    }
    map['questionnaire_version'] = Variable<String>(questionnaireVersion);
    map['typical_energy_score'] = Variable<int>(typicalEnergyScore);
    map['busy_impact_score'] = Variable<int>(busyImpactScore);
    map['back_to_back_impact_score'] = Variable<int>(backToBackImpactScore);
    map['long_block_impact_score'] = Variable<int>(longBlockImpactScore);
    map['free_gap_impact_score'] = Variable<int>(freeGapImpactScore);
    map['focus_impact_score'] = Variable<int>(focusImpactScore);
    map['social_impact_score'] = Variable<int>(socialImpactScore);
    map['life_admin_impact_score'] = Variable<int>(lifeAdminImpactScore);
    map['exercise_impact_score'] = Variable<int>(exerciseImpactScore);
    map['calendar_understanding_score'] = Variable<int>(
      calendarUnderstandingScore,
    );
    map['schedule_prediction_confidence_score'] = Variable<int>(
      schedulePredictionConfidenceScore,
    );
    map['questionnaire_completed_at'] = Variable<DateTime>(
      questionnaireCompletedAt,
    );
    if (!nullToAbsent || calendarSetupCompletedAt != null) {
      map['calendar_setup_completed_at'] = Variable<DateTime>(
        calendarSetupCompletedAt,
      );
    }
    map['calendar_setup_skipped'] = Variable<bool>(calendarSetupSkipped);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InitialSetupItemsCompanion toCompanion(bool nullToAbsent) {
    return InitialSetupItemsCompanion(
      id: Value(id),
      researchParticipantCode: researchParticipantCode == null && nullToAbsent
          ? const Value.absent()
          : Value(researchParticipantCode),
      questionnaireVersion: Value(questionnaireVersion),
      typicalEnergyScore: Value(typicalEnergyScore),
      busyImpactScore: Value(busyImpactScore),
      backToBackImpactScore: Value(backToBackImpactScore),
      longBlockImpactScore: Value(longBlockImpactScore),
      freeGapImpactScore: Value(freeGapImpactScore),
      focusImpactScore: Value(focusImpactScore),
      socialImpactScore: Value(socialImpactScore),
      lifeAdminImpactScore: Value(lifeAdminImpactScore),
      exerciseImpactScore: Value(exerciseImpactScore),
      calendarUnderstandingScore: Value(calendarUnderstandingScore),
      schedulePredictionConfidenceScore: Value(
        schedulePredictionConfidenceScore,
      ),
      questionnaireCompletedAt: Value(questionnaireCompletedAt),
      calendarSetupCompletedAt: calendarSetupCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarSetupCompletedAt),
      calendarSetupSkipped: Value(calendarSetupSkipped),
      updatedAt: Value(updatedAt),
    );
  }

  factory InitialSetupItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InitialSetupItem(
      id: serializer.fromJson<int>(json['id']),
      researchParticipantCode: serializer.fromJson<String?>(
        json['researchParticipantCode'],
      ),
      questionnaireVersion: serializer.fromJson<String>(
        json['questionnaireVersion'],
      ),
      typicalEnergyScore: serializer.fromJson<int>(json['typicalEnergyScore']),
      busyImpactScore: serializer.fromJson<int>(json['busyImpactScore']),
      backToBackImpactScore: serializer.fromJson<int>(
        json['backToBackImpactScore'],
      ),
      longBlockImpactScore: serializer.fromJson<int>(
        json['longBlockImpactScore'],
      ),
      freeGapImpactScore: serializer.fromJson<int>(json['freeGapImpactScore']),
      focusImpactScore: serializer.fromJson<int>(json['focusImpactScore']),
      socialImpactScore: serializer.fromJson<int>(json['socialImpactScore']),
      lifeAdminImpactScore: serializer.fromJson<int>(
        json['lifeAdminImpactScore'],
      ),
      exerciseImpactScore: serializer.fromJson<int>(
        json['exerciseImpactScore'],
      ),
      calendarUnderstandingScore: serializer.fromJson<int>(
        json['calendarUnderstandingScore'],
      ),
      schedulePredictionConfidenceScore: serializer.fromJson<int>(
        json['schedulePredictionConfidenceScore'],
      ),
      questionnaireCompletedAt: serializer.fromJson<DateTime>(
        json['questionnaireCompletedAt'],
      ),
      calendarSetupCompletedAt: serializer.fromJson<DateTime?>(
        json['calendarSetupCompletedAt'],
      ),
      calendarSetupSkipped: serializer.fromJson<bool>(
        json['calendarSetupSkipped'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'researchParticipantCode': serializer.toJson<String?>(
        researchParticipantCode,
      ),
      'questionnaireVersion': serializer.toJson<String>(questionnaireVersion),
      'typicalEnergyScore': serializer.toJson<int>(typicalEnergyScore),
      'busyImpactScore': serializer.toJson<int>(busyImpactScore),
      'backToBackImpactScore': serializer.toJson<int>(backToBackImpactScore),
      'longBlockImpactScore': serializer.toJson<int>(longBlockImpactScore),
      'freeGapImpactScore': serializer.toJson<int>(freeGapImpactScore),
      'focusImpactScore': serializer.toJson<int>(focusImpactScore),
      'socialImpactScore': serializer.toJson<int>(socialImpactScore),
      'lifeAdminImpactScore': serializer.toJson<int>(lifeAdminImpactScore),
      'exerciseImpactScore': serializer.toJson<int>(exerciseImpactScore),
      'calendarUnderstandingScore': serializer.toJson<int>(
        calendarUnderstandingScore,
      ),
      'schedulePredictionConfidenceScore': serializer.toJson<int>(
        schedulePredictionConfidenceScore,
      ),
      'questionnaireCompletedAt': serializer.toJson<DateTime>(
        questionnaireCompletedAt,
      ),
      'calendarSetupCompletedAt': serializer.toJson<DateTime?>(
        calendarSetupCompletedAt,
      ),
      'calendarSetupSkipped': serializer.toJson<bool>(calendarSetupSkipped),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InitialSetupItem copyWith({
    int? id,
    Value<String?> researchParticipantCode = const Value.absent(),
    String? questionnaireVersion,
    int? typicalEnergyScore,
    int? busyImpactScore,
    int? backToBackImpactScore,
    int? longBlockImpactScore,
    int? freeGapImpactScore,
    int? focusImpactScore,
    int? socialImpactScore,
    int? lifeAdminImpactScore,
    int? exerciseImpactScore,
    int? calendarUnderstandingScore,
    int? schedulePredictionConfidenceScore,
    DateTime? questionnaireCompletedAt,
    Value<DateTime?> calendarSetupCompletedAt = const Value.absent(),
    bool? calendarSetupSkipped,
    DateTime? updatedAt,
  }) => InitialSetupItem(
    id: id ?? this.id,
    researchParticipantCode: researchParticipantCode.present
        ? researchParticipantCode.value
        : this.researchParticipantCode,
    questionnaireVersion: questionnaireVersion ?? this.questionnaireVersion,
    typicalEnergyScore: typicalEnergyScore ?? this.typicalEnergyScore,
    busyImpactScore: busyImpactScore ?? this.busyImpactScore,
    backToBackImpactScore: backToBackImpactScore ?? this.backToBackImpactScore,
    longBlockImpactScore: longBlockImpactScore ?? this.longBlockImpactScore,
    freeGapImpactScore: freeGapImpactScore ?? this.freeGapImpactScore,
    focusImpactScore: focusImpactScore ?? this.focusImpactScore,
    socialImpactScore: socialImpactScore ?? this.socialImpactScore,
    lifeAdminImpactScore: lifeAdminImpactScore ?? this.lifeAdminImpactScore,
    exerciseImpactScore: exerciseImpactScore ?? this.exerciseImpactScore,
    calendarUnderstandingScore:
        calendarUnderstandingScore ?? this.calendarUnderstandingScore,
    schedulePredictionConfidenceScore:
        schedulePredictionConfidenceScore ??
        this.schedulePredictionConfidenceScore,
    questionnaireCompletedAt:
        questionnaireCompletedAt ?? this.questionnaireCompletedAt,
    calendarSetupCompletedAt: calendarSetupCompletedAt.present
        ? calendarSetupCompletedAt.value
        : this.calendarSetupCompletedAt,
    calendarSetupSkipped: calendarSetupSkipped ?? this.calendarSetupSkipped,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InitialSetupItem copyWithCompanion(InitialSetupItemsCompanion data) {
    return InitialSetupItem(
      id: data.id.present ? data.id.value : this.id,
      researchParticipantCode: data.researchParticipantCode.present
          ? data.researchParticipantCode.value
          : this.researchParticipantCode,
      questionnaireVersion: data.questionnaireVersion.present
          ? data.questionnaireVersion.value
          : this.questionnaireVersion,
      typicalEnergyScore: data.typicalEnergyScore.present
          ? data.typicalEnergyScore.value
          : this.typicalEnergyScore,
      busyImpactScore: data.busyImpactScore.present
          ? data.busyImpactScore.value
          : this.busyImpactScore,
      backToBackImpactScore: data.backToBackImpactScore.present
          ? data.backToBackImpactScore.value
          : this.backToBackImpactScore,
      longBlockImpactScore: data.longBlockImpactScore.present
          ? data.longBlockImpactScore.value
          : this.longBlockImpactScore,
      freeGapImpactScore: data.freeGapImpactScore.present
          ? data.freeGapImpactScore.value
          : this.freeGapImpactScore,
      focusImpactScore: data.focusImpactScore.present
          ? data.focusImpactScore.value
          : this.focusImpactScore,
      socialImpactScore: data.socialImpactScore.present
          ? data.socialImpactScore.value
          : this.socialImpactScore,
      lifeAdminImpactScore: data.lifeAdminImpactScore.present
          ? data.lifeAdminImpactScore.value
          : this.lifeAdminImpactScore,
      exerciseImpactScore: data.exerciseImpactScore.present
          ? data.exerciseImpactScore.value
          : this.exerciseImpactScore,
      calendarUnderstandingScore: data.calendarUnderstandingScore.present
          ? data.calendarUnderstandingScore.value
          : this.calendarUnderstandingScore,
      schedulePredictionConfidenceScore:
          data.schedulePredictionConfidenceScore.present
          ? data.schedulePredictionConfidenceScore.value
          : this.schedulePredictionConfidenceScore,
      questionnaireCompletedAt: data.questionnaireCompletedAt.present
          ? data.questionnaireCompletedAt.value
          : this.questionnaireCompletedAt,
      calendarSetupCompletedAt: data.calendarSetupCompletedAt.present
          ? data.calendarSetupCompletedAt.value
          : this.calendarSetupCompletedAt,
      calendarSetupSkipped: data.calendarSetupSkipped.present
          ? data.calendarSetupSkipped.value
          : this.calendarSetupSkipped,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InitialSetupItem(')
          ..write('id: $id, ')
          ..write('researchParticipantCode: $researchParticipantCode, ')
          ..write('questionnaireVersion: $questionnaireVersion, ')
          ..write('typicalEnergyScore: $typicalEnergyScore, ')
          ..write('busyImpactScore: $busyImpactScore, ')
          ..write('backToBackImpactScore: $backToBackImpactScore, ')
          ..write('longBlockImpactScore: $longBlockImpactScore, ')
          ..write('freeGapImpactScore: $freeGapImpactScore, ')
          ..write('focusImpactScore: $focusImpactScore, ')
          ..write('socialImpactScore: $socialImpactScore, ')
          ..write('lifeAdminImpactScore: $lifeAdminImpactScore, ')
          ..write('exerciseImpactScore: $exerciseImpactScore, ')
          ..write('calendarUnderstandingScore: $calendarUnderstandingScore, ')
          ..write(
            'schedulePredictionConfidenceScore: $schedulePredictionConfidenceScore, ',
          )
          ..write('questionnaireCompletedAt: $questionnaireCompletedAt, ')
          ..write('calendarSetupCompletedAt: $calendarSetupCompletedAt, ')
          ..write('calendarSetupSkipped: $calendarSetupSkipped, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    researchParticipantCode,
    questionnaireVersion,
    typicalEnergyScore,
    busyImpactScore,
    backToBackImpactScore,
    longBlockImpactScore,
    freeGapImpactScore,
    focusImpactScore,
    socialImpactScore,
    lifeAdminImpactScore,
    exerciseImpactScore,
    calendarUnderstandingScore,
    schedulePredictionConfidenceScore,
    questionnaireCompletedAt,
    calendarSetupCompletedAt,
    calendarSetupSkipped,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InitialSetupItem &&
          other.id == this.id &&
          other.researchParticipantCode == this.researchParticipantCode &&
          other.questionnaireVersion == this.questionnaireVersion &&
          other.typicalEnergyScore == this.typicalEnergyScore &&
          other.busyImpactScore == this.busyImpactScore &&
          other.backToBackImpactScore == this.backToBackImpactScore &&
          other.longBlockImpactScore == this.longBlockImpactScore &&
          other.freeGapImpactScore == this.freeGapImpactScore &&
          other.focusImpactScore == this.focusImpactScore &&
          other.socialImpactScore == this.socialImpactScore &&
          other.lifeAdminImpactScore == this.lifeAdminImpactScore &&
          other.exerciseImpactScore == this.exerciseImpactScore &&
          other.calendarUnderstandingScore == this.calendarUnderstandingScore &&
          other.schedulePredictionConfidenceScore ==
              this.schedulePredictionConfidenceScore &&
          other.questionnaireCompletedAt == this.questionnaireCompletedAt &&
          other.calendarSetupCompletedAt == this.calendarSetupCompletedAt &&
          other.calendarSetupSkipped == this.calendarSetupSkipped &&
          other.updatedAt == this.updatedAt);
}

class InitialSetupItemsCompanion extends UpdateCompanion<InitialSetupItem> {
  final Value<int> id;
  final Value<String?> researchParticipantCode;
  final Value<String> questionnaireVersion;
  final Value<int> typicalEnergyScore;
  final Value<int> busyImpactScore;
  final Value<int> backToBackImpactScore;
  final Value<int> longBlockImpactScore;
  final Value<int> freeGapImpactScore;
  final Value<int> focusImpactScore;
  final Value<int> socialImpactScore;
  final Value<int> lifeAdminImpactScore;
  final Value<int> exerciseImpactScore;
  final Value<int> calendarUnderstandingScore;
  final Value<int> schedulePredictionConfidenceScore;
  final Value<DateTime> questionnaireCompletedAt;
  final Value<DateTime?> calendarSetupCompletedAt;
  final Value<bool> calendarSetupSkipped;
  final Value<DateTime> updatedAt;
  const InitialSetupItemsCompanion({
    this.id = const Value.absent(),
    this.researchParticipantCode = const Value.absent(),
    this.questionnaireVersion = const Value.absent(),
    this.typicalEnergyScore = const Value.absent(),
    this.busyImpactScore = const Value.absent(),
    this.backToBackImpactScore = const Value.absent(),
    this.longBlockImpactScore = const Value.absent(),
    this.freeGapImpactScore = const Value.absent(),
    this.focusImpactScore = const Value.absent(),
    this.socialImpactScore = const Value.absent(),
    this.lifeAdminImpactScore = const Value.absent(),
    this.exerciseImpactScore = const Value.absent(),
    this.calendarUnderstandingScore = const Value.absent(),
    this.schedulePredictionConfidenceScore = const Value.absent(),
    this.questionnaireCompletedAt = const Value.absent(),
    this.calendarSetupCompletedAt = const Value.absent(),
    this.calendarSetupSkipped = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InitialSetupItemsCompanion.insert({
    this.id = const Value.absent(),
    this.researchParticipantCode = const Value.absent(),
    required String questionnaireVersion,
    required int typicalEnergyScore,
    required int busyImpactScore,
    required int backToBackImpactScore,
    required int longBlockImpactScore,
    required int freeGapImpactScore,
    required int focusImpactScore,
    required int socialImpactScore,
    required int lifeAdminImpactScore,
    required int exerciseImpactScore,
    required int calendarUnderstandingScore,
    required int schedulePredictionConfidenceScore,
    required DateTime questionnaireCompletedAt,
    this.calendarSetupCompletedAt = const Value.absent(),
    this.calendarSetupSkipped = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : questionnaireVersion = Value(questionnaireVersion),
       typicalEnergyScore = Value(typicalEnergyScore),
       busyImpactScore = Value(busyImpactScore),
       backToBackImpactScore = Value(backToBackImpactScore),
       longBlockImpactScore = Value(longBlockImpactScore),
       freeGapImpactScore = Value(freeGapImpactScore),
       focusImpactScore = Value(focusImpactScore),
       socialImpactScore = Value(socialImpactScore),
       lifeAdminImpactScore = Value(lifeAdminImpactScore),
       exerciseImpactScore = Value(exerciseImpactScore),
       calendarUnderstandingScore = Value(calendarUnderstandingScore),
       schedulePredictionConfidenceScore = Value(
         schedulePredictionConfidenceScore,
       ),
       questionnaireCompletedAt = Value(questionnaireCompletedAt);
  static Insertable<InitialSetupItem> custom({
    Expression<int>? id,
    Expression<String>? researchParticipantCode,
    Expression<String>? questionnaireVersion,
    Expression<int>? typicalEnergyScore,
    Expression<int>? busyImpactScore,
    Expression<int>? backToBackImpactScore,
    Expression<int>? longBlockImpactScore,
    Expression<int>? freeGapImpactScore,
    Expression<int>? focusImpactScore,
    Expression<int>? socialImpactScore,
    Expression<int>? lifeAdminImpactScore,
    Expression<int>? exerciseImpactScore,
    Expression<int>? calendarUnderstandingScore,
    Expression<int>? schedulePredictionConfidenceScore,
    Expression<DateTime>? questionnaireCompletedAt,
    Expression<DateTime>? calendarSetupCompletedAt,
    Expression<bool>? calendarSetupSkipped,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (researchParticipantCode != null)
        'research_participant_code': researchParticipantCode,
      if (questionnaireVersion != null)
        'questionnaire_version': questionnaireVersion,
      if (typicalEnergyScore != null)
        'typical_energy_score': typicalEnergyScore,
      if (busyImpactScore != null) 'busy_impact_score': busyImpactScore,
      if (backToBackImpactScore != null)
        'back_to_back_impact_score': backToBackImpactScore,
      if (longBlockImpactScore != null)
        'long_block_impact_score': longBlockImpactScore,
      if (freeGapImpactScore != null)
        'free_gap_impact_score': freeGapImpactScore,
      if (focusImpactScore != null) 'focus_impact_score': focusImpactScore,
      if (socialImpactScore != null) 'social_impact_score': socialImpactScore,
      if (lifeAdminImpactScore != null)
        'life_admin_impact_score': lifeAdminImpactScore,
      if (exerciseImpactScore != null)
        'exercise_impact_score': exerciseImpactScore,
      if (calendarUnderstandingScore != null)
        'calendar_understanding_score': calendarUnderstandingScore,
      if (schedulePredictionConfidenceScore != null)
        'schedule_prediction_confidence_score':
            schedulePredictionConfidenceScore,
      if (questionnaireCompletedAt != null)
        'questionnaire_completed_at': questionnaireCompletedAt,
      if (calendarSetupCompletedAt != null)
        'calendar_setup_completed_at': calendarSetupCompletedAt,
      if (calendarSetupSkipped != null)
        'calendar_setup_skipped': calendarSetupSkipped,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InitialSetupItemsCompanion copyWith({
    Value<int>? id,
    Value<String?>? researchParticipantCode,
    Value<String>? questionnaireVersion,
    Value<int>? typicalEnergyScore,
    Value<int>? busyImpactScore,
    Value<int>? backToBackImpactScore,
    Value<int>? longBlockImpactScore,
    Value<int>? freeGapImpactScore,
    Value<int>? focusImpactScore,
    Value<int>? socialImpactScore,
    Value<int>? lifeAdminImpactScore,
    Value<int>? exerciseImpactScore,
    Value<int>? calendarUnderstandingScore,
    Value<int>? schedulePredictionConfidenceScore,
    Value<DateTime>? questionnaireCompletedAt,
    Value<DateTime?>? calendarSetupCompletedAt,
    Value<bool>? calendarSetupSkipped,
    Value<DateTime>? updatedAt,
  }) {
    return InitialSetupItemsCompanion(
      id: id ?? this.id,
      researchParticipantCode:
          researchParticipantCode ?? this.researchParticipantCode,
      questionnaireVersion: questionnaireVersion ?? this.questionnaireVersion,
      typicalEnergyScore: typicalEnergyScore ?? this.typicalEnergyScore,
      busyImpactScore: busyImpactScore ?? this.busyImpactScore,
      backToBackImpactScore:
          backToBackImpactScore ?? this.backToBackImpactScore,
      longBlockImpactScore: longBlockImpactScore ?? this.longBlockImpactScore,
      freeGapImpactScore: freeGapImpactScore ?? this.freeGapImpactScore,
      focusImpactScore: focusImpactScore ?? this.focusImpactScore,
      socialImpactScore: socialImpactScore ?? this.socialImpactScore,
      lifeAdminImpactScore: lifeAdminImpactScore ?? this.lifeAdminImpactScore,
      exerciseImpactScore: exerciseImpactScore ?? this.exerciseImpactScore,
      calendarUnderstandingScore:
          calendarUnderstandingScore ?? this.calendarUnderstandingScore,
      schedulePredictionConfidenceScore:
          schedulePredictionConfidenceScore ??
          this.schedulePredictionConfidenceScore,
      questionnaireCompletedAt:
          questionnaireCompletedAt ?? this.questionnaireCompletedAt,
      calendarSetupCompletedAt:
          calendarSetupCompletedAt ?? this.calendarSetupCompletedAt,
      calendarSetupSkipped: calendarSetupSkipped ?? this.calendarSetupSkipped,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (researchParticipantCode.present) {
      map['research_participant_code'] = Variable<String>(
        researchParticipantCode.value,
      );
    }
    if (questionnaireVersion.present) {
      map['questionnaire_version'] = Variable<String>(
        questionnaireVersion.value,
      );
    }
    if (typicalEnergyScore.present) {
      map['typical_energy_score'] = Variable<int>(typicalEnergyScore.value);
    }
    if (busyImpactScore.present) {
      map['busy_impact_score'] = Variable<int>(busyImpactScore.value);
    }
    if (backToBackImpactScore.present) {
      map['back_to_back_impact_score'] = Variable<int>(
        backToBackImpactScore.value,
      );
    }
    if (longBlockImpactScore.present) {
      map['long_block_impact_score'] = Variable<int>(
        longBlockImpactScore.value,
      );
    }
    if (freeGapImpactScore.present) {
      map['free_gap_impact_score'] = Variable<int>(freeGapImpactScore.value);
    }
    if (focusImpactScore.present) {
      map['focus_impact_score'] = Variable<int>(focusImpactScore.value);
    }
    if (socialImpactScore.present) {
      map['social_impact_score'] = Variable<int>(socialImpactScore.value);
    }
    if (lifeAdminImpactScore.present) {
      map['life_admin_impact_score'] = Variable<int>(
        lifeAdminImpactScore.value,
      );
    }
    if (exerciseImpactScore.present) {
      map['exercise_impact_score'] = Variable<int>(exerciseImpactScore.value);
    }
    if (calendarUnderstandingScore.present) {
      map['calendar_understanding_score'] = Variable<int>(
        calendarUnderstandingScore.value,
      );
    }
    if (schedulePredictionConfidenceScore.present) {
      map['schedule_prediction_confidence_score'] = Variable<int>(
        schedulePredictionConfidenceScore.value,
      );
    }
    if (questionnaireCompletedAt.present) {
      map['questionnaire_completed_at'] = Variable<DateTime>(
        questionnaireCompletedAt.value,
      );
    }
    if (calendarSetupCompletedAt.present) {
      map['calendar_setup_completed_at'] = Variable<DateTime>(
        calendarSetupCompletedAt.value,
      );
    }
    if (calendarSetupSkipped.present) {
      map['calendar_setup_skipped'] = Variable<bool>(
        calendarSetupSkipped.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InitialSetupItemsCompanion(')
          ..write('id: $id, ')
          ..write('researchParticipantCode: $researchParticipantCode, ')
          ..write('questionnaireVersion: $questionnaireVersion, ')
          ..write('typicalEnergyScore: $typicalEnergyScore, ')
          ..write('busyImpactScore: $busyImpactScore, ')
          ..write('backToBackImpactScore: $backToBackImpactScore, ')
          ..write('longBlockImpactScore: $longBlockImpactScore, ')
          ..write('freeGapImpactScore: $freeGapImpactScore, ')
          ..write('focusImpactScore: $focusImpactScore, ')
          ..write('socialImpactScore: $socialImpactScore, ')
          ..write('lifeAdminImpactScore: $lifeAdminImpactScore, ')
          ..write('exerciseImpactScore: $exerciseImpactScore, ')
          ..write('calendarUnderstandingScore: $calendarUnderstandingScore, ')
          ..write(
            'schedulePredictionConfidenceScore: $schedulePredictionConfidenceScore, ',
          )
          ..write('questionnaireCompletedAt: $questionnaireCompletedAt, ')
          ..write('calendarSetupCompletedAt: $calendarSetupCompletedAt, ')
          ..write('calendarSetupSkipped: $calendarSetupSkipped, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $EnergyModelItemsTable extends EnergyModelItems
    with TableInfo<$EnergyModelItemsTable, EnergyModelItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnergyModelItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _modelVersionMeta = const VerificationMeta(
    'modelVersion',
  );
  @override
  late final GeneratedColumn<String> modelVersion = GeneratedColumn<String>(
    'model_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelSourceMeta = const VerificationMeta(
    'modelSource',
  );
  @override
  late final GeneratedColumn<String> modelSource = GeneratedColumn<String>(
    'model_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureVersionMeta = const VerificationMeta(
    'featureVersion',
  );
  @override
  late final GeneratedColumn<String> featureVersion = GeneratedColumn<String>(
    'feature_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetVersionMeta = const VerificationMeta(
    'targetVersion',
  );
  @override
  late final GeneratedColumn<String> targetVersion = GeneratedColumn<String>(
    'target_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interceptMeta = const VerificationMeta(
    'intercept',
  );
  @override
  late final GeneratedColumn<double> intercept = GeneratedColumn<double>(
    'intercept',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coefficientsJsonMeta = const VerificationMeta(
    'coefficientsJson',
  );
  @override
  late final GeneratedColumn<String> coefficientsJson = GeneratedColumn<String>(
    'coefficients_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modelVersion,
    modelSource,
    featureVersion,
    targetVersion,
    intercept,
    coefficientsJson,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'energy_model_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnergyModelItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('model_version')) {
      context.handle(
        _modelVersionMeta,
        modelVersion.isAcceptableOrUnknown(
          data['model_version']!,
          _modelVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelVersionMeta);
    }
    if (data.containsKey('model_source')) {
      context.handle(
        _modelSourceMeta,
        modelSource.isAcceptableOrUnknown(
          data['model_source']!,
          _modelSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelSourceMeta);
    }
    if (data.containsKey('feature_version')) {
      context.handle(
        _featureVersionMeta,
        featureVersion.isAcceptableOrUnknown(
          data['feature_version']!,
          _featureVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_featureVersionMeta);
    }
    if (data.containsKey('target_version')) {
      context.handle(
        _targetVersionMeta,
        targetVersion.isAcceptableOrUnknown(
          data['target_version']!,
          _targetVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetVersionMeta);
    }
    if (data.containsKey('intercept')) {
      context.handle(
        _interceptMeta,
        intercept.isAcceptableOrUnknown(data['intercept']!, _interceptMeta),
      );
    } else if (isInserting) {
      context.missing(_interceptMeta);
    }
    if (data.containsKey('coefficients_json')) {
      context.handle(
        _coefficientsJsonMeta,
        coefficientsJson.isAcceptableOrUnknown(
          data['coefficients_json']!,
          _coefficientsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_coefficientsJsonMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnergyModelItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnergyModelItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      modelVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_version'],
      )!,
      modelSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_source'],
      )!,
      featureVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_version'],
      )!,
      targetVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_version'],
      )!,
      intercept: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}intercept'],
      )!,
      coefficientsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}coefficients_json'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EnergyModelItemsTable createAlias(String alias) {
    return $EnergyModelItemsTable(attachedDatabase, alias);
  }
}

class EnergyModelItem extends DataClass implements Insertable<EnergyModelItem> {
  final int id;
  final String modelVersion;
  final String modelSource;
  final String featureVersion;
  final String targetVersion;
  final double intercept;
  final String coefficientsJson;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EnergyModelItem({
    required this.id,
    required this.modelVersion,
    required this.modelSource,
    required this.featureVersion,
    required this.targetVersion,
    required this.intercept,
    required this.coefficientsJson,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['model_version'] = Variable<String>(modelVersion);
    map['model_source'] = Variable<String>(modelSource);
    map['feature_version'] = Variable<String>(featureVersion);
    map['target_version'] = Variable<String>(targetVersion);
    map['intercept'] = Variable<double>(intercept);
    map['coefficients_json'] = Variable<String>(coefficientsJson);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EnergyModelItemsCompanion toCompanion(bool nullToAbsent) {
    return EnergyModelItemsCompanion(
      id: Value(id),
      modelVersion: Value(modelVersion),
      modelSource: Value(modelSource),
      featureVersion: Value(featureVersion),
      targetVersion: Value(targetVersion),
      intercept: Value(intercept),
      coefficientsJson: Value(coefficientsJson),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EnergyModelItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnergyModelItem(
      id: serializer.fromJson<int>(json['id']),
      modelVersion: serializer.fromJson<String>(json['modelVersion']),
      modelSource: serializer.fromJson<String>(json['modelSource']),
      featureVersion: serializer.fromJson<String>(json['featureVersion']),
      targetVersion: serializer.fromJson<String>(json['targetVersion']),
      intercept: serializer.fromJson<double>(json['intercept']),
      coefficientsJson: serializer.fromJson<String>(json['coefficientsJson']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modelVersion': serializer.toJson<String>(modelVersion),
      'modelSource': serializer.toJson<String>(modelSource),
      'featureVersion': serializer.toJson<String>(featureVersion),
      'targetVersion': serializer.toJson<String>(targetVersion),
      'intercept': serializer.toJson<double>(intercept),
      'coefficientsJson': serializer.toJson<String>(coefficientsJson),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EnergyModelItem copyWith({
    int? id,
    String? modelVersion,
    String? modelSource,
    String? featureVersion,
    String? targetVersion,
    double? intercept,
    String? coefficientsJson,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => EnergyModelItem(
    id: id ?? this.id,
    modelVersion: modelVersion ?? this.modelVersion,
    modelSource: modelSource ?? this.modelSource,
    featureVersion: featureVersion ?? this.featureVersion,
    targetVersion: targetVersion ?? this.targetVersion,
    intercept: intercept ?? this.intercept,
    coefficientsJson: coefficientsJson ?? this.coefficientsJson,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EnergyModelItem copyWithCompanion(EnergyModelItemsCompanion data) {
    return EnergyModelItem(
      id: data.id.present ? data.id.value : this.id,
      modelVersion: data.modelVersion.present
          ? data.modelVersion.value
          : this.modelVersion,
      modelSource: data.modelSource.present
          ? data.modelSource.value
          : this.modelSource,
      featureVersion: data.featureVersion.present
          ? data.featureVersion.value
          : this.featureVersion,
      targetVersion: data.targetVersion.present
          ? data.targetVersion.value
          : this.targetVersion,
      intercept: data.intercept.present ? data.intercept.value : this.intercept,
      coefficientsJson: data.coefficientsJson.present
          ? data.coefficientsJson.value
          : this.coefficientsJson,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnergyModelItem(')
          ..write('id: $id, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('modelSource: $modelSource, ')
          ..write('featureVersion: $featureVersion, ')
          ..write('targetVersion: $targetVersion, ')
          ..write('intercept: $intercept, ')
          ..write('coefficientsJson: $coefficientsJson, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    modelVersion,
    modelSource,
    featureVersion,
    targetVersion,
    intercept,
    coefficientsJson,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnergyModelItem &&
          other.id == this.id &&
          other.modelVersion == this.modelVersion &&
          other.modelSource == this.modelSource &&
          other.featureVersion == this.featureVersion &&
          other.targetVersion == this.targetVersion &&
          other.intercept == this.intercept &&
          other.coefficientsJson == this.coefficientsJson &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EnergyModelItemsCompanion extends UpdateCompanion<EnergyModelItem> {
  final Value<int> id;
  final Value<String> modelVersion;
  final Value<String> modelSource;
  final Value<String> featureVersion;
  final Value<String> targetVersion;
  final Value<double> intercept;
  final Value<String> coefficientsJson;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const EnergyModelItemsCompanion({
    this.id = const Value.absent(),
    this.modelVersion = const Value.absent(),
    this.modelSource = const Value.absent(),
    this.featureVersion = const Value.absent(),
    this.targetVersion = const Value.absent(),
    this.intercept = const Value.absent(),
    this.coefficientsJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EnergyModelItemsCompanion.insert({
    this.id = const Value.absent(),
    required String modelVersion,
    required String modelSource,
    required String featureVersion,
    required String targetVersion,
    required double intercept,
    required String coefficientsJson,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : modelVersion = Value(modelVersion),
       modelSource = Value(modelSource),
       featureVersion = Value(featureVersion),
       targetVersion = Value(targetVersion),
       intercept = Value(intercept),
       coefficientsJson = Value(coefficientsJson);
  static Insertable<EnergyModelItem> custom({
    Expression<int>? id,
    Expression<String>? modelVersion,
    Expression<String>? modelSource,
    Expression<String>? featureVersion,
    Expression<String>? targetVersion,
    Expression<double>? intercept,
    Expression<String>? coefficientsJson,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelVersion != null) 'model_version': modelVersion,
      if (modelSource != null) 'model_source': modelSource,
      if (featureVersion != null) 'feature_version': featureVersion,
      if (targetVersion != null) 'target_version': targetVersion,
      if (intercept != null) 'intercept': intercept,
      if (coefficientsJson != null) 'coefficients_json': coefficientsJson,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EnergyModelItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? modelVersion,
    Value<String>? modelSource,
    Value<String>? featureVersion,
    Value<String>? targetVersion,
    Value<double>? intercept,
    Value<String>? coefficientsJson,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return EnergyModelItemsCompanion(
      id: id ?? this.id,
      modelVersion: modelVersion ?? this.modelVersion,
      modelSource: modelSource ?? this.modelSource,
      featureVersion: featureVersion ?? this.featureVersion,
      targetVersion: targetVersion ?? this.targetVersion,
      intercept: intercept ?? this.intercept,
      coefficientsJson: coefficientsJson ?? this.coefficientsJson,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modelVersion.present) {
      map['model_version'] = Variable<String>(modelVersion.value);
    }
    if (modelSource.present) {
      map['model_source'] = Variable<String>(modelSource.value);
    }
    if (featureVersion.present) {
      map['feature_version'] = Variable<String>(featureVersion.value);
    }
    if (targetVersion.present) {
      map['target_version'] = Variable<String>(targetVersion.value);
    }
    if (intercept.present) {
      map['intercept'] = Variable<double>(intercept.value);
    }
    if (coefficientsJson.present) {
      map['coefficients_json'] = Variable<String>(coefficientsJson.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnergyModelItemsCompanion(')
          ..write('id: $id, ')
          ..write('modelVersion: $modelVersion, ')
          ..write('modelSource: $modelSource, ')
          ..write('featureVersion: $featureVersion, ')
          ..write('targetVersion: $targetVersion, ')
          ..write('intercept: $intercept, ')
          ..write('coefficientsJson: $coefficientsJson, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationPreferenceItemsTable extends NotificationPreferenceItems
    with
        TableInfo<
          $NotificationPreferenceItemsTable,
          NotificationPreferenceItem
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationPreferenceItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _morningEnabledMeta = const VerificationMeta(
    'morningEnabled',
  );
  @override
  late final GeneratedColumn<bool> morningEnabled = GeneratedColumn<bool>(
    'morning_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("morning_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _morningHourMeta = const VerificationMeta(
    'morningHour',
  );
  @override
  late final GeneratedColumn<int> morningHour = GeneratedColumn<int>(
    'morning_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9),
  );
  static const VerificationMeta _morningMinuteMeta = const VerificationMeta(
    'morningMinute',
  );
  @override
  late final GeneratedColumn<int> morningMinute = GeneratedColumn<int>(
    'morning_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _eveningEnabledMeta = const VerificationMeta(
    'eveningEnabled',
  );
  @override
  late final GeneratedColumn<bool> eveningEnabled = GeneratedColumn<bool>(
    'evening_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("evening_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _eveningHourMeta = const VerificationMeta(
    'eveningHour',
  );
  @override
  late final GeneratedColumn<int> eveningHour = GeneratedColumn<int>(
    'evening_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _eveningMinuteMeta = const VerificationMeta(
    'eveningMinute',
  );
  @override
  late final GeneratedColumn<int> eveningMinute = GeneratedColumn<int>(
    'evening_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    morningEnabled,
    morningHour,
    morningMinute,
    eveningEnabled,
    eveningHour,
    eveningMinute,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_preference_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationPreferenceItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('morning_enabled')) {
      context.handle(
        _morningEnabledMeta,
        morningEnabled.isAcceptableOrUnknown(
          data['morning_enabled']!,
          _morningEnabledMeta,
        ),
      );
    }
    if (data.containsKey('morning_hour')) {
      context.handle(
        _morningHourMeta,
        morningHour.isAcceptableOrUnknown(
          data['morning_hour']!,
          _morningHourMeta,
        ),
      );
    }
    if (data.containsKey('morning_minute')) {
      context.handle(
        _morningMinuteMeta,
        morningMinute.isAcceptableOrUnknown(
          data['morning_minute']!,
          _morningMinuteMeta,
        ),
      );
    }
    if (data.containsKey('evening_enabled')) {
      context.handle(
        _eveningEnabledMeta,
        eveningEnabled.isAcceptableOrUnknown(
          data['evening_enabled']!,
          _eveningEnabledMeta,
        ),
      );
    }
    if (data.containsKey('evening_hour')) {
      context.handle(
        _eveningHourMeta,
        eveningHour.isAcceptableOrUnknown(
          data['evening_hour']!,
          _eveningHourMeta,
        ),
      );
    }
    if (data.containsKey('evening_minute')) {
      context.handle(
        _eveningMinuteMeta,
        eveningMinute.isAcceptableOrUnknown(
          data['evening_minute']!,
          _eveningMinuteMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationPreferenceItem map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationPreferenceItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      morningEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}morning_enabled'],
      )!,
      morningHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}morning_hour'],
      )!,
      morningMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}morning_minute'],
      )!,
      eveningEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}evening_enabled'],
      )!,
      eveningHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evening_hour'],
      )!,
      eveningMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}evening_minute'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotificationPreferenceItemsTable createAlias(String alias) {
    return $NotificationPreferenceItemsTable(attachedDatabase, alias);
  }
}

class NotificationPreferenceItem extends DataClass
    implements Insertable<NotificationPreferenceItem> {
  final int id;
  final bool morningEnabled;
  final int morningHour;
  final int morningMinute;
  final bool eveningEnabled;
  final int eveningHour;
  final int eveningMinute;
  final DateTime updatedAt;
  const NotificationPreferenceItem({
    required this.id,
    required this.morningEnabled,
    required this.morningHour,
    required this.morningMinute,
    required this.eveningEnabled,
    required this.eveningHour,
    required this.eveningMinute,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['morning_enabled'] = Variable<bool>(morningEnabled);
    map['morning_hour'] = Variable<int>(morningHour);
    map['morning_minute'] = Variable<int>(morningMinute);
    map['evening_enabled'] = Variable<bool>(eveningEnabled);
    map['evening_hour'] = Variable<int>(eveningHour);
    map['evening_minute'] = Variable<int>(eveningMinute);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotificationPreferenceItemsCompanion toCompanion(bool nullToAbsent) {
    return NotificationPreferenceItemsCompanion(
      id: Value(id),
      morningEnabled: Value(morningEnabled),
      morningHour: Value(morningHour),
      morningMinute: Value(morningMinute),
      eveningEnabled: Value(eveningEnabled),
      eveningHour: Value(eveningHour),
      eveningMinute: Value(eveningMinute),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotificationPreferenceItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationPreferenceItem(
      id: serializer.fromJson<int>(json['id']),
      morningEnabled: serializer.fromJson<bool>(json['morningEnabled']),
      morningHour: serializer.fromJson<int>(json['morningHour']),
      morningMinute: serializer.fromJson<int>(json['morningMinute']),
      eveningEnabled: serializer.fromJson<bool>(json['eveningEnabled']),
      eveningHour: serializer.fromJson<int>(json['eveningHour']),
      eveningMinute: serializer.fromJson<int>(json['eveningMinute']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'morningEnabled': serializer.toJson<bool>(morningEnabled),
      'morningHour': serializer.toJson<int>(morningHour),
      'morningMinute': serializer.toJson<int>(morningMinute),
      'eveningEnabled': serializer.toJson<bool>(eveningEnabled),
      'eveningHour': serializer.toJson<int>(eveningHour),
      'eveningMinute': serializer.toJson<int>(eveningMinute),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NotificationPreferenceItem copyWith({
    int? id,
    bool? morningEnabled,
    int? morningHour,
    int? morningMinute,
    bool? eveningEnabled,
    int? eveningHour,
    int? eveningMinute,
    DateTime? updatedAt,
  }) => NotificationPreferenceItem(
    id: id ?? this.id,
    morningEnabled: morningEnabled ?? this.morningEnabled,
    morningHour: morningHour ?? this.morningHour,
    morningMinute: morningMinute ?? this.morningMinute,
    eveningEnabled: eveningEnabled ?? this.eveningEnabled,
    eveningHour: eveningHour ?? this.eveningHour,
    eveningMinute: eveningMinute ?? this.eveningMinute,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NotificationPreferenceItem copyWithCompanion(
    NotificationPreferenceItemsCompanion data,
  ) {
    return NotificationPreferenceItem(
      id: data.id.present ? data.id.value : this.id,
      morningEnabled: data.morningEnabled.present
          ? data.morningEnabled.value
          : this.morningEnabled,
      morningHour: data.morningHour.present
          ? data.morningHour.value
          : this.morningHour,
      morningMinute: data.morningMinute.present
          ? data.morningMinute.value
          : this.morningMinute,
      eveningEnabled: data.eveningEnabled.present
          ? data.eveningEnabled.value
          : this.eveningEnabled,
      eveningHour: data.eveningHour.present
          ? data.eveningHour.value
          : this.eveningHour,
      eveningMinute: data.eveningMinute.present
          ? data.eveningMinute.value
          : this.eveningMinute,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreferenceItem(')
          ..write('id: $id, ')
          ..write('morningEnabled: $morningEnabled, ')
          ..write('morningHour: $morningHour, ')
          ..write('morningMinute: $morningMinute, ')
          ..write('eveningEnabled: $eveningEnabled, ')
          ..write('eveningHour: $eveningHour, ')
          ..write('eveningMinute: $eveningMinute, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    morningEnabled,
    morningHour,
    morningMinute,
    eveningEnabled,
    eveningHour,
    eveningMinute,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationPreferenceItem &&
          other.id == this.id &&
          other.morningEnabled == this.morningEnabled &&
          other.morningHour == this.morningHour &&
          other.morningMinute == this.morningMinute &&
          other.eveningEnabled == this.eveningEnabled &&
          other.eveningHour == this.eveningHour &&
          other.eveningMinute == this.eveningMinute &&
          other.updatedAt == this.updatedAt);
}

class NotificationPreferenceItemsCompanion
    extends UpdateCompanion<NotificationPreferenceItem> {
  final Value<int> id;
  final Value<bool> morningEnabled;
  final Value<int> morningHour;
  final Value<int> morningMinute;
  final Value<bool> eveningEnabled;
  final Value<int> eveningHour;
  final Value<int> eveningMinute;
  final Value<DateTime> updatedAt;
  const NotificationPreferenceItemsCompanion({
    this.id = const Value.absent(),
    this.morningEnabled = const Value.absent(),
    this.morningHour = const Value.absent(),
    this.morningMinute = const Value.absent(),
    this.eveningEnabled = const Value.absent(),
    this.eveningHour = const Value.absent(),
    this.eveningMinute = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotificationPreferenceItemsCompanion.insert({
    this.id = const Value.absent(),
    this.morningEnabled = const Value.absent(),
    this.morningHour = const Value.absent(),
    this.morningMinute = const Value.absent(),
    this.eveningEnabled = const Value.absent(),
    this.eveningHour = const Value.absent(),
    this.eveningMinute = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<NotificationPreferenceItem> custom({
    Expression<int>? id,
    Expression<bool>? morningEnabled,
    Expression<int>? morningHour,
    Expression<int>? morningMinute,
    Expression<bool>? eveningEnabled,
    Expression<int>? eveningHour,
    Expression<int>? eveningMinute,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (morningEnabled != null) 'morning_enabled': morningEnabled,
      if (morningHour != null) 'morning_hour': morningHour,
      if (morningMinute != null) 'morning_minute': morningMinute,
      if (eveningEnabled != null) 'evening_enabled': eveningEnabled,
      if (eveningHour != null) 'evening_hour': eveningHour,
      if (eveningMinute != null) 'evening_minute': eveningMinute,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotificationPreferenceItemsCompanion copyWith({
    Value<int>? id,
    Value<bool>? morningEnabled,
    Value<int>? morningHour,
    Value<int>? morningMinute,
    Value<bool>? eveningEnabled,
    Value<int>? eveningHour,
    Value<int>? eveningMinute,
    Value<DateTime>? updatedAt,
  }) {
    return NotificationPreferenceItemsCompanion(
      id: id ?? this.id,
      morningEnabled: morningEnabled ?? this.morningEnabled,
      morningHour: morningHour ?? this.morningHour,
      morningMinute: morningMinute ?? this.morningMinute,
      eveningEnabled: eveningEnabled ?? this.eveningEnabled,
      eveningHour: eveningHour ?? this.eveningHour,
      eveningMinute: eveningMinute ?? this.eveningMinute,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (morningEnabled.present) {
      map['morning_enabled'] = Variable<bool>(morningEnabled.value);
    }
    if (morningHour.present) {
      map['morning_hour'] = Variable<int>(morningHour.value);
    }
    if (morningMinute.present) {
      map['morning_minute'] = Variable<int>(morningMinute.value);
    }
    if (eveningEnabled.present) {
      map['evening_enabled'] = Variable<bool>(eveningEnabled.value);
    }
    if (eveningHour.present) {
      map['evening_hour'] = Variable<int>(eveningHour.value);
    }
    if (eveningMinute.present) {
      map['evening_minute'] = Variable<int>(eveningMinute.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreferenceItemsCompanion(')
          ..write('id: $id, ')
          ..write('morningEnabled: $morningEnabled, ')
          ..write('morningHour: $morningHour, ')
          ..write('morningMinute: $morningMinute, ')
          ..write('eveningEnabled: $eveningEnabled, ')
          ..write('eveningHour: $eveningHour, ')
          ..write('eveningMinute: $eveningMinute, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ResearchInteractionItemsTable extends ResearchInteractionItems
    with TableInfo<$ResearchInteractionItemsTable, ResearchInteractionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ResearchInteractionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, eventType, occurredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'research_interaction_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ResearchInteractionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ResearchInteractionItem map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ResearchInteractionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_type'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
    );
  }

  @override
  $ResearchInteractionItemsTable createAlias(String alias) {
    return $ResearchInteractionItemsTable(attachedDatabase, alias);
  }
}

class ResearchInteractionItem extends DataClass
    implements Insertable<ResearchInteractionItem> {
  final int id;
  final String eventType;
  final DateTime occurredAt;
  const ResearchInteractionItem({
    required this.id,
    required this.eventType,
    required this.occurredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_type'] = Variable<String>(eventType);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  ResearchInteractionItemsCompanion toCompanion(bool nullToAbsent) {
    return ResearchInteractionItemsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      occurredAt: Value(occurredAt),
    );
  }

  factory ResearchInteractionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ResearchInteractionItem(
      id: serializer.fromJson<int>(json['id']),
      eventType: serializer.fromJson<String>(json['eventType']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventType': serializer.toJson<String>(eventType),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  ResearchInteractionItem copyWith({
    int? id,
    String? eventType,
    DateTime? occurredAt,
  }) => ResearchInteractionItem(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    occurredAt: occurredAt ?? this.occurredAt,
  );
  ResearchInteractionItem copyWithCompanion(
    ResearchInteractionItemsCompanion data,
  ) {
    return ResearchInteractionItem(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ResearchInteractionItem(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eventType, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ResearchInteractionItem &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.occurredAt == this.occurredAt);
}

class ResearchInteractionItemsCompanion
    extends UpdateCompanion<ResearchInteractionItem> {
  final Value<int> id;
  final Value<String> eventType;
  final Value<DateTime> occurredAt;
  const ResearchInteractionItemsCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.occurredAt = const Value.absent(),
  });
  ResearchInteractionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String eventType,
    required DateTime occurredAt,
  }) : eventType = Value(eventType),
       occurredAt = Value(occurredAt);
  static Insertable<ResearchInteractionItem> custom({
    Expression<int>? id,
    Expression<String>? eventType,
    Expression<DateTime>? occurredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (occurredAt != null) 'occurred_at': occurredAt,
    });
  }

  ResearchInteractionItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? eventType,
    Value<DateTime>? occurredAt,
  }) {
    return ResearchInteractionItemsCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ResearchInteractionItemsCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EventUserDataItemsTable eventUserDataItems =
      $EventUserDataItemsTable(this);
  late final $CachedCalendarEventItemsTable cachedCalendarEventItems =
      $CachedCalendarEventItemsTable(this);
  late final $ManualCalendarEventItemsTable manualCalendarEventItems =
      $ManualCalendarEventItemsTable(this);
  late final $DailyReflectionItemsTable dailyReflectionItems =
      $DailyReflectionItemsTable(this);
  late final $DailyIntentionItemsTable dailyIntentionItems =
      $DailyIntentionItemsTable(this);
  late final $DailyFeatureSnapshotItemsTable dailyFeatureSnapshotItems =
      $DailyFeatureSnapshotItemsTable(this);
  late final $DailyPredictionItemsTable dailyPredictionItems =
      $DailyPredictionItemsTable(this);
  late final $ForecastReflectionItemsTable forecastReflectionItems =
      $ForecastReflectionItemsTable(this);
  late final $CalendarSyncItemsTable calendarSyncItems =
      $CalendarSyncItemsTable(this);
  late final $InitialSetupItemsTable initialSetupItems =
      $InitialSetupItemsTable(this);
  late final $EnergyModelItemsTable energyModelItems = $EnergyModelItemsTable(
    this,
  );
  late final $NotificationPreferenceItemsTable notificationPreferenceItems =
      $NotificationPreferenceItemsTable(this);
  late final $ResearchInteractionItemsTable researchInteractionItems =
      $ResearchInteractionItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    eventUserDataItems,
    cachedCalendarEventItems,
    manualCalendarEventItems,
    dailyReflectionItems,
    dailyIntentionItems,
    dailyFeatureSnapshotItems,
    dailyPredictionItems,
    forecastReflectionItems,
    calendarSyncItems,
    initialSetupItems,
    energyModelItems,
    notificationPreferenceItems,
    researchInteractionItems,
  ];
}

typedef $$EventUserDataItemsTableCreateCompanionBuilder =
    EventUserDataItemsCompanion Function({
      Value<int> id,
      required String eventKey,
      required String source,
      Value<String?> externalId,
      required String date,
      Value<String?> category,
      Value<int?> energyImpactScore,
      Value<DateTime> updatedAt,
    });
typedef $$EventUserDataItemsTableUpdateCompanionBuilder =
    EventUserDataItemsCompanion Function({
      Value<int> id,
      Value<String> eventKey,
      Value<String> source,
      Value<String?> externalId,
      Value<String> date,
      Value<String?> category,
      Value<int?> energyImpactScore,
      Value<DateTime> updatedAt,
    });

class $$EventUserDataItemsTableFilterComposer
    extends Composer<_$AppDatabase, $EventUserDataItemsTable> {
  $$EventUserDataItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventKey => $composableBuilder(
    column: $table.eventKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyImpactScore => $composableBuilder(
    column: $table.energyImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EventUserDataItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $EventUserDataItemsTable> {
  $$EventUserDataItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventKey => $composableBuilder(
    column: $table.eventKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyImpactScore => $composableBuilder(
    column: $table.energyImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EventUserDataItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EventUserDataItemsTable> {
  $$EventUserDataItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventKey =>
      $composableBuilder(column: $table.eventKey, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get energyImpactScore => $composableBuilder(
    column: $table.energyImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EventUserDataItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EventUserDataItemsTable,
          EventUserDataItem,
          $$EventUserDataItemsTableFilterComposer,
          $$EventUserDataItemsTableOrderingComposer,
          $$EventUserDataItemsTableAnnotationComposer,
          $$EventUserDataItemsTableCreateCompanionBuilder,
          $$EventUserDataItemsTableUpdateCompanionBuilder,
          (
            EventUserDataItem,
            BaseReferences<
              _$AppDatabase,
              $EventUserDataItemsTable,
              EventUserDataItem
            >,
          ),
          EventUserDataItem,
          PrefetchHooks Function()
        > {
  $$EventUserDataItemsTableTableManager(
    _$AppDatabase db,
    $EventUserDataItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventUserDataItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventUserDataItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventUserDataItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventKey = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int?> energyImpactScore = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EventUserDataItemsCompanion(
                id: id,
                eventKey: eventKey,
                source: source,
                externalId: externalId,
                date: date,
                category: category,
                energyImpactScore: energyImpactScore,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventKey,
                required String source,
                Value<String?> externalId = const Value.absent(),
                required String date,
                Value<String?> category = const Value.absent(),
                Value<int?> energyImpactScore = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EventUserDataItemsCompanion.insert(
                id: id,
                eventKey: eventKey,
                source: source,
                externalId: externalId,
                date: date,
                category: category,
                energyImpactScore: energyImpactScore,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EventUserDataItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EventUserDataItemsTable,
      EventUserDataItem,
      $$EventUserDataItemsTableFilterComposer,
      $$EventUserDataItemsTableOrderingComposer,
      $$EventUserDataItemsTableAnnotationComposer,
      $$EventUserDataItemsTableCreateCompanionBuilder,
      $$EventUserDataItemsTableUpdateCompanionBuilder,
      (
        EventUserDataItem,
        BaseReferences<
          _$AppDatabase,
          $EventUserDataItemsTable,
          EventUserDataItem
        >,
      ),
      EventUserDataItem,
      PrefetchHooks Function()
    >;
typedef $$CachedCalendarEventItemsTableCreateCompanionBuilder =
    CachedCalendarEventItemsCompanion Function({
      Value<int> id,
      required String eventKey,
      required String source,
      Value<String?> externalId,
      required String date,
      required String title,
      required DateTime startTime,
      required DateTime endTime,
      Value<String?> category,
      Value<int?> energyImpactScore,
      Value<bool> isAllDay,
      Value<DateTime> updatedAt,
    });
typedef $$CachedCalendarEventItemsTableUpdateCompanionBuilder =
    CachedCalendarEventItemsCompanion Function({
      Value<int> id,
      Value<String> eventKey,
      Value<String> source,
      Value<String?> externalId,
      Value<String> date,
      Value<String> title,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<String?> category,
      Value<int?> energyImpactScore,
      Value<bool> isAllDay,
      Value<DateTime> updatedAt,
    });

class $$CachedCalendarEventItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCalendarEventItemsTable> {
  $$CachedCalendarEventItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventKey => $composableBuilder(
    column: $table.eventKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyImpactScore => $composableBuilder(
    column: $table.energyImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedCalendarEventItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCalendarEventItemsTable> {
  $$CachedCalendarEventItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventKey => $composableBuilder(
    column: $table.eventKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyImpactScore => $composableBuilder(
    column: $table.energyImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedCalendarEventItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCalendarEventItemsTable> {
  $$CachedCalendarEventItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventKey =>
      $composableBuilder(column: $table.eventKey, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get energyImpactScore => $composableBuilder(
    column: $table.energyImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isAllDay =>
      $composableBuilder(column: $table.isAllDay, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CachedCalendarEventItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCalendarEventItemsTable,
          CachedCalendarEventItem,
          $$CachedCalendarEventItemsTableFilterComposer,
          $$CachedCalendarEventItemsTableOrderingComposer,
          $$CachedCalendarEventItemsTableAnnotationComposer,
          $$CachedCalendarEventItemsTableCreateCompanionBuilder,
          $$CachedCalendarEventItemsTableUpdateCompanionBuilder,
          (
            CachedCalendarEventItem,
            BaseReferences<
              _$AppDatabase,
              $CachedCalendarEventItemsTable,
              CachedCalendarEventItem
            >,
          ),
          CachedCalendarEventItem,
          PrefetchHooks Function()
        > {
  $$CachedCalendarEventItemsTableTableManager(
    _$AppDatabase db,
    $CachedCalendarEventItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCalendarEventItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CachedCalendarEventItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedCalendarEventItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventKey = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> externalId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<int?> energyImpactScore = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CachedCalendarEventItemsCompanion(
                id: id,
                eventKey: eventKey,
                source: source,
                externalId: externalId,
                date: date,
                title: title,
                startTime: startTime,
                endTime: endTime,
                category: category,
                energyImpactScore: energyImpactScore,
                isAllDay: isAllDay,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventKey,
                required String source,
                Value<String?> externalId = const Value.absent(),
                required String date,
                required String title,
                required DateTime startTime,
                required DateTime endTime,
                Value<String?> category = const Value.absent(),
                Value<int?> energyImpactScore = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CachedCalendarEventItemsCompanion.insert(
                id: id,
                eventKey: eventKey,
                source: source,
                externalId: externalId,
                date: date,
                title: title,
                startTime: startTime,
                endTime: endTime,
                category: category,
                energyImpactScore: energyImpactScore,
                isAllDay: isAllDay,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedCalendarEventItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCalendarEventItemsTable,
      CachedCalendarEventItem,
      $$CachedCalendarEventItemsTableFilterComposer,
      $$CachedCalendarEventItemsTableOrderingComposer,
      $$CachedCalendarEventItemsTableAnnotationComposer,
      $$CachedCalendarEventItemsTableCreateCompanionBuilder,
      $$CachedCalendarEventItemsTableUpdateCompanionBuilder,
      (
        CachedCalendarEventItem,
        BaseReferences<
          _$AppDatabase,
          $CachedCalendarEventItemsTable,
          CachedCalendarEventItem
        >,
      ),
      CachedCalendarEventItem,
      PrefetchHooks Function()
    >;
typedef $$ManualCalendarEventItemsTableCreateCompanionBuilder =
    ManualCalendarEventItemsCompanion Function({
      Value<int> id,
      required String date,
      required String title,
      required DateTime startTime,
      required DateTime endTime,
      required String category,
      Value<int?> energyImpactScore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ManualCalendarEventItemsTableUpdateCompanionBuilder =
    ManualCalendarEventItemsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<String> title,
      Value<DateTime> startTime,
      Value<DateTime> endTime,
      Value<String> category,
      Value<int?> energyImpactScore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$ManualCalendarEventItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ManualCalendarEventItemsTable> {
  $$ManualCalendarEventItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyImpactScore => $composableBuilder(
    column: $table.energyImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ManualCalendarEventItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ManualCalendarEventItemsTable> {
  $$ManualCalendarEventItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyImpactScore => $composableBuilder(
    column: $table.energyImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ManualCalendarEventItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManualCalendarEventItemsTable> {
  $$ManualCalendarEventItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get energyImpactScore => $composableBuilder(
    column: $table.energyImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ManualCalendarEventItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ManualCalendarEventItemsTable,
          ManualCalendarEventItem,
          $$ManualCalendarEventItemsTableFilterComposer,
          $$ManualCalendarEventItemsTableOrderingComposer,
          $$ManualCalendarEventItemsTableAnnotationComposer,
          $$ManualCalendarEventItemsTableCreateCompanionBuilder,
          $$ManualCalendarEventItemsTableUpdateCompanionBuilder,
          (
            ManualCalendarEventItem,
            BaseReferences<
              _$AppDatabase,
              $ManualCalendarEventItemsTable,
              ManualCalendarEventItem
            >,
          ),
          ManualCalendarEventItem,
          PrefetchHooks Function()
        > {
  $$ManualCalendarEventItemsTableTableManager(
    _$AppDatabase db,
    $ManualCalendarEventItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManualCalendarEventItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ManualCalendarEventItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ManualCalendarEventItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime> endTime = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int?> energyImpactScore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ManualCalendarEventItemsCompanion(
                id: id,
                date: date,
                title: title,
                startTime: startTime,
                endTime: endTime,
                category: category,
                energyImpactScore: energyImpactScore,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required String title,
                required DateTime startTime,
                required DateTime endTime,
                required String category,
                Value<int?> energyImpactScore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ManualCalendarEventItemsCompanion.insert(
                id: id,
                date: date,
                title: title,
                startTime: startTime,
                endTime: endTime,
                category: category,
                energyImpactScore: energyImpactScore,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ManualCalendarEventItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ManualCalendarEventItemsTable,
      ManualCalendarEventItem,
      $$ManualCalendarEventItemsTableFilterComposer,
      $$ManualCalendarEventItemsTableOrderingComposer,
      $$ManualCalendarEventItemsTableAnnotationComposer,
      $$ManualCalendarEventItemsTableCreateCompanionBuilder,
      $$ManualCalendarEventItemsTableUpdateCompanionBuilder,
      (
        ManualCalendarEventItem,
        BaseReferences<
          _$AppDatabase,
          $ManualCalendarEventItemsTable,
          ManualCalendarEventItem
        >,
      ),
      ManualCalendarEventItem,
      PrefetchHooks Function()
    >;
typedef $$DailyReflectionItemsTableCreateCompanionBuilder =
    DailyReflectionItemsCompanion Function({
      Value<int> id,
      required String date,
      required int energyScore,
      Value<int?> intentionCompletionScore,
      Value<int?> intentionHelpfulnessScore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DailyReflectionItemsTableUpdateCompanionBuilder =
    DailyReflectionItemsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<int> energyScore,
      Value<int?> intentionCompletionScore,
      Value<int?> intentionHelpfulnessScore,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$DailyReflectionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyReflectionItemsTable> {
  $$DailyReflectionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get energyScore => $composableBuilder(
    column: $table.energyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intentionCompletionScore => $composableBuilder(
    column: $table.intentionCompletionScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intentionHelpfulnessScore => $composableBuilder(
    column: $table.intentionHelpfulnessScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyReflectionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyReflectionItemsTable> {
  $$DailyReflectionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get energyScore => $composableBuilder(
    column: $table.energyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intentionCompletionScore => $composableBuilder(
    column: $table.intentionCompletionScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intentionHelpfulnessScore => $composableBuilder(
    column: $table.intentionHelpfulnessScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyReflectionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyReflectionItemsTable> {
  $$DailyReflectionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get energyScore => $composableBuilder(
    column: $table.energyScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intentionCompletionScore => $composableBuilder(
    column: $table.intentionCompletionScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intentionHelpfulnessScore => $composableBuilder(
    column: $table.intentionHelpfulnessScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyReflectionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyReflectionItemsTable,
          DailyReflectionItem,
          $$DailyReflectionItemsTableFilterComposer,
          $$DailyReflectionItemsTableOrderingComposer,
          $$DailyReflectionItemsTableAnnotationComposer,
          $$DailyReflectionItemsTableCreateCompanionBuilder,
          $$DailyReflectionItemsTableUpdateCompanionBuilder,
          (
            DailyReflectionItem,
            BaseReferences<
              _$AppDatabase,
              $DailyReflectionItemsTable,
              DailyReflectionItem
            >,
          ),
          DailyReflectionItem,
          PrefetchHooks Function()
        > {
  $$DailyReflectionItemsTableTableManager(
    _$AppDatabase db,
    $DailyReflectionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyReflectionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyReflectionItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyReflectionItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> energyScore = const Value.absent(),
                Value<int?> intentionCompletionScore = const Value.absent(),
                Value<int?> intentionHelpfulnessScore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyReflectionItemsCompanion(
                id: id,
                date: date,
                energyScore: energyScore,
                intentionCompletionScore: intentionCompletionScore,
                intentionHelpfulnessScore: intentionHelpfulnessScore,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required int energyScore,
                Value<int?> intentionCompletionScore = const Value.absent(),
                Value<int?> intentionHelpfulnessScore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyReflectionItemsCompanion.insert(
                id: id,
                date: date,
                energyScore: energyScore,
                intentionCompletionScore: intentionCompletionScore,
                intentionHelpfulnessScore: intentionHelpfulnessScore,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyReflectionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyReflectionItemsTable,
      DailyReflectionItem,
      $$DailyReflectionItemsTableFilterComposer,
      $$DailyReflectionItemsTableOrderingComposer,
      $$DailyReflectionItemsTableAnnotationComposer,
      $$DailyReflectionItemsTableCreateCompanionBuilder,
      $$DailyReflectionItemsTableUpdateCompanionBuilder,
      (
        DailyReflectionItem,
        BaseReferences<
          _$AppDatabase,
          $DailyReflectionItemsTable,
          DailyReflectionItem
        >,
      ),
      DailyReflectionItem,
      PrefetchHooks Function()
    >;
typedef $$DailyIntentionItemsTableCreateCompanionBuilder =
    DailyIntentionItemsCompanion Function({
      Value<int> id,
      required String date,
      required String selectedFactor,
      Value<String> factorType,
      required String selectedAdjustment,
      Value<String> adjustmentType,
      Value<DateTime?> adjustmentStartTime,
      Value<DateTime?> adjustmentEndTime,
      Value<String> calendarSnapshotKey,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DailyIntentionItemsTableUpdateCompanionBuilder =
    DailyIntentionItemsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<String> selectedFactor,
      Value<String> factorType,
      Value<String> selectedAdjustment,
      Value<String> adjustmentType,
      Value<DateTime?> adjustmentStartTime,
      Value<DateTime?> adjustmentEndTime,
      Value<String> calendarSnapshotKey,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$DailyIntentionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyIntentionItemsTable> {
  $$DailyIntentionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedFactor => $composableBuilder(
    column: $table.selectedFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get factorType => $composableBuilder(
    column: $table.factorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedAdjustment => $composableBuilder(
    column: $table.selectedAdjustment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adjustmentType => $composableBuilder(
    column: $table.adjustmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get adjustmentStartTime => $composableBuilder(
    column: $table.adjustmentStartTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get adjustmentEndTime => $composableBuilder(
    column: $table.adjustmentEndTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarSnapshotKey => $composableBuilder(
    column: $table.calendarSnapshotKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyIntentionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyIntentionItemsTable> {
  $$DailyIntentionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedFactor => $composableBuilder(
    column: $table.selectedFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get factorType => $composableBuilder(
    column: $table.factorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedAdjustment => $composableBuilder(
    column: $table.selectedAdjustment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adjustmentType => $composableBuilder(
    column: $table.adjustmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get adjustmentStartTime => $composableBuilder(
    column: $table.adjustmentStartTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get adjustmentEndTime => $composableBuilder(
    column: $table.adjustmentEndTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarSnapshotKey => $composableBuilder(
    column: $table.calendarSnapshotKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyIntentionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyIntentionItemsTable> {
  $$DailyIntentionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get selectedFactor => $composableBuilder(
    column: $table.selectedFactor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get factorType => $composableBuilder(
    column: $table.factorType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get selectedAdjustment => $composableBuilder(
    column: $table.selectedAdjustment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get adjustmentType => $composableBuilder(
    column: $table.adjustmentType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get adjustmentStartTime => $composableBuilder(
    column: $table.adjustmentStartTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get adjustmentEndTime => $composableBuilder(
    column: $table.adjustmentEndTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calendarSnapshotKey => $composableBuilder(
    column: $table.calendarSnapshotKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyIntentionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyIntentionItemsTable,
          DailyIntentionItem,
          $$DailyIntentionItemsTableFilterComposer,
          $$DailyIntentionItemsTableOrderingComposer,
          $$DailyIntentionItemsTableAnnotationComposer,
          $$DailyIntentionItemsTableCreateCompanionBuilder,
          $$DailyIntentionItemsTableUpdateCompanionBuilder,
          (
            DailyIntentionItem,
            BaseReferences<
              _$AppDatabase,
              $DailyIntentionItemsTable,
              DailyIntentionItem
            >,
          ),
          DailyIntentionItem,
          PrefetchHooks Function()
        > {
  $$DailyIntentionItemsTableTableManager(
    _$AppDatabase db,
    $DailyIntentionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyIntentionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyIntentionItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyIntentionItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> selectedFactor = const Value.absent(),
                Value<String> factorType = const Value.absent(),
                Value<String> selectedAdjustment = const Value.absent(),
                Value<String> adjustmentType = const Value.absent(),
                Value<DateTime?> adjustmentStartTime = const Value.absent(),
                Value<DateTime?> adjustmentEndTime = const Value.absent(),
                Value<String> calendarSnapshotKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyIntentionItemsCompanion(
                id: id,
                date: date,
                selectedFactor: selectedFactor,
                factorType: factorType,
                selectedAdjustment: selectedAdjustment,
                adjustmentType: adjustmentType,
                adjustmentStartTime: adjustmentStartTime,
                adjustmentEndTime: adjustmentEndTime,
                calendarSnapshotKey: calendarSnapshotKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required String selectedFactor,
                Value<String> factorType = const Value.absent(),
                required String selectedAdjustment,
                Value<String> adjustmentType = const Value.absent(),
                Value<DateTime?> adjustmentStartTime = const Value.absent(),
                Value<DateTime?> adjustmentEndTime = const Value.absent(),
                Value<String> calendarSnapshotKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyIntentionItemsCompanion.insert(
                id: id,
                date: date,
                selectedFactor: selectedFactor,
                factorType: factorType,
                selectedAdjustment: selectedAdjustment,
                adjustmentType: adjustmentType,
                adjustmentStartTime: adjustmentStartTime,
                adjustmentEndTime: adjustmentEndTime,
                calendarSnapshotKey: calendarSnapshotKey,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyIntentionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyIntentionItemsTable,
      DailyIntentionItem,
      $$DailyIntentionItemsTableFilterComposer,
      $$DailyIntentionItemsTableOrderingComposer,
      $$DailyIntentionItemsTableAnnotationComposer,
      $$DailyIntentionItemsTableCreateCompanionBuilder,
      $$DailyIntentionItemsTableUpdateCompanionBuilder,
      (
        DailyIntentionItem,
        BaseReferences<
          _$AppDatabase,
          $DailyIntentionItemsTable,
          DailyIntentionItem
        >,
      ),
      DailyIntentionItem,
      PrefetchHooks Function()
    >;
typedef $$DailyFeatureSnapshotItemsTableCreateCompanionBuilder =
    DailyFeatureSnapshotItemsCompanion Function({
      Value<int> id,
      required String date,
      required DateTime capturedAt,
      required int analysisStartHour,
      required int analysisEndHour,
      required String predictionPhase,
      required int calculationVersion,
      required String calendarSnapshotKey,
      required int totalEventCount,
      required int allDayEventCount,
      required int totalScheduledMinutes,
      required int busyMinutes,
      required int focusMinutes,
      required int socialMinutes,
      required int lifeAdminMinutes,
      required int exerciseMinutes,
      required int restMinutes,
      required int backToBackEventCount,
      required int freeMinutes,
      required int longestGapBetweenActivitiesMinutes,
      required int maxConsecutiveBlockMinutes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$DailyFeatureSnapshotItemsTableUpdateCompanionBuilder =
    DailyFeatureSnapshotItemsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<DateTime> capturedAt,
      Value<int> analysisStartHour,
      Value<int> analysisEndHour,
      Value<String> predictionPhase,
      Value<int> calculationVersion,
      Value<String> calendarSnapshotKey,
      Value<int> totalEventCount,
      Value<int> allDayEventCount,
      Value<int> totalScheduledMinutes,
      Value<int> busyMinutes,
      Value<int> focusMinutes,
      Value<int> socialMinutes,
      Value<int> lifeAdminMinutes,
      Value<int> exerciseMinutes,
      Value<int> restMinutes,
      Value<int> backToBackEventCount,
      Value<int> freeMinutes,
      Value<int> longestGapBetweenActivitiesMinutes,
      Value<int> maxConsecutiveBlockMinutes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$DailyFeatureSnapshotItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DailyFeatureSnapshotItemsTable,
          DailyFeatureSnapshotItem
        > {
  $$DailyFeatureSnapshotItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $DailyPredictionItemsTable,
    List<DailyPredictionItem>
  >
  _dailyPredictionItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.dailyPredictionItems,
        aliasName: $_aliasNameGenerator(
          db.dailyFeatureSnapshotItems.id,
          db.dailyPredictionItems.featureSnapshotId,
        ),
      );

  $$DailyPredictionItemsTableProcessedTableManager
  get dailyPredictionItemsRefs {
    final manager = $$DailyPredictionItemsTableTableManager(
      $_db,
      $_db.dailyPredictionItems,
    ).filter((f) => f.featureSnapshotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _dailyPredictionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyFeatureSnapshotItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyFeatureSnapshotItemsTable> {
  $$DailyFeatureSnapshotItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get analysisStartHour => $composableBuilder(
    column: $table.analysisStartHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get analysisEndHour => $composableBuilder(
    column: $table.analysisEndHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get predictionPhase => $composableBuilder(
    column: $table.predictionPhase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calculationVersion => $composableBuilder(
    column: $table.calculationVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarSnapshotKey => $composableBuilder(
    column: $table.calendarSnapshotKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalEventCount => $composableBuilder(
    column: $table.totalEventCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allDayEventCount => $composableBuilder(
    column: $table.allDayEventCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalScheduledMinutes => $composableBuilder(
    column: $table.totalScheduledMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get busyMinutes => $composableBuilder(
    column: $table.busyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get socialMinutes => $composableBuilder(
    column: $table.socialMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifeAdminMinutes => $composableBuilder(
    column: $table.lifeAdminMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseMinutes => $composableBuilder(
    column: $table.exerciseMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get backToBackEventCount => $composableBuilder(
    column: $table.backToBackEventCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freeMinutes => $composableBuilder(
    column: $table.freeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longestGapBetweenActivitiesMinutes =>
      $composableBuilder(
        column: $table.longestGapBetweenActivitiesMinutes,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<int> get maxConsecutiveBlockMinutes => $composableBuilder(
    column: $table.maxConsecutiveBlockMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dailyPredictionItemsRefs(
    Expression<bool> Function($$DailyPredictionItemsTableFilterComposer f) f,
  ) {
    final $$DailyPredictionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dailyPredictionItems,
      getReferencedColumn: (t) => t.featureSnapshotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyPredictionItemsTableFilterComposer(
            $db: $db,
            $table: $db.dailyPredictionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DailyFeatureSnapshotItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyFeatureSnapshotItemsTable> {
  $$DailyFeatureSnapshotItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get analysisStartHour => $composableBuilder(
    column: $table.analysisStartHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get analysisEndHour => $composableBuilder(
    column: $table.analysisEndHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get predictionPhase => $composableBuilder(
    column: $table.predictionPhase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calculationVersion => $composableBuilder(
    column: $table.calculationVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarSnapshotKey => $composableBuilder(
    column: $table.calendarSnapshotKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalEventCount => $composableBuilder(
    column: $table.totalEventCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allDayEventCount => $composableBuilder(
    column: $table.allDayEventCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalScheduledMinutes => $composableBuilder(
    column: $table.totalScheduledMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get busyMinutes => $composableBuilder(
    column: $table.busyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get socialMinutes => $composableBuilder(
    column: $table.socialMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifeAdminMinutes => $composableBuilder(
    column: $table.lifeAdminMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseMinutes => $composableBuilder(
    column: $table.exerciseMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get backToBackEventCount => $composableBuilder(
    column: $table.backToBackEventCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freeMinutes => $composableBuilder(
    column: $table.freeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longestGapBetweenActivitiesMinutes =>
      $composableBuilder(
        column: $table.longestGapBetweenActivitiesMinutes,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get maxConsecutiveBlockMinutes => $composableBuilder(
    column: $table.maxConsecutiveBlockMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyFeatureSnapshotItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyFeatureSnapshotItemsTable> {
  $$DailyFeatureSnapshotItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get analysisStartHour => $composableBuilder(
    column: $table.analysisStartHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get analysisEndHour => $composableBuilder(
    column: $table.analysisEndHour,
    builder: (column) => column,
  );

  GeneratedColumn<String> get predictionPhase => $composableBuilder(
    column: $table.predictionPhase,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calculationVersion => $composableBuilder(
    column: $table.calculationVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calendarSnapshotKey => $composableBuilder(
    column: $table.calendarSnapshotKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalEventCount => $composableBuilder(
    column: $table.totalEventCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allDayEventCount => $composableBuilder(
    column: $table.allDayEventCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalScheduledMinutes => $composableBuilder(
    column: $table.totalScheduledMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get busyMinutes => $composableBuilder(
    column: $table.busyMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusMinutes => $composableBuilder(
    column: $table.focusMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get socialMinutes => $composableBuilder(
    column: $table.socialMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lifeAdminMinutes => $composableBuilder(
    column: $table.lifeAdminMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exerciseMinutes => $composableBuilder(
    column: $table.exerciseMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get backToBackEventCount => $composableBuilder(
    column: $table.backToBackEventCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get freeMinutes => $composableBuilder(
    column: $table.freeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longestGapBetweenActivitiesMinutes =>
      $composableBuilder(
        column: $table.longestGapBetweenActivitiesMinutes,
        builder: (column) => column,
      );

  GeneratedColumn<int> get maxConsecutiveBlockMinutes => $composableBuilder(
    column: $table.maxConsecutiveBlockMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> dailyPredictionItemsRefs<T extends Object>(
    Expression<T> Function($$DailyPredictionItemsTableAnnotationComposer a) f,
  ) {
    final $$DailyPredictionItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.dailyPredictionItems,
          getReferencedColumn: (t) => t.featureSnapshotId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyPredictionItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.dailyPredictionItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DailyFeatureSnapshotItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyFeatureSnapshotItemsTable,
          DailyFeatureSnapshotItem,
          $$DailyFeatureSnapshotItemsTableFilterComposer,
          $$DailyFeatureSnapshotItemsTableOrderingComposer,
          $$DailyFeatureSnapshotItemsTableAnnotationComposer,
          $$DailyFeatureSnapshotItemsTableCreateCompanionBuilder,
          $$DailyFeatureSnapshotItemsTableUpdateCompanionBuilder,
          (
            DailyFeatureSnapshotItem,
            $$DailyFeatureSnapshotItemsTableReferences,
          ),
          DailyFeatureSnapshotItem,
          PrefetchHooks Function({bool dailyPredictionItemsRefs})
        > {
  $$DailyFeatureSnapshotItemsTableTableManager(
    _$AppDatabase db,
    $DailyFeatureSnapshotItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyFeatureSnapshotItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DailyFeatureSnapshotItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyFeatureSnapshotItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<int> analysisStartHour = const Value.absent(),
                Value<int> analysisEndHour = const Value.absent(),
                Value<String> predictionPhase = const Value.absent(),
                Value<int> calculationVersion = const Value.absent(),
                Value<String> calendarSnapshotKey = const Value.absent(),
                Value<int> totalEventCount = const Value.absent(),
                Value<int> allDayEventCount = const Value.absent(),
                Value<int> totalScheduledMinutes = const Value.absent(),
                Value<int> busyMinutes = const Value.absent(),
                Value<int> focusMinutes = const Value.absent(),
                Value<int> socialMinutes = const Value.absent(),
                Value<int> lifeAdminMinutes = const Value.absent(),
                Value<int> exerciseMinutes = const Value.absent(),
                Value<int> restMinutes = const Value.absent(),
                Value<int> backToBackEventCount = const Value.absent(),
                Value<int> freeMinutes = const Value.absent(),
                Value<int> longestGapBetweenActivitiesMinutes =
                    const Value.absent(),
                Value<int> maxConsecutiveBlockMinutes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyFeatureSnapshotItemsCompanion(
                id: id,
                date: date,
                capturedAt: capturedAt,
                analysisStartHour: analysisStartHour,
                analysisEndHour: analysisEndHour,
                predictionPhase: predictionPhase,
                calculationVersion: calculationVersion,
                calendarSnapshotKey: calendarSnapshotKey,
                totalEventCount: totalEventCount,
                allDayEventCount: allDayEventCount,
                totalScheduledMinutes: totalScheduledMinutes,
                busyMinutes: busyMinutes,
                focusMinutes: focusMinutes,
                socialMinutes: socialMinutes,
                lifeAdminMinutes: lifeAdminMinutes,
                exerciseMinutes: exerciseMinutes,
                restMinutes: restMinutes,
                backToBackEventCount: backToBackEventCount,
                freeMinutes: freeMinutes,
                longestGapBetweenActivitiesMinutes:
                    longestGapBetweenActivitiesMinutes,
                maxConsecutiveBlockMinutes: maxConsecutiveBlockMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required DateTime capturedAt,
                required int analysisStartHour,
                required int analysisEndHour,
                required String predictionPhase,
                required int calculationVersion,
                required String calendarSnapshotKey,
                required int totalEventCount,
                required int allDayEventCount,
                required int totalScheduledMinutes,
                required int busyMinutes,
                required int focusMinutes,
                required int socialMinutes,
                required int lifeAdminMinutes,
                required int exerciseMinutes,
                required int restMinutes,
                required int backToBackEventCount,
                required int freeMinutes,
                required int longestGapBetweenActivitiesMinutes,
                required int maxConsecutiveBlockMinutes,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyFeatureSnapshotItemsCompanion.insert(
                id: id,
                date: date,
                capturedAt: capturedAt,
                analysisStartHour: analysisStartHour,
                analysisEndHour: analysisEndHour,
                predictionPhase: predictionPhase,
                calculationVersion: calculationVersion,
                calendarSnapshotKey: calendarSnapshotKey,
                totalEventCount: totalEventCount,
                allDayEventCount: allDayEventCount,
                totalScheduledMinutes: totalScheduledMinutes,
                busyMinutes: busyMinutes,
                focusMinutes: focusMinutes,
                socialMinutes: socialMinutes,
                lifeAdminMinutes: lifeAdminMinutes,
                exerciseMinutes: exerciseMinutes,
                restMinutes: restMinutes,
                backToBackEventCount: backToBackEventCount,
                freeMinutes: freeMinutes,
                longestGapBetweenActivitiesMinutes:
                    longestGapBetweenActivitiesMinutes,
                maxConsecutiveBlockMinutes: maxConsecutiveBlockMinutes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyFeatureSnapshotItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({dailyPredictionItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (dailyPredictionItemsRefs) db.dailyPredictionItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (dailyPredictionItemsRefs)
                    await $_getPrefetchedData<
                      DailyFeatureSnapshotItem,
                      $DailyFeatureSnapshotItemsTable,
                      DailyPredictionItem
                    >(
                      currentTable: table,
                      referencedTable:
                          $$DailyFeatureSnapshotItemsTableReferences
                              ._dailyPredictionItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DailyFeatureSnapshotItemsTableReferences(
                            db,
                            table,
                            p0,
                          ).dailyPredictionItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.featureSnapshotId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DailyFeatureSnapshotItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyFeatureSnapshotItemsTable,
      DailyFeatureSnapshotItem,
      $$DailyFeatureSnapshotItemsTableFilterComposer,
      $$DailyFeatureSnapshotItemsTableOrderingComposer,
      $$DailyFeatureSnapshotItemsTableAnnotationComposer,
      $$DailyFeatureSnapshotItemsTableCreateCompanionBuilder,
      $$DailyFeatureSnapshotItemsTableUpdateCompanionBuilder,
      (DailyFeatureSnapshotItem, $$DailyFeatureSnapshotItemsTableReferences),
      DailyFeatureSnapshotItem,
      PrefetchHooks Function({bool dailyPredictionItemsRefs})
    >;
typedef $$DailyPredictionItemsTableCreateCompanionBuilder =
    DailyPredictionItemsCompanion Function({
      Value<int> id,
      required String date,
      required int featureSnapshotId,
      required String predictedCategory,
      Value<double?> predictedScore,
      Value<String> reasonsJson,
      required String predictionVersion,
      Value<int?> agreementScore,
      Value<DateTime?> feedbackUpdatedAt,
      Value<DateTime> createdAt,
    });
typedef $$DailyPredictionItemsTableUpdateCompanionBuilder =
    DailyPredictionItemsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<int> featureSnapshotId,
      Value<String> predictedCategory,
      Value<double?> predictedScore,
      Value<String> reasonsJson,
      Value<String> predictionVersion,
      Value<int?> agreementScore,
      Value<DateTime?> feedbackUpdatedAt,
      Value<DateTime> createdAt,
    });

final class $$DailyPredictionItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DailyPredictionItemsTable,
          DailyPredictionItem
        > {
  $$DailyPredictionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DailyFeatureSnapshotItemsTable _featureSnapshotIdTable(
    _$AppDatabase db,
  ) => db.dailyFeatureSnapshotItems.createAlias(
    $_aliasNameGenerator(
      db.dailyPredictionItems.featureSnapshotId,
      db.dailyFeatureSnapshotItems.id,
    ),
  );

  $$DailyFeatureSnapshotItemsTableProcessedTableManager get featureSnapshotId {
    final $_column = $_itemColumn<int>('feature_snapshot_id')!;

    final manager = $$DailyFeatureSnapshotItemsTableTableManager(
      $_db,
      $_db.dailyFeatureSnapshotItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_featureSnapshotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ForecastReflectionItemsTable,
    List<ForecastReflectionItem>
  >
  _forecastReflectionItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.forecastReflectionItems,
        aliasName: $_aliasNameGenerator(
          db.dailyPredictionItems.id,
          db.forecastReflectionItems.predictionId,
        ),
      );

  $$ForecastReflectionItemsTableProcessedTableManager
  get forecastReflectionItemsRefs {
    final manager = $$ForecastReflectionItemsTableTableManager(
      $_db,
      $_db.forecastReflectionItems,
    ).filter((f) => f.predictionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _forecastReflectionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DailyPredictionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyPredictionItemsTable> {
  $$DailyPredictionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get predictedCategory => $composableBuilder(
    column: $table.predictedCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get predictedScore => $composableBuilder(
    column: $table.predictedScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonsJson => $composableBuilder(
    column: $table.reasonsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get predictionVersion => $composableBuilder(
    column: $table.predictionVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get agreementScore => $composableBuilder(
    column: $table.agreementScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get feedbackUpdatedAt => $composableBuilder(
    column: $table.feedbackUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyFeatureSnapshotItemsTableFilterComposer get featureSnapshotId {
    final $$DailyFeatureSnapshotItemsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.featureSnapshotId,
          referencedTable: $db.dailyFeatureSnapshotItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyFeatureSnapshotItemsTableFilterComposer(
                $db: $db,
                $table: $db.dailyFeatureSnapshotItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<bool> forecastReflectionItemsRefs(
    Expression<bool> Function($$ForecastReflectionItemsTableFilterComposer f) f,
  ) {
    final $$ForecastReflectionItemsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.forecastReflectionItems,
          getReferencedColumn: (t) => t.predictionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ForecastReflectionItemsTableFilterComposer(
                $db: $db,
                $table: $db.forecastReflectionItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DailyPredictionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyPredictionItemsTable> {
  $$DailyPredictionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get predictedCategory => $composableBuilder(
    column: $table.predictedCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get predictedScore => $composableBuilder(
    column: $table.predictedScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonsJson => $composableBuilder(
    column: $table.reasonsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get predictionVersion => $composableBuilder(
    column: $table.predictionVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get agreementScore => $composableBuilder(
    column: $table.agreementScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get feedbackUpdatedAt => $composableBuilder(
    column: $table.feedbackUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyFeatureSnapshotItemsTableOrderingComposer get featureSnapshotId {
    final $$DailyFeatureSnapshotItemsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.featureSnapshotId,
          referencedTable: $db.dailyFeatureSnapshotItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyFeatureSnapshotItemsTableOrderingComposer(
                $db: $db,
                $table: $db.dailyFeatureSnapshotItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$DailyPredictionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyPredictionItemsTable> {
  $$DailyPredictionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get predictedCategory => $composableBuilder(
    column: $table.predictedCategory,
    builder: (column) => column,
  );

  GeneratedColumn<double> get predictedScore => $composableBuilder(
    column: $table.predictedScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonsJson => $composableBuilder(
    column: $table.reasonsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get predictionVersion => $composableBuilder(
    column: $table.predictionVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get agreementScore => $composableBuilder(
    column: $table.agreementScore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get feedbackUpdatedAt => $composableBuilder(
    column: $table.feedbackUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DailyFeatureSnapshotItemsTableAnnotationComposer get featureSnapshotId {
    final $$DailyFeatureSnapshotItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.featureSnapshotId,
          referencedTable: $db.dailyFeatureSnapshotItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyFeatureSnapshotItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.dailyFeatureSnapshotItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> forecastReflectionItemsRefs<T extends Object>(
    Expression<T> Function($$ForecastReflectionItemsTableAnnotationComposer a)
    f,
  ) {
    final $$ForecastReflectionItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.forecastReflectionItems,
          getReferencedColumn: (t) => t.predictionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ForecastReflectionItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.forecastReflectionItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$DailyPredictionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyPredictionItemsTable,
          DailyPredictionItem,
          $$DailyPredictionItemsTableFilterComposer,
          $$DailyPredictionItemsTableOrderingComposer,
          $$DailyPredictionItemsTableAnnotationComposer,
          $$DailyPredictionItemsTableCreateCompanionBuilder,
          $$DailyPredictionItemsTableUpdateCompanionBuilder,
          (DailyPredictionItem, $$DailyPredictionItemsTableReferences),
          DailyPredictionItem,
          PrefetchHooks Function({
            bool featureSnapshotId,
            bool forecastReflectionItemsRefs,
          })
        > {
  $$DailyPredictionItemsTableTableManager(
    _$AppDatabase db,
    $DailyPredictionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyPredictionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyPredictionItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DailyPredictionItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> featureSnapshotId = const Value.absent(),
                Value<String> predictedCategory = const Value.absent(),
                Value<double?> predictedScore = const Value.absent(),
                Value<String> reasonsJson = const Value.absent(),
                Value<String> predictionVersion = const Value.absent(),
                Value<int?> agreementScore = const Value.absent(),
                Value<DateTime?> feedbackUpdatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyPredictionItemsCompanion(
                id: id,
                date: date,
                featureSnapshotId: featureSnapshotId,
                predictedCategory: predictedCategory,
                predictedScore: predictedScore,
                reasonsJson: reasonsJson,
                predictionVersion: predictionVersion,
                agreementScore: agreementScore,
                feedbackUpdatedAt: feedbackUpdatedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required int featureSnapshotId,
                required String predictedCategory,
                Value<double?> predictedScore = const Value.absent(),
                Value<String> reasonsJson = const Value.absent(),
                required String predictionVersion,
                Value<int?> agreementScore = const Value.absent(),
                Value<DateTime?> feedbackUpdatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DailyPredictionItemsCompanion.insert(
                id: id,
                date: date,
                featureSnapshotId: featureSnapshotId,
                predictedCategory: predictedCategory,
                predictedScore: predictedScore,
                reasonsJson: reasonsJson,
                predictionVersion: predictionVersion,
                agreementScore: agreementScore,
                feedbackUpdatedAt: feedbackUpdatedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DailyPredictionItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                featureSnapshotId = false,
                forecastReflectionItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (forecastReflectionItemsRefs) db.forecastReflectionItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (featureSnapshotId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.featureSnapshotId,
                                    referencedTable:
                                        $$DailyPredictionItemsTableReferences
                                            ._featureSnapshotIdTable(db),
                                    referencedColumn:
                                        $$DailyPredictionItemsTableReferences
                                            ._featureSnapshotIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (forecastReflectionItemsRefs)
                        await $_getPrefetchedData<
                          DailyPredictionItem,
                          $DailyPredictionItemsTable,
                          ForecastReflectionItem
                        >(
                          currentTable: table,
                          referencedTable: $$DailyPredictionItemsTableReferences
                              ._forecastReflectionItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DailyPredictionItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).forecastReflectionItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.predictionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DailyPredictionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyPredictionItemsTable,
      DailyPredictionItem,
      $$DailyPredictionItemsTableFilterComposer,
      $$DailyPredictionItemsTableOrderingComposer,
      $$DailyPredictionItemsTableAnnotationComposer,
      $$DailyPredictionItemsTableCreateCompanionBuilder,
      $$DailyPredictionItemsTableUpdateCompanionBuilder,
      (DailyPredictionItem, $$DailyPredictionItemsTableReferences),
      DailyPredictionItem,
      PrefetchHooks Function({
        bool featureSnapshotId,
        bool forecastReflectionItemsRefs,
      })
    >;
typedef $$ForecastReflectionItemsTableCreateCompanionBuilder =
    ForecastReflectionItemsCompanion Function({
      Value<int> id,
      required String date,
      required int predictionId,
      required String supportiveFactorType,
      required String supportiveFactorLabel,
      required String demandingFactorType,
      required String demandingFactorLabel,
      Value<String?> modelSupportiveFactorType,
      Value<String?> modelSupportiveFactorLabel,
      Value<String?> modelDemandingFactorType,
      Value<String?> modelDemandingFactorLabel,
      required DateTime revealedAt,
      Value<DateTime> updatedAt,
    });
typedef $$ForecastReflectionItemsTableUpdateCompanionBuilder =
    ForecastReflectionItemsCompanion Function({
      Value<int> id,
      Value<String> date,
      Value<int> predictionId,
      Value<String> supportiveFactorType,
      Value<String> supportiveFactorLabel,
      Value<String> demandingFactorType,
      Value<String> demandingFactorLabel,
      Value<String?> modelSupportiveFactorType,
      Value<String?> modelSupportiveFactorLabel,
      Value<String?> modelDemandingFactorType,
      Value<String?> modelDemandingFactorLabel,
      Value<DateTime> revealedAt,
      Value<DateTime> updatedAt,
    });

final class $$ForecastReflectionItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ForecastReflectionItemsTable,
          ForecastReflectionItem
        > {
  $$ForecastReflectionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DailyPredictionItemsTable _predictionIdTable(_$AppDatabase db) =>
      db.dailyPredictionItems.createAlias(
        $_aliasNameGenerator(
          db.forecastReflectionItems.predictionId,
          db.dailyPredictionItems.id,
        ),
      );

  $$DailyPredictionItemsTableProcessedTableManager get predictionId {
    final $_column = $_itemColumn<int>('prediction_id')!;

    final manager = $$DailyPredictionItemsTableTableManager(
      $_db,
      $_db.dailyPredictionItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_predictionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ForecastReflectionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ForecastReflectionItemsTable> {
  $$ForecastReflectionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supportiveFactorType => $composableBuilder(
    column: $table.supportiveFactorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supportiveFactorLabel => $composableBuilder(
    column: $table.supportiveFactorLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get demandingFactorType => $composableBuilder(
    column: $table.demandingFactorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get demandingFactorLabel => $composableBuilder(
    column: $table.demandingFactorLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelSupportiveFactorType => $composableBuilder(
    column: $table.modelSupportiveFactorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelSupportiveFactorLabel => $composableBuilder(
    column: $table.modelSupportiveFactorLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelDemandingFactorType => $composableBuilder(
    column: $table.modelDemandingFactorType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelDemandingFactorLabel => $composableBuilder(
    column: $table.modelDemandingFactorLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get revealedAt => $composableBuilder(
    column: $table.revealedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DailyPredictionItemsTableFilterComposer get predictionId {
    final $$DailyPredictionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.predictionId,
      referencedTable: $db.dailyPredictionItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DailyPredictionItemsTableFilterComposer(
            $db: $db,
            $table: $db.dailyPredictionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ForecastReflectionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ForecastReflectionItemsTable> {
  $$ForecastReflectionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supportiveFactorType => $composableBuilder(
    column: $table.supportiveFactorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supportiveFactorLabel => $composableBuilder(
    column: $table.supportiveFactorLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get demandingFactorType => $composableBuilder(
    column: $table.demandingFactorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get demandingFactorLabel => $composableBuilder(
    column: $table.demandingFactorLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelSupportiveFactorType => $composableBuilder(
    column: $table.modelSupportiveFactorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelSupportiveFactorLabel => $composableBuilder(
    column: $table.modelSupportiveFactorLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelDemandingFactorType => $composableBuilder(
    column: $table.modelDemandingFactorType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelDemandingFactorLabel => $composableBuilder(
    column: $table.modelDemandingFactorLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get revealedAt => $composableBuilder(
    column: $table.revealedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DailyPredictionItemsTableOrderingComposer get predictionId {
    final $$DailyPredictionItemsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.predictionId,
          referencedTable: $db.dailyPredictionItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyPredictionItemsTableOrderingComposer(
                $db: $db,
                $table: $db.dailyPredictionItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ForecastReflectionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ForecastReflectionItemsTable> {
  $$ForecastReflectionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get supportiveFactorType => $composableBuilder(
    column: $table.supportiveFactorType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supportiveFactorLabel => $composableBuilder(
    column: $table.supportiveFactorLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get demandingFactorType => $composableBuilder(
    column: $table.demandingFactorType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get demandingFactorLabel => $composableBuilder(
    column: $table.demandingFactorLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelSupportiveFactorType => $composableBuilder(
    column: $table.modelSupportiveFactorType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelSupportiveFactorLabel => $composableBuilder(
    column: $table.modelSupportiveFactorLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelDemandingFactorType => $composableBuilder(
    column: $table.modelDemandingFactorType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelDemandingFactorLabel => $composableBuilder(
    column: $table.modelDemandingFactorLabel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get revealedAt => $composableBuilder(
    column: $table.revealedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DailyPredictionItemsTableAnnotationComposer get predictionId {
    final $$DailyPredictionItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.predictionId,
          referencedTable: $db.dailyPredictionItems,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DailyPredictionItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.dailyPredictionItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$ForecastReflectionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ForecastReflectionItemsTable,
          ForecastReflectionItem,
          $$ForecastReflectionItemsTableFilterComposer,
          $$ForecastReflectionItemsTableOrderingComposer,
          $$ForecastReflectionItemsTableAnnotationComposer,
          $$ForecastReflectionItemsTableCreateCompanionBuilder,
          $$ForecastReflectionItemsTableUpdateCompanionBuilder,
          (ForecastReflectionItem, $$ForecastReflectionItemsTableReferences),
          ForecastReflectionItem,
          PrefetchHooks Function({bool predictionId})
        > {
  $$ForecastReflectionItemsTableTableManager(
    _$AppDatabase db,
    $ForecastReflectionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ForecastReflectionItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ForecastReflectionItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ForecastReflectionItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<int> predictionId = const Value.absent(),
                Value<String> supportiveFactorType = const Value.absent(),
                Value<String> supportiveFactorLabel = const Value.absent(),
                Value<String> demandingFactorType = const Value.absent(),
                Value<String> demandingFactorLabel = const Value.absent(),
                Value<String?> modelSupportiveFactorType = const Value.absent(),
                Value<String?> modelSupportiveFactorLabel =
                    const Value.absent(),
                Value<String?> modelDemandingFactorType = const Value.absent(),
                Value<String?> modelDemandingFactorLabel = const Value.absent(),
                Value<DateTime> revealedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ForecastReflectionItemsCompanion(
                id: id,
                date: date,
                predictionId: predictionId,
                supportiveFactorType: supportiveFactorType,
                supportiveFactorLabel: supportiveFactorLabel,
                demandingFactorType: demandingFactorType,
                demandingFactorLabel: demandingFactorLabel,
                modelSupportiveFactorType: modelSupportiveFactorType,
                modelSupportiveFactorLabel: modelSupportiveFactorLabel,
                modelDemandingFactorType: modelDemandingFactorType,
                modelDemandingFactorLabel: modelDemandingFactorLabel,
                revealedAt: revealedAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String date,
                required int predictionId,
                required String supportiveFactorType,
                required String supportiveFactorLabel,
                required String demandingFactorType,
                required String demandingFactorLabel,
                Value<String?> modelSupportiveFactorType = const Value.absent(),
                Value<String?> modelSupportiveFactorLabel =
                    const Value.absent(),
                Value<String?> modelDemandingFactorType = const Value.absent(),
                Value<String?> modelDemandingFactorLabel = const Value.absent(),
                required DateTime revealedAt,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ForecastReflectionItemsCompanion.insert(
                id: id,
                date: date,
                predictionId: predictionId,
                supportiveFactorType: supportiveFactorType,
                supportiveFactorLabel: supportiveFactorLabel,
                demandingFactorType: demandingFactorType,
                demandingFactorLabel: demandingFactorLabel,
                modelSupportiveFactorType: modelSupportiveFactorType,
                modelSupportiveFactorLabel: modelSupportiveFactorLabel,
                modelDemandingFactorType: modelDemandingFactorType,
                modelDemandingFactorLabel: modelDemandingFactorLabel,
                revealedAt: revealedAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ForecastReflectionItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({predictionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (predictionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.predictionId,
                                referencedTable:
                                    $$ForecastReflectionItemsTableReferences
                                        ._predictionIdTable(db),
                                referencedColumn:
                                    $$ForecastReflectionItemsTableReferences
                                        ._predictionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ForecastReflectionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ForecastReflectionItemsTable,
      ForecastReflectionItem,
      $$ForecastReflectionItemsTableFilterComposer,
      $$ForecastReflectionItemsTableOrderingComposer,
      $$ForecastReflectionItemsTableAnnotationComposer,
      $$ForecastReflectionItemsTableCreateCompanionBuilder,
      $$ForecastReflectionItemsTableUpdateCompanionBuilder,
      (ForecastReflectionItem, $$ForecastReflectionItemsTableReferences),
      ForecastReflectionItem,
      PrefetchHooks Function({bool predictionId})
    >;
typedef $$CalendarSyncItemsTableCreateCompanionBuilder =
    CalendarSyncItemsCompanion Function({
      required String date,
      required String source,
      required DateTime lastSuccessfulSyncAt,
      required int eventCount,
      Value<int> rowid,
    });
typedef $$CalendarSyncItemsTableUpdateCompanionBuilder =
    CalendarSyncItemsCompanion Function({
      Value<String> date,
      Value<String> source,
      Value<DateTime> lastSuccessfulSyncAt,
      Value<int> eventCount,
      Value<int> rowid,
    });

class $$CalendarSyncItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarSyncItemsTable> {
  $$CalendarSyncItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSuccessfulSyncAt => $composableBuilder(
    column: $table.lastSuccessfulSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eventCount => $composableBuilder(
    column: $table.eventCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendarSyncItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarSyncItemsTable> {
  $$CalendarSyncItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSuccessfulSyncAt => $composableBuilder(
    column: $table.lastSuccessfulSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eventCount => $composableBuilder(
    column: $table.eventCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarSyncItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarSyncItemsTable> {
  $$CalendarSyncItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSuccessfulSyncAt => $composableBuilder(
    column: $table.lastSuccessfulSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eventCount => $composableBuilder(
    column: $table.eventCount,
    builder: (column) => column,
  );
}

class $$CalendarSyncItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarSyncItemsTable,
          CalendarSyncItem,
          $$CalendarSyncItemsTableFilterComposer,
          $$CalendarSyncItemsTableOrderingComposer,
          $$CalendarSyncItemsTableAnnotationComposer,
          $$CalendarSyncItemsTableCreateCompanionBuilder,
          $$CalendarSyncItemsTableUpdateCompanionBuilder,
          (
            CalendarSyncItem,
            BaseReferences<
              _$AppDatabase,
              $CalendarSyncItemsTable,
              CalendarSyncItem
            >,
          ),
          CalendarSyncItem,
          PrefetchHooks Function()
        > {
  $$CalendarSyncItemsTableTableManager(
    _$AppDatabase db,
    $CalendarSyncItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarSyncItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarSyncItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarSyncItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> lastSuccessfulSyncAt = const Value.absent(),
                Value<int> eventCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarSyncItemsCompanion(
                date: date,
                source: source,
                lastSuccessfulSyncAt: lastSuccessfulSyncAt,
                eventCount: eventCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                required String source,
                required DateTime lastSuccessfulSyncAt,
                required int eventCount,
                Value<int> rowid = const Value.absent(),
              }) => CalendarSyncItemsCompanion.insert(
                date: date,
                source: source,
                lastSuccessfulSyncAt: lastSuccessfulSyncAt,
                eventCount: eventCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendarSyncItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarSyncItemsTable,
      CalendarSyncItem,
      $$CalendarSyncItemsTableFilterComposer,
      $$CalendarSyncItemsTableOrderingComposer,
      $$CalendarSyncItemsTableAnnotationComposer,
      $$CalendarSyncItemsTableCreateCompanionBuilder,
      $$CalendarSyncItemsTableUpdateCompanionBuilder,
      (
        CalendarSyncItem,
        BaseReferences<
          _$AppDatabase,
          $CalendarSyncItemsTable,
          CalendarSyncItem
        >,
      ),
      CalendarSyncItem,
      PrefetchHooks Function()
    >;
typedef $$InitialSetupItemsTableCreateCompanionBuilder =
    InitialSetupItemsCompanion Function({
      Value<int> id,
      Value<String?> researchParticipantCode,
      required String questionnaireVersion,
      required int typicalEnergyScore,
      required int busyImpactScore,
      required int backToBackImpactScore,
      required int longBlockImpactScore,
      required int freeGapImpactScore,
      required int focusImpactScore,
      required int socialImpactScore,
      required int lifeAdminImpactScore,
      required int exerciseImpactScore,
      required int calendarUnderstandingScore,
      required int schedulePredictionConfidenceScore,
      required DateTime questionnaireCompletedAt,
      Value<DateTime?> calendarSetupCompletedAt,
      Value<bool> calendarSetupSkipped,
      Value<DateTime> updatedAt,
    });
typedef $$InitialSetupItemsTableUpdateCompanionBuilder =
    InitialSetupItemsCompanion Function({
      Value<int> id,
      Value<String?> researchParticipantCode,
      Value<String> questionnaireVersion,
      Value<int> typicalEnergyScore,
      Value<int> busyImpactScore,
      Value<int> backToBackImpactScore,
      Value<int> longBlockImpactScore,
      Value<int> freeGapImpactScore,
      Value<int> focusImpactScore,
      Value<int> socialImpactScore,
      Value<int> lifeAdminImpactScore,
      Value<int> exerciseImpactScore,
      Value<int> calendarUnderstandingScore,
      Value<int> schedulePredictionConfidenceScore,
      Value<DateTime> questionnaireCompletedAt,
      Value<DateTime?> calendarSetupCompletedAt,
      Value<bool> calendarSetupSkipped,
      Value<DateTime> updatedAt,
    });

class $$InitialSetupItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InitialSetupItemsTable> {
  $$InitialSetupItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get researchParticipantCode => $composableBuilder(
    column: $table.researchParticipantCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionnaireVersion => $composableBuilder(
    column: $table.questionnaireVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get typicalEnergyScore => $composableBuilder(
    column: $table.typicalEnergyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get busyImpactScore => $composableBuilder(
    column: $table.busyImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get backToBackImpactScore => $composableBuilder(
    column: $table.backToBackImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longBlockImpactScore => $composableBuilder(
    column: $table.longBlockImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freeGapImpactScore => $composableBuilder(
    column: $table.freeGapImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusImpactScore => $composableBuilder(
    column: $table.focusImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get socialImpactScore => $composableBuilder(
    column: $table.socialImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lifeAdminImpactScore => $composableBuilder(
    column: $table.lifeAdminImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exerciseImpactScore => $composableBuilder(
    column: $table.exerciseImpactScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calendarUnderstandingScore => $composableBuilder(
    column: $table.calendarUnderstandingScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schedulePredictionConfidenceScore =>
      $composableBuilder(
        column: $table.schedulePredictionConfidenceScore,
        builder: (column) => ColumnFilters(column),
      );

  ColumnFilters<DateTime> get questionnaireCompletedAt => $composableBuilder(
    column: $table.questionnaireCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get calendarSetupCompletedAt => $composableBuilder(
    column: $table.calendarSetupCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get calendarSetupSkipped => $composableBuilder(
    column: $table.calendarSetupSkipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InitialSetupItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InitialSetupItemsTable> {
  $$InitialSetupItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get researchParticipantCode => $composableBuilder(
    column: $table.researchParticipantCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionnaireVersion => $composableBuilder(
    column: $table.questionnaireVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get typicalEnergyScore => $composableBuilder(
    column: $table.typicalEnergyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get busyImpactScore => $composableBuilder(
    column: $table.busyImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get backToBackImpactScore => $composableBuilder(
    column: $table.backToBackImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longBlockImpactScore => $composableBuilder(
    column: $table.longBlockImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freeGapImpactScore => $composableBuilder(
    column: $table.freeGapImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusImpactScore => $composableBuilder(
    column: $table.focusImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get socialImpactScore => $composableBuilder(
    column: $table.socialImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lifeAdminImpactScore => $composableBuilder(
    column: $table.lifeAdminImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exerciseImpactScore => $composableBuilder(
    column: $table.exerciseImpactScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calendarUnderstandingScore => $composableBuilder(
    column: $table.calendarUnderstandingScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get schedulePredictionConfidenceScore =>
      $composableBuilder(
        column: $table.schedulePredictionConfidenceScore,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<DateTime> get questionnaireCompletedAt => $composableBuilder(
    column: $table.questionnaireCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get calendarSetupCompletedAt => $composableBuilder(
    column: $table.calendarSetupCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get calendarSetupSkipped => $composableBuilder(
    column: $table.calendarSetupSkipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InitialSetupItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InitialSetupItemsTable> {
  $$InitialSetupItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get researchParticipantCode => $composableBuilder(
    column: $table.researchParticipantCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionnaireVersion => $composableBuilder(
    column: $table.questionnaireVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get typicalEnergyScore => $composableBuilder(
    column: $table.typicalEnergyScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get busyImpactScore => $composableBuilder(
    column: $table.busyImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get backToBackImpactScore => $composableBuilder(
    column: $table.backToBackImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longBlockImpactScore => $composableBuilder(
    column: $table.longBlockImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get freeGapImpactScore => $composableBuilder(
    column: $table.freeGapImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusImpactScore => $composableBuilder(
    column: $table.focusImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get socialImpactScore => $composableBuilder(
    column: $table.socialImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lifeAdminImpactScore => $composableBuilder(
    column: $table.lifeAdminImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get exerciseImpactScore => $composableBuilder(
    column: $table.exerciseImpactScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get calendarUnderstandingScore => $composableBuilder(
    column: $table.calendarUnderstandingScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get schedulePredictionConfidenceScore =>
      $composableBuilder(
        column: $table.schedulePredictionConfidenceScore,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get questionnaireCompletedAt => $composableBuilder(
    column: $table.questionnaireCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get calendarSetupCompletedAt => $composableBuilder(
    column: $table.calendarSetupCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get calendarSetupSkipped => $composableBuilder(
    column: $table.calendarSetupSkipped,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InitialSetupItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InitialSetupItemsTable,
          InitialSetupItem,
          $$InitialSetupItemsTableFilterComposer,
          $$InitialSetupItemsTableOrderingComposer,
          $$InitialSetupItemsTableAnnotationComposer,
          $$InitialSetupItemsTableCreateCompanionBuilder,
          $$InitialSetupItemsTableUpdateCompanionBuilder,
          (
            InitialSetupItem,
            BaseReferences<
              _$AppDatabase,
              $InitialSetupItemsTable,
              InitialSetupItem
            >,
          ),
          InitialSetupItem,
          PrefetchHooks Function()
        > {
  $$InitialSetupItemsTableTableManager(
    _$AppDatabase db,
    $InitialSetupItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InitialSetupItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InitialSetupItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InitialSetupItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> researchParticipantCode = const Value.absent(),
                Value<String> questionnaireVersion = const Value.absent(),
                Value<int> typicalEnergyScore = const Value.absent(),
                Value<int> busyImpactScore = const Value.absent(),
                Value<int> backToBackImpactScore = const Value.absent(),
                Value<int> longBlockImpactScore = const Value.absent(),
                Value<int> freeGapImpactScore = const Value.absent(),
                Value<int> focusImpactScore = const Value.absent(),
                Value<int> socialImpactScore = const Value.absent(),
                Value<int> lifeAdminImpactScore = const Value.absent(),
                Value<int> exerciseImpactScore = const Value.absent(),
                Value<int> calendarUnderstandingScore = const Value.absent(),
                Value<int> schedulePredictionConfidenceScore =
                    const Value.absent(),
                Value<DateTime> questionnaireCompletedAt = const Value.absent(),
                Value<DateTime?> calendarSetupCompletedAt =
                    const Value.absent(),
                Value<bool> calendarSetupSkipped = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InitialSetupItemsCompanion(
                id: id,
                researchParticipantCode: researchParticipantCode,
                questionnaireVersion: questionnaireVersion,
                typicalEnergyScore: typicalEnergyScore,
                busyImpactScore: busyImpactScore,
                backToBackImpactScore: backToBackImpactScore,
                longBlockImpactScore: longBlockImpactScore,
                freeGapImpactScore: freeGapImpactScore,
                focusImpactScore: focusImpactScore,
                socialImpactScore: socialImpactScore,
                lifeAdminImpactScore: lifeAdminImpactScore,
                exerciseImpactScore: exerciseImpactScore,
                calendarUnderstandingScore: calendarUnderstandingScore,
                schedulePredictionConfidenceScore:
                    schedulePredictionConfidenceScore,
                questionnaireCompletedAt: questionnaireCompletedAt,
                calendarSetupCompletedAt: calendarSetupCompletedAt,
                calendarSetupSkipped: calendarSetupSkipped,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> researchParticipantCode = const Value.absent(),
                required String questionnaireVersion,
                required int typicalEnergyScore,
                required int busyImpactScore,
                required int backToBackImpactScore,
                required int longBlockImpactScore,
                required int freeGapImpactScore,
                required int focusImpactScore,
                required int socialImpactScore,
                required int lifeAdminImpactScore,
                required int exerciseImpactScore,
                required int calendarUnderstandingScore,
                required int schedulePredictionConfidenceScore,
                required DateTime questionnaireCompletedAt,
                Value<DateTime?> calendarSetupCompletedAt =
                    const Value.absent(),
                Value<bool> calendarSetupSkipped = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InitialSetupItemsCompanion.insert(
                id: id,
                researchParticipantCode: researchParticipantCode,
                questionnaireVersion: questionnaireVersion,
                typicalEnergyScore: typicalEnergyScore,
                busyImpactScore: busyImpactScore,
                backToBackImpactScore: backToBackImpactScore,
                longBlockImpactScore: longBlockImpactScore,
                freeGapImpactScore: freeGapImpactScore,
                focusImpactScore: focusImpactScore,
                socialImpactScore: socialImpactScore,
                lifeAdminImpactScore: lifeAdminImpactScore,
                exerciseImpactScore: exerciseImpactScore,
                calendarUnderstandingScore: calendarUnderstandingScore,
                schedulePredictionConfidenceScore:
                    schedulePredictionConfidenceScore,
                questionnaireCompletedAt: questionnaireCompletedAt,
                calendarSetupCompletedAt: calendarSetupCompletedAt,
                calendarSetupSkipped: calendarSetupSkipped,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InitialSetupItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InitialSetupItemsTable,
      InitialSetupItem,
      $$InitialSetupItemsTableFilterComposer,
      $$InitialSetupItemsTableOrderingComposer,
      $$InitialSetupItemsTableAnnotationComposer,
      $$InitialSetupItemsTableCreateCompanionBuilder,
      $$InitialSetupItemsTableUpdateCompanionBuilder,
      (
        InitialSetupItem,
        BaseReferences<
          _$AppDatabase,
          $InitialSetupItemsTable,
          InitialSetupItem
        >,
      ),
      InitialSetupItem,
      PrefetchHooks Function()
    >;
typedef $$EnergyModelItemsTableCreateCompanionBuilder =
    EnergyModelItemsCompanion Function({
      Value<int> id,
      required String modelVersion,
      required String modelSource,
      required String featureVersion,
      required String targetVersion,
      required double intercept,
      required String coefficientsJson,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$EnergyModelItemsTableUpdateCompanionBuilder =
    EnergyModelItemsCompanion Function({
      Value<int> id,
      Value<String> modelVersion,
      Value<String> modelSource,
      Value<String> featureVersion,
      Value<String> targetVersion,
      Value<double> intercept,
      Value<String> coefficientsJson,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$EnergyModelItemsTableFilterComposer
    extends Composer<_$AppDatabase, $EnergyModelItemsTable> {
  $$EnergyModelItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelSource => $composableBuilder(
    column: $table.modelSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featureVersion => $composableBuilder(
    column: $table.featureVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetVersion => $composableBuilder(
    column: $table.targetVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get intercept => $composableBuilder(
    column: $table.intercept,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coefficientsJson => $composableBuilder(
    column: $table.coefficientsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EnergyModelItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnergyModelItemsTable> {
  $$EnergyModelItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelSource => $composableBuilder(
    column: $table.modelSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featureVersion => $composableBuilder(
    column: $table.featureVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetVersion => $composableBuilder(
    column: $table.targetVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get intercept => $composableBuilder(
    column: $table.intercept,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coefficientsJson => $composableBuilder(
    column: $table.coefficientsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnergyModelItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnergyModelItemsTable> {
  $$EnergyModelItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get modelVersion => $composableBuilder(
    column: $table.modelVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modelSource => $composableBuilder(
    column: $table.modelSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get featureVersion => $composableBuilder(
    column: $table.featureVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetVersion => $composableBuilder(
    column: $table.targetVersion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get intercept =>
      $composableBuilder(column: $table.intercept, builder: (column) => column);

  GeneratedColumn<String> get coefficientsJson => $composableBuilder(
    column: $table.coefficientsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EnergyModelItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnergyModelItemsTable,
          EnergyModelItem,
          $$EnergyModelItemsTableFilterComposer,
          $$EnergyModelItemsTableOrderingComposer,
          $$EnergyModelItemsTableAnnotationComposer,
          $$EnergyModelItemsTableCreateCompanionBuilder,
          $$EnergyModelItemsTableUpdateCompanionBuilder,
          (
            EnergyModelItem,
            BaseReferences<
              _$AppDatabase,
              $EnergyModelItemsTable,
              EnergyModelItem
            >,
          ),
          EnergyModelItem,
          PrefetchHooks Function()
        > {
  $$EnergyModelItemsTableTableManager(
    _$AppDatabase db,
    $EnergyModelItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnergyModelItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnergyModelItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnergyModelItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> modelVersion = const Value.absent(),
                Value<String> modelSource = const Value.absent(),
                Value<String> featureVersion = const Value.absent(),
                Value<String> targetVersion = const Value.absent(),
                Value<double> intercept = const Value.absent(),
                Value<String> coefficientsJson = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EnergyModelItemsCompanion(
                id: id,
                modelVersion: modelVersion,
                modelSource: modelSource,
                featureVersion: featureVersion,
                targetVersion: targetVersion,
                intercept: intercept,
                coefficientsJson: coefficientsJson,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String modelVersion,
                required String modelSource,
                required String featureVersion,
                required String targetVersion,
                required double intercept,
                required String coefficientsJson,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => EnergyModelItemsCompanion.insert(
                id: id,
                modelVersion: modelVersion,
                modelSource: modelSource,
                featureVersion: featureVersion,
                targetVersion: targetVersion,
                intercept: intercept,
                coefficientsJson: coefficientsJson,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EnergyModelItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnergyModelItemsTable,
      EnergyModelItem,
      $$EnergyModelItemsTableFilterComposer,
      $$EnergyModelItemsTableOrderingComposer,
      $$EnergyModelItemsTableAnnotationComposer,
      $$EnergyModelItemsTableCreateCompanionBuilder,
      $$EnergyModelItemsTableUpdateCompanionBuilder,
      (
        EnergyModelItem,
        BaseReferences<_$AppDatabase, $EnergyModelItemsTable, EnergyModelItem>,
      ),
      EnergyModelItem,
      PrefetchHooks Function()
    >;
typedef $$NotificationPreferenceItemsTableCreateCompanionBuilder =
    NotificationPreferenceItemsCompanion Function({
      Value<int> id,
      Value<bool> morningEnabled,
      Value<int> morningHour,
      Value<int> morningMinute,
      Value<bool> eveningEnabled,
      Value<int> eveningHour,
      Value<int> eveningMinute,
      Value<DateTime> updatedAt,
    });
typedef $$NotificationPreferenceItemsTableUpdateCompanionBuilder =
    NotificationPreferenceItemsCompanion Function({
      Value<int> id,
      Value<bool> morningEnabled,
      Value<int> morningHour,
      Value<int> morningMinute,
      Value<bool> eveningEnabled,
      Value<int> eveningHour,
      Value<int> eveningMinute,
      Value<DateTime> updatedAt,
    });

class $$NotificationPreferenceItemsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationPreferenceItemsTable> {
  $$NotificationPreferenceItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get morningEnabled => $composableBuilder(
    column: $table.morningEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get morningHour => $composableBuilder(
    column: $table.morningHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get morningMinute => $composableBuilder(
    column: $table.morningMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get eveningEnabled => $composableBuilder(
    column: $table.eveningEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eveningHour => $composableBuilder(
    column: $table.eveningHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get eveningMinute => $composableBuilder(
    column: $table.eveningMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationPreferenceItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationPreferenceItemsTable> {
  $$NotificationPreferenceItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get morningEnabled => $composableBuilder(
    column: $table.morningEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get morningHour => $composableBuilder(
    column: $table.morningHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get morningMinute => $composableBuilder(
    column: $table.morningMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get eveningEnabled => $composableBuilder(
    column: $table.eveningEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eveningHour => $composableBuilder(
    column: $table.eveningHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get eveningMinute => $composableBuilder(
    column: $table.eveningMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationPreferenceItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationPreferenceItemsTable> {
  $$NotificationPreferenceItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get morningEnabled => $composableBuilder(
    column: $table.morningEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get morningHour => $composableBuilder(
    column: $table.morningHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get morningMinute => $composableBuilder(
    column: $table.morningMinute,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get eveningEnabled => $composableBuilder(
    column: $table.eveningEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eveningHour => $composableBuilder(
    column: $table.eveningHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get eveningMinute => $composableBuilder(
    column: $table.eveningMinute,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotificationPreferenceItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationPreferenceItemsTable,
          NotificationPreferenceItem,
          $$NotificationPreferenceItemsTableFilterComposer,
          $$NotificationPreferenceItemsTableOrderingComposer,
          $$NotificationPreferenceItemsTableAnnotationComposer,
          $$NotificationPreferenceItemsTableCreateCompanionBuilder,
          $$NotificationPreferenceItemsTableUpdateCompanionBuilder,
          (
            NotificationPreferenceItem,
            BaseReferences<
              _$AppDatabase,
              $NotificationPreferenceItemsTable,
              NotificationPreferenceItem
            >,
          ),
          NotificationPreferenceItem,
          PrefetchHooks Function()
        > {
  $$NotificationPreferenceItemsTableTableManager(
    _$AppDatabase db,
    $NotificationPreferenceItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationPreferenceItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationPreferenceItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationPreferenceItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> morningEnabled = const Value.absent(),
                Value<int> morningHour = const Value.absent(),
                Value<int> morningMinute = const Value.absent(),
                Value<bool> eveningEnabled = const Value.absent(),
                Value<int> eveningHour = const Value.absent(),
                Value<int> eveningMinute = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotificationPreferenceItemsCompanion(
                id: id,
                morningEnabled: morningEnabled,
                morningHour: morningHour,
                morningMinute: morningMinute,
                eveningEnabled: eveningEnabled,
                eveningHour: eveningHour,
                eveningMinute: eveningMinute,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> morningEnabled = const Value.absent(),
                Value<int> morningHour = const Value.absent(),
                Value<int> morningMinute = const Value.absent(),
                Value<bool> eveningEnabled = const Value.absent(),
                Value<int> eveningHour = const Value.absent(),
                Value<int> eveningMinute = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotificationPreferenceItemsCompanion.insert(
                id: id,
                morningEnabled: morningEnabled,
                morningHour: morningHour,
                morningMinute: morningMinute,
                eveningEnabled: eveningEnabled,
                eveningHour: eveningHour,
                eveningMinute: eveningMinute,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationPreferenceItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationPreferenceItemsTable,
      NotificationPreferenceItem,
      $$NotificationPreferenceItemsTableFilterComposer,
      $$NotificationPreferenceItemsTableOrderingComposer,
      $$NotificationPreferenceItemsTableAnnotationComposer,
      $$NotificationPreferenceItemsTableCreateCompanionBuilder,
      $$NotificationPreferenceItemsTableUpdateCompanionBuilder,
      (
        NotificationPreferenceItem,
        BaseReferences<
          _$AppDatabase,
          $NotificationPreferenceItemsTable,
          NotificationPreferenceItem
        >,
      ),
      NotificationPreferenceItem,
      PrefetchHooks Function()
    >;
typedef $$ResearchInteractionItemsTableCreateCompanionBuilder =
    ResearchInteractionItemsCompanion Function({
      Value<int> id,
      required String eventType,
      required DateTime occurredAt,
    });
typedef $$ResearchInteractionItemsTableUpdateCompanionBuilder =
    ResearchInteractionItemsCompanion Function({
      Value<int> id,
      Value<String> eventType,
      Value<DateTime> occurredAt,
    });

class $$ResearchInteractionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ResearchInteractionItemsTable> {
  $$ResearchInteractionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ResearchInteractionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ResearchInteractionItemsTable> {
  $$ResearchInteractionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ResearchInteractionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ResearchInteractionItemsTable> {
  $$ResearchInteractionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );
}

class $$ResearchInteractionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ResearchInteractionItemsTable,
          ResearchInteractionItem,
          $$ResearchInteractionItemsTableFilterComposer,
          $$ResearchInteractionItemsTableOrderingComposer,
          $$ResearchInteractionItemsTableAnnotationComposer,
          $$ResearchInteractionItemsTableCreateCompanionBuilder,
          $$ResearchInteractionItemsTableUpdateCompanionBuilder,
          (
            ResearchInteractionItem,
            BaseReferences<
              _$AppDatabase,
              $ResearchInteractionItemsTable,
              ResearchInteractionItem
            >,
          ),
          ResearchInteractionItem,
          PrefetchHooks Function()
        > {
  $$ResearchInteractionItemsTableTableManager(
    _$AppDatabase db,
    $ResearchInteractionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ResearchInteractionItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ResearchInteractionItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ResearchInteractionItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
              }) => ResearchInteractionItemsCompanion(
                id: id,
                eventType: eventType,
                occurredAt: occurredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventType,
                required DateTime occurredAt,
              }) => ResearchInteractionItemsCompanion.insert(
                id: id,
                eventType: eventType,
                occurredAt: occurredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ResearchInteractionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ResearchInteractionItemsTable,
      ResearchInteractionItem,
      $$ResearchInteractionItemsTableFilterComposer,
      $$ResearchInteractionItemsTableOrderingComposer,
      $$ResearchInteractionItemsTableAnnotationComposer,
      $$ResearchInteractionItemsTableCreateCompanionBuilder,
      $$ResearchInteractionItemsTableUpdateCompanionBuilder,
      (
        ResearchInteractionItem,
        BaseReferences<
          _$AppDatabase,
          $ResearchInteractionItemsTable,
          ResearchInteractionItem
        >,
      ),
      ResearchInteractionItem,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EventUserDataItemsTableTableManager get eventUserDataItems =>
      $$EventUserDataItemsTableTableManager(_db, _db.eventUserDataItems);
  $$CachedCalendarEventItemsTableTableManager get cachedCalendarEventItems =>
      $$CachedCalendarEventItemsTableTableManager(
        _db,
        _db.cachedCalendarEventItems,
      );
  $$ManualCalendarEventItemsTableTableManager get manualCalendarEventItems =>
      $$ManualCalendarEventItemsTableTableManager(
        _db,
        _db.manualCalendarEventItems,
      );
  $$DailyReflectionItemsTableTableManager get dailyReflectionItems =>
      $$DailyReflectionItemsTableTableManager(_db, _db.dailyReflectionItems);
  $$DailyIntentionItemsTableTableManager get dailyIntentionItems =>
      $$DailyIntentionItemsTableTableManager(_db, _db.dailyIntentionItems);
  $$DailyFeatureSnapshotItemsTableTableManager get dailyFeatureSnapshotItems =>
      $$DailyFeatureSnapshotItemsTableTableManager(
        _db,
        _db.dailyFeatureSnapshotItems,
      );
  $$DailyPredictionItemsTableTableManager get dailyPredictionItems =>
      $$DailyPredictionItemsTableTableManager(_db, _db.dailyPredictionItems);
  $$ForecastReflectionItemsTableTableManager get forecastReflectionItems =>
      $$ForecastReflectionItemsTableTableManager(
        _db,
        _db.forecastReflectionItems,
      );
  $$CalendarSyncItemsTableTableManager get calendarSyncItems =>
      $$CalendarSyncItemsTableTableManager(_db, _db.calendarSyncItems);
  $$InitialSetupItemsTableTableManager get initialSetupItems =>
      $$InitialSetupItemsTableTableManager(_db, _db.initialSetupItems);
  $$EnergyModelItemsTableTableManager get energyModelItems =>
      $$EnergyModelItemsTableTableManager(_db, _db.energyModelItems);
  $$NotificationPreferenceItemsTableTableManager
  get notificationPreferenceItems =>
      $$NotificationPreferenceItemsTableTableManager(
        _db,
        _db.notificationPreferenceItems,
      );
  $$ResearchInteractionItemsTableTableManager get researchInteractionItems =>
      $$ResearchInteractionItemsTableTableManager(
        _db,
        _db.researchInteractionItems,
      );
}
