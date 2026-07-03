// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SesionClienteTable extends SesionCliente
    with TableInfo<$SesionClienteTable, SesionClienteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SesionClienteTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionTokenMeta = const VerificationMeta(
    'sessionToken',
  );
  @override
  late final GeneratedColumn<String> sessionToken = GeneratedColumn<String>(
    'session_token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreDisplayMeta = const VerificationMeta(
    'nombreDisplay',
  );
  @override
  late final GeneratedColumn<String> nombreDisplay = GeneratedColumn<String>(
    'nombre_display',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Guest'),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _esInvitadoMeta = const VerificationMeta(
    'esInvitado',
  );
  @override
  late final GeneratedColumn<bool> esInvitado = GeneratedColumn<bool>(
    'es_invitado',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_invitado" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _expiraEnMeta = const VerificationMeta(
    'expiraEn',
  );
  @override
  late final GeneratedColumn<DateTime> expiraEn = GeneratedColumn<DateTime>(
    'expira_en',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionToken,
    nombreDisplay,
    email,
    clienteId,
    esInvitado,
    creadoEn,
    expiraEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sesion_cliente';
  @override
  VerificationContext validateIntegrity(
    Insertable<SesionClienteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_token')) {
      context.handle(
        _sessionTokenMeta,
        sessionToken.isAcceptableOrUnknown(
          data['session_token']!,
          _sessionTokenMeta,
        ),
      );
    }
    if (data.containsKey('nombre_display')) {
      context.handle(
        _nombreDisplayMeta,
        nombreDisplay.isAcceptableOrUnknown(
          data['nombre_display']!,
          _nombreDisplayMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    }
    if (data.containsKey('es_invitado')) {
      context.handle(
        _esInvitadoMeta,
        esInvitado.isAcceptableOrUnknown(data['es_invitado']!, _esInvitadoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    if (data.containsKey('expira_en')) {
      context.handle(
        _expiraEnMeta,
        expiraEn.isAcceptableOrUnknown(data['expira_en']!, _expiraEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SesionClienteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SesionClienteData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sessionToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_token'],
      ),
      nombreDisplay:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nombre_display'],
          )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      ),
      esInvitado:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}es_invitado'],
          )!,
      creadoEn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}creado_en'],
          )!,
      expiraEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expira_en'],
      ),
    );
  }

  @override
  $SesionClienteTable createAlias(String alias) {
    return $SesionClienteTable(attachedDatabase, alias);
  }
}

class SesionClienteData extends DataClass
    implements Insertable<SesionClienteData> {
  final int id;
  final String? sessionToken;
  final String nombreDisplay;
  final String? email;
  final int? clienteId;
  final bool esInvitado;
  final DateTime creadoEn;
  final DateTime? expiraEn;
  const SesionClienteData({
    required this.id,
    this.sessionToken,
    required this.nombreDisplay,
    this.email,
    this.clienteId,
    required this.esInvitado,
    required this.creadoEn,
    this.expiraEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sessionToken != null) {
      map['session_token'] = Variable<String>(sessionToken);
    }
    map['nombre_display'] = Variable<String>(nombreDisplay);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || clienteId != null) {
      map['cliente_id'] = Variable<int>(clienteId);
    }
    map['es_invitado'] = Variable<bool>(esInvitado);
    map['creado_en'] = Variable<DateTime>(creadoEn);
    if (!nullToAbsent || expiraEn != null) {
      map['expira_en'] = Variable<DateTime>(expiraEn);
    }
    return map;
  }

  SesionClienteCompanion toCompanion(bool nullToAbsent) {
    return SesionClienteCompanion(
      id: Value(id),
      sessionToken:
          sessionToken == null && nullToAbsent
              ? const Value.absent()
              : Value(sessionToken),
      nombreDisplay: Value(nombreDisplay),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      clienteId:
          clienteId == null && nullToAbsent
              ? const Value.absent()
              : Value(clienteId),
      esInvitado: Value(esInvitado),
      creadoEn: Value(creadoEn),
      expiraEn:
          expiraEn == null && nullToAbsent
              ? const Value.absent()
              : Value(expiraEn),
    );
  }

  factory SesionClienteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SesionClienteData(
      id: serializer.fromJson<int>(json['id']),
      sessionToken: serializer.fromJson<String?>(json['sessionToken']),
      nombreDisplay: serializer.fromJson<String>(json['nombreDisplay']),
      email: serializer.fromJson<String?>(json['email']),
      clienteId: serializer.fromJson<int?>(json['clienteId']),
      esInvitado: serializer.fromJson<bool>(json['esInvitado']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
      expiraEn: serializer.fromJson<DateTime?>(json['expiraEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionToken': serializer.toJson<String?>(sessionToken),
      'nombreDisplay': serializer.toJson<String>(nombreDisplay),
      'email': serializer.toJson<String?>(email),
      'clienteId': serializer.toJson<int?>(clienteId),
      'esInvitado': serializer.toJson<bool>(esInvitado),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
      'expiraEn': serializer.toJson<DateTime?>(expiraEn),
    };
  }

  SesionClienteData copyWith({
    int? id,
    Value<String?> sessionToken = const Value.absent(),
    String? nombreDisplay,
    Value<String?> email = const Value.absent(),
    Value<int?> clienteId = const Value.absent(),
    bool? esInvitado,
    DateTime? creadoEn,
    Value<DateTime?> expiraEn = const Value.absent(),
  }) => SesionClienteData(
    id: id ?? this.id,
    sessionToken: sessionToken.present ? sessionToken.value : this.sessionToken,
    nombreDisplay: nombreDisplay ?? this.nombreDisplay,
    email: email.present ? email.value : this.email,
    clienteId: clienteId.present ? clienteId.value : this.clienteId,
    esInvitado: esInvitado ?? this.esInvitado,
    creadoEn: creadoEn ?? this.creadoEn,
    expiraEn: expiraEn.present ? expiraEn.value : this.expiraEn,
  );
  SesionClienteData copyWithCompanion(SesionClienteCompanion data) {
    return SesionClienteData(
      id: data.id.present ? data.id.value : this.id,
      sessionToken:
          data.sessionToken.present
              ? data.sessionToken.value
              : this.sessionToken,
      nombreDisplay:
          data.nombreDisplay.present
              ? data.nombreDisplay.value
              : this.nombreDisplay,
      email: data.email.present ? data.email.value : this.email,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      esInvitado:
          data.esInvitado.present ? data.esInvitado.value : this.esInvitado,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
      expiraEn: data.expiraEn.present ? data.expiraEn.value : this.expiraEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SesionClienteData(')
          ..write('id: $id, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('nombreDisplay: $nombreDisplay, ')
          ..write('email: $email, ')
          ..write('clienteId: $clienteId, ')
          ..write('esInvitado: $esInvitado, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('expiraEn: $expiraEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionToken,
    nombreDisplay,
    email,
    clienteId,
    esInvitado,
    creadoEn,
    expiraEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SesionClienteData &&
          other.id == this.id &&
          other.sessionToken == this.sessionToken &&
          other.nombreDisplay == this.nombreDisplay &&
          other.email == this.email &&
          other.clienteId == this.clienteId &&
          other.esInvitado == this.esInvitado &&
          other.creadoEn == this.creadoEn &&
          other.expiraEn == this.expiraEn);
}

class SesionClienteCompanion extends UpdateCompanion<SesionClienteData> {
  final Value<int> id;
  final Value<String?> sessionToken;
  final Value<String> nombreDisplay;
  final Value<String?> email;
  final Value<int?> clienteId;
  final Value<bool> esInvitado;
  final Value<DateTime> creadoEn;
  final Value<DateTime?> expiraEn;
  const SesionClienteCompanion({
    this.id = const Value.absent(),
    this.sessionToken = const Value.absent(),
    this.nombreDisplay = const Value.absent(),
    this.email = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.esInvitado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.expiraEn = const Value.absent(),
  });
  SesionClienteCompanion.insert({
    this.id = const Value.absent(),
    this.sessionToken = const Value.absent(),
    this.nombreDisplay = const Value.absent(),
    this.email = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.esInvitado = const Value.absent(),
    this.creadoEn = const Value.absent(),
    this.expiraEn = const Value.absent(),
  });
  static Insertable<SesionClienteData> custom({
    Expression<int>? id,
    Expression<String>? sessionToken,
    Expression<String>? nombreDisplay,
    Expression<String>? email,
    Expression<int>? clienteId,
    Expression<bool>? esInvitado,
    Expression<DateTime>? creadoEn,
    Expression<DateTime>? expiraEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionToken != null) 'session_token': sessionToken,
      if (nombreDisplay != null) 'nombre_display': nombreDisplay,
      if (email != null) 'email': email,
      if (clienteId != null) 'cliente_id': clienteId,
      if (esInvitado != null) 'es_invitado': esInvitado,
      if (creadoEn != null) 'creado_en': creadoEn,
      if (expiraEn != null) 'expira_en': expiraEn,
    });
  }

  SesionClienteCompanion copyWith({
    Value<int>? id,
    Value<String?>? sessionToken,
    Value<String>? nombreDisplay,
    Value<String?>? email,
    Value<int?>? clienteId,
    Value<bool>? esInvitado,
    Value<DateTime>? creadoEn,
    Value<DateTime?>? expiraEn,
  }) {
    return SesionClienteCompanion(
      id: id ?? this.id,
      sessionToken: sessionToken ?? this.sessionToken,
      nombreDisplay: nombreDisplay ?? this.nombreDisplay,
      email: email ?? this.email,
      clienteId: clienteId ?? this.clienteId,
      esInvitado: esInvitado ?? this.esInvitado,
      creadoEn: creadoEn ?? this.creadoEn,
      expiraEn: expiraEn ?? this.expiraEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionToken.present) {
      map['session_token'] = Variable<String>(sessionToken.value);
    }
    if (nombreDisplay.present) {
      map['nombre_display'] = Variable<String>(nombreDisplay.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (esInvitado.present) {
      map['es_invitado'] = Variable<bool>(esInvitado.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    if (expiraEn.present) {
      map['expira_en'] = Variable<DateTime>(expiraEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SesionClienteCompanion(')
          ..write('id: $id, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('nombreDisplay: $nombreDisplay, ')
          ..write('email: $email, ')
          ..write('clienteId: $clienteId, ')
          ..write('esInvitado: $esInvitado, ')
          ..write('creadoEn: $creadoEn, ')
          ..write('expiraEn: $expiraEn')
          ..write(')'))
        .toString();
  }
}

class $CategoriasCacheTable extends CategoriasCache
    with TableInfo<$CategoriasCacheTable, CategoriasCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlImagenIconoMeta = const VerificationMeta(
    'urlImagenIcono',
  );
  @override
  late final GeneratedColumn<String> urlImagenIcono = GeneratedColumn<String>(
    'url_imagen_icono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sincronizadoEnMeta = const VerificationMeta(
    'sincronizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> sincronizadoEn =
      GeneratedColumn<DateTime>(
        'sincronizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    descripcion,
    urlImagenIcono,
    sincronizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriasCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('url_imagen_icono')) {
      context.handle(
        _urlImagenIconoMeta,
        urlImagenIcono.isAcceptableOrUnknown(
          data['url_imagen_icono']!,
          _urlImagenIconoMeta,
        ),
      );
    }
    if (data.containsKey('sincronizado_en')) {
      context.handle(
        _sincronizadoEnMeta,
        sincronizadoEn.isAcceptableOrUnknown(
          data['sincronizado_en']!,
          _sincronizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriasCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriasCacheData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nombre:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nombre'],
          )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      urlImagenIcono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url_imagen_icono'],
      ),
      sincronizadoEn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}sincronizado_en'],
          )!,
    );
  }

  @override
  $CategoriasCacheTable createAlias(String alias) {
    return $CategoriasCacheTable(attachedDatabase, alias);
  }
}

class CategoriasCacheData extends DataClass
    implements Insertable<CategoriasCacheData> {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? urlImagenIcono;
  final DateTime sincronizadoEn;
  const CategoriasCacheData({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.urlImagenIcono,
    required this.sincronizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    if (!nullToAbsent || urlImagenIcono != null) {
      map['url_imagen_icono'] = Variable<String>(urlImagenIcono);
    }
    map['sincronizado_en'] = Variable<DateTime>(sincronizadoEn);
    return map;
  }

  CategoriasCacheCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCacheCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion:
          descripcion == null && nullToAbsent
              ? const Value.absent()
              : Value(descripcion),
      urlImagenIcono:
          urlImagenIcono == null && nullToAbsent
              ? const Value.absent()
              : Value(urlImagenIcono),
      sincronizadoEn: Value(sincronizadoEn),
    );
  }

  factory CategoriasCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriasCacheData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      urlImagenIcono: serializer.fromJson<String?>(json['urlImagenIcono']),
      sincronizadoEn: serializer.fromJson<DateTime>(json['sincronizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'urlImagenIcono': serializer.toJson<String?>(urlImagenIcono),
      'sincronizadoEn': serializer.toJson<DateTime>(sincronizadoEn),
    };
  }

  CategoriasCacheData copyWith({
    int? id,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    Value<String?> urlImagenIcono = const Value.absent(),
    DateTime? sincronizadoEn,
  }) => CategoriasCacheData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    urlImagenIcono:
        urlImagenIcono.present ? urlImagenIcono.value : this.urlImagenIcono,
    sincronizadoEn: sincronizadoEn ?? this.sincronizadoEn,
  );
  CategoriasCacheData copyWithCompanion(CategoriasCacheCompanion data) {
    return CategoriasCacheData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      urlImagenIcono:
          data.urlImagenIcono.present
              ? data.urlImagenIcono.value
              : this.urlImagenIcono,
      sincronizadoEn:
          data.sincronizadoEn.present
              ? data.sincronizadoEn.value
              : this.sincronizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCacheData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('urlImagenIcono: $urlImagenIcono, ')
          ..write('sincronizadoEn: $sincronizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, descripcion, urlImagenIcono, sincronizadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriasCacheData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.urlImagenIcono == this.urlImagenIcono &&
          other.sincronizadoEn == this.sincronizadoEn);
}

class CategoriasCacheCompanion extends UpdateCompanion<CategoriasCacheData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<String?> urlImagenIcono;
  final Value<DateTime> sincronizadoEn;
  const CategoriasCacheCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.urlImagenIcono = const Value.absent(),
    this.sincronizadoEn = const Value.absent(),
  });
  CategoriasCacheCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    this.urlImagenIcono = const Value.absent(),
    this.sincronizadoEn = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<CategoriasCacheData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? urlImagenIcono,
    Expression<DateTime>? sincronizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (urlImagenIcono != null) 'url_imagen_icono': urlImagenIcono,
      if (sincronizadoEn != null) 'sincronizado_en': sincronizadoEn,
    });
  }

  CategoriasCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<String?>? urlImagenIcono,
    Value<DateTime>? sincronizadoEn,
  }) {
    return CategoriasCacheCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      urlImagenIcono: urlImagenIcono ?? this.urlImagenIcono,
      sincronizadoEn: sincronizadoEn ?? this.sincronizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (urlImagenIcono.present) {
      map['url_imagen_icono'] = Variable<String>(urlImagenIcono.value);
    }
    if (sincronizadoEn.present) {
      map['sincronizado_en'] = Variable<DateTime>(sincronizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCacheCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('urlImagenIcono: $urlImagenIcono, ')
          ..write('sincronizadoEn: $sincronizadoEn')
          ..write(')'))
        .toString();
  }
}

class $ProductosCacheTable extends ProductosCache
    with TableInfo<$ProductosCacheTable, ProductosCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductosCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precioBaseMeta = const VerificationMeta(
    'precioBase',
  );
  @override
  late final GeneratedColumn<double> precioBase = GeneratedColumn<double>(
    'precio_base',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tasaImpuestoMeta = const VerificationMeta(
    'tasaImpuesto',
  );
  @override
  late final GeneratedColumn<double> tasaImpuesto = GeneratedColumn<double>(
    'tasa_impuesto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.18),
  );
  static const VerificationMeta _estaDisponibleMeta = const VerificationMeta(
    'estaDisponible',
  );
  @override
  late final GeneratedColumn<bool> estaDisponible = GeneratedColumn<bool>(
    'esta_disponible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("esta_disponible" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _imagenUrlMeta = const VerificationMeta(
    'imagenUrl',
  );
  @override
  late final GeneratedColumn<String> imagenUrl = GeneratedColumn<String>(
    'imagen_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias_cache (id)',
    ),
  );
  static const VerificationMeta _sincronizadoEnMeta = const VerificationMeta(
    'sincronizadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> sincronizadoEn =
      GeneratedColumn<DateTime>(
        'sincronizado_en',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sku,
    nombre,
    descripcion,
    precioBase,
    tasaImpuesto,
    estaDisponible,
    imagenUrl,
    categoriaId,
    sincronizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'productos_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductosCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('precio_base')) {
      context.handle(
        _precioBaseMeta,
        precioBase.isAcceptableOrUnknown(data['precio_base']!, _precioBaseMeta),
      );
    } else if (isInserting) {
      context.missing(_precioBaseMeta);
    }
    if (data.containsKey('tasa_impuesto')) {
      context.handle(
        _tasaImpuestoMeta,
        tasaImpuesto.isAcceptableOrUnknown(
          data['tasa_impuesto']!,
          _tasaImpuestoMeta,
        ),
      );
    }
    if (data.containsKey('esta_disponible')) {
      context.handle(
        _estaDisponibleMeta,
        estaDisponible.isAcceptableOrUnknown(
          data['esta_disponible']!,
          _estaDisponibleMeta,
        ),
      );
    }
    if (data.containsKey('imagen_url')) {
      context.handle(
        _imagenUrlMeta,
        imagenUrl.isAcceptableOrUnknown(data['imagen_url']!, _imagenUrlMeta),
      );
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('sincronizado_en')) {
      context.handle(
        _sincronizadoEnMeta,
        sincronizadoEn.isAcceptableOrUnknown(
          data['sincronizado_en']!,
          _sincronizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductosCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductosCacheData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      ),
      nombre:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nombre'],
          )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      precioBase:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}precio_base'],
          )!,
      tasaImpuesto:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}tasa_impuesto'],
          )!,
      estaDisponible:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}esta_disponible'],
          )!,
      imagenUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}imagen_url'],
      ),
      categoriaId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}categoria_id'],
          )!,
      sincronizadoEn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}sincronizado_en'],
          )!,
    );
  }

  @override
  $ProductosCacheTable createAlias(String alias) {
    return $ProductosCacheTable(attachedDatabase, alias);
  }
}

