import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveEmergencyRequest(Map<String, dynamic> requestData) async {
    await _firestore.collection('emergency_requests').add({
      ...requestData,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
  }
}
