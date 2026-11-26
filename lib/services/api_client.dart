import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) {
    final normalized = baseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
    return Uri.parse('$normalized$path');
  }

  static const _educationPath = '/api/v1/education/';
  static const _educationTimeout = Duration(seconds: 15);

  Future<List<Education>> getEducation() async {
    final response = await _client
        .get(
          _uri(_educationPath),
          headers: const {'Accept': 'application/json'},
        )
        .timeout(_educationTimeout);
    _ensureSuccess(response);
    final entries =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return entries
        .map((entry) => Education.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<Education> getEducationDetail(int id) async {
    final response = await _client
        .get(
          _uri('$_educationPath$id/'),
          headers: const {'Accept': 'application/json'},
        )
        .timeout(_educationTimeout);
    _ensureSuccess(response);
    return _decodeEducation(response);
  }

  Future<Education> createEducation(
    Education entry, {
    required String token,
  }) async {
    final response = await _client
        .post(
          _uri(_educationPath),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $token',
          },
          body: jsonEncode(entry.toJson()),
        )
        .timeout(_educationTimeout);
    _ensureSuccess(response);
    return _decodeEducation(response);
  }

  Education _decodeEducation(http.Response response) => Education.fromJson(
    jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
  );

  // Mengambil daftar proyek
  Future<List<Project>> getProjects() async {
    final response = await _client.get(
      _uri('/api/v1/projects/'),
      headers: const {'Accept': 'application/json'},
    );

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map((item) => Project.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Menambahkan proyek
  Future<Project> createProject(
    Project project, {
    required String token,
  }) async {
    final response = await _client.post(
      _uri('/api/v1/projects/'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(project.toJson()),
    );

    _ensureSuccess(response);

    return Project.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // Login dan memperoleh token
  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _uri('/api/v1/auth/token/'),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'username': username, 'password': password}),
    );

    _ensureSuccess(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    return decoded['token'] as String;
  }

  // Logout
  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: {'Authorization': 'Token $token'},
    );

    _ensureSuccess(response);
  }

  // Memeriksa status HTTP response
  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw ApiException(response.statusCode, response.body);
  }
}
