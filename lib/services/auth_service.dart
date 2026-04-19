import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nhac/models/user_model.dart';


class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithGoogle(BuildContext context) async {
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

      UserCredential userCredencial = await _auth.signInWithCredential(credential);

     
      final docUsuario = await _firestore.collection('usuarios').doc(userCredencial.user!.uid).get();

      
            if (!docUsuario.exists) {
        UserModel novoUsuarioGoogle = UserModel(
          uid: userCredencial.user!.uid,
          nome: userCredencial.user!.displayName ?? 'Usuário Google', 
          email: userCredencial.user!.email ?? '', 
          fotoUrl: userCredencial.user!.photoURL ?? '', 
          telefone: userCredencial.user!.phoneNumber ?? '',

        );
        await _firestore
            .collection('usuarios')
            .doc(userCredencial.user!.uid)
            .set(novoUsuarioGoogle.toMap());
      } else {
        
        if (userCredencial.user!.photoURL != null) {
          await _firestore
              .collection('usuarios')
              .doc(userCredencial.user!.uid)
              .update({
                'foto_url': userCredencial.user!.photoURL, 
              });
        }
      }


      

    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String message = "Erro ao entrar com Google.";
      if (e.code == 'account-exists-with-different-credential') {
        message = "Este e-mail já está associado a outra conta.";
      } else if (e.code == 'invalid-credential') {
        message = "Credenciais inválidas. Tente novamente.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
      );
    } catch(e) {
      if (!context.mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro inesperado: $e")),
      );
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
  UserCredential credencial = await _auth.signInWithEmailAndPassword(email: email, password: password);

  final doc = await _firestore.collection('usuarios').doc(credencial.user!.uid).get();
  
  if (doc.exists && doc.data()?['ativo'] == false) {
    await _auth.signOut(); 
    throw FirebaseAuthException(
      code: 'user-disabled',
      message: 'Esta conta foi desativada pelo usuário.',
    );
  }

  return credencial;
}


 Future<UserCredential> createAccount({

    required String email,
    required String password,
    required String nome,
    required String telefone,
  }) async {
    try {
     
      UserCredential credencial = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      UserModel novoUsuario = UserModel(
        uid: credencial.user!.uid,
        nome: nome,
        email: email,
        fotoUrl: '',
        telefone: telefone,
      );

      await _firestore
          .collection('usuarios')
          .doc(credencial.user!.uid)
          .set(novoUsuario.toMap());

      return credencial;

    } catch (e) {
      print("Erro ao criar conta: $e");
      rethrow;
    }
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

 Future<void> updateUserName({required String userName}) async {

  await currentUser!.updateDisplayName(userName);
  
  await _firestore
      .collection('usuarios')
      .doc(currentUser!.uid)
      .update({'nome': userName});
      
  notifyListeners();
}

  Future<void> desativarConta({
  required String email,
  required String password,
}) async {
  try {
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(credential);

    await _firestore
        .collection('usuarios')
        .doc(currentUser!.uid)
        .update({'ativo': false});

    await _auth.signOut();
    notifyListeners();
  } catch (e) {
    print("Erro ao desativar conta: $e");
    rethrow;
  }
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


  Future<void> uptadeEmail({required String newEmail}) async {

    try{
    await currentUser?.verifyBeforeUpdateEmail(newEmail);

    await _firestore.collection('usuarios')
                    .doc(currentUser?.uid)
                    .update({'email' : newEmail});

    notifyListeners();
    } catch (e) {
      print("Erro ao atualizar e-mail: $e");
      rethrow;

    }


  }


  Future<void> enviarSmsDeVerificacao({
    required String telefone,
    required Function(String verificationId) onCodeSent,
    required Function(String erro) onFailed,
  }) async {
    String numeroCompleto = '+55$telefone';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: numeroCompleto,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onFailed(e.message ?? 'Erro desconhecido');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> loginComSms({
    required String verificationId,
    required String smsCode,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

}
