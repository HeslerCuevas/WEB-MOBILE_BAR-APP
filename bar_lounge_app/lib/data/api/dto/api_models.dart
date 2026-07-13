// ignore_for_file: non_constant_identifier_names

double _parseDouble(dynamic v, {double defaultValue = 0.0}) {
  if (v == null) return defaultValue;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? defaultValue;
  return defaultValue;
}

double? _parseNullableDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

class RegistroRequest {

  final String nombre_completo;
  final String email;
  final String? telefono;
  final String password_plano;

  RegistroRequest({
    required this.nombre_completo,
    required this.email,
    this.telefono,
    required this.password_plano,
  });

  Map<String, dynamic> toJson() => {
        'nombre_completo': nombre_completo,
        'email': email,
        if (telefono != null) 'telefono': telefono,
        'password_plano': password_plano,
      };
}

class RegistroResponse {
  final String mensaje;
  final int cliente_id;
  final String email;
  
  RegistroResponse({
    required this.mensaje,
    required this.cliente_id,
    required this.email,
  });

  factory RegistroResponse.fromJson(Map<String, dynamic> json) =>
      RegistroResponse(
        mensaje: json['mensaje'] as String,
        cliente_id: json['cliente_id'] as int,
        email: json['email'] as String,
      );
}


class LoginRequest {
  final String email;
  final String password_plano;

  LoginRequest({required this.email, required this.password_plano});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password_plano': password_plano,
      };
}

class LoginResponse {
  final String access_token;
  final String token_type;
  final String canal;
  final int cliente_id;
  final String nombre_completo;

  LoginResponse({
    required this.access_token,
    required this.token_type,
    required this.canal,
    required this.cliente_id,
    required this.nombre_completo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        access_token: json['access_token'] as String,
        token_type: json['token_type'] as String,
        canal: json['canal'] as String,
        cliente_id: json['cliente_id'] as int,
        nombre_completo: json['nombre_completo'] as String,
      );
}


class CategoriaDto {
  final int id;
  final String nombre;
  final String descripcion;
  final String url_imagen_icono;

  CategoriaDto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.url_imagen_icono,
  });

  factory CategoriaDto.fromJson(Map<String, dynamic> json) => CategoriaDto(
        id: json['id'] as int,
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String? ?? '',
        url_imagen_icono: json['url_imagen_icono'] as String? ?? '',
      );
}


class ProductoDto {
  final int id;
  final String sku;
  final String nombre;
  final String descripcion;
  final double precio_base;
  final double tasa_impuesto;
  final bool esta_disponible;
  final String imagen_url;

  ProductoDto({
    required this.id,
    required this.sku,
    required this.nombre,
    required this.descripcion,
    required this.precio_base,
    required this.tasa_impuesto,
    required this.esta_disponible,
    required this.imagen_url,
  });


  factory ProductoDto.fromJson(Map<String, dynamic> json) => ProductoDto(
        id: json['id'] as int,
        sku: json['sku'] as String? ?? '',
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String? ?? '',
        precio_base: _parseDouble(json['precio_base']),
        tasa_impuesto: _parseDouble(json['tasa_impuesto'], defaultValue: 0.18),
        esta_disponible: json['esta_disponible'] as bool? ?? true,
        imagen_url: json['imagen_url'] as String? ?? '',
      );
}

class PromocionDto {
  final int id;
  final String nombre;
  final String? descripcion;
  final String tipo_descuento;
  final double valor;
  final String fecha_inicio;
  final String? fecha_fin;
  final bool activo;
  final int prioridad;
  final String aplica_a;
  final bool aplica_happy_hour;
  final String? hora_inicio_hh;
  final String? hora_fin_hh;
  final List<int> producto_ids;
  final List<int> categoria_ids;
  final double? precio_minimo_final;

  PromocionDto({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.tipo_descuento,
    required this.valor,
    required this.fecha_inicio,
    this.fecha_fin,
    required this.activo,
    required this.prioridad,
    required this.aplica_a,
    required this.aplica_happy_hour,
    this.hora_inicio_hh,
    this.hora_fin_hh,
    required this.producto_ids,
    required this.categoria_ids,
    this.precio_minimo_final,
  });

  factory PromocionDto.fromJson(Map<String, dynamic> json) => PromocionDto(
        id: json['id'] as int,
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String?,
        tipo_descuento: json['tipo_descuento'] as String,
        valor: _parseDouble(json['valor']),
        fecha_inicio: json['fecha_inicio'] as String,
        fecha_fin: json['fecha_fin'] as String?,
        activo: json['activo'] as bool? ?? true,
        prioridad: json['prioridad'] as int? ?? 0,
        aplica_a: json['aplica_a'] as String? ?? 'TODOS',
        aplica_happy_hour: json['aplica_happy_hour'] as bool? ?? false,
        hora_inicio_hh: json['hora_inicio_hh'] as String?,
        hora_fin_hh: json['hora_fin_hh'] as String?,
        producto_ids: (json['producto_ids'] as List?)?.map((e) => e as int).toList() ?? [],
        categoria_ids: (json['categoria_ids'] as List?)?.map((e) => e as int).toList() ?? [],
        precio_minimo_final: _parseNullableDouble(json['precio_minimo_final']),
      );
}


