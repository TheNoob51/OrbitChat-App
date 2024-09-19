import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // // Sign in with email and password
  // Future<User?> signInWithEmailAndPassword(
  //     String email, String password) async {
  //   try {
  //     UserCredential result = await _auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     User? user = result.user;
  //     return user;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // // Sign out
  // Future<void> signOut() async {
  //   try {
  //     return await _auth.signOut();
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // // Get current user
  // User? getCurrentUser() {
  //   try {
  //     User? user = _auth.currentUser;
  //     return user;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  Future<String> signUpUser(
      {required String name,
      required String email,
      required String password}) async {
    String res = "Error";
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        return "Please fill all the fields";
      }
      //for registering user in firebaseauth with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //for adding user data in firestore cloud
      await _firestore.collection("users").doc(credential.user!.uid).set({
        "name": name,
        "email": email,
        "password": password,
        "uid": credential.user!.uid
      });
      res = "Success";
    } on FirebaseAuthException catch (e) {
      res = e.message ?? "An unknown error occurred";
    } catch (e) {
      res = "An unknown error occurred";
    }
    return res;
  }
}
