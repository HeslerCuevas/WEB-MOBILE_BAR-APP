import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/mesa_activa.dart';

part 'mesa_dao.g.dart';

@DriftAccessor(tables: [MesaActiva])
class MesaDao extends DatabaseAccessor<AppDatabase> with _$MesaDaoMixin {
  MesaDao(super.db);

  Future<MesaActivaData> linkTable({
    required int numeroMesa,
    String? codigoQr,
    String? facturaUuid,
  }) async {
    // Clear any existing active table
    await delete(mesaActiva).go();
    return into(mesaActiva).insertReturning(
      MesaActivaCompanion.insert(
        numeroMesa: numeroMesa,
        codigoQrMesa: Value(codigoQr ?? 'MESA-${numeroMesa.toString().padLeft(2, '0')}'),
        facturaLocalUuid: Value(facturaUuid),
      ),
    );
  }

  Future<MesaActivaData?> getActiveMesa() {
    return (select(mesaActiva)
          ..where((m) => m.estadoCuenta.equals('ABIERTA'))
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<MesaActivaData?> watchActiveMesa() {
    return (select(mesaActiva)
          ..where((m) => m.estadoCuenta.equals('ABIERTA'))
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<void> updateFacturaUuid(int id, String uuid) {
    return (update(mesaActiva)..where((m) => m.id.equals(id))).write(
      MesaActivaCompanion(facturaLocalUuid: Value(uuid)),
    );
  }

  Future<void> closeTable(int id) {
    return (update(mesaActiva)..where((m) => m.id.equals(id))).write(
      const MesaActivaCompanion(estadoCuenta: Value('CERRADA')),
    );
  }
}