class VincularMesaRequest {
  final String codigo_qr_mesa;
  final int numero_mesa;

  VincularMesaRequest({
    required this.codigo_qr_mesa,
    required this.numero_mesa,
  });

  Map<String, dynamic> toJson() => {
        'codigo_qr_mesa': codigo_qr_mesa,
        'numero_mesa': numero_mesa,
      };
}

class VincularMesaResponse {
  final String mensaje;
  final String estado_mesa;
  final int numero_mesa;
  final String? factura_local_uuid_activa;

  VincularMesaResponse({
    required this.mensaje,
    required this.estado_mesa,
    required this.numero_mesa,
    this.factura_local_uuid_activa,
  });

  factory VincularMesaResponse.fromJson(Map<String, dynamic> json) =>
      VincularMesaResponse(
        mensaje: json['mensaje'] as String,
        estado_mesa: json['estado_mesa'] as String,
        numero_mesa: json['numero_mesa'] as int,
        factura_local_uuid_activa:
            json['factura_local_uuid_activa'] as String?,
      );
}


class DetallePedidoCreate {
  final int producto_id;
  final int cantidad;
  final double precio_unitario;
  final double monto_impuesto;
  final double subtotal_linea;
  final String? detalle_local_uuid;

  DetallePedidoCreate({
    required this.producto_id,
    required this.cantidad,
    required this.precio_unitario,
    required this.monto_impuesto,
    required this.subtotal_linea,
    this.detalle_local_uuid,
  });

  Map<String, dynamic> toJson() => {
        'producto_id': producto_id,
        'cantidad': cantidad,
        'precio_unitario': precio_unitario,
        'monto_impuesto': monto_impuesto,
        'subtotal_linea': subtotal_linea,
        if (detalle_local_uuid != null) 'detalle_local_uuid': detalle_local_uuid,
      };
}

class PedidoCreateRequest {
  final int? empleado_id;
  final int? cliente_id;
  final String canal_origen;
  final int? mesa;
  final double subtotal;
  final double total_impuestos;
  final double total_general;
  final double propina_extra;
  final String? factura_local_uuid;
  final List<DetallePedidoCreate> detalles;

  PedidoCreateRequest({
    this.empleado_id,
    this.cliente_id,
    required this.canal_origen,
    this.mesa,
    required this.subtotal,
    required this.total_impuestos,
    required this.total_general,
    this.propina_extra = 0.0,
    this.factura_local_uuid,
    required this.detalles,
  });

  Map<String, dynamic> toJson() => {
        if (empleado_id != null) 'empleado_id': empleado_id,
        if (cliente_id != null) 'cliente_id': cliente_id,
        'canal_origen': canal_origen,
        if (mesa != null) 'mesa': mesa,
        'subtotal': subtotal,
        'total_impuestos': total_impuestos,
        'total_general': total_general,
        'propina_extra': propina_extra,
        if (factura_local_uuid != null) 'factura_local_uuid': factura_local_uuid,
        'detalles': detalles.map((d) => d.toJson()).toList(),
      };
}

class DetallePedidoRequest {
  final int producto_id;
  final int cantidad;
  final double precio_unitario;
  final double monto_impuesto;
  final double subtotal_linea;
  final String? detalle_local_uuid;

  DetallePedidoRequest({
    required this.producto_id,
    required this.cantidad,
    required this.precio_unitario,
    required this.monto_impuesto,
    required this.subtotal_linea,
    this.detalle_local_uuid,
  });

  Map<String, dynamic> toJson() => {
        'producto_id': producto_id,
        'cantidad': cantidad,
        'precio_unitario': precio_unitario,
        'monto_impuesto': monto_impuesto,
        'subtotal_linea': subtotal_linea,
        if (detalle_local_uuid != null) 'detalle_local_uuid': detalle_local_uuid,
      };
}

class PedidoRequest {
  final String? factura_local_uuid;
  final int? mesa;
  final double subtotal;
  final double total_impuestos;
  final double propina_legal;
  final double propina_extra;
  final double total_general;
  final List<DetallePedidoRequest> detalles;

  PedidoRequest({
    this.factura_local_uuid,
    this.mesa,
    required this.subtotal,
    required this.total_impuestos,
    this.propina_legal = 0.0,
    this.propina_extra = 0.0,
    required this.total_general,
    required this.detalles,
  });

