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
        precio_base: (json['precio_base'] as num?)?.toDouble() ?? 0.0,
        tasa_impuesto: (json['tasa_impuesto'] as num?)?.toDouble() ?? 0.18,
        esta_disponible: json['esta_disponible'] as bool? ?? true,
        imagen_url: json['imagen_url'] as String? ?? '',
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


class DetallePedidoRequest {

  final String detalle_local_uuid;
  final int producto_id;
  final int cantidad;
  final double precio_unitario;
  final double monto_impuesto;
  final double subtotal_linea;

  DetallePedidoRequest({
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

class CrearPedidoRequest {
  final int numero_mesa;
  final int cliente_id;
  final String factura_local_uuid;
  final double subtotal;
  final double total_impuestos;
  final double propina_legal;
  final double propina_extra;
  final double total_general;
  final String? comentarios_cocina;

  final List<DetallePedidoRequest> detalles;

  CrearPedidoRequest({
    required this.numero_mesa,
    required this.cliente_id,
    required this.factura_local_uuid,
    required this.subtotal,
    required this.total_impuestos,
    required this.propina_legal,
    required this.propina_extra,
    required this.total_general,
    this.comentarios_cocina,
    required this.detalles,
  });

  Map<String, dynamic> toJson() => {
        'numero_mesa': numero_mesa,
        'mesa': numero_mesa,
        'cliente_id': cliente_id,
        'factura_local_uuid': factura_local_uuid,
        'subtotal': subtotal,
        'total_impuestos': total_impuestos,
        'propina_legal': propina_legal,
        'propina_extra': propina_extra,
        'total_general': total_general,
        if (comentarios_cocina != null)
          'comentarios_cocina': comentarios_cocina,
        'detalles': detalles.map((d) => d.toJson()).toList(),
      };
}

class CrearPedidoResponse {
  final String mensaje;
  final String? factura_local_uuid;
  final String? estado_sincronizacion;
  final String? estado_preparacion;

  CrearPedidoResponse({
    required this.mensaje,
    this.factura_local_uuid,
    this.estado_sincronizacion,
    this.estado_preparacion,
  });

  factory CrearPedidoResponse.fromJson(Map<String, dynamic> json) =>
      CrearPedidoResponse(
        mensaje: json['mensaje'] as String,
        factura_local_uuid: json['factura_local_uuid'] as String?,
        estado_sincronizacion: json['estado_sincronizacion'] as String?,
        estado_preparacion: json['estado_preparacion'] as String?,
      );
}


class AgregarPedidoRequest {
  final int cliente_id;
  final int numero_mesa;
  final String? comentarios_cocina;
  final double nuevo_subtotal_agregado;
  final double nuevo_impuesto_agregado;
  final double nueva_propina_agregada;
  final double nuevo_total_agregado;
  final List<DetallePedidoRequest> detalles_adicionales;

  AgregarPedidoRequest({
    required this.cliente_id,
    required this.numero_mesa,
    this.comentarios_cocina,
    required this.nuevo_subtotal_agregado,
    required this.nuevo_impuesto_agregado,
    required this.nueva_propina_agregada,
    required this.nuevo_total_agregado,
    required this.detalles_adicionales,
  });

  Map<String, dynamic> toJson() => {
        'cliente_id': cliente_id,
        'numero_mesa': numero_mesa,
        'mesa': numero_mesa,
        if (comentarios_cocina != null)
          'comentarios_cocina': comentarios_cocina,
        'nuevo_subtotal_agregado': nuevo_subtotal_agregado,
        'nuevo_impuesto_agregado': nuevo_impuesto_agregado,
        'nueva_propina_agregada': nueva_propina_agregada,
        'nuevo_total_agregado': nuevo_total_agregado,
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
        nuevo_subtotal: (json['nuevo_subtotal'] as num?)?.toDouble(),
        nuevo_total_impuestos: (json['nuevo_total_impuestos'] as num?)?.toDouble(),
        nuevo_total_general: (json['nuevo_total_general'] as num?)?.toDouble(),
      );
}


class ItemConsumidoDto {
  final String producto_nombre;
  final int cantidad;
  final double subtotal_linea;
  final String estado_preparacion;

  ItemConsumidoDto({
    required this.producto_nombre,
    required this.cantidad,
    required this.subtotal_linea,
    required this.estado_preparacion,
  });

  factory ItemConsumidoDto.fromJson(Map<String, dynamic> json) =>
      ItemConsumidoDto(
        producto_nombre: json['producto_nombre'] as String,
        cantidad: json['cantidad'] as int,
        subtotal_linea: (json['subtotal_linea'] as num).toDouble(),
        estado_preparacion: json['estado_preparacion'] as String,
      );
}

class ResumenCuentaResponse {
  final String factura_local_uuid;
  final String estado_cuenta;
  final double subtotal_acumulado;
  final double total_impuestos_acumulado;
  final double propina_legal_acumulada;
  final double total_general_acumulado;
  final List<ItemConsumidoDto> items_consumidos;

  ResumenCuentaResponse({
    required this.factura_local_uuid,
    required this.estado_cuenta,
    required this.subtotal_acumulado,
    required this.total_impuestos_acumulado,
    required this.propina_legal_acumulada,
    required this.total_general_acumulado,
    required this.items_consumidos,
  });

  factory ResumenCuentaResponse.fromJson(Map<String, dynamic> json) =>
      ResumenCuentaResponse(
        factura_local_uuid: json['factura_local_uuid'] as String,
        estado_cuenta: json['estado_cuenta'] as String,
        subtotal_acumulado:
            (json['subtotal_acumulado'] as num).toDouble(),
        total_impuestos_acumulado:
            (json['total_impuestos_acumulado'] as num).toDouble(),
        propina_legal_acumulada:
            (json['propina_legal_acumulada'] as num).toDouble(),
        total_general_acumulado:
            (json['total_general_acumulado'] as num).toDouble(),
        items_consumidos: (json['items_consumidos'] as List)
            .map((e) => ItemConsumidoDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}


class SolicitarCuentaRequest {
  final int numero_mesa;
  final String metodo_pago_preferido;
  final double propina_extra;
  final bool requiere_comprobante_fiscal;
  final String? rnc_comprobante;

  SolicitarCuentaRequest({
    required this.numero_mesa,
    required this.metodo_pago_preferido,
    required this.propina_extra,
    required this.requiere_comprobante_fiscal,
    this.rnc_comprobante,
  });

  Map<String, dynamic> toJson() => {
        'numero_mesa': numero_mesa,
        'mesa': numero_mesa,
        'metodo_pago_preferido': metodo_pago_preferido,
        'propina_extra': propina_extra,
        'requiere_comprobante_fiscal': requiere_comprobante_fiscal,
        'rnc_comprobante': rnc_comprobante,
      };
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
