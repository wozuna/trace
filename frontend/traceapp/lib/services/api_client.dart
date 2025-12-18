import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? 'http://localhost:3000/api';

  final http.Client _client;
  final String _baseUrl;

  Map<String, String> _jsonHeaders() => {'Content-Type': 'application/json'};

  ApiException _buildException(http.Response response, String context) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data['message'] != null) {
        return ApiException('$context: ${data['message']}');
      }
    } catch (_) {}
    return ApiException('$context (código ${response.statusCode})');
  }

  Map<String, dynamic> _decodeMap(http.Response response, String context) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) return data;
    } catch (_) {}
    throw ApiException('$context: respuesta no válida');
  }

  List<dynamic> _decodeList(http.Response response, String context) {
    try {
      final data = jsonDecode(response.body);
      if (data is List<dynamic>) return data;
    } catch (_) {}
    throw ApiException('$context: respuesta no válida');
  }

  Future<UserSession> login({required String email, required String password, required UserRole role}) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: _jsonHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': role.name,
      }),
    );

    if (response.statusCode != 200) {
      throw _buildException(response, 'No se pudo iniciar sesión');
    }

    final json = _decodeMap(response, 'Login inválido');
    return UserSession.fromJson(json);
  }

  Future<ReportSummary> fetchSummary() async {
    final response = await _client.get(Uri.parse('$_baseUrl/reports/summary'));
    if (response.statusCode != 200) {
      throw _buildException(response, 'No se pudo cargar el resumen');
    }
    final json = _decodeMap(response, 'Resumen inválido');
    return ReportSummary.fromJson(json);
  }

  Future<List<GroupSummary>> fetchGroups() async {
    final response = await _client.get(Uri.parse('$_baseUrl/admin/groups'));
    if (response.statusCode != 200) {
      throw _buildException(response, 'No se pudieron cargar los grupos');
    }
    final list = _decodeList(response, 'Grupos inválidos');
    return list.map((e) => GroupSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Activity>> fetchActivities({String? type}) async {
    final response = await _client.get(Uri.parse('$_baseUrl/activities${type != null ? '?type=$type' : ''}'));
    if (response.statusCode != 200) {
      throw _buildException(response, 'No se pudieron cargar las actividades');
    }
    final list = _decodeList(response, 'Actividades inválidas');
    return list.map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Referral>> fetchReferrals() async {
    final response = await _client.get(Uri.parse('$_baseUrl/referrals'));
    if (response.statusCode != 200) {
      throw _buildException(response, 'No se pudieron cargar las derivaciones');
    }
    final list = _decodeList(response, 'Derivaciones inválidas');
    return list.map((e) => Referral.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Student>> fetchStudents() async {
    final response = await _client.get(Uri.parse('$_baseUrl/admin/students'));
    if (response.statusCode != 200) {
      throw _buildException(response, 'No se pudieron cargar los alumnos');
    }
    final list = _decodeList(response, 'Alumnos inválidos');
    return list.map((e) => Student.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> createActivity(Map<String, dynamic> payload) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/activities'),
      headers: _jsonHeaders(),
      body: jsonEncode(payload),
    );
    if (response.statusCode != 201) {
      throw _buildException(response, 'No se pudo registrar la actividad');
    }
  }

  Future<void> createReferral(Map<String, dynamic> payload) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/referrals'),
      headers: _jsonHeaders(),
      body: jsonEncode(payload),
    );
    if (response.statusCode != 201) {
      throw _buildException(response, 'No se pudo registrar la derivación');
    }
  }
}
