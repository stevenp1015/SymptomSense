// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLogEntryCollection on Isar {
  IsarCollection<LogEntry> get logEntrys => this.collection();
}

const LogEntrySchema = CollectionSchema(
  name: r'LogEntry',
  id: -8268688274231935295,
  properties: {
    r'exerciseDurationMinutes': PropertySchema(
      id: 0,
      name: r'exerciseDurationMinutes',
      type: IsarType.long,
    ),
    r'exerciseEffort': PropertySchema(
      id: 1,
      name: r'exerciseEffort',
      type: IsarType.long,
    ),
    r'foodCategories': PropertySchema(
      id: 2,
      name: r'foodCategories',
      type: IsarType.stringList,
    ),
    r'hoursSlept': PropertySchema(
      id: 3,
      name: r'hoursSlept',
      type: IsarType.long,
    ),
    r'medications': PropertySchema(
      id: 4,
      name: r'medications',
      type: IsarType.objectList,
      target: r'MedicationIntake',
    ),
    r'notes': PropertySchema(
      id: 5,
      name: r'notes',
      type: IsarType.string,
    ),
    r'otherSymptom': PropertySchema(
      id: 6,
      name: r'otherSymptom',
      type: IsarType.string,
    ),
    r'painEntries': PropertySchema(
      id: 7,
      name: r'painEntries',
      type: IsarType.objectList,
      target: r'PainEntry',
    ),
    r'seizure': PropertySchema(
      id: 8,
      name: r'seizure',
      type: IsarType.bool,
    ),
    r'seizureSeverity': PropertySchema(
      id: 9,
      name: r'seizureSeverity',
      type: IsarType.long,
    ),
    r'timeSpentUprightMinutes': PropertySchema(
      id: 10,
      name: r'timeSpentUprightMinutes',
      type: IsarType.long,
    ),
    r'timestamp': PropertySchema(
      id: 11,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _logEntryEstimateSize,
  serialize: _logEntrySerialize,
  deserialize: _logEntryDeserialize,
  deserializeProp: _logEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'MedicationIntake': MedicationIntakeSchema,
    r'PainEntry': PainEntrySchema
  },
  getId: _logEntryGetId,
  getLinks: _logEntryGetLinks,
  attach: _logEntryAttach,
  version: '3.1.0+1',
);

int _logEntryEstimateSize(
  LogEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.foodCategories;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.medications;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[MedicationIntake]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              MedicationIntakeSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.otherSymptom;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.painEntries;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PainEntry]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              PainEntrySchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  return bytesCount;
}

void _logEntrySerialize(
  LogEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.exerciseDurationMinutes);
  writer.writeLong(offsets[1], object.exerciseEffort);
  writer.writeStringList(offsets[2], object.foodCategories);
  writer.writeLong(offsets[3], object.hoursSlept);
  writer.writeObjectList<MedicationIntake>(
    offsets[4],
    allOffsets,
    MedicationIntakeSchema.serialize,
    object.medications,
  );
  writer.writeString(offsets[5], object.notes);
  writer.writeString(offsets[6], object.otherSymptom);
  writer.writeObjectList<PainEntry>(
    offsets[7],
    allOffsets,
    PainEntrySchema.serialize,
    object.painEntries,
  );
  writer.writeBool(offsets[8], object.seizure);
  writer.writeLong(offsets[9], object.seizureSeverity);
  writer.writeLong(offsets[10], object.timeSpentUprightMinutes);
  writer.writeDateTime(offsets[11], object.timestamp);
}

LogEntry _logEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LogEntry();
  object.exerciseDurationMinutes = reader.readLongOrNull(offsets[0]);
  object.exerciseEffort = reader.readLongOrNull(offsets[1]);
  object.foodCategories = reader.readStringList(offsets[2]);
  object.hoursSlept = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.medications = reader.readObjectList<MedicationIntake>(
    offsets[4],
    MedicationIntakeSchema.deserialize,
    allOffsets,
    MedicationIntake(),
  );
  object.notes = reader.readStringOrNull(offsets[5]);
  object.otherSymptom = reader.readStringOrNull(offsets[6]);
  object.painEntries = reader.readObjectList<PainEntry>(
    offsets[7],
    PainEntrySchema.deserialize,
    allOffsets,
    PainEntry(),
  );
  object.seizure = reader.readBoolOrNull(offsets[8]);
  object.seizureSeverity = reader.readLongOrNull(offsets[9]);
  object.timeSpentUprightMinutes = reader.readLongOrNull(offsets[10]);
  object.timestamp = reader.readDateTime(offsets[11]);
  return object;
}

