import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/test_model.dart';

class TestRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<TestModel?> getTestById(String testId) async {
    try {
      final doc = await _firestore.collection('tests').doc(testId).get();
      if (doc.exists && doc.data() != null) {
        return TestModel.fromFirestore(doc.id, doc.data()!);
      }
    } catch (e) {
      print('[TestRepository] Error: $e');
    }
    return null;
  }
}
