import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/sesion_cliente.dart';
import 'tables/categorias_cache.dart';
import 'tables/productos_cache.dart';
import 'tables/mesa_activa.dart';
import 'tables/carrito_local.dart';
import 'tables/historial_pedidos.dart';
import 'tables/historial_detalles.dart';
import 'daos/sesion_dao.dart';
import 'daos/catalogo_dao.dart';
import 'daos/mesa_dao.dart';
import 'daos/carrito_dao.dart';
import 'daos/historial_dao.dart';
import 'daos/promociones_dao.dart';
import 'tables/promociones_cache.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    SesionCliente,
    CategoriasCache,
    ProductosCache,
    MesaActiva,
    CarritoLocal,
    HistorialPedidos,
    HistorialDetalles,
    PromocionesCache,
    PromocionesProductosCache,
    PromocionesCategoriasCache,
  ],
  daos: [SesionDao, CatalogoDao, MesaDao, CarritoDao, HistorialDao, PromocionesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        Future<void> addColumnSafely(TableInfo table, GeneratedColumn column) async {
          try {
            await m.addColumn(table, column);
          } catch (e) {
            if (!e.toString().contains('duplicate column name')) {
              rethrow;
            }
          }
        }

        if (from < 2) {
          await addColumnSafely(sesionCliente, sesionCliente.clienteId);
        }
        if (from < 3) {
          await addColumnSafely(historialPedidos, historialPedidos.clienteId);
        }
        if (from < 4) {
          await addColumnSafely(productosCache, productosCache.imagenUrl);
        }
        if (from < 6) {
          await addColumnSafely(sesionCliente, sesionCliente.email);
        }
        if (from < 7) {
          try { await m.createTable(promocionesCache); } catch (_) {}
          try { await m.createTable(promocionesProductosCache); } catch (_) {}
          try { await m.createTable(promocionesCategoriasCache); } catch (_) {}
        }
        if (from < 8) {
          await addColumnSafely(promocionesCache, promocionesCache.precioMinimoFinal);
        }
      },
    );
  }

  Future<void> _seedData() async {}

  Future<void> clearAllTables() async {
    await customStatement('PRAGMA foreign_keys = OFF');

    try {
      await transaction(() async {
        for (final table in allTables) {
          await delete(table).go();
        }
      });
    } finally {
      await customStatement('PRAGMA foreign_keys = ON');
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nocturnal_bar.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