P _logEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readObjectList<MedicationIntake>(
        offset,
        MedicationIntakeSchema.deserialize,
        allOffsets,
        MedicationIntake(),
      )) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readObjectList<PainEntry>(
        offset,
        PainEntrySchema.deserialize,
        allOffsets,
        PainEntry(),
      )) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _logEntryGetId(LogEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _logEntryGetLinks(LogEntry object) {
  return [];
}

void _logEntryAttach(IsarCollection<dynamic> col, Id id, LogEntry object) {
  object.id = id;
}

extension LogEntryQueryWhereSort on QueryBuilder<LogEntry, LogEntry, QWhere> {
  QueryBuilder<LogEntry, LogEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhere> anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension LogEntryQueryWhere on QueryBuilder<LogEntry, LogEntry, QWhereClause> {
  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> timestampEqualTo(
      DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> timestampNotEqualTo(
      DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> timestampGreaterThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> timestampLessThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterWhereClause> timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LogEntryQueryFilter
    on QueryBuilder<LogEntry, LogEntry, QFilterCondition> {
  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseDurationMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exerciseDurationMinutes',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseDurationMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exerciseDurationMinutes',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseDurationMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseDurationMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseDurationMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseDurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseDurationMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseDurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseEffortIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'exerciseEffort',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseEffortIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'exerciseEffort',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> exerciseEffortEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseEffort',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseEffortGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseEffort',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      exerciseEffortLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseEffort',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> exerciseEffortBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseEffort',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'foodCategories',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'foodCategories',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodCategories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foodCategories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foodCategories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foodCategories',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'foodCategories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'foodCategories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'foodCategories',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'foodCategories',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodCategories',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'foodCategories',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foodCategories',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foodCategories',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foodCategories',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foodCategories',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foodCategories',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      foodCategoriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'foodCategories',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> hoursSleptIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hoursSlept',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      hoursSleptIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hoursSlept',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> hoursSleptEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hoursSlept',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> hoursSleptGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hoursSlept',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> hoursSleptLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hoursSlept',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> hoursSleptBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hoursSlept',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> medicationsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'medications',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      medicationsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'medications',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      medicationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> medicationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      medicationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      medicationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      medicationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      medicationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'medications',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> otherSymptomIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'otherSymptom',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      otherSymptomIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'otherSymptom',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> otherSymptomEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherSymptom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      otherSymptomGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'otherSymptom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> otherSymptomLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'otherSymptom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> otherSymptomBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'otherSymptom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      otherSymptomStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'otherSymptom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> otherSymptomEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'otherSymptom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> otherSymptomContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'otherSymptom',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> otherSymptomMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'otherSymptom',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      otherSymptomIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherSymptom',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      otherSymptomIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'otherSymptom',
        value: '',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> painEntriesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'painEntries',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      painEntriesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'painEntries',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      painEntriesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'painEntries',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> painEntriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'painEntries',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      painEntriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'painEntries',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      painEntriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'painEntries',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      painEntriesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'painEntries',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      painEntriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'painEntries',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> seizureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seizure',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> seizureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seizure',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> seizureEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seizure',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      seizureSeverityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'seizureSeverity',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      seizureSeverityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'seizureSeverity',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      seizureSeverityEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seizureSeverity',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      seizureSeverityGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seizureSeverity',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      seizureSeverityLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seizureSeverity',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      seizureSeverityBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seizureSeverity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      timeSpentUprightMinutesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timeSpentUprightMinutes',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      timeSpentUprightMinutesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timeSpentUprightMinutes',
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      timeSpentUprightMinutesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timeSpentUprightMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      timeSpentUprightMinutesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timeSpentUprightMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      timeSpentUprightMinutesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timeSpentUprightMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition>
      timeSpentUprightMinutesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timeSpentUprightMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> timestampEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension LogEntryQueryObject
    on QueryBuilder<LogEntry, LogEntry, QFilterCondition> {
  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> medicationsElement(
      FilterQuery<MedicationIntake> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'medications');
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterFilterCondition> painEntriesElement(
      FilterQuery<PainEntry> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'painEntries');
    });
  }
}

extension LogEntryQueryLinks
    on QueryBuilder<LogEntry, LogEntry, QFilterCondition> {}

extension LogEntryQuerySortBy on QueryBuilder<LogEntry, LogEntry, QSortBy> {
  QueryBuilder<LogEntry, LogEntry, QAfterSortBy>
      sortByExerciseDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy>
      sortByExerciseDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByExerciseEffort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseEffort', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByExerciseEffortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseEffort', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByHoursSlept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByHoursSleptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByOtherSymptom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherSymptom', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByOtherSymptomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherSymptom', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortBySeizure() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seizure', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortBySeizureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seizure', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortBySeizureSeverity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seizureSeverity', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortBySeizureSeverityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seizureSeverity', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy>
      sortByTimeSpentUprightMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentUprightMinutes', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy>
      sortByTimeSpentUprightMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentUprightMinutes', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension LogEntryQuerySortThenBy
    on QueryBuilder<LogEntry, LogEntry, QSortThenBy> {
  QueryBuilder<LogEntry, LogEntry, QAfterSortBy>
      thenByExerciseDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseDurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy>
      thenByExerciseDurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseDurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByExerciseEffort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseEffort', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByExerciseEffortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseEffort', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByHoursSlept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByHoursSleptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByOtherSymptom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherSymptom', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByOtherSymptomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherSymptom', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenBySeizure() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seizure', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenBySeizureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seizure', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenBySeizureSeverity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seizureSeverity', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenBySeizureSeverityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seizureSeverity', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy>
      thenByTimeSpentUprightMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentUprightMinutes', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy>
      thenByTimeSpentUprightMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSpentUprightMinutes', Sort.desc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QAfterSortBy> thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension LogEntryQueryWhereDistinct
    on QueryBuilder<LogEntry, LogEntry, QDistinct> {
  QueryBuilder<LogEntry, LogEntry, QDistinct>
      distinctByExerciseDurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseDurationMinutes');
    });
  }

  QueryBuilder<LogEntry, LogEntry, QDistinct> distinctByExerciseEffort() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseEffort');
    });
  }

  QueryBuilder<LogEntry, LogEntry, QDistinct> distinctByFoodCategories() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foodCategories');
    });
  }

  QueryBuilder<LogEntry, LogEntry, QDistinct> distinctByHoursSlept() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hoursSlept');
    });
  }

  QueryBuilder<LogEntry, LogEntry, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QDistinct> distinctByOtherSymptom(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'otherSymptom', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LogEntry, LogEntry, QDistinct> distinctBySeizure() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seizure');
    });
  }

  QueryBuilder<LogEntry, LogEntry, QDistinct> distinctBySeizureSeverity() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seizureSeverity');
    });
  }

  QueryBuilder<LogEntry, LogEntry, QDistinct>
      distinctByTimeSpentUprightMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeSpentUprightMinutes');
    });
  }

  QueryBuilder<LogEntry, LogEntry, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension LogEntryQueryProperty
    on QueryBuilder<LogEntry, LogEntry, QQueryProperty> {
  QueryBuilder<LogEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LogEntry, int?, QQueryOperations>
      exerciseDurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseDurationMinutes');
    });
  }

  QueryBuilder<LogEntry, int?, QQueryOperations> exerciseEffortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseEffort');
    });
  }

  QueryBuilder<LogEntry, List<String>?, QQueryOperations>
      foodCategoriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foodCategories');
    });
  }

  QueryBuilder<LogEntry, int?, QQueryOperations> hoursSleptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hoursSlept');
    });
  }

  QueryBuilder<LogEntry, List<MedicationIntake>?, QQueryOperations>
      medicationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medications');
    });
  }

  QueryBuilder<LogEntry, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<LogEntry, String?, QQueryOperations> otherSymptomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'otherSymptom');
    });
  }

  QueryBuilder<LogEntry, List<PainEntry>?, QQueryOperations>
      painEntriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'painEntries');
    });
  }

  QueryBuilder<LogEntry, bool?, QQueryOperations> seizureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seizure');
    });
  }

  QueryBuilder<LogEntry, int?, QQueryOperations> seizureSeverityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seizureSeverity');
    });
  }

  QueryBuilder<LogEntry, int?, QQueryOperations>
      timeSpentUprightMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSpentUprightMinutes');
    });
  }

  QueryBuilder<LogEntry, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const MedicationIntakeSchema = Schema(
  name: r'MedicationIntake',
  id: 6308759356840214734,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _medicationIntakeEstimateSize,
  serialize: _medicationIntakeSerialize,
  deserialize: _medicationIntakeDeserialize,
  deserializeProp: _medicationIntakeDeserializeProp,
);