  Map<String, dynamic> toJson() => {
        if (factura_local_uuid != null) 'factura_local_uuid': factura_local_uuid,
        if (mesa != null) 'mesa': mesa,
        'subtotal': subtotal,
        'total_impuestos': total_impuestos,
        'propina_legal': propina_legal,
        'propina_extra': propina_extra,
        'total_general': total_general,
        'detalles': detalles.map((d) => d.toJson()).toList(),
      };
}

class DetallePedidoResponse {
  final int id;
  final int producto_id;
  final int cantidad;
  final double precio_unitario_historico;
  final double impuesto_historico;
  final double monto_impuesto;
  final double subtotal_linea;
  final String? detalle_local_uuid;

  DetallePedidoResponse({
    required this.id,
    required this.producto_id,
    required this.cantidad,
    required this.precio_unitario_historico,
    required this.impuesto_historico,
    required this.monto_impuesto,
    required this.subtotal_linea,
    this.detalle_local_uuid,
  });

  factory DetallePedidoResponse.fromJson(Map<String, dynamic> json) =>
      DetallePedidoResponse(
        id: json['id'] as int,
        producto_id: json['producto_id'] as int,
        cantidad: json['cantidad'] as int,
        precio_unitario_historico: _parseDouble(json['precio_unitario_historico']),
        impuesto_historico: _parseDouble(json['impuesto_historico']),
        monto_impuesto: _parseDouble(json['monto_impuesto']),
        subtotal_linea: _parseDouble(json['subtotal_linea']),
        detalle_local_uuid: json['detalle_local_uuid'] as String?,
      );
}

class PedidoResponse {
  final String? mensaje;
  final int? id;
  final String? factura_local_uuid;
  final int? cliente_id;
  final String? canal_origen;
  final int? mesa;
  final String? estado;
  final String? estado_sincronizacion;
  final double? propina_legal;
  final double? subtotal;
  final double? total_impuestos;
  final double? propina_extra;
  final double? total_general;
  final DateTime? fecha_creacion;

  PedidoResponse({
    this.mensaje,
    this.id,
    this.factura_local_uuid,
    this.cliente_id,
    this.canal_origen,
    this.mesa,
    this.estado,
    this.estado_sincronizacion,
    this.propina_legal,
    this.subtotal,
    this.total_impuestos,
    this.propina_extra,
    this.total_general,
    this.fecha_creacion,
  });

factory PedidoResponse.fromJson(Map<String, dynamic> json) {
    double? parseNullableDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return PedidoResponse(
      mensaje: json['mensaje'] as String?,
      id: json['id'] as int?,
      factura_local_uuid: json['factura_local_uuid'] as String?,
      cliente_id: json['cliente_id'] as int?,
      canal_origen: json['canal_origen'] as String?,
      mesa: json['mesa'] as int?,
      estado: json['estado'] as String?,
      estado_sincronizacion: json['estado_sincronizacion'] as String?,
      
      propina_legal: parseNullableDouble(json['propina_legal']),
      subtotal: parseNullableDouble(json['subtotal']),
      total_impuestos: parseNullableDouble(json['total_impuestos']),
      propina_extra: parseNullableDouble(json['propina_extra']),
      total_general: parseNullableDouble(json['total_general']),
      
      fecha_creacion: json['fecha_creacion'] != null 
          ? DateTime.tryParse(json['fecha_creacion'] as String) 
          : null,
    );
  }
}

class CancelarPedidoRequest {
  final int empleado_id;
  final String motivo;

  CancelarPedidoRequest({
    required this.empleado_id,
    required this.motivo,
  });

  Map<String, dynamic> toJson() => {
        'empleado_id': empleado_id,
        'motivo': motivo,
      };
}

class DetalleItemAdicional {
  final String detalle_local_uuid;
  final int producto_id;
  final int cantidad;
  final double precio_unitario;
  final double monto_impuesto;
  final double subtotal_linea;

  DetalleItemAdicional({
    required this.detalle_local_uuid,
    required this.producto_id,
    required this.cantidad,
    required this.precio_unitario,
    required this.monto_impuesto,
    required this.subtotal_linea,
  });

  Map<String, dynamic> toJson() => {
        'detalle_local_uuid': detalle_local_uuid,
        'producto_id': producto_id,
        'cantidad': cantidad,
        'precio_unitario': precio_unitario,
        'monto_impuesto': monto_impuesto,
        'subtotal_linea': subtotal_linea,
      };
}

class AgregarItemsRequest {
  final int? cliente_id;
  final double nuevo_subtotal_agregado;
  final double nuevo_impuesto_agregado;
  final List<DetalleItemAdicional> detalles_adicionales;

  AgregarItemsRequest({
    this.cliente_id,
    required this.nuevo_subtotal_agregado,
    required this.nuevo_impuesto_agregado,
    required this.detalles_adicionales,
  });

