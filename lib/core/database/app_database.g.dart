// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _taskMeta = const VerificationMeta('task');
  @override
  late final GeneratedColumn<String> task = GeneratedColumn<String>(
      'task', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endedAtMeta =
      const VerificationMeta('endedAt');
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
      'ended_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _plannedSecondsMeta =
      const VerificationMeta('plannedSeconds');
  @override
  late final GeneratedColumn<int> plannedSeconds = GeneratedColumn<int>(
      'planned_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _actualSecondsMeta =
      const VerificationMeta('actualSeconds');
  @override
  late final GeneratedColumn<int> actualSeconds = GeneratedColumn<int>(
      'actual_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cyclesMeta = const VerificationMeta('cycles');
  @override
  late final GeneratedColumn<int> cycles = GeneratedColumn<int>(
      'cycles', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _completedCyclesMeta =
      const VerificationMeta('completedCycles');
  @override
  late final GeneratedColumn<int> completedCycles = GeneratedColumn<int>(
      'completed_cycles', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _interruptionsMeta =
      const VerificationMeta('interruptions');
  @override
  late final GeneratedColumn<int> interruptions = GeneratedColumn<int>(
      'interruptions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _blockedAttemptsMeta =
      const VerificationMeta('blockedAttempts');
  @override
  late final GeneratedColumn<int> blockedAttempts = GeneratedColumn<int>(
      'blocked_attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        task,
        startedAt,
        endedAt,
        plannedSeconds,
        actualSeconds,
        status,
        cycles,
        completedCycles,
        interruptions,
        blockedAttempts,
        score
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<FocusSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task')) {
      context.handle(
          _taskMeta, task.isAcceptableOrUnknown(data['task']!, _taskMeta));
    } else if (isInserting) {
      context.missing(_taskMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(_endedAtMeta,
          endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta));
    }
    if (data.containsKey('planned_seconds')) {
      context.handle(
          _plannedSecondsMeta,
          plannedSeconds.isAcceptableOrUnknown(
              data['planned_seconds']!, _plannedSecondsMeta));
    } else if (isInserting) {
      context.missing(_plannedSecondsMeta);
    }
    if (data.containsKey('actual_seconds')) {
      context.handle(
          _actualSecondsMeta,
          actualSeconds.isAcceptableOrUnknown(
              data['actual_seconds']!, _actualSecondsMeta));
    } else if (isInserting) {
      context.missing(_actualSecondsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('cycles')) {
      context.handle(_cyclesMeta,
          cycles.isAcceptableOrUnknown(data['cycles']!, _cyclesMeta));
    } else if (isInserting) {
      context.missing(_cyclesMeta);
    }
    if (data.containsKey('completed_cycles')) {
      context.handle(
          _completedCyclesMeta,
          completedCycles.isAcceptableOrUnknown(
              data['completed_cycles']!, _completedCyclesMeta));
    }
    if (data.containsKey('interruptions')) {
      context.handle(
          _interruptionsMeta,
          interruptions.isAcceptableOrUnknown(
              data['interruptions']!, _interruptionsMeta));
    }
    if (data.containsKey('blocked_attempts')) {
      context.handle(
          _blockedAttemptsMeta,
          blockedAttempts.isAcceptableOrUnknown(
              data['blocked_attempts']!, _blockedAttemptsMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      task: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
      plannedSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}planned_seconds'])!,
      actualSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}actual_seconds'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      cycles: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cycles'])!,
      completedCycles: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_cycles'])!,
      interruptions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interruptions'])!,
      blockedAttempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}blocked_attempts'])!,
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score'])!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final int id;
  final String task;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int plannedSeconds;
  final int actualSeconds;
  final String status;
  final int cycles;
  final int completedCycles;
  final int interruptions;
  final int blockedAttempts;
  final int score;
  const FocusSession(
      {required this.id,
      required this.task,
      required this.startedAt,
      this.endedAt,
      required this.plannedSeconds,
      required this.actualSeconds,
      required this.status,
      required this.cycles,
      required this.completedCycles,
      required this.interruptions,
      required this.blockedAttempts,
      required this.score});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task'] = Variable<String>(task);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['planned_seconds'] = Variable<int>(plannedSeconds);
    map['actual_seconds'] = Variable<int>(actualSeconds);
    map['status'] = Variable<String>(status);
    map['cycles'] = Variable<int>(cycles);
    map['completed_cycles'] = Variable<int>(completedCycles);
    map['interruptions'] = Variable<int>(interruptions);
    map['blocked_attempts'] = Variable<int>(blockedAttempts);
    map['score'] = Variable<int>(score);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      task: Value(task),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      plannedSeconds: Value(plannedSeconds),
      actualSeconds: Value(actualSeconds),
      status: Value(status),
      cycles: Value(cycles),
      completedCycles: Value(completedCycles),
      interruptions: Value(interruptions),
      blockedAttempts: Value(blockedAttempts),
      score: Value(score),
    );
  }

  factory FocusSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<int>(json['id']),
      task: serializer.fromJson<String>(json['task']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      plannedSeconds: serializer.fromJson<int>(json['plannedSeconds']),
      actualSeconds: serializer.fromJson<int>(json['actualSeconds']),
      status: serializer.fromJson<String>(json['status']),
      cycles: serializer.fromJson<int>(json['cycles']),
      completedCycles: serializer.fromJson<int>(json['completedCycles']),
      interruptions: serializer.fromJson<int>(json['interruptions']),
      blockedAttempts: serializer.fromJson<int>(json['blockedAttempts']),
      score: serializer.fromJson<int>(json['score']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'task': serializer.toJson<String>(task),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'plannedSeconds': serializer.toJson<int>(plannedSeconds),
      'actualSeconds': serializer.toJson<int>(actualSeconds),
      'status': serializer.toJson<String>(status),
      'cycles': serializer.toJson<int>(cycles),
      'completedCycles': serializer.toJson<int>(completedCycles),
      'interruptions': serializer.toJson<int>(interruptions),
      'blockedAttempts': serializer.toJson<int>(blockedAttempts),
      'score': serializer.toJson<int>(score),
    };
  }

  FocusSession copyWith(
          {int? id,
          String? task,
          DateTime? startedAt,
          Value<DateTime?> endedAt = const Value.absent(),
          int? plannedSeconds,
          int? actualSeconds,
          String? status,
          int? cycles,
          int? completedCycles,
          int? interruptions,
          int? blockedAttempts,
          int? score}) =>
      FocusSession(
        id: id ?? this.id,
        task: task ?? this.task,
        startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt,
        plannedSeconds: plannedSeconds ?? this.plannedSeconds,
        actualSeconds: actualSeconds ?? this.actualSeconds,
        status: status ?? this.status,
        cycles: cycles ?? this.cycles,
        completedCycles: completedCycles ?? this.completedCycles,
        interruptions: interruptions ?? this.interruptions,
        blockedAttempts: blockedAttempts ?? this.blockedAttempts,
        score: score ?? this.score,
      );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      task: data.task.present ? data.task.value : this.task,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      plannedSeconds: data.plannedSeconds.present
          ? data.plannedSeconds.value
          : this.plannedSeconds,
      actualSeconds: data.actualSeconds.present
          ? data.actualSeconds.value
          : this.actualSeconds,
      status: data.status.present ? data.status.value : this.status,
      cycles: data.cycles.present ? data.cycles.value : this.cycles,
      completedCycles: data.completedCycles.present
          ? data.completedCycles.value
          : this.completedCycles,
      interruptions: data.interruptions.present
          ? data.interruptions.value
          : this.interruptions,
      blockedAttempts: data.blockedAttempts.present
          ? data.blockedAttempts.value
          : this.blockedAttempts,
      score: data.score.present ? data.score.value : this.score,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('task: $task, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('actualSeconds: $actualSeconds, ')
          ..write('status: $status, ')
          ..write('cycles: $cycles, ')
          ..write('completedCycles: $completedCycles, ')
          ..write('interruptions: $interruptions, ')
          ..write('blockedAttempts: $blockedAttempts, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      task,
      startedAt,
      endedAt,
      plannedSeconds,
      actualSeconds,
      status,
      cycles,
      completedCycles,
      interruptions,
      blockedAttempts,
      score);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.task == this.task &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.plannedSeconds == this.plannedSeconds &&
          other.actualSeconds == this.actualSeconds &&
          other.status == this.status &&
          other.cycles == this.cycles &&
          other.completedCycles == this.completedCycles &&
          other.interruptions == this.interruptions &&
          other.blockedAttempts == this.blockedAttempts &&
          other.score == this.score);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<int> id;
  final Value<String> task;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> plannedSeconds;
  final Value<int> actualSeconds;
  final Value<String> status;
  final Value<int> cycles;
  final Value<int> completedCycles;
  final Value<int> interruptions;
  final Value<int> blockedAttempts;
  final Value<int> score;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.task = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.plannedSeconds = const Value.absent(),
    this.actualSeconds = const Value.absent(),
    this.status = const Value.absent(),
    this.cycles = const Value.absent(),
    this.completedCycles = const Value.absent(),
    this.interruptions = const Value.absent(),
    this.blockedAttempts = const Value.absent(),
    this.score = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String task,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required int plannedSeconds,
    required int actualSeconds,
    required String status,
    required int cycles,
    this.completedCycles = const Value.absent(),
    this.interruptions = const Value.absent(),
    this.blockedAttempts = const Value.absent(),
    this.score = const Value.absent(),
  })  : task = Value(task),
        startedAt = Value(startedAt),
        plannedSeconds = Value(plannedSeconds),
        actualSeconds = Value(actualSeconds),
        status = Value(status),
        cycles = Value(cycles);
  static Insertable<FocusSession> custom({
    Expression<int>? id,
    Expression<String>? task,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? plannedSeconds,
    Expression<int>? actualSeconds,
    Expression<String>? status,
    Expression<int>? cycles,
    Expression<int>? completedCycles,
    Expression<int>? interruptions,
    Expression<int>? blockedAttempts,
    Expression<int>? score,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (task != null) 'task': task,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (plannedSeconds != null) 'planned_seconds': plannedSeconds,
      if (actualSeconds != null) 'actual_seconds': actualSeconds,
      if (status != null) 'status': status,
      if (cycles != null) 'cycles': cycles,
      if (completedCycles != null) 'completed_cycles': completedCycles,
      if (interruptions != null) 'interruptions': interruptions,
      if (blockedAttempts != null) 'blocked_attempts': blockedAttempts,
      if (score != null) 'score': score,
    });
  }

  FocusSessionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? task,
      Value<DateTime>? startedAt,
      Value<DateTime?>? endedAt,
      Value<int>? plannedSeconds,
      Value<int>? actualSeconds,
      Value<String>? status,
      Value<int>? cycles,
      Value<int>? completedCycles,
      Value<int>? interruptions,
      Value<int>? blockedAttempts,
      Value<int>? score}) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      task: task ?? this.task,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedSeconds: plannedSeconds ?? this.plannedSeconds,
      actualSeconds: actualSeconds ?? this.actualSeconds,
      status: status ?? this.status,
      cycles: cycles ?? this.cycles,
      completedCycles: completedCycles ?? this.completedCycles,
      interruptions: interruptions ?? this.interruptions,
      blockedAttempts: blockedAttempts ?? this.blockedAttempts,
      score: score ?? this.score,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (task.present) {
      map['task'] = Variable<String>(task.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (plannedSeconds.present) {
      map['planned_seconds'] = Variable<int>(plannedSeconds.value);
    }
    if (actualSeconds.present) {
      map['actual_seconds'] = Variable<int>(actualSeconds.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (cycles.present) {
      map['cycles'] = Variable<int>(cycles.value);
    }
    if (completedCycles.present) {
      map['completed_cycles'] = Variable<int>(completedCycles.value);
    }
    if (interruptions.present) {
      map['interruptions'] = Variable<int>(interruptions.value);
    }
    if (blockedAttempts.present) {
      map['blocked_attempts'] = Variable<int>(blockedAttempts.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('task: $task, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedSeconds: $plannedSeconds, ')
          ..write('actualSeconds: $actualSeconds, ')
          ..write('status: $status, ')
          ..write('cycles: $cycles, ')
          ..write('completedCycles: $completedCycles, ')
          ..write('interruptions: $interruptions, ')
          ..write('blockedAttempts: $blockedAttempts, ')
          ..write('score: $score')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [focusSessions];
}

typedef $$FocusSessionsTableCreateCompanionBuilder = FocusSessionsCompanion
    Function({
  Value<int> id,
  required String task,
  required DateTime startedAt,
  Value<DateTime?> endedAt,
  required int plannedSeconds,
  required int actualSeconds,
  required String status,
  required int cycles,
  Value<int> completedCycles,
  Value<int> interruptions,
  Value<int> blockedAttempts,
  Value<int> score,
});
typedef $$FocusSessionsTableUpdateCompanionBuilder = FocusSessionsCompanion
    Function({
  Value<int> id,
  Value<String> task,
  Value<DateTime> startedAt,
  Value<DateTime?> endedAt,
  Value<int> plannedSeconds,
  Value<int> actualSeconds,
  Value<String> status,
  Value<int> cycles,
  Value<int> completedCycles,
  Value<int> interruptions,
  Value<int> blockedAttempts,
  Value<int> score,
});

class $$FocusSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FocusSessionsTable,
    FocusSession,
    $$FocusSessionsTableFilterComposer,
    $$FocusSessionsTableOrderingComposer,
    $$FocusSessionsTableCreateCompanionBuilder,
    $$FocusSessionsTableUpdateCompanionBuilder> {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FocusSessionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FocusSessionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> task = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> endedAt = const Value.absent(),
            Value<int> plannedSeconds = const Value.absent(),
            Value<int> actualSeconds = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> cycles = const Value.absent(),
            Value<int> completedCycles = const Value.absent(),
            Value<int> interruptions = const Value.absent(),
            Value<int> blockedAttempts = const Value.absent(),
            Value<int> score = const Value.absent(),
          }) =>
              FocusSessionsCompanion(
            id: id,
            task: task,
            startedAt: startedAt,
            endedAt: endedAt,
            plannedSeconds: plannedSeconds,
            actualSeconds: actualSeconds,
            status: status,
            cycles: cycles,
            completedCycles: completedCycles,
            interruptions: interruptions,
            blockedAttempts: blockedAttempts,
            score: score,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String task,
            required DateTime startedAt,
            Value<DateTime?> endedAt = const Value.absent(),
            required int plannedSeconds,
            required int actualSeconds,
            required String status,
            required int cycles,
            Value<int> completedCycles = const Value.absent(),
            Value<int> interruptions = const Value.absent(),
            Value<int> blockedAttempts = const Value.absent(),
            Value<int> score = const Value.absent(),
          }) =>
              FocusSessionsCompanion.insert(
            id: id,
            task: task,
            startedAt: startedAt,
            endedAt: endedAt,
            plannedSeconds: plannedSeconds,
            actualSeconds: actualSeconds,
            status: status,
            cycles: cycles,
            completedCycles: completedCycles,
            interruptions: interruptions,
            blockedAttempts: blockedAttempts,
            score: score,
          ),
        ));
}

