import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'mock_data.dart';

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? 'http://localhost:3000/api';

  final http.Client _client;
  final String _baseUrl;

  Future<UserSession> login({required String email, required String password, required UserRole role}) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role.name,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return UserSession.fromJson(json);
      }
    } catch (_) {}

    return UserSession(
      token: 'offline-token',
      name: 'Modo demostración',
      email: email,
      role: role,
    );
  }

  Future<ReportSummary> fetchSummary() async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/reports/summary'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ReportSummary.fromJson(json);
      }
    } catch (_) {}

    return MockData.summary;
  }

  Future<List<GroupSummary>> fetchGroups() async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/admin/groups'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        return list.map((e) => GroupSummary.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return MockData.groups;
  }

  Future<List<Activity>> fetchActivities({String? type}) async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/activities${type != null ? '?type=$type' : ''}'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        return list.map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return MockData.activities;
  }

  Future<List<Referral>> fetchReferrals() async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/referrals'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        return list.map((e) => Referral.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return MockData.referrals;
  }

  Future<List<Student>> fetchStudents() async {
    try {
      final response = await _client.get(Uri.parse('$_baseUrl/admin/students'));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        return list.map((e) => Student.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return MockData.students;
  }

  Future<bool> createActivity(Map<String, dynamic> payload) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/activities'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<bool> createReferral(Map<String, dynamic> payload) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/referrals'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}
