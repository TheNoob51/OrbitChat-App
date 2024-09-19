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
    // Initialize the response string with a default error message
    String res = "Error";
    try {
      // Check if any of the input fields are empty
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        return "Please fill all the fields";
      }
      // Register the user with Firebase Authentication using email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Add the user data to Firestore under the "users" collection
      await _firestore.collection("users").doc(credential.user!.uid).set({
        "name": name,
        "email": email,
        "password": password,
        "uid": credential.user!.uid
      });
      // If everything is successful, update the response to "Success"
      res = "Success";
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      res = e.message ?? "An unknown error occurred";
    } catch (e) {
      // Handle any other errors that might occur
      res = "An unknown error occurred";
    }
    // Return the response string
    return res;
  }
}
