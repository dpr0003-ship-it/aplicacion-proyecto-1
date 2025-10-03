import 'package:flutter/material.dart';
import '../models/test_model.dart';
import '../repositories/test_repository.dart';

class TestProvider with ChangeNotifier {
  final TestRepository _repository = TestRepository();

  TestModel? _test;
  TestModel? get test => _test;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> loadTest(String testId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedTest = await _repository.getTestById(testId);
      if (fetchedTest != null) {
        _test = fetchedTest;
      } else {
        _error = 'Test no encontrado';
      }
    } catch (e) {
      _error = 'Error al cargar test';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearTest() {
    _test = null;
    _error = null;
    notifyListeners();
  }
}