int _medicationIntakeEstimateSize(
  MedicationIntake object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _medicationIntakeSerialize(
  MedicationIntake object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
}

MedicationIntake _medicationIntakeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MedicationIntake();
  object.name = reader.readStringOrNull(offsets[0]);
  return object;
}

P _medicationIntakeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension MedicationIntakeQueryFilter
    on QueryBuilder<MedicationIntake, MedicationIntake, QFilterCondition> {
  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<MedicationIntake, MedicationIntake, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension MedicationIntakeQueryObject
    on QueryBuilder<MedicationIntake, MedicationIntake, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PainEntrySchema = Schema(
  name: r'PainEntry',
  id: -2925931938070422075,
  properties: {
    r'location': PropertySchema(
      id: 0,
      name: r'location',
      type: IsarType.string,
    ),
    r'severity': PropertySchema(
      id: 1,
      name: r'severity',
      type: IsarType.long,
    )
  },
  estimateSize: _painEntryEstimateSize,
  serialize: _painEntrySerialize,
  deserialize: _painEntryDeserialize,
  deserializeProp: _painEntryDeserializeProp,
);

int _painEntryEstimateSize(
  PainEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.location;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _painEntrySerialize(
  PainEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.location);
  writer.writeLong(offsets[1], object.severity);
}

PainEntry _painEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PainEntry();
  object.location = reader.readStringOrNull(offsets[0]);
  object.severity = reader.readLongOrNull(offsets[1]);
  return object;
}

P _painEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PainEntryQueryFilter
    on QueryBuilder<PainEntry, PainEntry, QFilterCondition> {
  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'location',
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition>
      locationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'location',
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'location',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'location',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition>
      locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> severityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'severity',
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition>
      severityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'severity',
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> severityEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'severity',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> severityGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'severity',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> severityLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'severity',
        value: value,
      ));
    });
  }

  QueryBuilder<PainEntry, PainEntry, QAfterFilterCondition> severityBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'severity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PainEntryQueryObject
    on QueryBuilder<PainEntry, PainEntry, QFilterCondition> {}
