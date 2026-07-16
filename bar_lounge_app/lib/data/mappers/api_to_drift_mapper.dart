import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../api/dto/api_models.dart';


class ApiToDriftMapper {
  ApiToDriftMapper._();

  static CategoriasCacheCompanion categoriaToCompanion(CategoriaDto dto) {
    return CategoriasCacheCompanion.insert(
      id: Value(dto.id),
      nombre: dto.nombre,
      descripcion: Value(dto.descripcion),
      urlImagenIcono: Value(dto.url_imagen_icono),
    );
  }

  static List<CategoriasCacheCompanion> categoriasToCompanions(
      List<CategoriaDto> dtos) {
    return dtos.map(categoriaToCompanion).toList();
  }

  static ProductosCacheCompanion productoToCompanion(
    ProductoDto dto,
    int categoriaId,
  ) {
    return ProductosCacheCompanion.insert(
      id: Value(dto.id),
      nombre: dto.nombre,
      descripcion: Value(dto.descripcion),
      precioBase: dto.precio_base,
      tasaImpuesto: Value(dto.tasa_impuesto),
      estaDisponible: Value(dto.esta_disponible),
      imagenUrl: Value(dto.imagen_url),
      categoriaId: categoriaId,
      sku: Value(dto.sku),
      cantidadDisponible: Value(dto.cantidad_disponible),
    );
  }

  static List<ProductosCacheCompanion> productosToCompanions(
    List<ProductoDto> dtos,
    int categoriaId,
  ) {
    return dtos.map((d) => productoToCompanion(d, categoriaId)).toList();
  }

  static PromocionesCacheCompanion promocionToCompanion(PromocionDto dto) {
    return PromocionesCacheCompanion.insert(
      id: Value(dto.id),
      nombre: dto.nombre,
      descripcion: Value(dto.descripcion),
      tipoDescuento: dto.tipo_descuento,
      valor: dto.valor,
      fechaInicio: DateTime.parse(dto.fecha_inicio),
      fechaFin: Value(dto.fecha_fin != null ? DateTime.parse(dto.fecha_fin!) : null),
      activo: Value(dto.activo),
      prioridad: Value(dto.prioridad),
      aplicaA: Value(dto.aplica_a),
      aplicaHappyHour: Value(dto.aplica_happy_hour),
      horaInicioHh: Value(dto.hora_inicio_hh),
      horaFinHh: Value(dto.hora_fin_hh),
      precioMinimoFinal: Value(dto.precio_minimo_final),
    );
  }

  static List<PromocionesCacheCompanion> promocionesToCompanions(List<PromocionDto> dtos) {
    return dtos.map(promocionToCompanion).toList();
  }

  static List<PromocionesProductosCacheCompanion> promocionProductosToCompanions(PromocionDto dto) {
    return dto.producto_ids.map((prodId) => PromocionesProductosCacheCompanion.insert(
      promocionId: dto.id,
      productoId: prodId,
    )).toList();
  }

  static List<PromocionesCategoriasCacheCompanion> promocionCategoriasToCompanions(PromocionDto dto) {
    return dto.categoria_ids.map((catId) => PromocionesCategoriasCacheCompanion.insert(
      promocionId: dto.id,
      categoriaId: catId,
    )).toList();
  }
}
