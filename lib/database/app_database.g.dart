// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sourceLanguageMeta = const VerificationMeta(
    'sourceLanguage',
  );
  @override
  late final GeneratedColumn<String> sourceLanguage = GeneratedColumn<String>(
    'source_language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetLanguageMeta = const VerificationMeta(
    'targetLanguage',
  );
  @override
  late final GeneratedColumn<String> targetLanguage = GeneratedColumn<String>(
    'target_language',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uuid,
    createdAt,
    durationSeconds,
    sourceLanguage,
    targetLanguage,
    title,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('source_language')) {
      context.handle(
        _sourceLanguageMeta,
        sourceLanguage.isAcceptableOrUnknown(
          data['source_language']!,
          _sourceLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceLanguageMeta);
    }
    if (data.containsKey('target_language')) {
      context.handle(
        _targetLanguageMeta,
        targetLanguage.isAcceptableOrUnknown(
          data['target_language']!,
          _targetLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetLanguageMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      sourceLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_language'],
      )!,
      targetLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_language'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final String uuid;
  final DateTime createdAt;
  final int durationSeconds;
  final String sourceLanguage;
  final String targetLanguage;
  final String? title;
  const Session({
    required this.id,
    required this.uuid,
    required this.createdAt,
    required this.durationSeconds,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.title,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['source_language'] = Variable<String>(sourceLanguage);
    map['target_language'] = Variable<String>(targetLanguage);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      createdAt: Value(createdAt),
      durationSeconds: Value(durationSeconds),
      sourceLanguage: Value(sourceLanguage),
      targetLanguage: Value(targetLanguage),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      sourceLanguage: serializer.fromJson<String>(json['sourceLanguage']),
      targetLanguage: serializer.fromJson<String>(json['targetLanguage']),
      title: serializer.fromJson<String?>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'sourceLanguage': serializer.toJson<String>(sourceLanguage),
      'targetLanguage': serializer.toJson<String>(targetLanguage),
      'title': serializer.toJson<String?>(title),
    };
  }

  Session copyWith({
    int? id,
    String? uuid,
    DateTime? createdAt,
    int? durationSeconds,
    String? sourceLanguage,
    String? targetLanguage,
    Value<String?> title = const Value.absent(),
  }) => Session(
    id: id ?? this.id,
    uuid: uuid ?? this.uuid,
    createdAt: createdAt ?? this.createdAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    sourceLanguage: sourceLanguage ?? this.sourceLanguage,
    targetLanguage: targetLanguage ?? this.targetLanguage,
    title: title.present ? title.value : this.title,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      sourceLanguage: data.sourceLanguage.present
          ? data.sourceLanguage.value
          : this.sourceLanguage,
      targetLanguage: data.targetLanguage.present
          ? data.targetLanguage.value
          : this.targetLanguage,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('createdAt: $createdAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    uuid,
    createdAt,
    durationSeconds,
    sourceLanguage,
    targetLanguage,
    title,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.createdAt == this.createdAt &&
          other.durationSeconds == this.durationSeconds &&
          other.sourceLanguage == this.sourceLanguage &&
          other.targetLanguage == this.targetLanguage &&
          other.title == this.title);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<DateTime> createdAt;
  final Value<int> durationSeconds;
  final Value<String> sourceLanguage;
  final Value<String> targetLanguage;
  final Value<String?> title;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.sourceLanguage = const Value.absent(),
    this.targetLanguage = const Value.absent(),
    this.title = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required DateTime createdAt,
    this.durationSeconds = const Value.absent(),
    required String sourceLanguage,
    required String targetLanguage,
    this.title = const Value.absent(),
  }) : uuid = Value(uuid),
       createdAt = Value(createdAt),
       sourceLanguage = Value(sourceLanguage),
       targetLanguage = Value(targetLanguage);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<DateTime>? createdAt,
    Expression<int>? durationSeconds,
    Expression<String>? sourceLanguage,
    Expression<String>? targetLanguage,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (createdAt != null) 'created_at': createdAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (sourceLanguage != null) 'source_language': sourceLanguage,
      if (targetLanguage != null) 'target_language': targetLanguage,
      if (title != null) 'title': title,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? uuid,
    Value<DateTime>? createdAt,
    Value<int>? durationSeconds,
    Value<String>? sourceLanguage,
    Value<String>? targetLanguage,
    Value<String?>? title,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (sourceLanguage.present) {
      map['source_language'] = Variable<String>(sourceLanguage.value);
    }
    if (targetLanguage.present) {
      map['target_language'] = Variable<String>(targetLanguage.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('createdAt: $createdAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('sourceLanguage: $sourceLanguage, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $SubtitleEntriesTable extends SubtitleEntries
    with TableInfo<$SubtitleEntriesTable, SubtitleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubtitleEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionUuidMeta = const VerificationMeta(
    'sessionUuid',
  );
  @override
  late final GeneratedColumn<String> sessionUuid = GeneratedColumn<String>(
    'session_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalTextMeta = const VerificationMeta(
    'originalText',
  );
  @override
  late final GeneratedColumn<String> originalText = GeneratedColumn<String>(
    'original_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translatedTextMeta = const VerificationMeta(
    'translatedText',
  );
  @override
  late final GeneratedColumn<String> translatedText = GeneratedColumn<String>(
    'translated_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chunkIndexMeta = const VerificationMeta(
    'chunkIndex',
  );
  @override
  late final GeneratedColumn<int> chunkIndex = GeneratedColumn<int>(
    'chunk_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionUuid,
    originalText,
    translatedText,
    timestamp,
    chunkIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subtitle_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubtitleEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_uuid')) {
      context.handle(
        _sessionUuidMeta,
        sessionUuid.isAcceptableOrUnknown(
          data['session_uuid']!,
          _sessionUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionUuidMeta);
    }
    if (data.containsKey('original_text')) {
      context.handle(
        _originalTextMeta,
        originalText.isAcceptableOrUnknown(
          data['original_text']!,
          _originalTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalTextMeta);
    }
    if (data.containsKey('translated_text')) {
      context.handle(
        _translatedTextMeta,
        translatedText.isAcceptableOrUnknown(
          data['translated_text']!,
          _translatedTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translatedTextMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('chunk_index')) {
      context.handle(
        _chunkIndexMeta,
        chunkIndex.isAcceptableOrUnknown(data['chunk_index']!, _chunkIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_chunkIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubtitleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubtitleEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_uuid'],
      )!,
      originalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_text'],
      )!,
      translatedText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translated_text'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      chunkIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chunk_index'],
      )!,
    );
  }

  @override
  $SubtitleEntriesTable createAlias(String alias) {
    return $SubtitleEntriesTable(attachedDatabase, alias);
  }
}

class SubtitleEntry extends DataClass implements Insertable<SubtitleEntry> {
  final int id;
  final String sessionUuid;
  final String originalText;
  final String translatedText;
  final DateTime timestamp;
  final int chunkIndex;
  const SubtitleEntry({
    required this.id,
    required this.sessionUuid,
    required this.originalText,
    required this.translatedText,
    required this.timestamp,
    required this.chunkIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_uuid'] = Variable<String>(sessionUuid);
    map['original_text'] = Variable<String>(originalText);
    map['translated_text'] = Variable<String>(translatedText);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['chunk_index'] = Variable<int>(chunkIndex);
    return map;
  }

  SubtitleEntriesCompanion toCompanion(bool nullToAbsent) {
    return SubtitleEntriesCompanion(
      id: Value(id),
      sessionUuid: Value(sessionUuid),
      originalText: Value(originalText),
      translatedText: Value(translatedText),
      timestamp: Value(timestamp),
      chunkIndex: Value(chunkIndex),
    );
  }

  factory SubtitleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubtitleEntry(
      id: serializer.fromJson<int>(json['id']),
      sessionUuid: serializer.fromJson<String>(json['sessionUuid']),
      originalText: serializer.fromJson<String>(json['originalText']),
      translatedText: serializer.fromJson<String>(json['translatedText']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      chunkIndex: serializer.fromJson<int>(json['chunkIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionUuid': serializer.toJson<String>(sessionUuid),
      'originalText': serializer.toJson<String>(originalText),
      'translatedText': serializer.toJson<String>(translatedText),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'chunkIndex': serializer.toJson<int>(chunkIndex),
    };
  }

  SubtitleEntry copyWith({
    int? id,
    String? sessionUuid,
    String? originalText,
    String? translatedText,
    DateTime? timestamp,
    int? chunkIndex,
  }) => SubtitleEntry(
    id: id ?? this.id,
    sessionUuid: sessionUuid ?? this.sessionUuid,
    originalText: originalText ?? this.originalText,
    translatedText: translatedText ?? this.translatedText,
    timestamp: timestamp ?? this.timestamp,
    chunkIndex: chunkIndex ?? this.chunkIndex,
  );
  SubtitleEntry copyWithCompanion(SubtitleEntriesCompanion data) {
    return SubtitleEntry(
      id: data.id.present ? data.id.value : this.id,
      sessionUuid: data.sessionUuid.present
          ? data.sessionUuid.value
          : this.sessionUuid,
      originalText: data.originalText.present
          ? data.originalText.value
          : this.originalText,
      translatedText: data.translatedText.present
          ? data.translatedText.value
          : this.translatedText,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      chunkIndex: data.chunkIndex.present
          ? data.chunkIndex.value
          : this.chunkIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubtitleEntry(')
          ..write('id: $id, ')
          ..write('sessionUuid: $sessionUuid, ')
          ..write('originalText: $originalText, ')
          ..write('translatedText: $translatedText, ')
          ..write('timestamp: $timestamp, ')
          ..write('chunkIndex: $chunkIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionUuid,
    originalText,
    translatedText,
    timestamp,
    chunkIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubtitleEntry &&
          other.id == this.id &&
          other.sessionUuid == this.sessionUuid &&
          other.originalText == this.originalText &&
          other.translatedText == this.translatedText &&
          other.timestamp == this.timestamp &&
          other.chunkIndex == this.chunkIndex);
}

class SubtitleEntriesCompanion extends UpdateCompanion<SubtitleEntry> {
  final Value<int> id;
  final Value<String> sessionUuid;
  final Value<String> originalText;
  final Value<String> translatedText;
  final Value<DateTime> timestamp;
  final Value<int> chunkIndex;
  const SubtitleEntriesCompanion({
    this.id = const Value.absent(),
    this.sessionUuid = const Value.absent(),
    this.originalText = const Value.absent(),
    this.translatedText = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.chunkIndex = const Value.absent(),
  });
  SubtitleEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String sessionUuid,
    required String originalText,
    required String translatedText,
    required DateTime timestamp,
    required int chunkIndex,
  }) : sessionUuid = Value(sessionUuid),
       originalText = Value(originalText),
       translatedText = Value(translatedText),
       timestamp = Value(timestamp),
       chunkIndex = Value(chunkIndex);
  static Insertable<SubtitleEntry> custom({
    Expression<int>? id,
    Expression<String>? sessionUuid,
    Expression<String>? originalText,
    Expression<String>? translatedText,
    Expression<DateTime>? timestamp,
    Expression<int>? chunkIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionUuid != null) 'session_uuid': sessionUuid,
      if (originalText != null) 'original_text': originalText,
      if (translatedText != null) 'translated_text': translatedText,
      if (timestamp != null) 'timestamp': timestamp,
      if (chunkIndex != null) 'chunk_index': chunkIndex,
    });
  }

  SubtitleEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? sessionUuid,
    Value<String>? originalText,
    Value<String>? translatedText,
    Value<DateTime>? timestamp,
    Value<int>? chunkIndex,
  }) {
    return SubtitleEntriesCompanion(
      id: id ?? this.id,
      sessionUuid: sessionUuid ?? this.sessionUuid,
      originalText: originalText ?? this.originalText,
      translatedText: translatedText ?? this.translatedText,
      timestamp: timestamp ?? this.timestamp,
      chunkIndex: chunkIndex ?? this.chunkIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionUuid.present) {
      map['session_uuid'] = Variable<String>(sessionUuid.value);
    }
    if (originalText.present) {
      map['original_text'] = Variable<String>(originalText.value);
    }
    if (translatedText.present) {
      map['translated_text'] = Variable<String>(translatedText.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (chunkIndex.present) {
      map['chunk_index'] = Variable<int>(chunkIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubtitleEntriesCompanion(')
          ..write('id: $id, ')
          ..write('sessionUuid: $sessionUuid, ')
          ..write('originalText: $originalText, ')
          ..write('translatedText: $translatedText, ')
          ..write('timestamp: $timestamp, ')
          ..write('chunkIndex: $chunkIndex')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $SubtitleEntriesTable subtitleEntries = $SubtitleEntriesTable(
    this,
  );
  late final SessionsDao sessionsDao = SessionsDao(this as AppDatabase);
  late final EntriesDao entriesDao = EntriesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sessions,
    subtitleEntries,
  ];
}

typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required String uuid,
      required DateTime createdAt,
      Value<int> durationSeconds,
      required String sourceLanguage,
      required String targetLanguage,
      Value<String?> title,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<String> uuid,
      Value<DateTime> createdAt,
      Value<int> durationSeconds,
      Value<String> sourceLanguage,
      Value<String> targetLanguage,
      Value<String?> title,
    });

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
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

  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
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

  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceLanguage => $composableBuilder(
    column: $table.sourceLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
          Session,
          PrefetchHooks Function()
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uuid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<String> sourceLanguage = const Value.absent(),
                Value<String> targetLanguage = const Value.absent(),
                Value<String?> title = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                uuid: uuid,
                createdAt: createdAt,
                durationSeconds: durationSeconds,
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage,
                title: title,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uuid,
                required DateTime createdAt,
                Value<int> durationSeconds = const Value.absent(),
                required String sourceLanguage,
                required String targetLanguage,
                Value<String?> title = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                uuid: uuid,
                createdAt: createdAt,
                durationSeconds: durationSeconds,
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage,
                title: title,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, BaseReferences<_$AppDatabase, $SessionsTable, Session>),
      Session,
      PrefetchHooks Function()
    >;
typedef $$SubtitleEntriesTableCreateCompanionBuilder =
    SubtitleEntriesCompanion Function({
      Value<int> id,
      required String sessionUuid,
      required String originalText,
      required String translatedText,
      required DateTime timestamp,
      required int chunkIndex,
    });
typedef $$SubtitleEntriesTableUpdateCompanionBuilder =
    SubtitleEntriesCompanion Function({
      Value<int> id,
      Value<String> sessionUuid,
      Value<String> originalText,
      Value<String> translatedText,
      Value<DateTime> timestamp,
      Value<int> chunkIndex,
    });

class $$SubtitleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SubtitleEntriesTable> {
  $$SubtitleEntriesTableFilterComposer({
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

  ColumnFilters<String> get sessionUuid => $composableBuilder(
    column: $table.sessionUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translatedText => $composableBuilder(
    column: $table.translatedText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chunkIndex => $composableBuilder(
    column: $table.chunkIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SubtitleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubtitleEntriesTable> {
  $$SubtitleEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get sessionUuid => $composableBuilder(
    column: $table.sessionUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translatedText => $composableBuilder(
    column: $table.translatedText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chunkIndex => $composableBuilder(
    column: $table.chunkIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubtitleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubtitleEntriesTable> {
  $$SubtitleEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionUuid => $composableBuilder(
    column: $table.sessionUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalText => $composableBuilder(
    column: $table.originalText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translatedText => $composableBuilder(
    column: $table.translatedText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get chunkIndex => $composableBuilder(
    column: $table.chunkIndex,
    builder: (column) => column,
  );
}

class $$SubtitleEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubtitleEntriesTable,
          SubtitleEntry,
          $$SubtitleEntriesTableFilterComposer,
          $$SubtitleEntriesTableOrderingComposer,
          $$SubtitleEntriesTableAnnotationComposer,
          $$SubtitleEntriesTableCreateCompanionBuilder,
          $$SubtitleEntriesTableUpdateCompanionBuilder,
          (
            SubtitleEntry,
            BaseReferences<_$AppDatabase, $SubtitleEntriesTable, SubtitleEntry>,
          ),
          SubtitleEntry,
          PrefetchHooks Function()
        > {
  $$SubtitleEntriesTableTableManager(
    _$AppDatabase db,
    $SubtitleEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubtitleEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubtitleEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubtitleEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sessionUuid = const Value.absent(),
                Value<String> originalText = const Value.absent(),
                Value<String> translatedText = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> chunkIndex = const Value.absent(),
              }) => SubtitleEntriesCompanion(
                id: id,
                sessionUuid: sessionUuid,
                originalText: originalText,
                translatedText: translatedText,
                timestamp: timestamp,
                chunkIndex: chunkIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sessionUuid,
                required String originalText,
                required String translatedText,
                required DateTime timestamp,
                required int chunkIndex,
              }) => SubtitleEntriesCompanion.insert(
                id: id,
                sessionUuid: sessionUuid,
                originalText: originalText,
                translatedText: translatedText,
                timestamp: timestamp,
                chunkIndex: chunkIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SubtitleEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubtitleEntriesTable,
      SubtitleEntry,
      $$SubtitleEntriesTableFilterComposer,
      $$SubtitleEntriesTableOrderingComposer,
      $$SubtitleEntriesTableAnnotationComposer,
      $$SubtitleEntriesTableCreateCompanionBuilder,
      $$SubtitleEntriesTableUpdateCompanionBuilder,
      (
        SubtitleEntry,
        BaseReferences<_$AppDatabase, $SubtitleEntriesTable, SubtitleEntry>,
      ),
      SubtitleEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$SubtitleEntriesTableTableManager get subtitleEntries =>
      $$SubtitleEntriesTableTableManager(_db, _db.subtitleEntries);
}