  Map<String, dynamic> toJson() => {
        if (cliente_id != null) 'cliente_id': cliente_id,
        'nuevo_subtotal_agregado': nuevo_subtotal_agregado,
        'nuevo_impuesto_agregado': nuevo_impuesto_agregado,
        'detalles_adicionales':
            detalles_adicionales.map((d) => d.toJson()).toList(),
      };
}

class AgregarPedidoResponse {
  final String mensaje;
  final double? nuevo_subtotal;
  final double? nuevo_total_impuestos;
  final double? nuevo_total_general;

  AgregarPedidoResponse({
    required this.mensaje,
    this.nuevo_subtotal,
    this.nuevo_total_impuestos,
    this.nuevo_total_general,
  });

  factory AgregarPedidoResponse.fromJson(Map<String, dynamic> json) =>
      AgregarPedidoResponse(
        mensaje: json['mensaje'] as String? ?? 'Añadido a la cuenta',
        nuevo_subtotal: _parseNullableDouble(json['nuevo_subtotal']),
        nuevo_total_impuestos: _parseNullableDouble(json['nuevo_total_impuestos']),
        nuevo_total_general: _parseNullableDouble(json['nuevo_total_general']),
      );
}

class SolicitarCuentaRequest {
  final String metodo_pago_preferido;
  final double propina_extra;

  SolicitarCuentaRequest({
    this.metodo_pago_preferido = 'EFECTIVO',
    this.propina_extra = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'metodo_pago_preferido': metodo_pago_preferido,
        'propina_extra': propina_extra,
      };
}


class ItemResumen {
  final String producto_nombre;
  final int cantidad;
  final double subtotal_linea;
  final String estado_preparacion;

  ItemResumen({
    required this.producto_nombre,
    required this.cantidad,
    required this.subtotal_linea,
    required this.estado_preparacion,
  });

  factory ItemResumen.fromJson(Map<String, dynamic> json) {
    return ItemResumen(
      producto_nombre: json['producto_nombre'] as String? ?? 'Desconocido',
      cantidad: json['cantidad'] as int? ?? 1,
      subtotal_linea: _parseDouble(json['subtotal_linea']),
      estado_preparacion: json['estado_preparacion'] as String? ?? 'PENDIENTE',
    );
  }
}

class ResumenCuentaResponse {
  final String factura_local_uuid;
  final String estado_cuenta;
  final double subtotal_acumulado;
  final double total_impuestos_acumulado;
  final double propina_legal_acumulada;
  final double propina_extra_acumulada;
  final double total_general_acumulado;
  final List<ItemResumen> items_consumidos;

  ResumenCuentaResponse({
    required this.factura_local_uuid,
    required this.estado_cuenta,
    required this.subtotal_acumulado,
    required this.total_impuestos_acumulado,
    required this.propina_legal_acumulada,
    required this.propina_extra_acumulada,
    required this.total_general_acumulado,
    required this.items_consumidos,
  });

  factory ResumenCuentaResponse.fromJson(Map<String, dynamic> json) {
    return ResumenCuentaResponse(
      factura_local_uuid: json['factura_local_uuid'] as String,
      estado_cuenta: json['estado_cuenta'] as String,
      subtotal_acumulado: _parseDouble(json['subtotal_acumulado']),
      total_impuestos_acumulado: _parseDouble(json['total_impuestos_acumulado']),
      propina_legal_acumulada: _parseDouble(json['propina_legal_acumulada']),
      propina_extra_acumulada: _parseDouble(json['propina_extra_acumulada']),
      total_general_acumulado: _parseDouble(json['total_general_acumulado']),
      items_consumidos: (json['items_consumidos'] as List?)
              ?.map((e) => ItemResumen.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }
}


class LlamarMeseroRequest {
  final String motivo_llamada;

  LlamarMeseroRequest({required this.motivo_llamada});

  Map<String, dynamic> toJson() => {
        'motivo_llamada': motivo_llamada,
      };
}

class MensajeResponse {
  final String mensaje;

  MensajeResponse({required this.mensaje});
  
  factory MensajeResponse.fromJson(Map<String, dynamic> json) =>
      MensajeResponse(mensaje: json['mensaje'] as String);
}


// ─── Password Reset DTOs ───────────────────────────────────────────────────

class SolicitarResetRequest {
  final String email;

  SolicitarResetRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ConfirmarResetRequest {
  final String token;
  final String password_nuevo;

  ConfirmarResetRequest({required this.token, required this.password_nuevo});

  Map<String, dynamic> toJson() => {
        'token': token,
        'password_nuevo': password_nuevo,
      };
}

class ResetResponse {
  final String mensaje;

  ResetResponse({required this.mensaje});

  factory ResetResponse.fromJson(Map<String, dynamic> json) =>
      ResetResponse(mensaje: json['mensaje'] as String? ?? '');
}
