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
    String? email,
    bool emailVerificado = false,
    int? clienteId,
  }) async {
    await clearSessions();
    return into(sesionCliente).insertReturning(
      SesionClienteCompanion.insert(
        sessionToken: Value(token),
        nombreDisplay: Value(nombre),
        email: Value(email),
        emailVerificado: Value(emailVerificado),
        clienteId: Value(clienteId),
        esInvitado: const Value(false),
      ),
    );
  }

  Future<SesionClienteData?> getActiveSession() {
    return (select(sesionCliente)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<SesionClienteData?> watchActiveSession() {
    return (select(sesionCliente)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<void> updateNombre(String nombre) async {
    final session = await getActiveSession();
    if (session != null) {
      await update(sesionCliente).replace(
        session.copyWith(nombreDisplay: nombre),
      );
    }
  }

  Future<void> updateEmailVerification(bool emailVerificado) async {
    final session = await getActiveSession();
    if (session != null) {
      await update(sesionCliente).replace(
        session.copyWith(emailVerificado: emailVerificado),
      );
    }
  }

  Future<void> updateEmail(String email, {bool? emailVerificado}) async {
    final session = await getActiveSession();
    if (session != null) {
      await update(sesionCliente).replace(
        session.copyWith(
          email: Value(email),
          emailVerificado: emailVerificado ?? session.emailVerificado,
        ),
      );
    }
  }

  Future<int> clearSessions() => delete(sesionCliente).go();
}
