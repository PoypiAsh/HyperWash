import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<UserCredential> register(
    String fullName,
    String email,
    String password,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    await credential.user!.updateDisplayName(fullName);

    await _firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'fullName': fullName,
      'email': email.trim(),
      'role': 'customer',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  static Future<void> placeOrder({
    required String serviceName,
    required int quantity,
    required int unitPrice,
    required String pickupAddress,
    required String notes,
    required DateTime pickupDate,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please log in before placing an order.');
    }

    await _firestore.collection('orders').add({
      'customerId': user.uid,
      'customerName': user.displayName ?? 'Customer',
      'customerEmail': user.email ?? '',
      'serviceName': serviceName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'estimatedTotal': quantity * unitPrice,
      'pickupAddress': pickupAddress,
      'notes': notes,
      'pickupDate': Timestamp.fromDate(pickupDate),
      'status': 'Pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> logout() async {
    await _auth.signOut();
  }
}