class ProductosCacheData extends DataClass
    implements Insertable<ProductosCacheData> {
  final int id;
  final String? sku;
  final String nombre;
  final String? descripcion;
  final double precioBase;
  final double tasaImpuesto;
  final bool estaDisponible;
  final String? imagenUrl;
  final int categoriaId;
  final DateTime sincronizadoEn;
  const ProductosCacheData({
    required this.id,
    this.sku,
    required this.nombre,
    this.descripcion,
    required this.precioBase,
    required this.tasaImpuesto,
    required this.estaDisponible,
    this.imagenUrl,
    required this.categoriaId,
    required this.sincronizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['precio_base'] = Variable<double>(precioBase);
    map['tasa_impuesto'] = Variable<double>(tasaImpuesto);
    map['esta_disponible'] = Variable<bool>(estaDisponible);
    if (!nullToAbsent || imagenUrl != null) {
      map['imagen_url'] = Variable<String>(imagenUrl);
    }
    map['categoria_id'] = Variable<int>(categoriaId);
    map['sincronizado_en'] = Variable<DateTime>(sincronizadoEn);
    return map;
  }

  ProductosCacheCompanion toCompanion(bool nullToAbsent) {
    return ProductosCacheCompanion(
      id: Value(id),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      nombre: Value(nombre),
      descripcion:
          descripcion == null && nullToAbsent
              ? const Value.absent()
              : Value(descripcion),
      precioBase: Value(precioBase),
      tasaImpuesto: Value(tasaImpuesto),
      estaDisponible: Value(estaDisponible),
      imagenUrl:
          imagenUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(imagenUrl),
      categoriaId: Value(categoriaId),
      sincronizadoEn: Value(sincronizadoEn),
    );
  }

  factory ProductosCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductosCacheData(
      id: serializer.fromJson<int>(json['id']),
      sku: serializer.fromJson<String?>(json['sku']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      precioBase: serializer.fromJson<double>(json['precioBase']),
      tasaImpuesto: serializer.fromJson<double>(json['tasaImpuesto']),
      estaDisponible: serializer.fromJson<bool>(json['estaDisponible']),
      imagenUrl: serializer.fromJson<String?>(json['imagenUrl']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      sincronizadoEn: serializer.fromJson<DateTime>(json['sincronizadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sku': serializer.toJson<String?>(sku),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'precioBase': serializer.toJson<double>(precioBase),
      'tasaImpuesto': serializer.toJson<double>(tasaImpuesto),
      'estaDisponible': serializer.toJson<bool>(estaDisponible),
      'imagenUrl': serializer.toJson<String?>(imagenUrl),
      'categoriaId': serializer.toJson<int>(categoriaId),
      'sincronizadoEn': serializer.toJson<DateTime>(sincronizadoEn),
    };
  }

  ProductosCacheData copyWith({
    int? id,
    Value<String?> sku = const Value.absent(),
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    double? precioBase,
    double? tasaImpuesto,
    bool? estaDisponible,
    Value<String?> imagenUrl = const Value.absent(),
    int? categoriaId,
    DateTime? sincronizadoEn,
  }) => ProductosCacheData(
    id: id ?? this.id,
    sku: sku.present ? sku.value : this.sku,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    precioBase: precioBase ?? this.precioBase,
    tasaImpuesto: tasaImpuesto ?? this.tasaImpuesto,
    estaDisponible: estaDisponible ?? this.estaDisponible,
    imagenUrl: imagenUrl.present ? imagenUrl.value : this.imagenUrl,
    categoriaId: categoriaId ?? this.categoriaId,
    sincronizadoEn: sincronizadoEn ?? this.sincronizadoEn,
  );
  ProductosCacheData copyWithCompanion(ProductosCacheCompanion data) {
    return ProductosCacheData(
      id: data.id.present ? data.id.value : this.id,
      sku: data.sku.present ? data.sku.value : this.sku,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      precioBase:
          data.precioBase.present ? data.precioBase.value : this.precioBase,
      tasaImpuesto:
          data.tasaImpuesto.present
              ? data.tasaImpuesto.value
              : this.tasaImpuesto,
      estaDisponible:
          data.estaDisponible.present
              ? data.estaDisponible.value
              : this.estaDisponible,
      imagenUrl: data.imagenUrl.present ? data.imagenUrl.value : this.imagenUrl,
      categoriaId:
          data.categoriaId.present ? data.categoriaId.value : this.categoriaId,
      sincronizadoEn:
          data.sincronizadoEn.present
              ? data.sincronizadoEn.value
              : this.sincronizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCacheData(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precioBase: $precioBase, ')
          ..write('tasaImpuesto: $tasaImpuesto, ')
          ..write('estaDisponible: $estaDisponible, ')
          ..write('imagenUrl: $imagenUrl, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('sincronizadoEn: $sincronizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sku,
    nombre,
    descripcion,
    precioBase,
    tasaImpuesto,
    estaDisponible,
    imagenUrl,
    categoriaId,
    sincronizadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductosCacheData &&
          other.id == this.id &&
          other.sku == this.sku &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.precioBase == this.precioBase &&
          other.tasaImpuesto == this.tasaImpuesto &&
          other.estaDisponible == this.estaDisponible &&
          other.imagenUrl == this.imagenUrl &&
          other.categoriaId == this.categoriaId &&
          other.sincronizadoEn == this.sincronizadoEn);
}

class ProductosCacheCompanion extends UpdateCompanion<ProductosCacheData> {
  final Value<int> id;
  final Value<String?> sku;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<double> precioBase;
  final Value<double> tasaImpuesto;
  final Value<bool> estaDisponible;
  final Value<String?> imagenUrl;
  final Value<int> categoriaId;
  final Value<DateTime> sincronizadoEn;
  const ProductosCacheCompanion({
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.precioBase = const Value.absent(),
    this.tasaImpuesto = const Value.absent(),
    this.estaDisponible = const Value.absent(),
    this.imagenUrl = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.sincronizadoEn = const Value.absent(),
  });
  ProductosCacheCompanion.insert({
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    required double precioBase,
    this.tasaImpuesto = const Value.absent(),
    this.estaDisponible = const Value.absent(),
    this.imagenUrl = const Value.absent(),
    required int categoriaId,
    this.sincronizadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       precioBase = Value(precioBase),
       categoriaId = Value(categoriaId);
  static Insertable<ProductosCacheData> custom({
    Expression<int>? id,
    Expression<String>? sku,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<double>? precioBase,
    Expression<double>? tasaImpuesto,
    Expression<bool>? estaDisponible,
    Expression<String>? imagenUrl,
    Expression<int>? categoriaId,
    Expression<DateTime>? sincronizadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (precioBase != null) 'precio_base': precioBase,
      if (tasaImpuesto != null) 'tasa_impuesto': tasaImpuesto,
      if (estaDisponible != null) 'esta_disponible': estaDisponible,
      if (imagenUrl != null) 'imagen_url': imagenUrl,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (sincronizadoEn != null) 'sincronizado_en': sincronizadoEn,
    });
  }

  ProductosCacheCompanion copyWith({
    Value<int>? id,
    Value<String?>? sku,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<double>? precioBase,
    Value<double>? tasaImpuesto,
    Value<bool>? estaDisponible,
    Value<String?>? imagenUrl,
    Value<int>? categoriaId,
    Value<DateTime>? sincronizadoEn,
  }) {
    return ProductosCacheCompanion(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precioBase: precioBase ?? this.precioBase,
      tasaImpuesto: tasaImpuesto ?? this.tasaImpuesto,
      estaDisponible: estaDisponible ?? this.estaDisponible,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      categoriaId: categoriaId ?? this.categoriaId,
      sincronizadoEn: sincronizadoEn ?? this.sincronizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (precioBase.present) {
      map['precio_base'] = Variable<double>(precioBase.value);
    }
    if (tasaImpuesto.present) {
      map['tasa_impuesto'] = Variable<double>(tasaImpuesto.value);
    }
    if (estaDisponible.present) {
      map['esta_disponible'] = Variable<bool>(estaDisponible.value);
    }
    if (imagenUrl.present) {
      map['imagen_url'] = Variable<String>(imagenUrl.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (sincronizadoEn.present) {
      map['sincronizado_en'] = Variable<DateTime>(sincronizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductosCacheCompanion(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('precioBase: $precioBase, ')
          ..write('tasaImpuesto: $tasaImpuesto, ')
          ..write('estaDisponible: $estaDisponible, ')
          ..write('imagenUrl: $imagenUrl, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('sincronizadoEn: $sincronizadoEn')
          ..write(')'))
        .toString();
  }
}

class $MesaActivaTable extends MesaActiva
    with TableInfo<$MesaActivaTable, MesaActivaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MesaActivaTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _numeroMesaMeta = const VerificationMeta(
    'numeroMesa',
  );
  @override
  late final GeneratedColumn<int> numeroMesa = GeneratedColumn<int>(
    'numero_mesa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codigoQrMesaMeta = const VerificationMeta(
    'codigoQrMesa',
  );
  @override
  late final GeneratedColumn<String> codigoQrMesa = GeneratedColumn<String>(
    'codigo_qr_mesa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estadoCuentaMeta = const VerificationMeta(
    'estadoCuenta',
  );
  @override
  late final GeneratedColumn<String> estadoCuenta = GeneratedColumn<String>(
    'estado_cuenta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ABIERTA'),
  );
  static const VerificationMeta _facturaLocalUuidMeta = const VerificationMeta(
    'facturaLocalUuid',
  );
  @override
  late final GeneratedColumn<String> facturaLocalUuid = GeneratedColumn<String>(
    'factura_local_uuid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _vinculadoEnMeta = const VerificationMeta(
    'vinculadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> vinculadoEn = GeneratedColumn<DateTime>(
    'vinculado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    numeroMesa,
    codigoQrMesa,
    estadoCuenta,
    facturaLocalUuid,
    vinculadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mesa_activa';
  @override
  VerificationContext validateIntegrity(
    Insertable<MesaActivaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('numero_mesa')) {
      context.handle(
        _numeroMesaMeta,
        numeroMesa.isAcceptableOrUnknown(data['numero_mesa']!, _numeroMesaMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMesaMeta);
    }
    if (data.containsKey('codigo_qr_mesa')) {
      context.handle(
        _codigoQrMesaMeta,
        codigoQrMesa.isAcceptableOrUnknown(
          data['codigo_qr_mesa']!,
          _codigoQrMesaMeta,
        ),
      );
    }
    if (data.containsKey('estado_cuenta')) {
      context.handle(
        _estadoCuentaMeta,
        estadoCuenta.isAcceptableOrUnknown(
          data['estado_cuenta']!,
          _estadoCuentaMeta,
        ),
      );
    }
    if (data.containsKey('factura_local_uuid')) {
      context.handle(
        _facturaLocalUuidMeta,
        facturaLocalUuid.isAcceptableOrUnknown(
          data['factura_local_uuid']!,
          _facturaLocalUuidMeta,
        ),
      );
    }
    if (data.containsKey('vinculado_en')) {
      context.handle(
        _vinculadoEnMeta,
        vinculadoEn.isAcceptableOrUnknown(
          data['vinculado_en']!,
          _vinculadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MesaActivaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MesaActivaData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      numeroMesa:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}numero_mesa'],
          )!,
      codigoQrMesa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_qr_mesa'],
      ),
      estadoCuenta:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}estado_cuenta'],
          )!,
      facturaLocalUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}factura_local_uuid'],
      ),
      vinculadoEn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}vinculado_en'],
          )!,
    );
  }

  @override
  $MesaActivaTable createAlias(String alias) {
    return $MesaActivaTable(attachedDatabase, alias);
  }
}

class MesaActivaData extends DataClass implements Insertable<MesaActivaData> {
  final int id;
  final int numeroMesa;
  final String? codigoQrMesa;
  final String estadoCuenta;
  final String? facturaLocalUuid;
  final DateTime vinculadoEn;
  const MesaActivaData({
    required this.id,
    required this.numeroMesa,
    this.codigoQrMesa,
    required this.estadoCuenta,
    this.facturaLocalUuid,
    required this.vinculadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['numero_mesa'] = Variable<int>(numeroMesa);
    if (!nullToAbsent || codigoQrMesa != null) {
      map['codigo_qr_mesa'] = Variable<String>(codigoQrMesa);
    }
    map['estado_cuenta'] = Variable<String>(estadoCuenta);
    if (!nullToAbsent || facturaLocalUuid != null) {
      map['factura_local_uuid'] = Variable<String>(facturaLocalUuid);
    }
    map['vinculado_en'] = Variable<DateTime>(vinculadoEn);
    return map;
  }

  MesaActivaCompanion toCompanion(bool nullToAbsent) {
    return MesaActivaCompanion(
      id: Value(id),
      numeroMesa: Value(numeroMesa),
      codigoQrMesa:
          codigoQrMesa == null && nullToAbsent
              ? const Value.absent()
              : Value(codigoQrMesa),
      estadoCuenta: Value(estadoCuenta),
      facturaLocalUuid:
          facturaLocalUuid == null && nullToAbsent
              ? const Value.absent()
              : Value(facturaLocalUuid),
      vinculadoEn: Value(vinculadoEn),
    );
  }

  factory MesaActivaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MesaActivaData(
      id: serializer.fromJson<int>(json['id']),
      numeroMesa: serializer.fromJson<int>(json['numeroMesa']),
      codigoQrMesa: serializer.fromJson<String?>(json['codigoQrMesa']),
      estadoCuenta: serializer.fromJson<String>(json['estadoCuenta']),
      facturaLocalUuid: serializer.fromJson<String?>(json['facturaLocalUuid']),
      vinculadoEn: serializer.fromJson<DateTime>(json['vinculadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'numeroMesa': serializer.toJson<int>(numeroMesa),
      'codigoQrMesa': serializer.toJson<String?>(codigoQrMesa),
      'estadoCuenta': serializer.toJson<String>(estadoCuenta),
      'facturaLocalUuid': serializer.toJson<String?>(facturaLocalUuid),
      'vinculadoEn': serializer.toJson<DateTime>(vinculadoEn),
    };
  }

  MesaActivaData copyWith({
    int? id,
    int? numeroMesa,
    Value<String?> codigoQrMesa = const Value.absent(),
    String? estadoCuenta,
    Value<String?> facturaLocalUuid = const Value.absent(),
    DateTime? vinculadoEn,
  }) => MesaActivaData(
    id: id ?? this.id,
    numeroMesa: numeroMesa ?? this.numeroMesa,
    codigoQrMesa: codigoQrMesa.present ? codigoQrMesa.value : this.codigoQrMesa,
    estadoCuenta: estadoCuenta ?? this.estadoCuenta,
    facturaLocalUuid:
        facturaLocalUuid.present
            ? facturaLocalUuid.value
            : this.facturaLocalUuid,
    vinculadoEn: vinculadoEn ?? this.vinculadoEn,
  );
  MesaActivaData copyWithCompanion(MesaActivaCompanion data) {
    return MesaActivaData(
      id: data.id.present ? data.id.value : this.id,
      numeroMesa:
          data.numeroMesa.present ? data.numeroMesa.value : this.numeroMesa,
      codigoQrMesa:
          data.codigoQrMesa.present
              ? data.codigoQrMesa.value
              : this.codigoQrMesa,
      estadoCuenta:
          data.estadoCuenta.present
              ? data.estadoCuenta.value
              : this.estadoCuenta,
      facturaLocalUuid:
          data.facturaLocalUuid.present
              ? data.facturaLocalUuid.value
              : this.facturaLocalUuid,
      vinculadoEn:
          data.vinculadoEn.present ? data.vinculadoEn.value : this.vinculadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MesaActivaData(')
          ..write('id: $id, ')
          ..write('numeroMesa: $numeroMesa, ')
          ..write('codigoQrMesa: $codigoQrMesa, ')
          ..write('estadoCuenta: $estadoCuenta, ')
          ..write('facturaLocalUuid: $facturaLocalUuid, ')
          ..write('vinculadoEn: $vinculadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    numeroMesa,
    codigoQrMesa,
    estadoCuenta,
    facturaLocalUuid,
    vinculadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MesaActivaData &&
          other.id == this.id &&
          other.numeroMesa == this.numeroMesa &&
          other.codigoQrMesa == this.codigoQrMesa &&
          other.estadoCuenta == this.estadoCuenta &&
          other.facturaLocalUuid == this.facturaLocalUuid &&
          other.vinculadoEn == this.vinculadoEn);
}

class MesaActivaCompanion extends UpdateCompanion<MesaActivaData> {
  final Value<int> id;
  final Value<int> numeroMesa;
  final Value<String?> codigoQrMesa;
  final Value<String> estadoCuenta;
  final Value<String?> facturaLocalUuid;
  final Value<DateTime> vinculadoEn;
  const MesaActivaCompanion({
    this.id = const Value.absent(),
    this.numeroMesa = const Value.absent(),
    this.codigoQrMesa = const Value.absent(),
    this.estadoCuenta = const Value.absent(),
    this.facturaLocalUuid = const Value.absent(),
    this.vinculadoEn = const Value.absent(),
  });
  MesaActivaCompanion.insert({
    this.id = const Value.absent(),
    required int numeroMesa,
    this.codigoQrMesa = const Value.absent(),
    this.estadoCuenta = const Value.absent(),
    this.facturaLocalUuid = const Value.absent(),
    this.vinculadoEn = const Value.absent(),
  }) : numeroMesa = Value(numeroMesa);
  static Insertable<MesaActivaData> custom({
    Expression<int>? id,
    Expression<int>? numeroMesa,
    Expression<String>? codigoQrMesa,
    Expression<String>? estadoCuenta,
    Expression<String>? facturaLocalUuid,
    Expression<DateTime>? vinculadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numeroMesa != null) 'numero_mesa': numeroMesa,
      if (codigoQrMesa != null) 'codigo_qr_mesa': codigoQrMesa,
      if (estadoCuenta != null) 'estado_cuenta': estadoCuenta,
      if (facturaLocalUuid != null) 'factura_local_uuid': facturaLocalUuid,
      if (vinculadoEn != null) 'vinculado_en': vinculadoEn,
    });
  }

  MesaActivaCompanion copyWith({
    Value<int>? id,
    Value<int>? numeroMesa,
    Value<String?>? codigoQrMesa,
    Value<String>? estadoCuenta,
    Value<String?>? facturaLocalUuid,
    Value<DateTime>? vinculadoEn,
  }) {
    return MesaActivaCompanion(
      id: id ?? this.id,
      numeroMesa: numeroMesa ?? this.numeroMesa,
      codigoQrMesa: codigoQrMesa ?? this.codigoQrMesa,
      estadoCuenta: estadoCuenta ?? this.estadoCuenta,
      facturaLocalUuid: facturaLocalUuid ?? this.facturaLocalUuid,
      vinculadoEn: vinculadoEn ?? this.vinculadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (numeroMesa.present) {
      map['numero_mesa'] = Variable<int>(numeroMesa.value);
    }
    if (codigoQrMesa.present) {
      map['codigo_qr_mesa'] = Variable<String>(codigoQrMesa.value);
    }
    if (estadoCuenta.present) {
      map['estado_cuenta'] = Variable<String>(estadoCuenta.value);
    }
    if (facturaLocalUuid.present) {
      map['factura_local_uuid'] = Variable<String>(facturaLocalUuid.value);
    }
    if (vinculadoEn.present) {
      map['vinculado_en'] = Variable<DateTime>(vinculadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MesaActivaCompanion(')
          ..write('id: $id, ')
          ..write('numeroMesa: $numeroMesa, ')
          ..write('codigoQrMesa: $codigoQrMesa, ')
          ..write('estadoCuenta: $estadoCuenta, ')
          ..write('facturaLocalUuid: $facturaLocalUuid, ')
          ..write('vinculadoEn: $vinculadoEn')
          ..write(')'))
        .toString();
  }
}

class $CarritoLocalTable extends CarritoLocal
    with TableInfo<$CarritoLocalTable, CarritoLocalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarritoLocalTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _detalleLocalUuidMeta = const VerificationMeta(
    'detalleLocalUuid',
  );
  @override
  late final GeneratedColumn<String> detalleLocalUuid = GeneratedColumn<String>(
    'detalle_local_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES productos_cache (id)',
    ),
  );
  static const VerificationMeta _nombreProductoMeta = const VerificationMeta(
    'nombreProducto',
  );
  @override
  late final GeneratedColumn<String> nombreProducto = GeneratedColumn<String>(
    'nombre_producto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tasaImpuestoMeta = const VerificationMeta(
    'tasaImpuesto',
  );
  @override
  late final GeneratedColumn<double> tasaImpuesto = GeneratedColumn<double>(
    'tasa_impuesto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.18),
  );
  static const VerificationMeta _subtotalLineaMeta = const VerificationMeta(
    'subtotalLinea',
  );
  @override
  late final GeneratedColumn<double> subtotalLinea = GeneratedColumn<double>(
    'subtotal_linea',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoImpuestoMeta = const VerificationMeta(
    'montoImpuesto',
  );
  @override
  late final GeneratedColumn<double> montoImpuesto = GeneratedColumn<double>(
    'monto_impuesto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _comentariosCocinaMeta = const VerificationMeta(
    'comentariosCocina',
  );
  @override
  late final GeneratedColumn<String> comentariosCocina =
      GeneratedColumn<String>(
        'comentarios_cocina',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _agregadoEnMeta = const VerificationMeta(
    'agregadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> agregadoEn = GeneratedColumn<DateTime>(
    'agregado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    detalleLocalUuid,
    productoId,
    nombreProducto,
    cantidad,
    precioUnitario,
    tasaImpuesto,
    subtotalLinea,
    montoImpuesto,
    comentariosCocina,
    agregadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'carrito_local';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarritoLocalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('detalle_local_uuid')) {
      context.handle(
        _detalleLocalUuidMeta,
        detalleLocalUuid.isAcceptableOrUnknown(
          data['detalle_local_uuid']!,
          _detalleLocalUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detalleLocalUuidMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('nombre_producto')) {
      context.handle(
        _nombreProductoMeta,
        nombreProducto.isAcceptableOrUnknown(
          data['nombre_producto']!,
          _nombreProductoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nombreProductoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('tasa_impuesto')) {
      context.handle(
        _tasaImpuestoMeta,
        tasaImpuesto.isAcceptableOrUnknown(
          data['tasa_impuesto']!,
          _tasaImpuestoMeta,
        ),
      );
    }
    if (data.containsKey('subtotal_linea')) {
      context.handle(
        _subtotalLineaMeta,
        subtotalLinea.isAcceptableOrUnknown(
          data['subtotal_linea']!,
          _subtotalLineaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtotalLineaMeta);
    }
    if (data.containsKey('monto_impuesto')) {
      context.handle(
        _montoImpuestoMeta,
        montoImpuesto.isAcceptableOrUnknown(
          data['monto_impuesto']!,
          _montoImpuestoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoImpuestoMeta);
    }
    if (data.containsKey('comentarios_cocina')) {
      context.handle(
        _comentariosCocinaMeta,
        comentariosCocina.isAcceptableOrUnknown(
          data['comentarios_cocina']!,
          _comentariosCocinaMeta,
        ),
      );
    }
    if (data.containsKey('agregado_en')) {
      context.handle(
        _agregadoEnMeta,
        agregadoEn.isAcceptableOrUnknown(data['agregado_en']!, _agregadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarritoLocalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarritoLocalData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      detalleLocalUuid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}detalle_local_uuid'],
          )!,
      productoId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}producto_id'],
          )!,
      nombreProducto:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nombre_producto'],
          )!,
      cantidad:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}cantidad'],
          )!,
      precioUnitario:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}precio_unitario'],
          )!,
      tasaImpuesto:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}tasa_impuesto'],
          )!,
      subtotalLinea:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}subtotal_linea'],
          )!,
      montoImpuesto:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}monto_impuesto'],
          )!,
      comentariosCocina: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comentarios_cocina'],
      ),
      agregadoEn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}agregado_en'],
          )!,
    );
  }

  @override
  $CarritoLocalTable createAlias(String alias) {
    return $CarritoLocalTable(attachedDatabase, alias);
  }
}

class CarritoLocalData extends DataClass
    implements Insertable<CarritoLocalData> {
  final int id;
  final String detalleLocalUuid;
  final int productoId;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;
  final double tasaImpuesto;
  final double subtotalLinea;
  final double montoImpuesto;
  final String? comentariosCocina;
  final DateTime agregadoEn;
  const CarritoLocalData({
    required this.id,
    required this.detalleLocalUuid,
    required this.productoId,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.tasaImpuesto,
    required this.subtotalLinea,
    required this.montoImpuesto,
    this.comentariosCocina,
    required this.agregadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['detalle_local_uuid'] = Variable<String>(detalleLocalUuid);
    map['producto_id'] = Variable<int>(productoId);
    map['nombre_producto'] = Variable<String>(nombreProducto);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['tasa_impuesto'] = Variable<double>(tasaImpuesto);
    map['subtotal_linea'] = Variable<double>(subtotalLinea);
    map['monto_impuesto'] = Variable<double>(montoImpuesto);
    if (!nullToAbsent || comentariosCocina != null) {
      map['comentarios_cocina'] = Variable<String>(comentariosCocina);
    }
    map['agregado_en'] = Variable<DateTime>(agregadoEn);
    return map;
  }

  CarritoLocalCompanion toCompanion(bool nullToAbsent) {
    return CarritoLocalCompanion(
      id: Value(id),
      detalleLocalUuid: Value(detalleLocalUuid),
      productoId: Value(productoId),
      nombreProducto: Value(nombreProducto),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
      tasaImpuesto: Value(tasaImpuesto),
      subtotalLinea: Value(subtotalLinea),
      montoImpuesto: Value(montoImpuesto),
      comentariosCocina:
          comentariosCocina == null && nullToAbsent
              ? const Value.absent()
              : Value(comentariosCocina),
      agregadoEn: Value(agregadoEn),
    );
  }

  factory CarritoLocalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarritoLocalData(
      id: serializer.fromJson<int>(json['id']),
      detalleLocalUuid: serializer.fromJson<String>(json['detalleLocalUuid']),
      productoId: serializer.fromJson<int>(json['productoId']),
      nombreProducto: serializer.fromJson<String>(json['nombreProducto']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      tasaImpuesto: serializer.fromJson<double>(json['tasaImpuesto']),
      subtotalLinea: serializer.fromJson<double>(json['subtotalLinea']),
      montoImpuesto: serializer.fromJson<double>(json['montoImpuesto']),
      comentariosCocina: serializer.fromJson<String?>(
        json['comentariosCocina'],
      ),
      agregadoEn: serializer.fromJson<DateTime>(json['agregadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'detalleLocalUuid': serializer.toJson<String>(detalleLocalUuid),
      'productoId': serializer.toJson<int>(productoId),
      'nombreProducto': serializer.toJson<String>(nombreProducto),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'tasaImpuesto': serializer.toJson<double>(tasaImpuesto),
      'subtotalLinea': serializer.toJson<double>(subtotalLinea),
      'montoImpuesto': serializer.toJson<double>(montoImpuesto),
      'comentariosCocina': serializer.toJson<String?>(comentariosCocina),
      'agregadoEn': serializer.toJson<DateTime>(agregadoEn),
    };
  }

  CarritoLocalData copyWith({
    int? id,
    String? detalleLocalUuid,
    int? productoId,
    String? nombreProducto,
    int? cantidad,
    double? precioUnitario,
    double? tasaImpuesto,
    double? subtotalLinea,
    double? montoImpuesto,
    Value<String?> comentariosCocina = const Value.absent(),
    DateTime? agregadoEn,
  }) => CarritoLocalData(
    id: id ?? this.id,
    detalleLocalUuid: detalleLocalUuid ?? this.detalleLocalUuid,
    productoId: productoId ?? this.productoId,
    nombreProducto: nombreProducto ?? this.nombreProducto,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    tasaImpuesto: tasaImpuesto ?? this.tasaImpuesto,
    subtotalLinea: subtotalLinea ?? this.subtotalLinea,
    montoImpuesto: montoImpuesto ?? this.montoImpuesto,
    comentariosCocina:
        comentariosCocina.present
            ? comentariosCocina.value
            : this.comentariosCocina,
    agregadoEn: agregadoEn ?? this.agregadoEn,
  );
  CarritoLocalData copyWithCompanion(CarritoLocalCompanion data) {
    return CarritoLocalData(
      id: data.id.present ? data.id.value : this.id,
      detalleLocalUuid:
          data.detalleLocalUuid.present
              ? data.detalleLocalUuid.value
              : this.detalleLocalUuid,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      nombreProducto:
          data.nombreProducto.present
              ? data.nombreProducto.value
              : this.nombreProducto,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario:
          data.precioUnitario.present
              ? data.precioUnitario.value
              : this.precioUnitario,
      tasaImpuesto:
          data.tasaImpuesto.present
              ? data.tasaImpuesto.value
              : this.tasaImpuesto,
      subtotalLinea:
          data.subtotalLinea.present
              ? data.subtotalLinea.value
              : this.subtotalLinea,
      montoImpuesto:
          data.montoImpuesto.present
              ? data.montoImpuesto.value
              : this.montoImpuesto,
      comentariosCocina:
          data.comentariosCocina.present
              ? data.comentariosCocina.value
              : this.comentariosCocina,
      agregadoEn:
          data.agregadoEn.present ? data.agregadoEn.value : this.agregadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarritoLocalData(')
          ..write('id: $id, ')
          ..write('detalleLocalUuid: $detalleLocalUuid, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('tasaImpuesto: $tasaImpuesto, ')
          ..write('subtotalLinea: $subtotalLinea, ')
          ..write('montoImpuesto: $montoImpuesto, ')
          ..write('comentariosCocina: $comentariosCocina, ')
          ..write('agregadoEn: $agregadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    detalleLocalUuid,
    productoId,
    nombreProducto,
    cantidad,
    precioUnitario,
    tasaImpuesto,
    subtotalLinea,
    montoImpuesto,
    comentariosCocina,
    agregadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarritoLocalData &&
          other.id == this.id &&
          other.detalleLocalUuid == this.detalleLocalUuid &&
          other.productoId == this.productoId &&
          other.nombreProducto == this.nombreProducto &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.tasaImpuesto == this.tasaImpuesto &&
          other.subtotalLinea == this.subtotalLinea &&
          other.montoImpuesto == this.montoImpuesto &&
          other.comentariosCocina == this.comentariosCocina &&
          other.agregadoEn == this.agregadoEn);
}

class CarritoLocalCompanion extends UpdateCompanion<CarritoLocalData> {
  final Value<int> id;
  final Value<String> detalleLocalUuid;
  final Value<int> productoId;
  final Value<String> nombreProducto;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<double> tasaImpuesto;
  final Value<double> subtotalLinea;
  final Value<double> montoImpuesto;
  final Value<String?> comentariosCocina;
  final Value<DateTime> agregadoEn;
  const CarritoLocalCompanion({
    this.id = const Value.absent(),
    this.detalleLocalUuid = const Value.absent(),
    this.productoId = const Value.absent(),
    this.nombreProducto = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.tasaImpuesto = const Value.absent(),
    this.subtotalLinea = const Value.absent(),
    this.montoImpuesto = const Value.absent(),
    this.comentariosCocina = const Value.absent(),
    this.agregadoEn = const Value.absent(),
  });
  CarritoLocalCompanion.insert({
    this.id = const Value.absent(),
    required String detalleLocalUuid,
    required int productoId,
    required String nombreProducto,
    this.cantidad = const Value.absent(),
    required double precioUnitario,
    this.tasaImpuesto = const Value.absent(),
    required double subtotalLinea,
    required double montoImpuesto,
    this.comentariosCocina = const Value.absent(),
    this.agregadoEn = const Value.absent(),
  }) : detalleLocalUuid = Value(detalleLocalUuid),
       productoId = Value(productoId),
       nombreProducto = Value(nombreProducto),
       precioUnitario = Value(precioUnitario),
       subtotalLinea = Value(subtotalLinea),
       montoImpuesto = Value(montoImpuesto);
  static Insertable<CarritoLocalData> custom({
    Expression<int>? id,
    Expression<String>? detalleLocalUuid,
    Expression<int>? productoId,
    Expression<String>? nombreProducto,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
    Expression<double>? tasaImpuesto,
    Expression<double>? subtotalLinea,
    Expression<double>? montoImpuesto,
    Expression<String>? comentariosCocina,
    Expression<DateTime>? agregadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (detalleLocalUuid != null) 'detalle_local_uuid': detalleLocalUuid,
      if (productoId != null) 'producto_id': productoId,
      if (nombreProducto != null) 'nombre_producto': nombreProducto,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (tasaImpuesto != null) 'tasa_impuesto': tasaImpuesto,
      if (subtotalLinea != null) 'subtotal_linea': subtotalLinea,
      if (montoImpuesto != null) 'monto_impuesto': montoImpuesto,
      if (comentariosCocina != null) 'comentarios_cocina': comentariosCocina,
      if (agregadoEn != null) 'agregado_en': agregadoEn,
    });
  }

  CarritoLocalCompanion copyWith({
    Value<int>? id,
    Value<String>? detalleLocalUuid,
    Value<int>? productoId,
    Value<String>? nombreProducto,
    Value<int>? cantidad,
    Value<double>? precioUnitario,
    Value<double>? tasaImpuesto,
    Value<double>? subtotalLinea,
    Value<double>? montoImpuesto,
    Value<String?>? comentariosCocina,
    Value<DateTime>? agregadoEn,
  }) {
    return CarritoLocalCompanion(
      id: id ?? this.id,
      detalleLocalUuid: detalleLocalUuid ?? this.detalleLocalUuid,
      productoId: productoId ?? this.productoId,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      tasaImpuesto: tasaImpuesto ?? this.tasaImpuesto,
      subtotalLinea: subtotalLinea ?? this.subtotalLinea,
      montoImpuesto: montoImpuesto ?? this.montoImpuesto,
      comentariosCocina: comentariosCocina ?? this.comentariosCocina,
      agregadoEn: agregadoEn ?? this.agregadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (detalleLocalUuid.present) {
      map['detalle_local_uuid'] = Variable<String>(detalleLocalUuid.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (nombreProducto.present) {
      map['nombre_producto'] = Variable<String>(nombreProducto.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (tasaImpuesto.present) {
      map['tasa_impuesto'] = Variable<double>(tasaImpuesto.value);
    }
    if (subtotalLinea.present) {
      map['subtotal_linea'] = Variable<double>(subtotalLinea.value);
    }
    if (montoImpuesto.present) {
      map['monto_impuesto'] = Variable<double>(montoImpuesto.value);
    }
    if (comentariosCocina.present) {
      map['comentarios_cocina'] = Variable<String>(comentariosCocina.value);
    }
    if (agregadoEn.present) {
      map['agregado_en'] = Variable<DateTime>(agregadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarritoLocalCompanion(')
          ..write('id: $id, ')
          ..write('detalleLocalUuid: $detalleLocalUuid, ')
          ..write('productoId: $productoId, ')
          ..write('nombreProducto: $nombreProducto, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('tasaImpuesto: $tasaImpuesto, ')
          ..write('subtotalLinea: $subtotalLinea, ')
          ..write('montoImpuesto: $montoImpuesto, ')
          ..write('comentariosCocina: $comentariosCocina, ')
          ..write('agregadoEn: $agregadoEn')
          ..write(')'))
        .toString();
  }
}

class $HistorialPedidosTable extends HistorialPedidos
    with TableInfo<$HistorialPedidosTable, HistorialPedido> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistorialPedidosTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _facturaLocalUuidMeta = const VerificationMeta(
    'facturaLocalUuid',
  );
  @override
  late final GeneratedColumn<String> facturaLocalUuid = GeneratedColumn<String>(
    'factura_local_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _numeroMesaMeta = const VerificationMeta(
    'numeroMesa',
  );
  @override
  late final GeneratedColumn<int> numeroMesa = GeneratedColumn<int>(
    'numero_mesa',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalImpuestosMeta = const VerificationMeta(
    'totalImpuestos',
  );
  @override
  late final GeneratedColumn<double> totalImpuestos = GeneratedColumn<double>(
    'total_impuestos',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propinaLegalMeta = const VerificationMeta(
    'propinaLegal',
  );
  @override
  late final GeneratedColumn<double> propinaLegal = GeneratedColumn<double>(
    'propina_legal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalGeneralMeta = const VerificationMeta(
    'totalGeneral',
  );
  @override
  late final GeneratedColumn<double> totalGeneral = GeneratedColumn<double>(
    'total_general',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propinaVoluntariaMeta = const VerificationMeta(
    'propinaVoluntaria',
  );
  @override
  late final GeneratedColumn<double> propinaVoluntaria =
      GeneratedColumn<double>(
        'propina_voluntaria',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _estadoCuentaMeta = const VerificationMeta(
    'estadoCuenta',
  );
  @override
  late final GeneratedColumn<String> estadoCuenta = GeneratedColumn<String>(
    'estado_cuenta',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ABIERTA'),
  );
  static const VerificationMeta _comentariosCocinaMeta = const VerificationMeta(
    'comentariosCocina',
  );
  @override
  late final GeneratedColumn<String> comentariosCocina =
      GeneratedColumn<String>(
        'comentarios_cocina',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    facturaLocalUuid,
    clienteId,
    numeroMesa,
    subtotal,
    totalImpuestos,
    propinaLegal,
    totalGeneral,
    propinaVoluntaria,
    estadoCuenta,
    comentariosCocina,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historial_pedidos';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistorialPedido> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('factura_local_uuid')) {
      context.handle(
        _facturaLocalUuidMeta,
        facturaLocalUuid.isAcceptableOrUnknown(
          data['factura_local_uuid']!,
          _facturaLocalUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_facturaLocalUuidMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    }
    if (data.containsKey('numero_mesa')) {
      context.handle(
        _numeroMesaMeta,
        numeroMesa.isAcceptableOrUnknown(data['numero_mesa']!, _numeroMesaMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMesaMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('total_impuestos')) {
      context.handle(
        _totalImpuestosMeta,
        totalImpuestos.isAcceptableOrUnknown(
          data['total_impuestos']!,
          _totalImpuestosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalImpuestosMeta);
    }
    if (data.containsKey('propina_legal')) {
      context.handle(
        _propinaLegalMeta,
        propinaLegal.isAcceptableOrUnknown(
          data['propina_legal']!,
          _propinaLegalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_propinaLegalMeta);
    }
    if (data.containsKey('total_general')) {
      context.handle(
        _totalGeneralMeta,
        totalGeneral.isAcceptableOrUnknown(
          data['total_general']!,
          _totalGeneralMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalGeneralMeta);
    }
    if (data.containsKey('propina_voluntaria')) {
      context.handle(
        _propinaVoluntariaMeta,
        propinaVoluntaria.isAcceptableOrUnknown(
          data['propina_voluntaria']!,
          _propinaVoluntariaMeta,
        ),
      );
    }
    if (data.containsKey('estado_cuenta')) {
      context.handle(
        _estadoCuentaMeta,
        estadoCuenta.isAcceptableOrUnknown(
          data['estado_cuenta']!,
          _estadoCuentaMeta,
        ),
      );
    }
    if (data.containsKey('comentarios_cocina')) {
      context.handle(
        _comentariosCocinaMeta,
        comentariosCocina.isAcceptableOrUnknown(
          data['comentarios_cocina']!,
          _comentariosCocinaMeta,
        ),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistorialPedido map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistorialPedido(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      facturaLocalUuid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}factura_local_uuid'],
          )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      ),
      numeroMesa:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}numero_mesa'],
          )!,
      subtotal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}subtotal'],
          )!,
      totalImpuestos:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_impuestos'],
          )!,
      propinaLegal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}propina_legal'],
          )!,
      totalGeneral:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_general'],
          )!,
      propinaVoluntaria:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}propina_voluntaria'],
          )!,
      estadoCuenta:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}estado_cuenta'],
          )!,
      comentariosCocina: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comentarios_cocina'],
      ),
      creadoEn:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}creado_en'],
          )!,
    );
  }

  @override
  $HistorialPedidosTable createAlias(String alias) {
    return $HistorialPedidosTable(attachedDatabase, alias);
  }
}

class HistorialPedido extends DataClass implements Insertable<HistorialPedido> {
  final int id;
  final String facturaLocalUuid;
  final int? clienteId;
  final int numeroMesa;
  final double subtotal;
  final double totalImpuestos;
  final double propinaLegal;
  final double totalGeneral;
  final double propinaVoluntaria;
  final String estadoCuenta;
  final String? comentariosCocina;
  final DateTime creadoEn;
  const HistorialPedido({
    required this.id,
    required this.facturaLocalUuid,
    this.clienteId,
    required this.numeroMesa,
    required this.subtotal,
    required this.totalImpuestos,
    required this.propinaLegal,
    required this.totalGeneral,
    required this.propinaVoluntaria,
    required this.estadoCuenta,
    this.comentariosCocina,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['factura_local_uuid'] = Variable<String>(facturaLocalUuid);
    if (!nullToAbsent || clienteId != null) {
      map['cliente_id'] = Variable<int>(clienteId);
    }
    map['numero_mesa'] = Variable<int>(numeroMesa);
    map['subtotal'] = Variable<double>(subtotal);
    map['total_impuestos'] = Variable<double>(totalImpuestos);
    map['propina_legal'] = Variable<double>(propinaLegal);
    map['total_general'] = Variable<double>(totalGeneral);
    map['propina_voluntaria'] = Variable<double>(propinaVoluntaria);
    map['estado_cuenta'] = Variable<String>(estadoCuenta);
    if (!nullToAbsent || comentariosCocina != null) {
      map['comentarios_cocina'] = Variable<String>(comentariosCocina);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  HistorialPedidosCompanion toCompanion(bool nullToAbsent) {
    return HistorialPedidosCompanion(
      id: Value(id),
      facturaLocalUuid: Value(facturaLocalUuid),
      clienteId:
          clienteId == null && nullToAbsent
              ? const Value.absent()
              : Value(clienteId),
      numeroMesa: Value(numeroMesa),
      subtotal: Value(subtotal),
      totalImpuestos: Value(totalImpuestos),
      propinaLegal: Value(propinaLegal),
      totalGeneral: Value(totalGeneral),
      propinaVoluntaria: Value(propinaVoluntaria),
      estadoCuenta: Value(estadoCuenta),
      comentariosCocina:
          comentariosCocina == null && nullToAbsent
              ? const Value.absent()
              : Value(comentariosCocina),
      creadoEn: Value(creadoEn),
    );
  }

  factory HistorialPedido.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistorialPedido(
      id: serializer.fromJson<int>(json['id']),
      facturaLocalUuid: serializer.fromJson<String>(json['facturaLocalUuid']),
      clienteId: serializer.fromJson<int?>(json['clienteId']),
      numeroMesa: serializer.fromJson<int>(json['numeroMesa']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      totalImpuestos: serializer.fromJson<double>(json['totalImpuestos']),
      propinaLegal: serializer.fromJson<double>(json['propinaLegal']),
      totalGeneral: serializer.fromJson<double>(json['totalGeneral']),
      propinaVoluntaria: serializer.fromJson<double>(json['propinaVoluntaria']),
      estadoCuenta: serializer.fromJson<String>(json['estadoCuenta']),
      comentariosCocina: serializer.fromJson<String?>(
        json['comentariosCocina'],
      ),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'facturaLocalUuid': serializer.toJson<String>(facturaLocalUuid),
      'clienteId': serializer.toJson<int?>(clienteId),
      'numeroMesa': serializer.toJson<int>(numeroMesa),
      'subtotal': serializer.toJson<double>(subtotal),
      'totalImpuestos': serializer.toJson<double>(totalImpuestos),
      'propinaLegal': serializer.toJson<double>(propinaLegal),
      'totalGeneral': serializer.toJson<double>(totalGeneral),
      'propinaVoluntaria': serializer.toJson<double>(propinaVoluntaria),
      'estadoCuenta': serializer.toJson<String>(estadoCuenta),
      'comentariosCocina': serializer.toJson<String?>(comentariosCocina),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  HistorialPedido copyWith({
    int? id,
    String? facturaLocalUuid,
    Value<int?> clienteId = const Value.absent(),
    int? numeroMesa,
    double? subtotal,
    double? totalImpuestos,
    double? propinaLegal,
    double? totalGeneral,
    double? propinaVoluntaria,
    String? estadoCuenta,
    Value<String?> comentariosCocina = const Value.absent(),
    DateTime? creadoEn,
  }) => HistorialPedido(
    id: id ?? this.id,
    facturaLocalUuid: facturaLocalUuid ?? this.facturaLocalUuid,
    clienteId: clienteId.present ? clienteId.value : this.clienteId,
    numeroMesa: numeroMesa ?? this.numeroMesa,
    subtotal: subtotal ?? this.subtotal,
    totalImpuestos: totalImpuestos ?? this.totalImpuestos,
    propinaLegal: propinaLegal ?? this.propinaLegal,
    totalGeneral: totalGeneral ?? this.totalGeneral,
    propinaVoluntaria: propinaVoluntaria ?? this.propinaVoluntaria,
    estadoCuenta: estadoCuenta ?? this.estadoCuenta,
    comentariosCocina:
        comentariosCocina.present
            ? comentariosCocina.value
            : this.comentariosCocina,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  HistorialPedido copyWithCompanion(HistorialPedidosCompanion data) {
    return HistorialPedido(
      id: data.id.present ? data.id.value : this.id,
      facturaLocalUuid:
          data.facturaLocalUuid.present
              ? data.facturaLocalUuid.value
              : this.facturaLocalUuid,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      numeroMesa:
          data.numeroMesa.present ? data.numeroMesa.value : this.numeroMesa,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      totalImpuestos:
          data.totalImpuestos.present
              ? data.totalImpuestos.value
              : this.totalImpuestos,
      propinaLegal:
          data.propinaLegal.present
              ? data.propinaLegal.value
              : this.propinaLegal,
      totalGeneral:
          data.totalGeneral.present
              ? data.totalGeneral.value
              : this.totalGeneral,
      propinaVoluntaria:
          data.propinaVoluntaria.present
              ? data.propinaVoluntaria.value
              : this.propinaVoluntaria,
      estadoCuenta:
          data.estadoCuenta.present
              ? data.estadoCuenta.value
              : this.estadoCuenta,
      comentariosCocina:
          data.comentariosCocina.present
              ? data.comentariosCocina.value
              : this.comentariosCocina,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistorialPedido(')
          ..write('id: $id, ')
          ..write('facturaLocalUuid: $facturaLocalUuid, ')
          ..write('clienteId: $clienteId, ')
          ..write('numeroMesa: $numeroMesa, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalImpuestos: $totalImpuestos, ')
          ..write('propinaLegal: $propinaLegal, ')
          ..write('totalGeneral: $totalGeneral, ')
          ..write('propinaVoluntaria: $propinaVoluntaria, ')
          ..write('estadoCuenta: $estadoCuenta, ')
          ..write('comentariosCocina: $comentariosCocina, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    facturaLocalUuid,
    clienteId,
    numeroMesa,
    subtotal,
    totalImpuestos,
    propinaLegal,
    totalGeneral,
    propinaVoluntaria,
    estadoCuenta,
    comentariosCocina,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistorialPedido &&
          other.id == this.id &&
          other.facturaLocalUuid == this.facturaLocalUuid &&
          other.clienteId == this.clienteId &&
          other.numeroMesa == this.numeroMesa &&
          other.subtotal == this.subtotal &&
          other.totalImpuestos == this.totalImpuestos &&
          other.propinaLegal == this.propinaLegal &&
          other.totalGeneral == this.totalGeneral &&
          other.propinaVoluntaria == this.propinaVoluntaria &&
          other.estadoCuenta == this.estadoCuenta &&
          other.comentariosCocina == this.comentariosCocina &&
          other.creadoEn == this.creadoEn);
}

class HistorialPedidosCompanion extends UpdateCompanion<HistorialPedido> {
  final Value<int> id;
  final Value<String> facturaLocalUuid;
  final Value<int?> clienteId;
  final Value<int> numeroMesa;
  final Value<double> subtotal;
  final Value<double> totalImpuestos;
  final Value<double> propinaLegal;
  final Value<double> totalGeneral;
  final Value<double> propinaVoluntaria;
  final Value<String> estadoCuenta;
  final Value<String?> comentariosCocina;
  final Value<DateTime> creadoEn;
  const HistorialPedidosCompanion({
    this.id = const Value.absent(),
    this.facturaLocalUuid = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.numeroMesa = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.totalImpuestos = const Value.absent(),
    this.propinaLegal = const Value.absent(),
    this.totalGeneral = const Value.absent(),
    this.propinaVoluntaria = const Value.absent(),
    this.estadoCuenta = const Value.absent(),
    this.comentariosCocina = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  HistorialPedidosCompanion.insert({
    this.id = const Value.absent(),
    required String facturaLocalUuid,
    this.clienteId = const Value.absent(),
    required int numeroMesa,
    required double subtotal,
    required double totalImpuestos,
    required double propinaLegal,
    required double totalGeneral,
    this.propinaVoluntaria = const Value.absent(),
    this.estadoCuenta = const Value.absent(),
    this.comentariosCocina = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : facturaLocalUuid = Value(facturaLocalUuid),
       numeroMesa = Value(numeroMesa),
       subtotal = Value(subtotal),
       totalImpuestos = Value(totalImpuestos),
       propinaLegal = Value(propinaLegal),
       totalGeneral = Value(totalGeneral);
  static Insertable<HistorialPedido> custom({
    Expression<int>? id,
    Expression<String>? facturaLocalUuid,
    Expression<int>? clienteId,
    Expression<int>? numeroMesa,
    Expression<double>? subtotal,
    Expression<double>? totalImpuestos,
    Expression<double>? propinaLegal,
    Expression<double>? totalGeneral,
    Expression<double>? propinaVoluntaria,
    Expression<String>? estadoCuenta,
    Expression<String>? comentariosCocina,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (facturaLocalUuid != null) 'factura_local_uuid': facturaLocalUuid,
      if (clienteId != null) 'cliente_id': clienteId,
      if (numeroMesa != null) 'numero_mesa': numeroMesa,
      if (subtotal != null) 'subtotal': subtotal,
      if (totalImpuestos != null) 'total_impuestos': totalImpuestos,
      if (propinaLegal != null) 'propina_legal': propinaLegal,
      if (totalGeneral != null) 'total_general': totalGeneral,
      if (propinaVoluntaria != null) 'propina_voluntaria': propinaVoluntaria,
      if (estadoCuenta != null) 'estado_cuenta': estadoCuenta,
      if (comentariosCocina != null) 'comentarios_cocina': comentariosCocina,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  HistorialPedidosCompanion copyWith({
    Value<int>? id,
    Value<String>? facturaLocalUuid,
    Value<int?>? clienteId,
    Value<int>? numeroMesa,
    Value<double>? subtotal,
    Value<double>? totalImpuestos,
    Value<double>? propinaLegal,
    Value<double>? totalGeneral,
    Value<double>? propinaVoluntaria,
    Value<String>? estadoCuenta,
    Value<String?>? comentariosCocina,
    Value<DateTime>? creadoEn,
  }) {
    return HistorialPedidosCompanion(
      id: id ?? this.id,
      facturaLocalUuid: facturaLocalUuid ?? this.facturaLocalUuid,
      clienteId: clienteId ?? this.clienteId,
      numeroMesa: numeroMesa ?? this.numeroMesa,
      subtotal: subtotal ?? this.subtotal,
      totalImpuestos: totalImpuestos ?? this.totalImpuestos,
      propinaLegal: propinaLegal ?? this.propinaLegal,
      totalGeneral: totalGeneral ?? this.totalGeneral,
      propinaVoluntaria: propinaVoluntaria ?? this.propinaVoluntaria,
      estadoCuenta: estadoCuenta ?? this.estadoCuenta,
      comentariosCocina: comentariosCocina ?? this.comentariosCocina,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (facturaLocalUuid.present) {
      map['factura_local_uuid'] = Variable<String>(facturaLocalUuid.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (numeroMesa.present) {
      map['numero_mesa'] = Variable<int>(numeroMesa.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (totalImpuestos.present) {
      map['total_impuestos'] = Variable<double>(totalImpuestos.value);
    }
    if (propinaLegal.present) {
      map['propina_legal'] = Variable<double>(propinaLegal.value);
    }
    if (totalGeneral.present) {
      map['total_general'] = Variable<double>(totalGeneral.value);
    }
    if (propinaVoluntaria.present) {
      map['propina_voluntaria'] = Variable<double>(propinaVoluntaria.value);
    }
    if (estadoCuenta.present) {
      map['estado_cuenta'] = Variable<String>(estadoCuenta.value);
    }
    if (comentariosCocina.present) {
      map['comentarios_cocina'] = Variable<String>(comentariosCocina.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistorialPedidosCompanion(')
          ..write('id: $id, ')
          ..write('facturaLocalUuid: $facturaLocalUuid, ')
          ..write('clienteId: $clienteId, ')
          ..write('numeroMesa: $numeroMesa, ')
          ..write('subtotal: $subtotal, ')
          ..write('totalImpuestos: $totalImpuestos, ')
          ..write('propinaLegal: $propinaLegal, ')
          ..write('totalGeneral: $totalGeneral, ')
          ..write('propinaVoluntaria: $propinaVoluntaria, ')
          ..write('estadoCuenta: $estadoCuenta, ')
          ..write('comentariosCocina: $comentariosCocina, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $HistorialDetallesTable extends HistorialDetalles
    with TableInfo<$HistorialDetallesTable, HistorialDetalle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistorialDetallesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _detalleLocalUuidMeta = const VerificationMeta(
    'detalleLocalUuid',
  );
  @override
  late final GeneratedColumn<String> detalleLocalUuid = GeneratedColumn<String>(
    'detalle_local_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _facturaLocalUuidMeta = const VerificationMeta(
    'facturaLocalUuid',
  );
  @override
  late final GeneratedColumn<String> facturaLocalUuid = GeneratedColumn<String>(
    'factura_local_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productoNombreMeta = const VerificationMeta(
    'productoNombre',
  );
  @override
  late final GeneratedColumn<String> productoNombre = GeneratedColumn<String>(
    'producto_nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _montoImpuestoMeta = const VerificationMeta(
    'montoImpuesto',
  );
  @override
  late final GeneratedColumn<double> montoImpuesto = GeneratedColumn<double>(
    'monto_impuesto',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalLineaMeta = const VerificationMeta(
    'subtotalLinea',
  );
  @override
  late final GeneratedColumn<double> subtotalLinea = GeneratedColumn<double>(
    'subtotal_linea',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estadoPreparacionMeta = const VerificationMeta(
    'estadoPreparacion',
  );
  @override
  late final GeneratedColumn<String> estadoPreparacion =
      GeneratedColumn<String>(
        'estado_preparacion',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('EN_COLA'),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    detalleLocalUuid,
    facturaLocalUuid,
    productoId,
    productoNombre,
    cantidad,
    precioUnitario,
    montoImpuesto,
    subtotalLinea,
    estadoPreparacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'historial_detalles';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistorialDetalle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('detalle_local_uuid')) {
      context.handle(
        _detalleLocalUuidMeta,
        detalleLocalUuid.isAcceptableOrUnknown(
          data['detalle_local_uuid']!,
          _detalleLocalUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detalleLocalUuidMeta);
    }
    if (data.containsKey('factura_local_uuid')) {
      context.handle(
        _facturaLocalUuidMeta,
        facturaLocalUuid.isAcceptableOrUnknown(
          data['factura_local_uuid']!,
          _facturaLocalUuidMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_facturaLocalUuidMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('producto_nombre')) {
      context.handle(
        _productoNombreMeta,
        productoNombre.isAcceptableOrUnknown(
          data['producto_nombre']!,
          _productoNombreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productoNombreMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioMeta);
    }
    if (data.containsKey('monto_impuesto')) {
      context.handle(
        _montoImpuestoMeta,
        montoImpuesto.isAcceptableOrUnknown(
          data['monto_impuesto']!,
          _montoImpuestoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoImpuestoMeta);
    }
    if (data.containsKey('subtotal_linea')) {
      context.handle(
        _subtotalLineaMeta,
        subtotalLinea.isAcceptableOrUnknown(
          data['subtotal_linea']!,
          _subtotalLineaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtotalLineaMeta);
    }
    if (data.containsKey('estado_preparacion')) {
      context.handle(
        _estadoPreparacionMeta,
        estadoPreparacion.isAcceptableOrUnknown(
          data['estado_preparacion']!,
          _estadoPreparacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistorialDetalle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistorialDetalle(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      detalleLocalUuid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}detalle_local_uuid'],
          )!,
      facturaLocalUuid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}factura_local_uuid'],
          )!,
      productoId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}producto_id'],
          )!,
      productoNombre:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}producto_nombre'],
          )!,
      cantidad:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}cantidad'],
          )!,
      precioUnitario:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}precio_unitario'],
          )!,
      montoImpuesto:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}monto_impuesto'],
          )!,
      subtotalLinea:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}subtotal_linea'],
          )!,
      estadoPreparacion:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}estado_preparacion'],
          )!,
    );
  }

  @override
  $HistorialDetallesTable createAlias(String alias) {
    return $HistorialDetallesTable(attachedDatabase, alias);
  }
}

class HistorialDetalle extends DataClass
    implements Insertable<HistorialDetalle> {
  final int id;
  final String detalleLocalUuid;
  final String facturaLocalUuid;
  final int productoId;
  final String productoNombre;
  final int cantidad;
  final double precioUnitario;
  final double montoImpuesto;
  final double subtotalLinea;
  final String estadoPreparacion;
  const HistorialDetalle({
    required this.id,
    required this.detalleLocalUuid,
    required this.facturaLocalUuid,
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.montoImpuesto,
    required this.subtotalLinea,
    required this.estadoPreparacion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['detalle_local_uuid'] = Variable<String>(detalleLocalUuid);
    map['factura_local_uuid'] = Variable<String>(facturaLocalUuid);
    map['producto_id'] = Variable<int>(productoId);
    map['producto_nombre'] = Variable<String>(productoNombre);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario'] = Variable<double>(precioUnitario);
    map['monto_impuesto'] = Variable<double>(montoImpuesto);
    map['subtotal_linea'] = Variable<double>(subtotalLinea);
    map['estado_preparacion'] = Variable<String>(estadoPreparacion);
    return map;
  }

  HistorialDetallesCompanion toCompanion(bool nullToAbsent) {
    return HistorialDetallesCompanion(
      id: Value(id),
      detalleLocalUuid: Value(detalleLocalUuid),
      facturaLocalUuid: Value(facturaLocalUuid),
      productoId: Value(productoId),
      productoNombre: Value(productoNombre),
      cantidad: Value(cantidad),
      precioUnitario: Value(precioUnitario),
      montoImpuesto: Value(montoImpuesto),
      subtotalLinea: Value(subtotalLinea),
      estadoPreparacion: Value(estadoPreparacion),
    );
  }

  factory HistorialDetalle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistorialDetalle(
      id: serializer.fromJson<int>(json['id']),
      detalleLocalUuid: serializer.fromJson<String>(json['detalleLocalUuid']),
      facturaLocalUuid: serializer.fromJson<String>(json['facturaLocalUuid']),
      productoId: serializer.fromJson<int>(json['productoId']),
      productoNombre: serializer.fromJson<String>(json['productoNombre']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      montoImpuesto: serializer.fromJson<double>(json['montoImpuesto']),
      subtotalLinea: serializer.fromJson<double>(json['subtotalLinea']),
      estadoPreparacion: serializer.fromJson<String>(json['estadoPreparacion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'detalleLocalUuid': serializer.toJson<String>(detalleLocalUuid),
      'facturaLocalUuid': serializer.toJson<String>(facturaLocalUuid),
      'productoId': serializer.toJson<int>(productoId),
      'productoNombre': serializer.toJson<String>(productoNombre),
      'cantidad': serializer.toJson<int>(cantidad),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'montoImpuesto': serializer.toJson<double>(montoImpuesto),
      'subtotalLinea': serializer.toJson<double>(subtotalLinea),
      'estadoPreparacion': serializer.toJson<String>(estadoPreparacion),
    };
  }

  HistorialDetalle copyWith({
    int? id,
    String? detalleLocalUuid,
    String? facturaLocalUuid,
    int? productoId,
    String? productoNombre,
    int? cantidad,
    double? precioUnitario,
    double? montoImpuesto,
    double? subtotalLinea,
    String? estadoPreparacion,
  }) => HistorialDetalle(
    id: id ?? this.id,
    detalleLocalUuid: detalleLocalUuid ?? this.detalleLocalUuid,
    facturaLocalUuid: facturaLocalUuid ?? this.facturaLocalUuid,
    productoId: productoId ?? this.productoId,
    productoNombre: productoNombre ?? this.productoNombre,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    montoImpuesto: montoImpuesto ?? this.montoImpuesto,
    subtotalLinea: subtotalLinea ?? this.subtotalLinea,
    estadoPreparacion: estadoPreparacion ?? this.estadoPreparacion,
  );
  HistorialDetalle copyWithCompanion(HistorialDetallesCompanion data) {
    return HistorialDetalle(
      id: data.id.present ? data.id.value : this.id,
      detalleLocalUuid:
          data.detalleLocalUuid.present
              ? data.detalleLocalUuid.value
              : this.detalleLocalUuid,
      facturaLocalUuid:
          data.facturaLocalUuid.present
              ? data.facturaLocalUuid.value
              : this.facturaLocalUuid,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
      productoNombre:
          data.productoNombre.present
              ? data.productoNombre.value
              : this.productoNombre,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario:
          data.precioUnitario.present
              ? data.precioUnitario.value
              : this.precioUnitario,
      montoImpuesto:
          data.montoImpuesto.present
              ? data.montoImpuesto.value
              : this.montoImpuesto,
      subtotalLinea:
          data.subtotalLinea.present
              ? data.subtotalLinea.value
              : this.subtotalLinea,
      estadoPreparacion:
          data.estadoPreparacion.present
              ? data.estadoPreparacion.value
              : this.estadoPreparacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistorialDetalle(')
          ..write('id: $id, ')
          ..write('detalleLocalUuid: $detalleLocalUuid, ')
          ..write('facturaLocalUuid: $facturaLocalUuid, ')
          ..write('productoId: $productoId, ')
          ..write('productoNombre: $productoNombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('montoImpuesto: $montoImpuesto, ')
          ..write('subtotalLinea: $subtotalLinea, ')
          ..write('estadoPreparacion: $estadoPreparacion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    detalleLocalUuid,
    facturaLocalUuid,
    productoId,
    productoNombre,
    cantidad,
    precioUnitario,
    montoImpuesto,
    subtotalLinea,
    estadoPreparacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistorialDetalle &&
          other.id == this.id &&
          other.detalleLocalUuid == this.detalleLocalUuid &&
          other.facturaLocalUuid == this.facturaLocalUuid &&
          other.productoId == this.productoId &&
          other.productoNombre == this.productoNombre &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.montoImpuesto == this.montoImpuesto &&
          other.subtotalLinea == this.subtotalLinea &&
          other.estadoPreparacion == this.estadoPreparacion);
}

class HistorialDetallesCompanion extends UpdateCompanion<HistorialDetalle> {
  final Value<int> id;
  final Value<String> detalleLocalUuid;
  final Value<String> facturaLocalUuid;
  final Value<int> productoId;
  final Value<String> productoNombre;
  final Value<int> cantidad;
  final Value<double> precioUnitario;
  final Value<double> montoImpuesto;
  final Value<double> subtotalLinea;
  final Value<String> estadoPreparacion;
  const HistorialDetallesCompanion({
    this.id = const Value.absent(),
    this.detalleLocalUuid = const Value.absent(),
    this.facturaLocalUuid = const Value.absent(),
    this.productoId = const Value.absent(),
    this.productoNombre = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.montoImpuesto = const Value.absent(),
    this.subtotalLinea = const Value.absent(),
    this.estadoPreparacion = const Value.absent(),
  });
  HistorialDetallesCompanion.insert({
    this.id = const Value.absent(),
    required String detalleLocalUuid,
    required String facturaLocalUuid,
    required int productoId,
    required String productoNombre,
    required int cantidad,
    required double precioUnitario,
    required double montoImpuesto,
    required double subtotalLinea,
    this.estadoPreparacion = const Value.absent(),
  }) : detalleLocalUuid = Value(detalleLocalUuid),
       facturaLocalUuid = Value(facturaLocalUuid),
       productoId = Value(productoId),
       productoNombre = Value(productoNombre),
       cantidad = Value(cantidad),
       precioUnitario = Value(precioUnitario),
       montoImpuesto = Value(montoImpuesto),
       subtotalLinea = Value(subtotalLinea);
  static Insertable<HistorialDetalle> custom({
    Expression<int>? id,
    Expression<String>? detalleLocalUuid,
    Expression<String>? facturaLocalUuid,
    Expression<int>? productoId,
    Expression<String>? productoNombre,
    Expression<int>? cantidad,
    Expression<double>? precioUnitario,
    Expression<double>? montoImpuesto,
    Expression<double>? subtotalLinea,
    Expression<String>? estadoPreparacion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (detalleLocalUuid != null) 'detalle_local_uuid': detalleLocalUuid,
      if (facturaLocalUuid != null) 'factura_local_uuid': facturaLocalUuid,
      if (productoId != null) 'producto_id': productoId,
      if (productoNombre != null) 'producto_nombre': productoNombre,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (montoImpuesto != null) 'monto_impuesto': montoImpuesto,
      if (subtotalLinea != null) 'subtotal_linea': subtotalLinea,
      if (estadoPreparacion != null) 'estado_preparacion': estadoPreparacion,
    });
  }

  HistorialDetallesCompanion copyWith({
    Value<int>? id,
    Value<String>? detalleLocalUuid,
    Value<String>? facturaLocalUuid,
    Value<int>? productoId,
    Value<String>? productoNombre,
    Value<int>? cantidad,
    Value<double>? precioUnitario,
    Value<double>? montoImpuesto,
    Value<double>? subtotalLinea,
    Value<String>? estadoPreparacion,
  }) {
    return HistorialDetallesCompanion(
      id: id ?? this.id,
      detalleLocalUuid: detalleLocalUuid ?? this.detalleLocalUuid,
      facturaLocalUuid: facturaLocalUuid ?? this.facturaLocalUuid,
      productoId: productoId ?? this.productoId,
      productoNombre: productoNombre ?? this.productoNombre,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      montoImpuesto: montoImpuesto ?? this.montoImpuesto,
      subtotalLinea: subtotalLinea ?? this.subtotalLinea,
      estadoPreparacion: estadoPreparacion ?? this.estadoPreparacion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (detalleLocalUuid.present) {
      map['detalle_local_uuid'] = Variable<String>(detalleLocalUuid.value);
    }
    if (facturaLocalUuid.present) {
      map['factura_local_uuid'] = Variable<String>(facturaLocalUuid.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (productoNombre.present) {
      map['producto_nombre'] = Variable<String>(productoNombre.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (montoImpuesto.present) {
      map['monto_impuesto'] = Variable<double>(montoImpuesto.value);
    }
    if (subtotalLinea.present) {
      map['subtotal_linea'] = Variable<double>(subtotalLinea.value);
    }
    if (estadoPreparacion.present) {
      map['estado_preparacion'] = Variable<String>(estadoPreparacion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistorialDetallesCompanion(')
          ..write('id: $id, ')
          ..write('detalleLocalUuid: $detalleLocalUuid, ')
          ..write('facturaLocalUuid: $facturaLocalUuid, ')
          ..write('productoId: $productoId, ')
          ..write('productoNombre: $productoNombre, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('montoImpuesto: $montoImpuesto, ')
          ..write('subtotalLinea: $subtotalLinea, ')
          ..write('estadoPreparacion: $estadoPreparacion')
          ..write(')'))
        .toString();
  }
}

class $PromocionesCacheTable extends PromocionesCache
    with TableInfo<$PromocionesCacheTable, PromocionesCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromocionesCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 150),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoDescuentoMeta = const VerificationMeta(
    'tipoDescuento',
  );
  @override
  late final GeneratedColumn<String> tipoDescuento = GeneratedColumn<String>(
    'tipo_descuento',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaFinMeta = const VerificationMeta(
    'fechaFin',
  );
  @override
  late final GeneratedColumn<DateTime> fechaFin = GeneratedColumn<DateTime>(
    'fecha_fin',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _prioridadMeta = const VerificationMeta(
    'prioridad',
  );
  @override
  late final GeneratedColumn<int> prioridad = GeneratedColumn<int>(
    'prioridad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _aplicaAMeta = const VerificationMeta(
    'aplicaA',
  );
  @override
  late final GeneratedColumn<String> aplicaA = GeneratedColumn<String>(
    'aplica_a',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('TODOS'),
  );
  static const VerificationMeta _aplicaHappyHourMeta = const VerificationMeta(
    'aplicaHappyHour',
  );
  @override
  late final GeneratedColumn<bool> aplicaHappyHour = GeneratedColumn<bool>(
    'aplica_happy_hour',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aplica_happy_hour" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _horaInicioHhMeta = const VerificationMeta(
    'horaInicioHh',
  );
  @override
  late final GeneratedColumn<String> horaInicioHh = GeneratedColumn<String>(
    'hora_inicio_hh',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 5),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _horaFinHhMeta = const VerificationMeta(
    'horaFinHh',
  );
  @override
  late final GeneratedColumn<String> horaFinHh = GeneratedColumn<String>(
    'hora_fin_hh',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 5),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precioMinimoFinalMeta = const VerificationMeta(
    'precioMinimoFinal',
  );
  @override
  late final GeneratedColumn<double> precioMinimoFinal =
      GeneratedColumn<double>(
        'precio_minimo_final',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    descripcion,
    tipoDescuento,
    valor,
    fechaInicio,
    fechaFin,
    activo,
    prioridad,
    aplicaA,
    aplicaHappyHour,
    horaInicioHh,
    horaFinHh,
    precioMinimoFinal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promociones_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<PromocionesCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('tipo_descuento')) {
      context.handle(
        _tipoDescuentoMeta,
        tipoDescuento.isAcceptableOrUnknown(
          data['tipo_descuento']!,
          _tipoDescuentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoDescuentoMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('fecha_fin')) {
      context.handle(
        _fechaFinMeta,
        fechaFin.isAcceptableOrUnknown(data['fecha_fin']!, _fechaFinMeta),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('prioridad')) {
      context.handle(
        _prioridadMeta,
        prioridad.isAcceptableOrUnknown(data['prioridad']!, _prioridadMeta),
      );
    }
    if (data.containsKey('aplica_a')) {
      context.handle(
        _aplicaAMeta,
        aplicaA.isAcceptableOrUnknown(data['aplica_a']!, _aplicaAMeta),
      );
    }
    if (data.containsKey('aplica_happy_hour')) {
      context.handle(
        _aplicaHappyHourMeta,
        aplicaHappyHour.isAcceptableOrUnknown(
          data['aplica_happy_hour']!,
          _aplicaHappyHourMeta,
        ),
      );
    }
    if (data.containsKey('hora_inicio_hh')) {
      context.handle(
        _horaInicioHhMeta,
        horaInicioHh.isAcceptableOrUnknown(
          data['hora_inicio_hh']!,
          _horaInicioHhMeta,
        ),
      );
    }
    if (data.containsKey('hora_fin_hh')) {
      context.handle(
        _horaFinHhMeta,
        horaFinHh.isAcceptableOrUnknown(data['hora_fin_hh']!, _horaFinHhMeta),
      );
    }
    if (data.containsKey('precio_minimo_final')) {
      context.handle(
        _precioMinimoFinalMeta,
        precioMinimoFinal.isAcceptableOrUnknown(
          data['precio_minimo_final']!,
          _precioMinimoFinalMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PromocionesCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromocionesCacheData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      nombre:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}nombre'],
          )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      tipoDescuento:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}tipo_descuento'],
          )!,
      valor:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}valor'],
          )!,
      fechaInicio:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}fecha_inicio'],
          )!,
      fechaFin: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_fin'],
      ),
      activo:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}activo'],
          )!,
      prioridad:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}prioridad'],
          )!,
      aplicaA:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}aplica_a'],
          )!,
      aplicaHappyHour:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}aplica_happy_hour'],
          )!,
      horaInicioHh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hora_inicio_hh'],
      ),
      horaFinHh: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hora_fin_hh'],
      ),
      precioMinimoFinal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_minimo_final'],
      ),
    );
  }

  @override
  $PromocionesCacheTable createAlias(String alias) {
    return $PromocionesCacheTable(attachedDatabase, alias);
  }
}

class PromocionesCacheData extends DataClass
    implements Insertable<PromocionesCacheData> {
  final int id;
  final String nombre;
  final String? descripcion;
  final String tipoDescuento;
  final double valor;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final bool activo;
  final int prioridad;
  final String aplicaA;
  final bool aplicaHappyHour;
  final String? horaInicioHh;
  final String? horaFinHh;
  final double? precioMinimoFinal;
  const PromocionesCacheData({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.tipoDescuento,
    required this.valor,
    required this.fechaInicio,
    this.fechaFin,
    required this.activo,
    required this.prioridad,
    required this.aplicaA,
    required this.aplicaHappyHour,
    this.horaInicioHh,
    this.horaFinHh,
    this.precioMinimoFinal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['tipo_descuento'] = Variable<String>(tipoDescuento);
    map['valor'] = Variable<double>(valor);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    if (!nullToAbsent || fechaFin != null) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin);
    }
    map['activo'] = Variable<bool>(activo);
    map['prioridad'] = Variable<int>(prioridad);
    map['aplica_a'] = Variable<String>(aplicaA);
    map['aplica_happy_hour'] = Variable<bool>(aplicaHappyHour);
    if (!nullToAbsent || horaInicioHh != null) {
      map['hora_inicio_hh'] = Variable<String>(horaInicioHh);
    }
    if (!nullToAbsent || horaFinHh != null) {
      map['hora_fin_hh'] = Variable<String>(horaFinHh);
    }
    if (!nullToAbsent || precioMinimoFinal != null) {
      map['precio_minimo_final'] = Variable<double>(precioMinimoFinal);
    }
    return map;
  }

  PromocionesCacheCompanion toCompanion(bool nullToAbsent) {
    return PromocionesCacheCompanion(
      id: Value(id),
      nombre: Value(nombre),
      descripcion:
          descripcion == null && nullToAbsent
              ? const Value.absent()
              : Value(descripcion),
      tipoDescuento: Value(tipoDescuento),
      valor: Value(valor),
      fechaInicio: Value(fechaInicio),
      fechaFin:
          fechaFin == null && nullToAbsent
              ? const Value.absent()
              : Value(fechaFin),
      activo: Value(activo),
      prioridad: Value(prioridad),
      aplicaA: Value(aplicaA),
      aplicaHappyHour: Value(aplicaHappyHour),
      horaInicioHh:
          horaInicioHh == null && nullToAbsent
              ? const Value.absent()
              : Value(horaInicioHh),
      horaFinHh:
          horaFinHh == null && nullToAbsent
              ? const Value.absent()
              : Value(horaFinHh),
      precioMinimoFinal:
          precioMinimoFinal == null && nullToAbsent
              ? const Value.absent()
              : Value(precioMinimoFinal),
    );
  }

  factory PromocionesCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromocionesCacheData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      tipoDescuento: serializer.fromJson<String>(json['tipoDescuento']),
      valor: serializer.fromJson<double>(json['valor']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      fechaFin: serializer.fromJson<DateTime?>(json['fechaFin']),
      activo: serializer.fromJson<bool>(json['activo']),
      prioridad: serializer.fromJson<int>(json['prioridad']),
      aplicaA: serializer.fromJson<String>(json['aplicaA']),
      aplicaHappyHour: serializer.fromJson<bool>(json['aplicaHappyHour']),
      horaInicioHh: serializer.fromJson<String?>(json['horaInicioHh']),
      horaFinHh: serializer.fromJson<String?>(json['horaFinHh']),
      precioMinimoFinal: serializer.fromJson<double?>(
        json['precioMinimoFinal'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'tipoDescuento': serializer.toJson<String>(tipoDescuento),
      'valor': serializer.toJson<double>(valor),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'fechaFin': serializer.toJson<DateTime?>(fechaFin),
      'activo': serializer.toJson<bool>(activo),
      'prioridad': serializer.toJson<int>(prioridad),
      'aplicaA': serializer.toJson<String>(aplicaA),
      'aplicaHappyHour': serializer.toJson<bool>(aplicaHappyHour),
      'horaInicioHh': serializer.toJson<String?>(horaInicioHh),
      'horaFinHh': serializer.toJson<String?>(horaFinHh),
      'precioMinimoFinal': serializer.toJson<double?>(precioMinimoFinal),
    };
  }

  PromocionesCacheData copyWith({
    int? id,
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    String? tipoDescuento,
    double? valor,
    DateTime? fechaInicio,
    Value<DateTime?> fechaFin = const Value.absent(),
    bool? activo,
    int? prioridad,
    String? aplicaA,
    bool? aplicaHappyHour,
    Value<String?> horaInicioHh = const Value.absent(),
    Value<String?> horaFinHh = const Value.absent(),
    Value<double?> precioMinimoFinal = const Value.absent(),
  }) => PromocionesCacheData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    tipoDescuento: tipoDescuento ?? this.tipoDescuento,
    valor: valor ?? this.valor,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    fechaFin: fechaFin.present ? fechaFin.value : this.fechaFin,
    activo: activo ?? this.activo,
    prioridad: prioridad ?? this.prioridad,
    aplicaA: aplicaA ?? this.aplicaA,
    aplicaHappyHour: aplicaHappyHour ?? this.aplicaHappyHour,
    horaInicioHh: horaInicioHh.present ? horaInicioHh.value : this.horaInicioHh,
    horaFinHh: horaFinHh.present ? horaFinHh.value : this.horaFinHh,
    precioMinimoFinal:
        precioMinimoFinal.present
            ? precioMinimoFinal.value
            : this.precioMinimoFinal,
  );
  PromocionesCacheData copyWithCompanion(PromocionesCacheCompanion data) {
    return PromocionesCacheData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      tipoDescuento:
          data.tipoDescuento.present
              ? data.tipoDescuento.value
              : this.tipoDescuento,
      valor: data.valor.present ? data.valor.value : this.valor,
      fechaInicio:
          data.fechaInicio.present ? data.fechaInicio.value : this.fechaInicio,
      fechaFin: data.fechaFin.present ? data.fechaFin.value : this.fechaFin,
      activo: data.activo.present ? data.activo.value : this.activo,
      prioridad: data.prioridad.present ? data.prioridad.value : this.prioridad,
      aplicaA: data.aplicaA.present ? data.aplicaA.value : this.aplicaA,
      aplicaHappyHour:
          data.aplicaHappyHour.present
              ? data.aplicaHappyHour.value
              : this.aplicaHappyHour,
      horaInicioHh:
          data.horaInicioHh.present
              ? data.horaInicioHh.value
              : this.horaInicioHh,
      horaFinHh: data.horaFinHh.present ? data.horaFinHh.value : this.horaFinHh,
      precioMinimoFinal:
          data.precioMinimoFinal.present
              ? data.precioMinimoFinal.value
              : this.precioMinimoFinal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromocionesCacheData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipoDescuento: $tipoDescuento, ')
          ..write('valor: $valor, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('activo: $activo, ')
          ..write('prioridad: $prioridad, ')
          ..write('aplicaA: $aplicaA, ')
          ..write('aplicaHappyHour: $aplicaHappyHour, ')
          ..write('horaInicioHh: $horaInicioHh, ')
          ..write('horaFinHh: $horaFinHh, ')
          ..write('precioMinimoFinal: $precioMinimoFinal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    descripcion,
    tipoDescuento,
    valor,
    fechaInicio,
    fechaFin,
    activo,
    prioridad,
    aplicaA,
    aplicaHappyHour,
    horaInicioHh,
    horaFinHh,
    precioMinimoFinal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromocionesCacheData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.tipoDescuento == this.tipoDescuento &&
          other.valor == this.valor &&
          other.fechaInicio == this.fechaInicio &&
          other.fechaFin == this.fechaFin &&
          other.activo == this.activo &&
          other.prioridad == this.prioridad &&
          other.aplicaA == this.aplicaA &&
          other.aplicaHappyHour == this.aplicaHappyHour &&
          other.horaInicioHh == this.horaInicioHh &&
          other.horaFinHh == this.horaFinHh &&
          other.precioMinimoFinal == this.precioMinimoFinal);
}

class PromocionesCacheCompanion extends UpdateCompanion<PromocionesCacheData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<String> tipoDescuento;
  final Value<double> valor;
  final Value<DateTime> fechaInicio;
  final Value<DateTime?> fechaFin;
  final Value<bool> activo;
  final Value<int> prioridad;
  final Value<String> aplicaA;
  final Value<bool> aplicaHappyHour;
  final Value<String?> horaInicioHh;
  final Value<String?> horaFinHh;
  final Value<double?> precioMinimoFinal;
  const PromocionesCacheCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.tipoDescuento = const Value.absent(),
    this.valor = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.fechaFin = const Value.absent(),
    this.activo = const Value.absent(),
    this.prioridad = const Value.absent(),
    this.aplicaA = const Value.absent(),
    this.aplicaHappyHour = const Value.absent(),
    this.horaInicioHh = const Value.absent(),
    this.horaFinHh = const Value.absent(),
    this.precioMinimoFinal = const Value.absent(),
  });
  PromocionesCacheCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    required String tipoDescuento,
    required double valor,
    required DateTime fechaInicio,
    this.fechaFin = const Value.absent(),
    this.activo = const Value.absent(),
    this.prioridad = const Value.absent(),
    this.aplicaA = const Value.absent(),
    this.aplicaHappyHour = const Value.absent(),
    this.horaInicioHh = const Value.absent(),
    this.horaFinHh = const Value.absent(),
    this.precioMinimoFinal = const Value.absent(),
  }) : nombre = Value(nombre),
       tipoDescuento = Value(tipoDescuento),
       valor = Value(valor),
       fechaInicio = Value(fechaInicio);
  static Insertable<PromocionesCacheData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? tipoDescuento,
    Expression<double>? valor,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? fechaFin,
    Expression<bool>? activo,
    Expression<int>? prioridad,
    Expression<String>? aplicaA,
    Expression<bool>? aplicaHappyHour,
    Expression<String>? horaInicioHh,
    Expression<String>? horaFinHh,
    Expression<double>? precioMinimoFinal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (tipoDescuento != null) 'tipo_descuento': tipoDescuento,
      if (valor != null) 'valor': valor,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (fechaFin != null) 'fecha_fin': fechaFin,
      if (activo != null) 'activo': activo,
      if (prioridad != null) 'prioridad': prioridad,
      if (aplicaA != null) 'aplica_a': aplicaA,
      if (aplicaHappyHour != null) 'aplica_happy_hour': aplicaHappyHour,
      if (horaInicioHh != null) 'hora_inicio_hh': horaInicioHh,
      if (horaFinHh != null) 'hora_fin_hh': horaFinHh,
      if (precioMinimoFinal != null) 'precio_minimo_final': precioMinimoFinal,
    });
  }

  PromocionesCacheCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<String>? tipoDescuento,
    Value<double>? valor,
    Value<DateTime>? fechaInicio,
    Value<DateTime?>? fechaFin,
    Value<bool>? activo,
    Value<int>? prioridad,
    Value<String>? aplicaA,
    Value<bool>? aplicaHappyHour,
    Value<String?>? horaInicioHh,
    Value<String?>? horaFinHh,
    Value<double?>? precioMinimoFinal,
  }) {
    return PromocionesCacheCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tipoDescuento: tipoDescuento ?? this.tipoDescuento,
      valor: valor ?? this.valor,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      activo: activo ?? this.activo,
      prioridad: prioridad ?? this.prioridad,
      aplicaA: aplicaA ?? this.aplicaA,
      aplicaHappyHour: aplicaHappyHour ?? this.aplicaHappyHour,
      horaInicioHh: horaInicioHh ?? this.horaInicioHh,
      horaFinHh: horaFinHh ?? this.horaFinHh,
      precioMinimoFinal: precioMinimoFinal ?? this.precioMinimoFinal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (tipoDescuento.present) {
      map['tipo_descuento'] = Variable<String>(tipoDescuento.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (fechaFin.present) {
      map['fecha_fin'] = Variable<DateTime>(fechaFin.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (prioridad.present) {
      map['prioridad'] = Variable<int>(prioridad.value);
    }
    if (aplicaA.present) {
      map['aplica_a'] = Variable<String>(aplicaA.value);
    }
    if (aplicaHappyHour.present) {
      map['aplica_happy_hour'] = Variable<bool>(aplicaHappyHour.value);
    }
    if (horaInicioHh.present) {
      map['hora_inicio_hh'] = Variable<String>(horaInicioHh.value);
    }
    if (horaFinHh.present) {
      map['hora_fin_hh'] = Variable<String>(horaFinHh.value);
    }
    if (precioMinimoFinal.present) {
      map['precio_minimo_final'] = Variable<double>(precioMinimoFinal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromocionesCacheCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipoDescuento: $tipoDescuento, ')
          ..write('valor: $valor, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('fechaFin: $fechaFin, ')
          ..write('activo: $activo, ')
          ..write('prioridad: $prioridad, ')
          ..write('aplicaA: $aplicaA, ')
          ..write('aplicaHappyHour: $aplicaHappyHour, ')
          ..write('horaInicioHh: $horaInicioHh, ')
          ..write('horaFinHh: $horaFinHh, ')
          ..write('precioMinimoFinal: $precioMinimoFinal')
          ..write(')'))
        .toString();
  }
}

class $PromocionesProductosCacheTable extends PromocionesProductosCache
    with
        TableInfo<
          $PromocionesProductosCacheTable,
          PromocionesProductosCacheData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromocionesProductosCacheTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _promocionIdMeta = const VerificationMeta(
    'promocionId',
  );
  @override
  late final GeneratedColumn<int> promocionId = GeneratedColumn<int>(
    'promocion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  @override
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, promocionId, productoId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promociones_productos_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<PromocionesProductosCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('promocion_id')) {
      context.handle(
        _promocionIdMeta,
        promocionId.isAcceptableOrUnknown(
          data['promocion_id']!,
          _promocionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_promocionIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PromocionesProductosCacheData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromocionesProductosCacheData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      promocionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}promocion_id'],
          )!,
      productoId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}producto_id'],
          )!,
    );
  }

  @override
  $PromocionesProductosCacheTable createAlias(String alias) {
    return $PromocionesProductosCacheTable(attachedDatabase, alias);
  }
}

class PromocionesProductosCacheData extends DataClass
    implements Insertable<PromocionesProductosCacheData> {
  final int id;
  final int promocionId;
  final int productoId;
  const PromocionesProductosCacheData({
    required this.id,
    required this.promocionId,
    required this.productoId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['promocion_id'] = Variable<int>(promocionId);
    map['producto_id'] = Variable<int>(productoId);
    return map;
  }

  PromocionesProductosCacheCompanion toCompanion(bool nullToAbsent) {
    return PromocionesProductosCacheCompanion(
      id: Value(id),
      promocionId: Value(promocionId),
      productoId: Value(productoId),
    );
  }

  factory PromocionesProductosCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromocionesProductosCacheData(
      id: serializer.fromJson<int>(json['id']),
      promocionId: serializer.fromJson<int>(json['promocionId']),
      productoId: serializer.fromJson<int>(json['productoId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'promocionId': serializer.toJson<int>(promocionId),
      'productoId': serializer.toJson<int>(productoId),
    };
  }

  PromocionesProductosCacheData copyWith({
    int? id,
    int? promocionId,
    int? productoId,
  }) => PromocionesProductosCacheData(
    id: id ?? this.id,
    promocionId: promocionId ?? this.promocionId,
    productoId: productoId ?? this.productoId,
  );
  PromocionesProductosCacheData copyWithCompanion(
    PromocionesProductosCacheCompanion data,
  ) {
    return PromocionesProductosCacheData(
      id: data.id.present ? data.id.value : this.id,
      promocionId:
          data.promocionId.present ? data.promocionId.value : this.promocionId,
      productoId:
          data.productoId.present ? data.productoId.value : this.productoId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromocionesProductosCacheData(')
          ..write('id: $id, ')
          ..write('promocionId: $promocionId, ')
          ..write('productoId: $productoId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, promocionId, productoId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromocionesProductosCacheData &&
          other.id == this.id &&
          other.promocionId == this.promocionId &&
          other.productoId == this.productoId);
}

class PromocionesProductosCacheCompanion
    extends UpdateCompanion<PromocionesProductosCacheData> {
  final Value<int> id;
  final Value<int> promocionId;
  final Value<int> productoId;
  const PromocionesProductosCacheCompanion({
    this.id = const Value.absent(),
    this.promocionId = const Value.absent(),
    this.productoId = const Value.absent(),
  });
  PromocionesProductosCacheCompanion.insert({
    this.id = const Value.absent(),
    required int promocionId,
    required int productoId,
  }) : promocionId = Value(promocionId),
       productoId = Value(productoId);
  static Insertable<PromocionesProductosCacheData> custom({
    Expression<int>? id,
    Expression<int>? promocionId,
    Expression<int>? productoId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (promocionId != null) 'promocion_id': promocionId,
      if (productoId != null) 'producto_id': productoId,
    });
  }

  PromocionesProductosCacheCompanion copyWith({
    Value<int>? id,
    Value<int>? promocionId,
    Value<int>? productoId,
  }) {
    return PromocionesProductosCacheCompanion(
      id: id ?? this.id,
      promocionId: promocionId ?? this.promocionId,
      productoId: productoId ?? this.productoId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (promocionId.present) {
      map['promocion_id'] = Variable<int>(promocionId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromocionesProductosCacheCompanion(')
          ..write('id: $id, ')
          ..write('promocionId: $promocionId, ')
          ..write('productoId: $productoId')
          ..write(')'))
        .toString();
  }
}

class $PromocionesCategoriasCacheTable extends PromocionesCategoriasCache
    with
        TableInfo<
          $PromocionesCategoriasCacheTable,
          PromocionesCategoriasCacheData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromocionesCategoriasCacheTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _promocionIdMeta = const VerificationMeta(
    'promocionId',
  );
  @override
  late final GeneratedColumn<int> promocionId = GeneratedColumn<int>(
    'promocion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, promocionId, categoriaId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promociones_categorias_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<PromocionesCategoriasCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('promocion_id')) {
      context.handle(
        _promocionIdMeta,
        promocionId.isAcceptableOrUnknown(
          data['promocion_id']!,
          _promocionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_promocionIdMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PromocionesCategoriasCacheData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromocionesCategoriasCacheData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      promocionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}promocion_id'],
          )!,
      categoriaId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}categoria_id'],
          )!,
    );
  }

  @override
  $PromocionesCategoriasCacheTable createAlias(String alias) {
    return $PromocionesCategoriasCacheTable(attachedDatabase, alias);
  }
}

class PromocionesCategoriasCacheData extends DataClass
    implements Insertable<PromocionesCategoriasCacheData> {
  final int id;
  final int promocionId;
  final int categoriaId;
  const PromocionesCategoriasCacheData({
    required this.id,
    required this.promocionId,
    required this.categoriaId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['promocion_id'] = Variable<int>(promocionId);
    map['categoria_id'] = Variable<int>(categoriaId);
    return map;
  }

  PromocionesCategoriasCacheCompanion toCompanion(bool nullToAbsent) {
    return PromocionesCategoriasCacheCompanion(
      id: Value(id),
      promocionId: Value(promocionId),
      categoriaId: Value(categoriaId),
    );
  }

  factory PromocionesCategoriasCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromocionesCategoriasCacheData(
      id: serializer.fromJson<int>(json['id']),
      promocionId: serializer.fromJson<int>(json['promocionId']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'promocionId': serializer.toJson<int>(promocionId),
      'categoriaId': serializer.toJson<int>(categoriaId),
    };
  }

  PromocionesCategoriasCacheData copyWith({
    int? id,
    int? promocionId,
    int? categoriaId,
  }) => PromocionesCategoriasCacheData(
    id: id ?? this.id,
    promocionId: promocionId ?? this.promocionId,
    categoriaId: categoriaId ?? this.categoriaId,
  );
  PromocionesCategoriasCacheData copyWithCompanion(
    PromocionesCategoriasCacheCompanion data,
  ) {
    return PromocionesCategoriasCacheData(
      id: data.id.present ? data.id.value : this.id,
      promocionId:
          data.promocionId.present ? data.promocionId.value : this.promocionId,
      categoriaId:
          data.categoriaId.present ? data.categoriaId.value : this.categoriaId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromocionesCategoriasCacheData(')
          ..write('id: $id, ')
          ..write('promocionId: $promocionId, ')
          ..write('categoriaId: $categoriaId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, promocionId, categoriaId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromocionesCategoriasCacheData &&
          other.id == this.id &&
          other.promocionId == this.promocionId &&
          other.categoriaId == this.categoriaId);
}

class PromocionesCategoriasCacheCompanion
    extends UpdateCompanion<PromocionesCategoriasCacheData> {
  final Value<int> id;
  final Value<int> promocionId;
  final Value<int> categoriaId;
  const PromocionesCategoriasCacheCompanion({
    this.id = const Value.absent(),
    this.promocionId = const Value.absent(),
    this.categoriaId = const Value.absent(),
  });
  PromocionesCategoriasCacheCompanion.insert({
    this.id = const Value.absent(),
    required int promocionId,
    required int categoriaId,
  }) : promocionId = Value(promocionId),
       categoriaId = Value(categoriaId);
  static Insertable<PromocionesCategoriasCacheData> custom({
    Expression<int>? id,
    Expression<int>? promocionId,
    Expression<int>? categoriaId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (promocionId != null) 'promocion_id': promocionId,
      if (categoriaId != null) 'categoria_id': categoriaId,
    });
  }

  PromocionesCategoriasCacheCompanion copyWith({
    Value<int>? id,
    Value<int>? promocionId,
    Value<int>? categoriaId,
  }) {
    return PromocionesCategoriasCacheCompanion(
      id: id ?? this.id,
      promocionId: promocionId ?? this.promocionId,
      categoriaId: categoriaId ?? this.categoriaId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (promocionId.present) {
      map['promocion_id'] = Variable<int>(promocionId.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromocionesCategoriasCacheCompanion(')
          ..write('id: $id, ')
          ..write('promocionId: $promocionId, ')
          ..write('categoriaId: $categoriaId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SesionClienteTable sesionCliente = $SesionClienteTable(this);
  late final $CategoriasCacheTable categoriasCache = $CategoriasCacheTable(
    this,
  );
  late final $ProductosCacheTable productosCache = $ProductosCacheTable(this);
  late final $MesaActivaTable mesaActiva = $MesaActivaTable(this);
  late final $CarritoLocalTable carritoLocal = $CarritoLocalTable(this);
  late final $HistorialPedidosTable historialPedidos = $HistorialPedidosTable(
    this,
  );
  late final $HistorialDetallesTable historialDetalles =
      $HistorialDetallesTable(this);
  late final $PromocionesCacheTable promocionesCache = $PromocionesCacheTable(
    this,
  );
  late final $PromocionesProductosCacheTable promocionesProductosCache =
      $PromocionesProductosCacheTable(this);
  late final $PromocionesCategoriasCacheTable promocionesCategoriasCache =
      $PromocionesCategoriasCacheTable(this);
  late final SesionDao sesionDao = SesionDao(this as AppDatabase);
  late final CatalogoDao catalogoDao = CatalogoDao(this as AppDatabase);
  late final MesaDao mesaDao = MesaDao(this as AppDatabase);
  late final CarritoDao carritoDao = CarritoDao(this as AppDatabase);
  late final HistorialDao historialDao = HistorialDao(this as AppDatabase);
  late final PromocionesDao promocionesDao = PromocionesDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sesionCliente,
    categoriasCache,
    productosCache,
    mesaActiva,
    carritoLocal,
    historialPedidos,
    historialDetalles,
    promocionesCache,
    promocionesProductosCache,
    promocionesCategoriasCache,
  ];
}

typedef $$SesionClienteTableCreateCompanionBuilder =
    SesionClienteCompanion Function({
      Value<int> id,
      Value<String?> sessionToken,
      Value<String> nombreDisplay,
      Value<String?> email,
      Value<int?> clienteId,
      Value<bool> esInvitado,
      Value<DateTime> creadoEn,
      Value<DateTime?> expiraEn,
    });
typedef $$SesionClienteTableUpdateCompanionBuilder =
    SesionClienteCompanion Function({
      Value<int> id,
      Value<String?> sessionToken,
      Value<String> nombreDisplay,
      Value<String?> email,
      Value<int?> clienteId,
      Value<bool> esInvitado,
      Value<DateTime> creadoEn,
      Value<DateTime?> expiraEn,
    });

class $$SesionClienteTableFilterComposer
    extends Composer<_$AppDatabase, $SesionClienteTable> {
  $$SesionClienteTableFilterComposer({
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

  ColumnFilters<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreDisplay => $composableBuilder(
    column: $table.nombreDisplay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esInvitado => $composableBuilder(
    column: $table.esInvitado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiraEn => $composableBuilder(
    column: $table.expiraEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SesionClienteTableOrderingComposer
    extends Composer<_$AppDatabase, $SesionClienteTable> {
  $$SesionClienteTableOrderingComposer({
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

  ColumnOrderings<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreDisplay => $composableBuilder(
    column: $table.nombreDisplay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esInvitado => $composableBuilder(
    column: $table.esInvitado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiraEn => $composableBuilder(
    column: $table.expiraEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SesionClienteTableAnnotationComposer
    extends Composer<_$AppDatabase, $SesionClienteTable> {
  $$SesionClienteTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreDisplay => $composableBuilder(
    column: $table.nombreDisplay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<bool> get esInvitado => $composableBuilder(
    column: $table.esInvitado,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  GeneratedColumn<DateTime> get expiraEn =>
      $composableBuilder(column: $table.expiraEn, builder: (column) => column);
}

class $$SesionClienteTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SesionClienteTable,
          SesionClienteData,
          $$SesionClienteTableFilterComposer,
          $$SesionClienteTableOrderingComposer,
          $$SesionClienteTableAnnotationComposer,
          $$SesionClienteTableCreateCompanionBuilder,
          $$SesionClienteTableUpdateCompanionBuilder,
          (
            SesionClienteData,
            BaseReferences<
              _$AppDatabase,
              $SesionClienteTable,
              SesionClienteData
            >,
          ),
          SesionClienteData,
          PrefetchHooks Function()
        > {
  $$SesionClienteTableTableManager(_$AppDatabase db, $SesionClienteTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SesionClienteTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$SesionClienteTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SesionClienteTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> sessionToken = const Value.absent(),
                Value<String> nombreDisplay = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int?> clienteId = const Value.absent(),
                Value<bool> esInvitado = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime?> expiraEn = const Value.absent(),
              }) => SesionClienteCompanion(
                id: id,
                sessionToken: sessionToken,
                nombreDisplay: nombreDisplay,
                email: email,
                clienteId: clienteId,
                esInvitado: esInvitado,
                creadoEn: creadoEn,
                expiraEn: expiraEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> sessionToken = const Value.absent(),
                Value<String> nombreDisplay = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<int?> clienteId = const Value.absent(),
                Value<bool> esInvitado = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
                Value<DateTime?> expiraEn = const Value.absent(),
              }) => SesionClienteCompanion.insert(
                id: id,
                sessionToken: sessionToken,
                nombreDisplay: nombreDisplay,
                email: email,
                clienteId: clienteId,
                esInvitado: esInvitado,
                creadoEn: creadoEn,
                expiraEn: expiraEn,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SesionClienteTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SesionClienteTable,
      SesionClienteData,
      $$SesionClienteTableFilterComposer,
      $$SesionClienteTableOrderingComposer,
      $$SesionClienteTableAnnotationComposer,
      $$SesionClienteTableCreateCompanionBuilder,
      $$SesionClienteTableUpdateCompanionBuilder,
      (
        SesionClienteData,
        BaseReferences<_$AppDatabase, $SesionClienteTable, SesionClienteData>,
      ),
      SesionClienteData,
      PrefetchHooks Function()
    >;
typedef $$CategoriasCacheTableCreateCompanionBuilder =
    CategoriasCacheCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> descripcion,
      Value<String?> urlImagenIcono,
      Value<DateTime> sincronizadoEn,
    });
typedef $$CategoriasCacheTableUpdateCompanionBuilder =
    CategoriasCacheCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<String?> urlImagenIcono,
      Value<DateTime> sincronizadoEn,
    });

final class $$CategoriasCacheTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoriasCacheTable,
          CategoriasCacheData
        > {
  $$CategoriasCacheTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ProductosCacheTable, List<ProductosCacheData>>
  _productosCacheRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productosCache,
    aliasName: $_aliasNameGenerator(
      db.categoriasCache.id,
      db.productosCache.categoriaId,
    ),
  );

  $$ProductosCacheTableProcessedTableManager get productosCacheRefs {
    final manager = $$ProductosCacheTableTableManager(
      $_db,
      $_db.productosCache,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productosCacheRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasCacheTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasCacheTable> {
  $$CategoriasCacheTableFilterComposer({
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

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urlImagenIcono => $composableBuilder(
    column: $table.urlImagenIcono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sincronizadoEn => $composableBuilder(
    column: $table.sincronizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productosCacheRefs(
    Expression<bool> Function($$ProductosCacheTableFilterComposer f) f,
  ) {
    final $$ProductosCacheTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productosCache,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosCacheTableFilterComposer(
            $db: $db,
            $table: $db.productosCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasCacheTable> {
  $$CategoriasCacheTableOrderingComposer({
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

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urlImagenIcono => $composableBuilder(
    column: $table.urlImagenIcono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sincronizadoEn => $composableBuilder(
    column: $table.sincronizadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasCacheTable> {
  $$CategoriasCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get urlImagenIcono => $composableBuilder(
    column: $table.urlImagenIcono,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sincronizadoEn => $composableBuilder(
    column: $table.sincronizadoEn,
    builder: (column) => column,
  );

  Expression<T> productosCacheRefs<T extends Object>(
    Expression<T> Function($$ProductosCacheTableAnnotationComposer a) f,
  ) {
    final $$ProductosCacheTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productosCache,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosCacheTableAnnotationComposer(
            $db: $db,
            $table: $db.productosCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasCacheTable,
          CategoriasCacheData,
          $$CategoriasCacheTableFilterComposer,
          $$CategoriasCacheTableOrderingComposer,
          $$CategoriasCacheTableAnnotationComposer,
          $$CategoriasCacheTableCreateCompanionBuilder,
          $$CategoriasCacheTableUpdateCompanionBuilder,
          (CategoriasCacheData, $$CategoriasCacheTableReferences),
          CategoriasCacheData,
          PrefetchHooks Function({bool productosCacheRefs})
        > {
  $$CategoriasCacheTableTableManager(
    _$AppDatabase db,
    $CategoriasCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$CategoriasCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CategoriasCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$CategoriasCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String?> urlImagenIcono = const Value.absent(),
                Value<DateTime> sincronizadoEn = const Value.absent(),
              }) => CategoriasCacheCompanion(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                urlImagenIcono: urlImagenIcono,
                sincronizadoEn: sincronizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                Value<String?> urlImagenIcono = const Value.absent(),
                Value<DateTime> sincronizadoEn = const Value.absent(),
              }) => CategoriasCacheCompanion.insert(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                urlImagenIcono: urlImagenIcono,
                sincronizadoEn: sincronizadoEn,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CategoriasCacheTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({productosCacheRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productosCacheRefs) db.productosCache,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productosCacheRefs)
                    await $_getPrefetchedData<
                      CategoriasCacheData,
                      $CategoriasCacheTable,
                      ProductosCacheData
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriasCacheTableReferences
                          ._productosCacheRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CategoriasCacheTableReferences(
                                db,
                                table,
                                p0,
                              ).productosCacheRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.categoriaId == item.id,
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

typedef $$CategoriasCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasCacheTable,
      CategoriasCacheData,
      $$CategoriasCacheTableFilterComposer,
      $$CategoriasCacheTableOrderingComposer,
      $$CategoriasCacheTableAnnotationComposer,
      $$CategoriasCacheTableCreateCompanionBuilder,
      $$CategoriasCacheTableUpdateCompanionBuilder,
      (CategoriasCacheData, $$CategoriasCacheTableReferences),
      CategoriasCacheData,
      PrefetchHooks Function({bool productosCacheRefs})
    >;
typedef $$ProductosCacheTableCreateCompanionBuilder =
    ProductosCacheCompanion Function({
      Value<int> id,
      Value<String?> sku,
      required String nombre,
      Value<String?> descripcion,
      required double precioBase,
      Value<double> tasaImpuesto,
      Value<bool> estaDisponible,
      Value<String?> imagenUrl,
      required int categoriaId,
      Value<DateTime> sincronizadoEn,
    });
typedef $$ProductosCacheTableUpdateCompanionBuilder =
    ProductosCacheCompanion Function({
      Value<int> id,
      Value<String?> sku,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<double> precioBase,
      Value<double> tasaImpuesto,
      Value<bool> estaDisponible,
      Value<String?> imagenUrl,
      Value<int> categoriaId,
      Value<DateTime> sincronizadoEn,
    });

final class $$ProductosCacheTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProductosCacheTable,
          ProductosCacheData
        > {
  $$ProductosCacheTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriasCacheTable _categoriaIdTable(_$AppDatabase db) =>
      db.categoriasCache.createAlias(
        $_aliasNameGenerator(
          db.productosCache.categoriaId,
          db.categoriasCache.id,
        ),
      );

  $$CategoriasCacheTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasCacheTableTableManager(
      $_db,
      $_db.categoriasCache,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CarritoLocalTable, List<CarritoLocalData>>
  _carritoLocalRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carritoLocal,
    aliasName: $_aliasNameGenerator(
      db.productosCache.id,
      db.carritoLocal.productoId,
    ),
  );

  $$CarritoLocalTableProcessedTableManager get carritoLocalRefs {
    final manager = $$CarritoLocalTableTableManager(
      $_db,
      $_db.carritoLocal,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_carritoLocalRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductosCacheTableFilterComposer
    extends Composer<_$AppDatabase, $ProductosCacheTable> {
  $$ProductosCacheTableFilterComposer({
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

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioBase => $composableBuilder(
    column: $table.precioBase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tasaImpuesto => $composableBuilder(
    column: $table.tasaImpuesto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get estaDisponible => $composableBuilder(
    column: $table.estaDisponible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagenUrl => $composableBuilder(
    column: $table.imagenUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sincronizadoEn => $composableBuilder(
    column: $table.sincronizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasCacheTableFilterComposer get categoriaId {
    final $$CategoriasCacheTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categoriasCache,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasCacheTableFilterComposer(
            $db: $db,
            $table: $db.categoriasCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> carritoLocalRefs(
    Expression<bool> Function($$CarritoLocalTableFilterComposer f) f,
  ) {
    final $$CarritoLocalTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carritoLocal,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarritoLocalTableFilterComposer(
            $db: $db,
            $table: $db.carritoLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductosCacheTable> {
  $$ProductosCacheTableOrderingComposer({
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

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioBase => $composableBuilder(
    column: $table.precioBase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tasaImpuesto => $composableBuilder(
    column: $table.tasaImpuesto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get estaDisponible => $composableBuilder(
    column: $table.estaDisponible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagenUrl => $composableBuilder(
    column: $table.imagenUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sincronizadoEn => $composableBuilder(
    column: $table.sincronizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasCacheTableOrderingComposer get categoriaId {
    final $$CategoriasCacheTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categoriasCache,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasCacheTableOrderingComposer(
            $db: $db,
            $table: $db.categoriasCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductosCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductosCacheTable> {
  $$ProductosCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioBase => $composableBuilder(
    column: $table.precioBase,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tasaImpuesto => $composableBuilder(
    column: $table.tasaImpuesto,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get estaDisponible => $composableBuilder(
    column: $table.estaDisponible,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imagenUrl =>
      $composableBuilder(column: $table.imagenUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get sincronizadoEn => $composableBuilder(
    column: $table.sincronizadoEn,
    builder: (column) => column,
  );

  $$CategoriasCacheTableAnnotationComposer get categoriaId {
    final $$CategoriasCacheTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categoriasCache,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasCacheTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriasCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> carritoLocalRefs<T extends Object>(
    Expression<T> Function($$CarritoLocalTableAnnotationComposer a) f,
  ) {
    final $$CarritoLocalTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carritoLocal,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarritoLocalTableAnnotationComposer(
            $db: $db,
            $table: $db.carritoLocal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductosCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductosCacheTable,
          ProductosCacheData,
          $$ProductosCacheTableFilterComposer,
          $$ProductosCacheTableOrderingComposer,
          $$ProductosCacheTableAnnotationComposer,
          $$ProductosCacheTableCreateCompanionBuilder,
          $$ProductosCacheTableUpdateCompanionBuilder,
          (ProductosCacheData, $$ProductosCacheTableReferences),
          ProductosCacheData,
          PrefetchHooks Function({bool categoriaId, bool carritoLocalRefs})
        > {
  $$ProductosCacheTableTableManager(
    _$AppDatabase db,
    $ProductosCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ProductosCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ProductosCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ProductosCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<double> precioBase = const Value.absent(),
                Value<double> tasaImpuesto = const Value.absent(),
                Value<bool> estaDisponible = const Value.absent(),
                Value<String?> imagenUrl = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
                Value<DateTime> sincronizadoEn = const Value.absent(),
              }) => ProductosCacheCompanion(
                id: id,
                sku: sku,
                nombre: nombre,
                descripcion: descripcion,
                precioBase: precioBase,
                tasaImpuesto: tasaImpuesto,
                estaDisponible: estaDisponible,
                imagenUrl: imagenUrl,
                categoriaId: categoriaId,
                sincronizadoEn: sincronizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                required double precioBase,
                Value<double> tasaImpuesto = const Value.absent(),
                Value<bool> estaDisponible = const Value.absent(),
                Value<String?> imagenUrl = const Value.absent(),
                required int categoriaId,
                Value<DateTime> sincronizadoEn = const Value.absent(),
              }) => ProductosCacheCompanion.insert(
                id: id,
                sku: sku,
                nombre: nombre,
                descripcion: descripcion,
                precioBase: precioBase,
                tasaImpuesto: tasaImpuesto,
                estaDisponible: estaDisponible,
                imagenUrl: imagenUrl,
                categoriaId: categoriaId,
                sincronizadoEn: sincronizadoEn,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ProductosCacheTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            categoriaId = false,
            carritoLocalRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (carritoLocalRefs) db.carritoLocal],
              addJoins: <
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
                if (categoriaId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoriaId,
                            referencedTable: $$ProductosCacheTableReferences
                                ._categoriaIdTable(db),
                            referencedColumn:
                                $$ProductosCacheTableReferences
                                    ._categoriaIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (carritoLocalRefs)
                    await $_getPrefetchedData<
                      ProductosCacheData,
                      $ProductosCacheTable,
                      CarritoLocalData
                    >(
                      currentTable: table,
                      referencedTable: $$ProductosCacheTableReferences
                          ._carritoLocalRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ProductosCacheTableReferences(
                                db,
                                table,
                                p0,
                              ).carritoLocalRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.productoId == item.id,
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

typedef $$ProductosCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductosCacheTable,
      ProductosCacheData,
      $$ProductosCacheTableFilterComposer,
      $$ProductosCacheTableOrderingComposer,
      $$ProductosCacheTableAnnotationComposer,
      $$ProductosCacheTableCreateCompanionBuilder,
      $$ProductosCacheTableUpdateCompanionBuilder,
      (ProductosCacheData, $$ProductosCacheTableReferences),
      ProductosCacheData,
      PrefetchHooks Function({bool categoriaId, bool carritoLocalRefs})
    >;
typedef $$MesaActivaTableCreateCompanionBuilder =
    MesaActivaCompanion Function({
      Value<int> id,
      required int numeroMesa,
      Value<String?> codigoQrMesa,
      Value<String> estadoCuenta,
      Value<String?> facturaLocalUuid,
      Value<DateTime> vinculadoEn,
    });
typedef $$MesaActivaTableUpdateCompanionBuilder =
    MesaActivaCompanion Function({
      Value<int> id,
      Value<int> numeroMesa,
      Value<String?> codigoQrMesa,
      Value<String> estadoCuenta,
      Value<String?> facturaLocalUuid,
      Value<DateTime> vinculadoEn,
    });

class $$MesaActivaTableFilterComposer
    extends Composer<_$AppDatabase, $MesaActivaTable> {
  $$MesaActivaTableFilterComposer({
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

  ColumnFilters<int> get numeroMesa => $composableBuilder(
    column: $table.numeroMesa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoQrMesa => $composableBuilder(
    column: $table.codigoQrMesa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoCuenta => $composableBuilder(
    column: $table.estadoCuenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get facturaLocalUuid => $composableBuilder(
    column: $table.facturaLocalUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get vinculadoEn => $composableBuilder(
    column: $table.vinculadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MesaActivaTableOrderingComposer
    extends Composer<_$AppDatabase, $MesaActivaTable> {
  $$MesaActivaTableOrderingComposer({
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

  ColumnOrderings<int> get numeroMesa => $composableBuilder(
    column: $table.numeroMesa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoQrMesa => $composableBuilder(
    column: $table.codigoQrMesa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoCuenta => $composableBuilder(
    column: $table.estadoCuenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get facturaLocalUuid => $composableBuilder(
    column: $table.facturaLocalUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get vinculadoEn => $composableBuilder(
    column: $table.vinculadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MesaActivaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MesaActivaTable> {
  $$MesaActivaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numeroMesa => $composableBuilder(
    column: $table.numeroMesa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get codigoQrMesa => $composableBuilder(
    column: $table.codigoQrMesa,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estadoCuenta => $composableBuilder(
    column: $table.estadoCuenta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get facturaLocalUuid => $composableBuilder(
    column: $table.facturaLocalUuid,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get vinculadoEn => $composableBuilder(
    column: $table.vinculadoEn,
    builder: (column) => column,
  );
}

class $$MesaActivaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MesaActivaTable,
          MesaActivaData,
          $$MesaActivaTableFilterComposer,
          $$MesaActivaTableOrderingComposer,
          $$MesaActivaTableAnnotationComposer,
          $$MesaActivaTableCreateCompanionBuilder,
          $$MesaActivaTableUpdateCompanionBuilder,
          (
            MesaActivaData,
            BaseReferences<_$AppDatabase, $MesaActivaTable, MesaActivaData>,
          ),
          MesaActivaData,
          PrefetchHooks Function()
        > {
  $$MesaActivaTableTableManager(_$AppDatabase db, $MesaActivaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MesaActivaTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MesaActivaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MesaActivaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> numeroMesa = const Value.absent(),
                Value<String?> codigoQrMesa = const Value.absent(),
                Value<String> estadoCuenta = const Value.absent(),
                Value<String?> facturaLocalUuid = const Value.absent(),
                Value<DateTime> vinculadoEn = const Value.absent(),
              }) => MesaActivaCompanion(
                id: id,
                numeroMesa: numeroMesa,
                codigoQrMesa: codigoQrMesa,
                estadoCuenta: estadoCuenta,
                facturaLocalUuid: facturaLocalUuid,
                vinculadoEn: vinculadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int numeroMesa,
                Value<String?> codigoQrMesa = const Value.absent(),
                Value<String> estadoCuenta = const Value.absent(),
                Value<String?> facturaLocalUuid = const Value.absent(),
                Value<DateTime> vinculadoEn = const Value.absent(),
              }) => MesaActivaCompanion.insert(
                id: id,
                numeroMesa: numeroMesa,
                codigoQrMesa: codigoQrMesa,
                estadoCuenta: estadoCuenta,
                facturaLocalUuid: facturaLocalUuid,
                vinculadoEn: vinculadoEn,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MesaActivaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MesaActivaTable,
      MesaActivaData,
      $$MesaActivaTableFilterComposer,
      $$MesaActivaTableOrderingComposer,
      $$MesaActivaTableAnnotationComposer,
      $$MesaActivaTableCreateCompanionBuilder,
      $$MesaActivaTableUpdateCompanionBuilder,
      (
        MesaActivaData,
        BaseReferences<_$AppDatabase, $MesaActivaTable, MesaActivaData>,
      ),
      MesaActivaData,
      PrefetchHooks Function()
    >;
typedef $$CarritoLocalTableCreateCompanionBuilder =
    CarritoLocalCompanion Function({
      Value<int> id,
      required String detalleLocalUuid,
      required int productoId,
      required String nombreProducto,
      Value<int> cantidad,
      required double precioUnitario,
      Value<double> tasaImpuesto,
      required double subtotalLinea,
      required double montoImpuesto,
      Value<String?> comentariosCocina,
      Value<DateTime> agregadoEn,
    });
typedef $$CarritoLocalTableUpdateCompanionBuilder =
    CarritoLocalCompanion Function({
      Value<int> id,
      Value<String> detalleLocalUuid,
      Value<int> productoId,
      Value<String> nombreProducto,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<double> tasaImpuesto,
      Value<double> subtotalLinea,
      Value<double> montoImpuesto,
      Value<String?> comentariosCocina,
      Value<DateTime> agregadoEn,
    });

final class $$CarritoLocalTableReferences
    extends
        BaseReferences<_$AppDatabase, $CarritoLocalTable, CarritoLocalData> {
  $$CarritoLocalTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductosCacheTable _productoIdTable(_$AppDatabase db) =>
      db.productosCache.createAlias(
        $_aliasNameGenerator(db.carritoLocal.productoId, db.productosCache.id),
      );

  $$ProductosCacheTableProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $$ProductosCacheTableTableManager(
      $_db,
      $_db.productosCache,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CarritoLocalTableFilterComposer
    extends Composer<_$AppDatabase, $CarritoLocalTable> {
  $$CarritoLocalTableFilterComposer({
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

  ColumnFilters<String> get detalleLocalUuid => $composableBuilder(
    column: $table.detalleLocalUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tasaImpuesto => $composableBuilder(
    column: $table.tasaImpuesto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotalLinea => $composableBuilder(
    column: $table.subtotalLinea,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoImpuesto => $composableBuilder(
    column: $table.montoImpuesto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comentariosCocina => $composableBuilder(
    column: $table.comentariosCocina,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get agregadoEn => $composableBuilder(
    column: $table.agregadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductosCacheTableFilterComposer get productoId {
    final $$ProductosCacheTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productosCache,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosCacheTableFilterComposer(
            $db: $db,
            $table: $db.productosCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarritoLocalTableOrderingComposer
    extends Composer<_$AppDatabase, $CarritoLocalTable> {
  $$CarritoLocalTableOrderingComposer({
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

  ColumnOrderings<String> get detalleLocalUuid => $composableBuilder(
    column: $table.detalleLocalUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tasaImpuesto => $composableBuilder(
    column: $table.tasaImpuesto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotalLinea => $composableBuilder(
    column: $table.subtotalLinea,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoImpuesto => $composableBuilder(
    column: $table.montoImpuesto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comentariosCocina => $composableBuilder(
    column: $table.comentariosCocina,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get agregadoEn => $composableBuilder(
    column: $table.agregadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductosCacheTableOrderingComposer get productoId {
    final $$ProductosCacheTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productosCache,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosCacheTableOrderingComposer(
            $db: $db,
            $table: $db.productosCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarritoLocalTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarritoLocalTable> {
  $$CarritoLocalTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get detalleLocalUuid => $composableBuilder(
    column: $table.detalleLocalUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreProducto => $composableBuilder(
    column: $table.nombreProducto,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<double> get tasaImpuesto => $composableBuilder(
    column: $table.tasaImpuesto,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotalLinea => $composableBuilder(
    column: $table.subtotalLinea,
    builder: (column) => column,
  );

  GeneratedColumn<double> get montoImpuesto => $composableBuilder(
    column: $table.montoImpuesto,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comentariosCocina => $composableBuilder(
    column: $table.comentariosCocina,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get agregadoEn => $composableBuilder(
    column: $table.agregadoEn,
    builder: (column) => column,
  );

  $$ProductosCacheTableAnnotationComposer get productoId {
    final $$ProductosCacheTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.productosCache,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductosCacheTableAnnotationComposer(
            $db: $db,
            $table: $db.productosCache,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarritoLocalTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarritoLocalTable,
          CarritoLocalData,
          $$CarritoLocalTableFilterComposer,
          $$CarritoLocalTableOrderingComposer,
          $$CarritoLocalTableAnnotationComposer,
          $$CarritoLocalTableCreateCompanionBuilder,
          $$CarritoLocalTableUpdateCompanionBuilder,
          (CarritoLocalData, $$CarritoLocalTableReferences),
          CarritoLocalData,
          PrefetchHooks Function({bool productoId})
        > {
  $$CarritoLocalTableTableManager(_$AppDatabase db, $CarritoLocalTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CarritoLocalTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CarritoLocalTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$CarritoLocalTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> detalleLocalUuid = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<String> nombreProducto = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<double> tasaImpuesto = const Value.absent(),
                Value<double> subtotalLinea = const Value.absent(),
                Value<double> montoImpuesto = const Value.absent(),
                Value<String?> comentariosCocina = const Value.absent(),
                Value<DateTime> agregadoEn = const Value.absent(),
              }) => CarritoLocalCompanion(
                id: id,
                detalleLocalUuid: detalleLocalUuid,
                productoId: productoId,
                nombreProducto: nombreProducto,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                tasaImpuesto: tasaImpuesto,
                subtotalLinea: subtotalLinea,
                montoImpuesto: montoImpuesto,
                comentariosCocina: comentariosCocina,
                agregadoEn: agregadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String detalleLocalUuid,
                required int productoId,
                required String nombreProducto,
                Value<int> cantidad = const Value.absent(),
                required double precioUnitario,
                Value<double> tasaImpuesto = const Value.absent(),
                required double subtotalLinea,
                required double montoImpuesto,
                Value<String?> comentariosCocina = const Value.absent(),
                Value<DateTime> agregadoEn = const Value.absent(),
              }) => CarritoLocalCompanion.insert(
                id: id,
                detalleLocalUuid: detalleLocalUuid,
                productoId: productoId,
                nombreProducto: nombreProducto,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                tasaImpuesto: tasaImpuesto,
                subtotalLinea: subtotalLinea,
                montoImpuesto: montoImpuesto,
                comentariosCocina: comentariosCocina,
                agregadoEn: agregadoEn,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CarritoLocalTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({productoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (productoId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.productoId,
                            referencedTable: $$CarritoLocalTableReferences
                                ._productoIdTable(db),
                            referencedColumn:
                                $$CarritoLocalTableReferences
                                    ._productoIdTable(db)
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

typedef $$CarritoLocalTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarritoLocalTable,
      CarritoLocalData,
      $$CarritoLocalTableFilterComposer,
      $$CarritoLocalTableOrderingComposer,
      $$CarritoLocalTableAnnotationComposer,
      $$CarritoLocalTableCreateCompanionBuilder,
      $$CarritoLocalTableUpdateCompanionBuilder,
      (CarritoLocalData, $$CarritoLocalTableReferences),
      CarritoLocalData,
      PrefetchHooks Function({bool productoId})
    >;
typedef $$HistorialPedidosTableCreateCompanionBuilder =
    HistorialPedidosCompanion Function({
      Value<int> id,
      required String facturaLocalUuid,
      Value<int?> clienteId,
      required int numeroMesa,
      required double subtotal,
      required double totalImpuestos,
      required double propinaLegal,
      required double totalGeneral,
      Value<double> propinaVoluntaria,
      Value<String> estadoCuenta,
      Value<String?> comentariosCocina,
      Value<DateTime> creadoEn,
    });
typedef $$HistorialPedidosTableUpdateCompanionBuilder =
    HistorialPedidosCompanion Function({
      Value<int> id,
      Value<String> facturaLocalUuid,
      Value<int?> clienteId,
      Value<int> numeroMesa,
      Value<double> subtotal,
      Value<double> totalImpuestos,
      Value<double> propinaLegal,
      Value<double> totalGeneral,
      Value<double> propinaVoluntaria,
      Value<String> estadoCuenta,
      Value<String?> comentariosCocina,
      Value<DateTime> creadoEn,
    });

class $$HistorialPedidosTableFilterComposer
    extends Composer<_$AppDatabase, $HistorialPedidosTable> {
  $$HistorialPedidosTableFilterComposer({
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

  ColumnFilters<String> get facturaLocalUuid => $composableBuilder(
    column: $table.facturaLocalUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numeroMesa => $composableBuilder(
    column: $table.numeroMesa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalImpuestos => $composableBuilder(
    column: $table.totalImpuestos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get propinaLegal => $composableBuilder(
    column: $table.propinaLegal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalGeneral => $composableBuilder(
    column: $table.totalGeneral,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get propinaVoluntaria => $composableBuilder(
    column: $table.propinaVoluntaria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoCuenta => $composableBuilder(
    column: $table.estadoCuenta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comentariosCocina => $composableBuilder(
    column: $table.comentariosCocina,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistorialPedidosTableOrderingComposer
    extends Composer<_$AppDatabase, $HistorialPedidosTable> {
  $$HistorialPedidosTableOrderingComposer({
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

  ColumnOrderings<String> get facturaLocalUuid => $composableBuilder(
    column: $table.facturaLocalUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numeroMesa => $composableBuilder(
    column: $table.numeroMesa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalImpuestos => $composableBuilder(
    column: $table.totalImpuestos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get propinaLegal => $composableBuilder(
    column: $table.propinaLegal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalGeneral => $composableBuilder(
    column: $table.totalGeneral,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get propinaVoluntaria => $composableBuilder(
    column: $table.propinaVoluntaria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoCuenta => $composableBuilder(
    column: $table.estadoCuenta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comentariosCocina => $composableBuilder(
    column: $table.comentariosCocina,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistorialPedidosTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistorialPedidosTable> {
  $$HistorialPedidosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get facturaLocalUuid => $composableBuilder(
    column: $table.facturaLocalUuid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);

  GeneratedColumn<int> get numeroMesa => $composableBuilder(
    column: $table.numeroMesa,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get totalImpuestos => $composableBuilder(
    column: $table.totalImpuestos,
    builder: (column) => column,
  );

  GeneratedColumn<double> get propinaLegal => $composableBuilder(
    column: $table.propinaLegal,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalGeneral => $composableBuilder(
    column: $table.totalGeneral,
    builder: (column) => column,
  );

  GeneratedColumn<double> get propinaVoluntaria => $composableBuilder(
    column: $table.propinaVoluntaria,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estadoCuenta => $composableBuilder(
    column: $table.estadoCuenta,
    builder: (column) => column,
  );

  GeneratedColumn<String> get comentariosCocina => $composableBuilder(
    column: $table.comentariosCocina,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);
}

class $$HistorialPedidosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistorialPedidosTable,
          HistorialPedido,
          $$HistorialPedidosTableFilterComposer,
          $$HistorialPedidosTableOrderingComposer,
          $$HistorialPedidosTableAnnotationComposer,
          $$HistorialPedidosTableCreateCompanionBuilder,
          $$HistorialPedidosTableUpdateCompanionBuilder,
          (
            HistorialPedido,
            BaseReferences<
              _$AppDatabase,
              $HistorialPedidosTable,
              HistorialPedido
            >,
          ),
          HistorialPedido,
          PrefetchHooks Function()
        > {
  $$HistorialPedidosTableTableManager(
    _$AppDatabase db,
    $HistorialPedidosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$HistorialPedidosTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$HistorialPedidosTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$HistorialPedidosTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> facturaLocalUuid = const Value.absent(),
                Value<int?> clienteId = const Value.absent(),
                Value<int> numeroMesa = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> totalImpuestos = const Value.absent(),
                Value<double> propinaLegal = const Value.absent(),
                Value<double> totalGeneral = const Value.absent(),
                Value<double> propinaVoluntaria = const Value.absent(),
                Value<String> estadoCuenta = const Value.absent(),
                Value<String?> comentariosCocina = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => HistorialPedidosCompanion(
                id: id,
                facturaLocalUuid: facturaLocalUuid,
                clienteId: clienteId,
                numeroMesa: numeroMesa,
                subtotal: subtotal,
                totalImpuestos: totalImpuestos,
                propinaLegal: propinaLegal,
                totalGeneral: totalGeneral,
                propinaVoluntaria: propinaVoluntaria,
                estadoCuenta: estadoCuenta,
                comentariosCocina: comentariosCocina,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String facturaLocalUuid,
                Value<int?> clienteId = const Value.absent(),
                required int numeroMesa,
                required double subtotal,
                required double totalImpuestos,
                required double propinaLegal,
                required double totalGeneral,
                Value<double> propinaVoluntaria = const Value.absent(),
                Value<String> estadoCuenta = const Value.absent(),
                Value<String?> comentariosCocina = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => HistorialPedidosCompanion.insert(
                id: id,
                facturaLocalUuid: facturaLocalUuid,
                clienteId: clienteId,
                numeroMesa: numeroMesa,
                subtotal: subtotal,
                totalImpuestos: totalImpuestos,
                propinaLegal: propinaLegal,
                totalGeneral: totalGeneral,
                propinaVoluntaria: propinaVoluntaria,
                estadoCuenta: estadoCuenta,
                comentariosCocina: comentariosCocina,
                creadoEn: creadoEn,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistorialPedidosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistorialPedidosTable,
      HistorialPedido,
      $$HistorialPedidosTableFilterComposer,
      $$HistorialPedidosTableOrderingComposer,
      $$HistorialPedidosTableAnnotationComposer,
      $$HistorialPedidosTableCreateCompanionBuilder,
      $$HistorialPedidosTableUpdateCompanionBuilder,
      (
        HistorialPedido,
        BaseReferences<_$AppDatabase, $HistorialPedidosTable, HistorialPedido>,
      ),
      HistorialPedido,
      PrefetchHooks Function()
    >;
typedef $$HistorialDetallesTableCreateCompanionBuilder =
    HistorialDetallesCompanion Function({
      Value<int> id,
      required String detalleLocalUuid,
      required String facturaLocalUuid,
      required int productoId,
      required String productoNombre,
      required int cantidad,
      required double precioUnitario,
      required double montoImpuesto,
      required double subtotalLinea,
      Value<String> estadoPreparacion,
    });
typedef $$HistorialDetallesTableUpdateCompanionBuilder =
    HistorialDetallesCompanion Function({
      Value<int> id,
      Value<String> detalleLocalUuid,
      Value<String> facturaLocalUuid,
      Value<int> productoId,
      Value<String> productoNombre,
      Value<int> cantidad,
      Value<double> precioUnitario,
      Value<double> montoImpuesto,
      Value<double> subtotalLinea,
      Value<String> estadoPreparacion,
    });

class $$HistorialDetallesTableFilterComposer
    extends Composer<_$AppDatabase, $HistorialDetallesTable> {
  $$HistorialDetallesTableFilterComposer({
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

  ColumnFilters<String> get detalleLocalUuid => $composableBuilder(
    column: $table.detalleLocalUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get facturaLocalUuid => $composableBuilder(
    column: $table.facturaLocalUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productoNombre => $composableBuilder(
    column: $table.productoNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get montoImpuesto => $composableBuilder(
    column: $table.montoImpuesto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotalLinea => $composableBuilder(
    column: $table.subtotalLinea,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estadoPreparacion => $composableBuilder(
    column: $table.estadoPreparacion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HistorialDetallesTableOrderingComposer
    extends Composer<_$AppDatabase, $HistorialDetallesTable> {
  $$HistorialDetallesTableOrderingComposer({
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

  ColumnOrderings<String> get detalleLocalUuid => $composableBuilder(
    column: $table.detalleLocalUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get facturaLocalUuid => $composableBuilder(
    column: $table.facturaLocalUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productoNombre => $composableBuilder(
    column: $table.productoNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get montoImpuesto => $composableBuilder(
    column: $table.montoImpuesto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotalLinea => $composableBuilder(
    column: $table.subtotalLinea,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estadoPreparacion => $composableBuilder(
    column: $table.estadoPreparacion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HistorialDetallesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistorialDetallesTable> {
  $$HistorialDetallesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get detalleLocalUuid => $composableBuilder(
    column: $table.detalleLocalUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get facturaLocalUuid => $composableBuilder(
    column: $table.facturaLocalUuid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productoNombre => $composableBuilder(
    column: $table.productoNombre,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<double> get montoImpuesto => $composableBuilder(
    column: $table.montoImpuesto,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotalLinea => $composableBuilder(
    column: $table.subtotalLinea,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estadoPreparacion => $composableBuilder(
    column: $table.estadoPreparacion,
    builder: (column) => column,
  );
}

class $$HistorialDetallesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistorialDetallesTable,
          HistorialDetalle,
          $$HistorialDetallesTableFilterComposer,
          $$HistorialDetallesTableOrderingComposer,
          $$HistorialDetallesTableAnnotationComposer,
          $$HistorialDetallesTableCreateCompanionBuilder,
          $$HistorialDetallesTableUpdateCompanionBuilder,
          (
            HistorialDetalle,
            BaseReferences<
              _$AppDatabase,
              $HistorialDetallesTable,
              HistorialDetalle
            >,
          ),
          HistorialDetalle,
          PrefetchHooks Function()
        > {
  $$HistorialDetallesTableTableManager(
    _$AppDatabase db,
    $HistorialDetallesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$HistorialDetallesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$HistorialDetallesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$HistorialDetallesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> detalleLocalUuid = const Value.absent(),
                Value<String> facturaLocalUuid = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<String> productoNombre = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<double> montoImpuesto = const Value.absent(),
                Value<double> subtotalLinea = const Value.absent(),
                Value<String> estadoPreparacion = const Value.absent(),
              }) => HistorialDetallesCompanion(
                id: id,
                detalleLocalUuid: detalleLocalUuid,
                facturaLocalUuid: facturaLocalUuid,
                productoId: productoId,
                productoNombre: productoNombre,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                montoImpuesto: montoImpuesto,
                subtotalLinea: subtotalLinea,
                estadoPreparacion: estadoPreparacion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String detalleLocalUuid,
                required String facturaLocalUuid,
                required int productoId,
                required String productoNombre,
                required int cantidad,
                required double precioUnitario,
                required double montoImpuesto,
                required double subtotalLinea,
                Value<String> estadoPreparacion = const Value.absent(),
              }) => HistorialDetallesCompanion.insert(
                id: id,
                detalleLocalUuid: detalleLocalUuid,
                facturaLocalUuid: facturaLocalUuid,
                productoId: productoId,
                productoNombre: productoNombre,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                montoImpuesto: montoImpuesto,
                subtotalLinea: subtotalLinea,
                estadoPreparacion: estadoPreparacion,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HistorialDetallesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistorialDetallesTable,
      HistorialDetalle,
      $$HistorialDetallesTableFilterComposer,
      $$HistorialDetallesTableOrderingComposer,
      $$HistorialDetallesTableAnnotationComposer,
      $$HistorialDetallesTableCreateCompanionBuilder,
      $$HistorialDetallesTableUpdateCompanionBuilder,
      (
        HistorialDetalle,
        BaseReferences<
          _$AppDatabase,
          $HistorialDetallesTable,
          HistorialDetalle
        >,
      ),
      HistorialDetalle,
      PrefetchHooks Function()
    >;
typedef $$PromocionesCacheTableCreateCompanionBuilder =
    PromocionesCacheCompanion Function({
      Value<int> id,
      required String nombre,
      Value<String?> descripcion,
      required String tipoDescuento,
      required double valor,
      required DateTime fechaInicio,
      Value<DateTime?> fechaFin,
      Value<bool> activo,
      Value<int> prioridad,
      Value<String> aplicaA,
      Value<bool> aplicaHappyHour,
      Value<String?> horaInicioHh,
      Value<String?> horaFinHh,
      Value<double?> precioMinimoFinal,
    });
typedef $$PromocionesCacheTableUpdateCompanionBuilder =
    PromocionesCacheCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<String> tipoDescuento,
      Value<double> valor,
      Value<DateTime> fechaInicio,
      Value<DateTime?> fechaFin,
      Value<bool> activo,
      Value<int> prioridad,
      Value<String> aplicaA,
      Value<bool> aplicaHappyHour,
      Value<String?> horaInicioHh,
      Value<String?> horaFinHh,
      Value<double?> precioMinimoFinal,
    });

class $$PromocionesCacheTableFilterComposer
    extends Composer<_$AppDatabase, $PromocionesCacheTable> {
  $$PromocionesCacheTableFilterComposer({
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

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoDescuento => $composableBuilder(
    column: $table.tipoDescuento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get aplicaA => $composableBuilder(
    column: $table.aplicaA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aplicaHappyHour => $composableBuilder(
    column: $table.aplicaHappyHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get horaInicioHh => $composableBuilder(
    column: $table.horaInicioHh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get horaFinHh => $composableBuilder(
    column: $table.horaFinHh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioMinimoFinal => $composableBuilder(
    column: $table.precioMinimoFinal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PromocionesCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $PromocionesCacheTable> {
  $$PromocionesCacheTableOrderingComposer({
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

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoDescuento => $composableBuilder(
    column: $table.tipoDescuento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaFin => $composableBuilder(
    column: $table.fechaFin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prioridad => $composableBuilder(
    column: $table.prioridad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get aplicaA => $composableBuilder(
    column: $table.aplicaA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aplicaHappyHour => $composableBuilder(
    column: $table.aplicaHappyHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get horaInicioHh => $composableBuilder(
    column: $table.horaInicioHh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get horaFinHh => $composableBuilder(
    column: $table.horaFinHh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioMinimoFinal => $composableBuilder(
    column: $table.precioMinimoFinal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PromocionesCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromocionesCacheTable> {
  $$PromocionesCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipoDescuento => $composableBuilder(
    column: $table.tipoDescuento,
    builder: (column) => column,
  );

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fechaFin =>
      $composableBuilder(column: $table.fechaFin, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<int> get prioridad =>
      $composableBuilder(column: $table.prioridad, builder: (column) => column);

  GeneratedColumn<String> get aplicaA =>
      $composableBuilder(column: $table.aplicaA, builder: (column) => column);

  GeneratedColumn<bool> get aplicaHappyHour => $composableBuilder(
    column: $table.aplicaHappyHour,
    builder: (column) => column,
  );

  GeneratedColumn<String> get horaInicioHh => $composableBuilder(
    column: $table.horaInicioHh,
    builder: (column) => column,
  );

  GeneratedColumn<String> get horaFinHh =>
      $composableBuilder(column: $table.horaFinHh, builder: (column) => column);

  GeneratedColumn<double> get precioMinimoFinal => $composableBuilder(
    column: $table.precioMinimoFinal,
    builder: (column) => column,
  );
}

class $$PromocionesCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromocionesCacheTable,
          PromocionesCacheData,
          $$PromocionesCacheTableFilterComposer,
          $$PromocionesCacheTableOrderingComposer,
          $$PromocionesCacheTableAnnotationComposer,
          $$PromocionesCacheTableCreateCompanionBuilder,
          $$PromocionesCacheTableUpdateCompanionBuilder,
          (
            PromocionesCacheData,
            BaseReferences<
              _$AppDatabase,
              $PromocionesCacheTable,
              PromocionesCacheData
            >,
          ),
          PromocionesCacheData,
          PrefetchHooks Function()
        > {
  $$PromocionesCacheTableTableManager(
    _$AppDatabase db,
    $PromocionesCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$PromocionesCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PromocionesCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$PromocionesCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String> tipoDescuento = const Value.absent(),
                Value<double> valor = const Value.absent(),
                Value<DateTime> fechaInicio = const Value.absent(),
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> prioridad = const Value.absent(),
                Value<String> aplicaA = const Value.absent(),
                Value<bool> aplicaHappyHour = const Value.absent(),
                Value<String?> horaInicioHh = const Value.absent(),
                Value<String?> horaFinHh = const Value.absent(),
                Value<double?> precioMinimoFinal = const Value.absent(),
              }) => PromocionesCacheCompanion(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                tipoDescuento: tipoDescuento,
                valor: valor,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                activo: activo,
                prioridad: prioridad,
                aplicaA: aplicaA,
                aplicaHappyHour: aplicaHappyHour,
                horaInicioHh: horaInicioHh,
                horaFinHh: horaFinHh,
                precioMinimoFinal: precioMinimoFinal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                required String tipoDescuento,
                required double valor,
                required DateTime fechaInicio,
                Value<DateTime?> fechaFin = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<int> prioridad = const Value.absent(),
                Value<String> aplicaA = const Value.absent(),
                Value<bool> aplicaHappyHour = const Value.absent(),
                Value<String?> horaInicioHh = const Value.absent(),
                Value<String?> horaFinHh = const Value.absent(),
                Value<double?> precioMinimoFinal = const Value.absent(),
              }) => PromocionesCacheCompanion.insert(
                id: id,
                nombre: nombre,
                descripcion: descripcion,
                tipoDescuento: tipoDescuento,
                valor: valor,
                fechaInicio: fechaInicio,
                fechaFin: fechaFin,
                activo: activo,
                prioridad: prioridad,
                aplicaA: aplicaA,
                aplicaHappyHour: aplicaHappyHour,
                horaInicioHh: horaInicioHh,
                horaFinHh: horaFinHh,
                precioMinimoFinal: precioMinimoFinal,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PromocionesCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromocionesCacheTable,
      PromocionesCacheData,
      $$PromocionesCacheTableFilterComposer,
      $$PromocionesCacheTableOrderingComposer,
      $$PromocionesCacheTableAnnotationComposer,
      $$PromocionesCacheTableCreateCompanionBuilder,
      $$PromocionesCacheTableUpdateCompanionBuilder,
      (
        PromocionesCacheData,
        BaseReferences<
          _$AppDatabase,
          $PromocionesCacheTable,
          PromocionesCacheData
        >,
      ),
      PromocionesCacheData,
      PrefetchHooks Function()
    >;
typedef $$PromocionesProductosCacheTableCreateCompanionBuilder =
    PromocionesProductosCacheCompanion Function({
      Value<int> id,
      required int promocionId,
      required int productoId,
    });
typedef $$PromocionesProductosCacheTableUpdateCompanionBuilder =
    PromocionesProductosCacheCompanion Function({
      Value<int> id,
      Value<int> promocionId,
      Value<int> productoId,
    });

class $$PromocionesProductosCacheTableFilterComposer
    extends Composer<_$AppDatabase, $PromocionesProductosCacheTable> {
  $$PromocionesProductosCacheTableFilterComposer({
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

  ColumnFilters<int> get promocionId => $composableBuilder(
    column: $table.promocionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PromocionesProductosCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $PromocionesProductosCacheTable> {
  $$PromocionesProductosCacheTableOrderingComposer({
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

  ColumnOrderings<int> get promocionId => $composableBuilder(
    column: $table.promocionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PromocionesProductosCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromocionesProductosCacheTable> {
  $$PromocionesProductosCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get promocionId => $composableBuilder(
    column: $table.promocionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => column,
  );
}

class $$PromocionesProductosCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromocionesProductosCacheTable,
          PromocionesProductosCacheData,
          $$PromocionesProductosCacheTableFilterComposer,
          $$PromocionesProductosCacheTableOrderingComposer,
          $$PromocionesProductosCacheTableAnnotationComposer,
          $$PromocionesProductosCacheTableCreateCompanionBuilder,
          $$PromocionesProductosCacheTableUpdateCompanionBuilder,
          (
            PromocionesProductosCacheData,
            BaseReferences<
              _$AppDatabase,
              $PromocionesProductosCacheTable,
              PromocionesProductosCacheData
            >,
          ),
          PromocionesProductosCacheData,
          PrefetchHooks Function()
        > {
  $$PromocionesProductosCacheTableTableManager(
    _$AppDatabase db,
    $PromocionesProductosCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PromocionesProductosCacheTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$PromocionesProductosCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$PromocionesProductosCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> promocionId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
              }) => PromocionesProductosCacheCompanion(
                id: id,
                promocionId: promocionId,
                productoId: productoId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int promocionId,
                required int productoId,
              }) => PromocionesProductosCacheCompanion.insert(
                id: id,
                promocionId: promocionId,
                productoId: productoId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PromocionesProductosCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromocionesProductosCacheTable,
      PromocionesProductosCacheData,
      $$PromocionesProductosCacheTableFilterComposer,
      $$PromocionesProductosCacheTableOrderingComposer,
      $$PromocionesProductosCacheTableAnnotationComposer,
      $$PromocionesProductosCacheTableCreateCompanionBuilder,
      $$PromocionesProductosCacheTableUpdateCompanionBuilder,
      (
        PromocionesProductosCacheData,
        BaseReferences<
          _$AppDatabase,
          $PromocionesProductosCacheTable,
          PromocionesProductosCacheData
        >,
      ),
      PromocionesProductosCacheData,
      PrefetchHooks Function()
    >;
typedef $$PromocionesCategoriasCacheTableCreateCompanionBuilder =
    PromocionesCategoriasCacheCompanion Function({
      Value<int> id,
      required int promocionId,
      required int categoriaId,
    });
typedef $$PromocionesCategoriasCacheTableUpdateCompanionBuilder =
    PromocionesCategoriasCacheCompanion Function({
      Value<int> id,
      Value<int> promocionId,
      Value<int> categoriaId,
    });

class $$PromocionesCategoriasCacheTableFilterComposer
    extends Composer<_$AppDatabase, $PromocionesCategoriasCacheTable> {
  $$PromocionesCategoriasCacheTableFilterComposer({
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

  ColumnFilters<int> get promocionId => $composableBuilder(
    column: $table.promocionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoriaId => $composableBuilder(
    column: $table.categoriaId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PromocionesCategoriasCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $PromocionesCategoriasCacheTable> {
  $$PromocionesCategoriasCacheTableOrderingComposer({
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

  ColumnOrderings<int> get promocionId => $composableBuilder(
    column: $table.promocionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoriaId => $composableBuilder(
    column: $table.categoriaId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PromocionesCategoriasCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromocionesCategoriasCacheTable> {
  $$PromocionesCategoriasCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get promocionId => $composableBuilder(
    column: $table.promocionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get categoriaId => $composableBuilder(
    column: $table.categoriaId,
    builder: (column) => column,
  );
}

class $$PromocionesCategoriasCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromocionesCategoriasCacheTable,
          PromocionesCategoriasCacheData,
          $$PromocionesCategoriasCacheTableFilterComposer,
          $$PromocionesCategoriasCacheTableOrderingComposer,
          $$PromocionesCategoriasCacheTableAnnotationComposer,
          $$PromocionesCategoriasCacheTableCreateCompanionBuilder,
          $$PromocionesCategoriasCacheTableUpdateCompanionBuilder,
          (
            PromocionesCategoriasCacheData,
            BaseReferences<
              _$AppDatabase,
              $PromocionesCategoriasCacheTable,
              PromocionesCategoriasCacheData
            >,
          ),
          PromocionesCategoriasCacheData,
          PrefetchHooks Function()
        > {
  $$PromocionesCategoriasCacheTableTableManager(
    _$AppDatabase db,
    $PromocionesCategoriasCacheTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PromocionesCategoriasCacheTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$PromocionesCategoriasCacheTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$PromocionesCategoriasCacheTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> promocionId = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
              }) => PromocionesCategoriasCacheCompanion(
                id: id,
                promocionId: promocionId,
                categoriaId: categoriaId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int promocionId,
                required int categoriaId,
              }) => PromocionesCategoriasCacheCompanion.insert(
                id: id,
                promocionId: promocionId,
                categoriaId: categoriaId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PromocionesCategoriasCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromocionesCategoriasCacheTable,
      PromocionesCategoriasCacheData,
      $$PromocionesCategoriasCacheTableFilterComposer,
      $$PromocionesCategoriasCacheTableOrderingComposer,
      $$PromocionesCategoriasCacheTableAnnotationComposer,
      $$PromocionesCategoriasCacheTableCreateCompanionBuilder,
      $$PromocionesCategoriasCacheTableUpdateCompanionBuilder,
      (
        PromocionesCategoriasCacheData,
        BaseReferences<
          _$AppDatabase,
          $PromocionesCategoriasCacheTable,
          PromocionesCategoriasCacheData
        >,
      ),
      PromocionesCategoriasCacheData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SesionClienteTableTableManager get sesionCliente =>
      $$SesionClienteTableTableManager(_db, _db.sesionCliente);
  $$CategoriasCacheTableTableManager get categoriasCache =>
      $$CategoriasCacheTableTableManager(_db, _db.categoriasCache);
  $$ProductosCacheTableTableManager get productosCache =>
      $$ProductosCacheTableTableManager(_db, _db.productosCache);
  $$MesaActivaTableTableManager get mesaActiva =>
      $$MesaActivaTableTableManager(_db, _db.mesaActiva);
  $$CarritoLocalTableTableManager get carritoLocal =>
      $$CarritoLocalTableTableManager(_db, _db.carritoLocal);
  $$HistorialPedidosTableTableManager get historialPedidos =>
      $$HistorialPedidosTableTableManager(_db, _db.historialPedidos);
  $$HistorialDetallesTableTableManager get historialDetalles =>
      $$HistorialDetallesTableTableManager(_db, _db.historialDetalles);
  $$PromocionesCacheTableTableManager get promocionesCache =>
      $$PromocionesCacheTableTableManager(_db, _db.promocionesCache);
  $$PromocionesProductosCacheTableTableManager get promocionesProductosCache =>
      $$PromocionesProductosCacheTableTableManager(
        _db,
        _db.promocionesProductosCache,
      );
  $$PromocionesCategoriasCacheTableTableManager
  get promocionesCategoriasCache =>
      $$PromocionesCategoriasCacheTableTableManager(
        _db,
        _db.promocionesCategoriasCache,
      );
}
