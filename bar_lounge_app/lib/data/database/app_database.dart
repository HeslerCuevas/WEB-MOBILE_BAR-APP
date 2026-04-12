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
import 'daos/reservations_dao.dart';
import 'tables/table_reservations.dart';

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
    TableReservations,
  ],
  daos: [
    SesionDao,
    CatalogoDao,
    MesaDao,
    CarritoDao,
    HistorialDao,
    ReservationsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(sesionCliente, sesionCliente.clienteId);
        }
        if (from < 3) {
          await m.addColumn(historialPedidos, historialPedidos.clienteId);
        }
        if (from < 4) {
          await m.addColumn(productosCache, productosCache.imagenUrl);
        }
        if (from < 5) {
          await m.createTable(tableReservations);
        }
      },
    );
  }

  /// Seed sample data on first launch
  Future<void> _seedData() async {
    // Intentionally empty. Products and Categories will be fetched from API.
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'nocturnal_bar.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
