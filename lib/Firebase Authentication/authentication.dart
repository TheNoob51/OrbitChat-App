import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//<----------------------------------------------------------------------->
  // Sign in with email and password
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some Error Occured";
    try {
      if (email.isEmpty || password.isEmpty) {
        return "Please fill all the fields";
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "Success";
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      res = e.message ?? "An unknown error occurred";
    } catch (e) {
      // Handle any other errors that might occur
      res = "An unknown error occurred";
    }
    return res;
  }

//<----------------------------------------------------------------------->
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

//<----------------------------------------------------------------------->
  // Get current user
  User? getCurrentUser() {
    try {
      User? user = _auth.currentUser;
      return user;
    } catch (e) {
      logger.i(e.toString());
      return null;
    }
  }

//<----------------------------------------------------------------------->

  Future<String?> getUserName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        if (user.isAnonymous) {
          return "Anonymous";
        } else {
          DocumentSnapshot doc =
              await _firestore.collection("users").doc(user.uid).get();
          if (doc.exists) {
            return doc["name"] ?? "No name found";
          } else {
            return "User document does not exist";
          }
        }
      } else {
        return "No user is currently signed in";
      }
    } catch (e) {
      print(e.toString());
      return "An error occurred while fetching the user name";
    }
  }

//<----------------------------------------------------------------------->
  // Sign in with Google
  Future<String> signInWithGoogle() async {
    String res = "Some Error Occurred";
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return "Sign in aborted by user";
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google user credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Get the user details
      User? user = userCredential.user;
      if (user != null) {
        // Check if the user document already exists
        DocumentSnapshot doc =
            await _firestore.collection("users").doc(user.uid).get();
        if (!doc.exists) {
          // If the document does not exist, create a new one
          await _firestore.collection("users").doc(user.uid).set(
              {"name": user.displayName, "email": user.email, "uid": user.uid});
        }
      }

      res = "Success";
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      res = e.message ?? "An unknown error occurred";
    } catch (e) {
      // Handle any other errors that might occur
      res = "An unknown error occurred";
    }
    return res;
  }

//<----------------------------------------------------------------------->
//signin anonymously
  Future<String> signInAnonymously() async {
    String res = "Some Error Occurred";
    try {
      await _auth.signInAnonymously();
      res = "Success";
    } on FirebaseAuthException catch (e) {
      res = e.message ?? "An unknown error occurred";
    } catch (e) {
      res = "An unknown error occurred";
    }
    return res;
  }

//<----------------------------------------------------------------------->
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
//<----------------------------------------------------------------------->