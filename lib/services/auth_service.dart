import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading = false;

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithGoogle() async {
    _setLoading(true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        _setLoading(false);
        return; 
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

    } catch (e) {
      //snackbar aqui sem ser a barra de chocolate
      print("Erro no login com Google: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }



  Future<UserCredential> signIn({
    required String email,
    required String password,

  }) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }


  Future<UserCredential> createAccount({
    required String email,
    required String password,

  }) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

   Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> resetPassword({
    required String email,

  } ) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUserName({
    required String userName,
  }) async {
    await currentUser!.updateDisplayName(userName);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await _auth.signOut();
  }

   Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
   }) async {
    AuthCredential credential = 
              EmailAuthProvider.credential(email: email, password: currentPassword);
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);

   }


  Future<bool> checarEmail(String email) async {
  try {
    await _auth.createUserWithEmailAndPassword(
      email: email, 
      password: 'senha_temporaria_muito_longa_123'
    );
    
    await _auth.currentUser?.delete();
    return false;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}

}