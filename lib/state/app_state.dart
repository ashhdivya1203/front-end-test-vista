// lib/state/app_state.dart
import 'package:flutter/foundation.dart';
import '../models/company.dart';
import '../services/api_client.dart';

class AppState extends ChangeNotifier {
  final ApiClient api = ApiClient();

  List<Company> companies = [];
  bool loading = false;
  String? error;

  Future<void> fetchCompanies() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      companies = await api.getCompanies();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> addCompany(String name, String regNo) async {
    try {
      await api.createCompany(name, regNo);
      await fetchCompanies();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> addService(int companyId, String name, String? desc, double price) async {
    try {
      await api.createService(companyId: companyId, name: name, description: desc, price: price);
      await fetchCompanies();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> removeCompany(int id) async {
    try {
      await api.deleteCompany(id);
      await fetchCompanies(); // refresh the list
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

}
