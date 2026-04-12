import '../api_client.dart';
import '../dto/api_models.dart';

/// API service for all endpoints from api_contract.md
class ApiService {
  final ApiClient _client;

  ApiService(this._client);

  // ── 2.1 Registration ────────────────────────────────────────
  Future<RegistroResponse> registro(RegistroRequest request) async {
    final response = await _client.dio.post(
      '/clientes/auth/registro',
      data: request.toJson(),
    );
    return RegistroResponse.fromJson(response.data);
  }

  // ── 2.2 Login ───────────────────────────────────────────
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _client.dio.post(
      '/clientes/auth/login',
      data: request.toJson(),
    );
    final loginResponse = LoginResponse.fromJson(response.data);
    // Store token and cliente_id per contract instruction
    await _client.saveToken(loginResponse.access_token, clienteId: loginResponse.cliente_id);
    return loginResponse;
  }

  // ── 3.1 Categories ──────────────────────────────────────
  Future<List<dynamic>> getCategorias({int? lastSyncTimestamp}) async {
    final response = await _client.dio.get(
      '/productos/categorias',
      queryParameters: lastSyncTimestamp != null ? {'last_sync': lastSyncTimestamp} : null,
    );
    return response.data as List;
  }

  // ── 3.1 Full Catalog ─────────────────────────────────
  Future<List<dynamic>> getCatalogo({int? lastSyncTimestamp}) async {
    final response = await _client.dio.get(
      '/productos/',
      queryParameters: lastSyncTimestamp != null ? {'last_sync': lastSyncTimestamp} : null,
    );
    return response.data as List;
  }

  // ── 3.2 Products by Category ─────────────────────────
  Future<List<dynamic>> getProductos(int categoriaId, {int? lastSyncTimestamp}) async {
    final response = await _client.dio.get(
      '/productos/por-categoria/$categoriaId',
      queryParameters: lastSyncTimestamp != null ? {'last_sync': lastSyncTimestamp} : null,
    );
    return response.data as List;
  }

  // ── 4.1 Link Table ───────────────────────────────────
  Future<VincularMesaResponse> vincularMesa(
      VincularMesaRequest request) async {
    final response = await _client.dio.post(
      '/clientes/mesas/vincular',
      data: request.toJson(),
    );
    return VincularMesaResponse.fromJson(response.data);
  }

  // ── 5.1 Create Order ────────────────────────────────────
  Future<CrearPedidoResponse> crearPedido(CrearPedidoRequest request) async {
    final response = await _client.dio.post(
      '/pedidos/',
      data: request.toJson(),
    );
    return CrearPedidoResponse.fromJson(response.data);
  }

  // ── 5.2 Add Items to Order ─────────────────────────
  Future<AgregarPedidoResponse> agregarAPedido(
    String facturaLocalUuid,
    AgregarPedidoRequest request,
  ) async {
    final response = await _client.dio.patch(
      '/clientes/pedidos/$facturaLocalUuid/agregar-items',
      data: request.toJson(),
    );
    return AgregarPedidoResponse.fromJson(response.data);
  }

  // ── 5.3 Bill Summary ───────────────────────────────
  Future<ResumenCuentaResponse> getResumenCuenta(
      String facturaLocalUuid) async {
    final response = await _client.dio.get(
      '/clientes/pedidos/$facturaLocalUuid/resumen',
    );
    return ResumenCuentaResponse.fromJson(response.data);
  }

  // ── 6.1 Request Bill ────────────────────────────────
  Future<MensajeResponse> solicitarCuenta(
    String facturaLocalUuid,
    SolicitarCuentaRequest request,
  ) async {
    final response = await _client.dio.post(
      '/clientes/pedidos/$facturaLocalUuid/solicitar-cuenta',
      data: request.toJson(),
    );
    return MensajeResponse.fromJson(response.data);
  }

  // ── 6.2 Call Waiter ───────────────────────────────────
  Future<MensajeResponse> llamarMesero(
    int numeroMesa,
    LlamarMeseroRequest request,
  ) async {
    final response = await _client.dio.post(
      '/clientes/mesas/$numeroMesa/llamar-mesero',
      data: request.toJson(),
    );
    return MensajeResponse.fromJson(response.data);
  }

  // ── Logout ──────────────────────────────────────────────
  Future<void> logout() async {
    await _client.clearToken();
  }
}
