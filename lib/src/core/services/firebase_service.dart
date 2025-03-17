import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User operations
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    String? phone,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  // Crop operations
  Future<void> addCrop({
    required String userId,
    required String name,
    required String variety,
    required DateTime plantingDate,
    required DateTime expectedHarvestDate,
    required String status,
  }) async {
    await _firestore.collection('crops').add({
      'userId': userId,
      'name': name,
      'variety': variety,
      'plantingDate': plantingDate,
      'expectedHarvestDate': expectedHarvestDate,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getUserCrops(String userId) {
    return _firestore
        .collection('crops')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList());
  }

  Future<void> updateCrop(String cropId, Map<String, dynamic> data) async {
    await _firestore.collection('crops').doc(cropId).update(data);
  }

  Future<void> deleteCrop(String cropId) async {
    await _firestore.collection('crops').doc(cropId).delete();
  }

  // Advisory operations
  Future<void> addAdvisory({
    required String cropId,
    required String title,
    required String description,
  }) async {
    await _firestore.collection('advisories').add({
      'cropId': cropId,
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getCropAdvisories(String cropId) {
    return _firestore
        .collection('advisories')
        .where('cropId', isEqualTo: cropId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList());
  }

  // Weather data operations
  Future<void> saveWeatherData({
    required String location,
    required Map<String, dynamic> weatherData,
  }) async {
    await _firestore.collection('weather_data').doc(location).set({
      ...weatherData,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getWeatherData(String location) async {
    final doc = await _firestore.collection('weather_data').doc(location).get();
    return doc.data();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
} 