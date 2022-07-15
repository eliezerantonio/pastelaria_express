import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../helper/firebase_errors.dart';
import 'user_model.dart';

class UserManager with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserManager() {
    loadCurrentUser();
  }
  UserModel user;
  bool _loading = false;
  bool get isLogged => user != null;

//login

  Future signIn({
    @required UserModel user,
    @required Function onFail,
    @required Function onSuccess,
  }) async {
    loading = true;

    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);

      await loadCurrentUser(firebaseUser: result);

      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    } finally {
      loading = false;
    }
  }

//cadastro
  Future<void> signUp(
      {@required UserModel user,
      @required Function onFail,
      @required Function onSuccess,
      bool admin = false,}) async {
    loading = true;
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      user.id = result.user.uid;

      //chamando o metodo salvar
      await user.saveData();
      this.user = user;
      if (admin) {
        await user.saveAdmin();
      }
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    } finally {
      loading = false;
    }
  }

  Future<void> loadCurrentUser({UserCredential firebaseUser}) async {
    final currentUser = firebaseUser?.user ?? auth.currentUser;

    // currentUser.sendEmailVerification();
    if (currentUser != null) {
      final DocumentSnapshot docUser =
          await firestore.collection('users').doc(currentUser.uid).get();
      user = UserModel.fromDocument(docUser);

      try {
        //verificando usuario admin
        final docAdmin =
            await firestore.collection('admins').doc(user?.id).get();

        if (docAdmin.exists) {
          user?.admin = true;
        }
        final docSuperUser =
            await firestore.collection('super').doc(user.id).get();
        if (docSuperUser.exists) {
          user.superUser = true;
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
      notifyListeners();
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void signOut() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;
  bool get adminEnabled => user != null && user.admin;
  bool get superEnabled => user != null && user.superUser;
}
