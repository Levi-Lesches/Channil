import "dart:async";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";
import "package:flutter/material.dart";

class UserModel extends DataModel {
  String? email;
  String? uid;
  ChannilUser? channilUser;
  String authStatus = "Pending";
  bool get hasAccount => channilUser != null;
  bool get isAuthenticated => uid != null && email != null;
  
  StreamSubscription<GoogleAccount?>? _googleSubscription;
  StreamSubscription<FirebaseUser?>? _firebaseSubscription;
  
  @override
  @mustCallSuper
  Future<void> init() async {
    _googleSubscription = services.auth.google.onCurrentUserChanged.listen(_onGoogleSignIn);
    _firebaseSubscription = services.auth.authStates.listen(updateUser);
    final user = services.auth.user;
    await updateUser(user);
  }

  @override
  void dispose() {
    _googleSubscription?.cancel();
    _firebaseSubscription?.cancel();
    super.dispose();
  }

  Future<void> _onGoogleSignIn(GoogleAccount? account) async {
    if (account == null) return;
    final user = await services.auth.signInWithGoogleWeb(account);
    if (user == null) return;
    await updateUser(user);
  }

  Future<void> updateUser(FirebaseUser? user) async {
    if (user == null) {
      uid = null;
      email = null;
      authStatus = "Pending";
      channilUser = null; 
    } else {
      email = user.email;
      uid = user.uid;
      authStatus = "Authenticated as\n$email";
      channilUser = await services.database.getUser(user.uid);
    }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    authStatus = "Loading...";
    email = null; 
    notifyListeners();
    await services.auth.signOut();
    final FirebaseUser? user;
    try {
      print("Now, signing in");
      user = await services.auth.signIn();
      await updateUser(user);
    } catch (error) {
      authStatus = "Error signing in";
      notifyListeners();
      return;
    }
    if (user == null) {
      authStatus = "Cancelled";
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await services.auth.signOut();
    email = null;
    uid = null;
    channilUser = null;
    authStatus = "Pending";
  }

  Future<void> saveUser(ChannilUser user) async {
    await services.database.saveUser(user);
    channilUser = user;
    notifyListeners();
  }
}
