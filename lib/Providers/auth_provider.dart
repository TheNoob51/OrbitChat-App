import 'dart:async';
import 'package:devfolio_genai/Firebase%20Authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  late StreamSubscription<User?> _authStateSubscription;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    // Initialize _isLoading to true only if there's no persisted user.
    // If FirebaseAuth has a cached user, authStateChanges will fire quickly.
    _isLoading = FirebaseAuth.instance.currentUser == null;
    // notifyListeners(); // Avoid notifying before subscription
    _authStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
    // If there's already a user, _onAuthStateChanged will set isLoading to false.
    // If not, and _isLoading was set to true, it remains true until a state change.
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _currentUser = user;
    _isLoading = false; // Auth state known, no longer loading initial state
    // Don't nullify errorMessage here, as it might have been set by a failed login attempt
    // and needs to be displayed by the UI before being cleared.
    notifyListeners();
  }

  void clearErrorMessage() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  Future<void> _executeAuthAction(Future<UserCredential?> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final userCredential = await action();
      // _currentUser will be updated by the _authStateSubscription listener
      // However, if action() returns null for an error specific to that method (e.g. GoogleSignIn cancelled)
      // and not a FirebaseException, the auth state might not change immediately.
      // We set error message here for such cases.
      if (userCredential == null && _currentUser == null) {
        // If there's no current user and the action didn't result in one,
        // it implies a silent failure or cancellation (e.g. Google Sign In cancelled by user)
        // Firebase specific errors are caught in the catch block.
      if (userCredential == null && _currentUser == null) {
        _errorMessage = "Authentication process was cancelled or failed.";
      } else if (userCredential != null) {
        _errorMessage = null; // Clear error on successful auth
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "An unknown authentication error occurred.";
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    await _executeAuthAction(
        () => _authService.signInWithEmailAndPassword(email, password));
  }

  Future<void> signInWithGoogle() async {
    await _executeAuthAction(() => _authService.signInWithGoogle());
  }

  Future<void> signInAnonymously() async {
    await _executeAuthAction(() => _authService.signInAnonymously());
  }

  Future<void> signOut() async {
    // No need to set isLoading for signOut, authStateChanges will handle UI update
    // _isLoading = true;
    // _errorMessage = null; // Should be cleared by _onAuthStateChanged or explicitly by UI
    // notifyListeners(); // Not strictly necessary here as authStateChanges will notify
    try {
      await _authService.signOut();
      // _currentUser will be updated by the _authStateSubscription listener to null
      // _errorMessage = null; // Let _onAuthStateChanged handle this or UI clear it.
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "Error signing out.";
      notifyListeners(); // Notify if error during signout
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners(); // Notify if error during signout
    }
    // finally {
      // _isLoading = false; // Let _onAuthStateChanged handle this
      // notifyListeners();
    // }
  }
}
