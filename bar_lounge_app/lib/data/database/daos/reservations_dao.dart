import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/table_reservations.dart';

part 'reservations_dao.g.dart';

@DriftAccessor(tables: [TableReservations])
class ReservationsDao extends DatabaseAccessor<AppDatabase>
    with _$ReservationsDaoMixin {
  ReservationsDao(super.db);

  Stream<List<TableReservation>> watchReservationsForClient(int clienteId) {
    return (select(tableReservations)
          ..where((r) => r.clienteId.equals(clienteId))
          ..orderBy([
            (r) => OrderingTerm(expression: r.resDate, mode: OrderingMode.asc),
            (r) => OrderingTerm(expression: r.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<int> insertReservation(TableReservationsCompanion reservation) {
    return into(tableReservations).insert(reservation);
  }

  Future<void> deleteReservation(int id) async {
    await (delete(tableReservations)..where((r) => r.id.equals(id))).go();
  }

  Future<void> clearReservationsForClient(int clienteId) async {
    await (delete(tableReservations)..where((r) => r.clienteId.equals(clienteId))).go();
  }
}
