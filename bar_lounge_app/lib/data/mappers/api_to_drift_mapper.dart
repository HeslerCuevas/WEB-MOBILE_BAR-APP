import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../api/dto/api_models.dart';

/// Maps API response DTOs to Drift companion objects for local persistence
class ApiToDriftMapper {
  ApiToDriftMapper._();

  // ── Categorías ──────────────────────────────────────────────
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

  // ── Productos ───────────────────────────────────────────────
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
    );
  }

  static List<ProductosCacheCompanion> productosToCompanions(
    List<ProductoDto> dtos,
    int categoriaId,
  ) {
    return dtos.map((d) => productoToCompanion(d, categoriaId)).toList();
  }
}
