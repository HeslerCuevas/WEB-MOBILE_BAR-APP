import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sesion_cliente.dart';

part 'sesion_dao.g.dart';

@DriftAccessor(tables: [SesionCliente])
class SesionDao extends DatabaseAccessor<AppDatabase> with _$SesionDaoMixin {
  SesionDao(super.db);

  Future<SesionClienteData> createGuestSession() {
    return into(sesionCliente).insertReturning(
      SesionClienteCompanion.insert(
        esInvitado: const Value(true),
        nombreDisplay: const Value('Guest'),
      ),
    );
  }

  Future<SesionClienteData> createAuthSession({
    required String token,
    required String nombre,
    int? clienteId,
  }) {
    return into(sesionCliente).insertReturning(
      SesionClienteCompanion.insert(
        sessionToken: Value(token),
        nombreDisplay: Value(nombre),
        clienteId: Value(clienteId),
        esInvitado: const Value(false),
      ),
    );
  }

  Future<SesionClienteData?> getActiveSession() {
    return (select(sesionCliente)
          ..orderBy([(t) => OrderingTerm.desc(t.creadoEn)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<SesionClienteData?> watchActiveSession() {
    return (select(sesionCliente)
          ..orderBy([(t) => OrderingTerm.desc(t.creadoEn)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<int> clearSessions() => delete(sesionCliente).go();
}
