// lib/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/company.dart';

class ApiClient {
  // !! EDIT this depending on emulator/device:
  // Android emulator: http://10.0.2.2:4000
  // iOS simulator / web: http://localhost:4000
  static const String baseUrl = 'http://localhost:4000';

  final http.Client _http = http.Client();

  Future<List<Company>> getCompanies() async {
    final res = await _http.get(Uri.parse('$baseUrl/companies'));
    if (res.statusCode != 200) throw Exception('Failed to load companies: ${res.body}');
    final List data = jsonDecode(res.body) as List;
    return data.map((e) => Company.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Company> createCompany(String name, String regNo) async {
    final res = await _http.post(
      Uri.parse('$baseUrl/companies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'registrationNumber': regNo}),
    );
    if (res.statusCode != 201) throw Exception('Create company failed: ${res.body}');
    return Company.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> createService({
    required int companyId,
    required String name,
    String? description,
    required double price,
  }) async {
    final res = await _http.post(
      Uri.parse('$baseUrl/services'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'companyId': companyId,
        'name': name,
        'description': description,
        'price': price
      }),
    );
    if (res.statusCode != 201) throw Exception('Create service failed: ${res.body}');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getServiceById(int id) async {
    final res = await _http.get(Uri.parse('$baseUrl/services/$id'));
    if (res.statusCode != 200) throw Exception('Get service failed: ${res.body}');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> deleteCompany(int id) async {
    final res = await _http.delete(Uri.parse('$baseUrl/companies/$id'));
    if (res.statusCode != 200) {
      throw Exception('Delete company failed: ${res.body}');
    }
  }

}
