import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // current user
  User? get currentUser => _auth.currentUser;

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      final fcmToken = await FirebaseMessaging.instance.getToken();
      // Update FCM token and isLoggedIn status after successful sign in
      if (user != null) {
        await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get()
            .then((docs) {
          if (docs.docs.isNotEmpty) {
            docs.docs.first.reference.update({
              'fcmToken': fcmToken,
              'isLoggedIn': true,
            });
          }
        });
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      
      // Update display name in Firebase Authentication
      await user?.updateDisplayName(displayName);
      await user?.reload();

      // Get FCM token
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      // Store user details with isLoggedIn status
      await _firestore
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "uid": user?.uid,
        "name": displayName,
        "email": email,
        "createdAt": Timestamp.now(),
        "fcmToken": fcmToken,
        "isLoggedIn": true, // Set to true when user registers
      });
      
      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Update FCM token
  Future<void> _updateFCMToken(String email) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get()
            .then((docs) {
          if (docs.docs.isNotEmpty) {
            docs.docs.first.reference.update({'fcmToken': token});
          }
        });
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  //reset password
  Future sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Password reset error: $e');
      return null;
    }
  }

  String getUserDisplayName() {
    return _auth.currentUser?.displayName ?? "Guest";
  }

  // sign out
  Future signOut() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        try {
          final querySnapshot = await _firestore
              .collection('users')
              .where('email', isEqualTo: user.email)
              .get();
              
          if (querySnapshot.docs.isNotEmpty) {
            await querySnapshot.docs.first.reference.update({
              'fcmToken': null,
              'isLoggedIn': false, // Set to false when user signs out
            });
          }
        } catch (e) {
          print('Error updating user status: $e');
        }
      }
      
      return await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      return null;
    }
  }

  Future<void> updateExistingUserTokens() async {
  final user = _auth.currentUser;
  if (user != null) {
    await _updateFCMToken(user.email!);
  }
}
}