class $$FocusSessionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get task => $state.composableBuilder(
      column: $state.table.task,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get endedAt => $state.composableBuilder(
      column: $state.table.endedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get plannedSeconds => $state.composableBuilder(
      column: $state.table.plannedSeconds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get actualSeconds => $state.composableBuilder(
      column: $state.table.actualSeconds,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get cycles => $state.composableBuilder(
      column: $state.table.cycles,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get completedCycles => $state.composableBuilder(
      column: $state.table.completedCycles,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get interruptions => $state.composableBuilder(
      column: $state.table.interruptions,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get blockedAttempts => $state.composableBuilder(
      column: $state.table.blockedAttempts,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get score => $state.composableBuilder(
      column: $state.table.score,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$FocusSessionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get task => $state.composableBuilder(
      column: $state.table.task,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get endedAt => $state.composableBuilder(
      column: $state.table.endedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get plannedSeconds => $state.composableBuilder(
      column: $state.table.plannedSeconds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get actualSeconds => $state.composableBuilder(
      column: $state.table.actualSeconds,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get status => $state.composableBuilder(
      column: $state.table.status,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get cycles => $state.composableBuilder(
      column: $state.table.cycles,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get completedCycles => $state.composableBuilder(
      column: $state.table.completedCycles,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get interruptions => $state.composableBuilder(
      column: $state.table.interruptions,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get blockedAttempts => $state.composableBuilder(
      column: $state.table.blockedAttempts,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get score => $state.composableBuilder(
      column: $state.table.score,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
}
