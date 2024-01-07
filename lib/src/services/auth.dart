export  "package:firebase_auth/firebase_auth.dart";

import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";

import "service.dart";

typedef FirebaseUser = User;
typedef GoogleAccount = GoogleSignInAccount;

class AuthService extends Service {
  // Must be late so it happens after FirebaseService.init
  late final firebase = FirebaseAuth.instance;
  final google = GoogleSignIn();

  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  Stream<FirebaseUser?> get authStates => firebase.authStateChanges();
  FirebaseUser? get user => firebase.currentUser;

  Future<FirebaseUser?> signIn() async {
    final account = await google.signIn();
    if (account == null) return null;
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    await firebase.signInWithCredential(credential);
    return user;
  }

  Future<FirebaseUser?> signInWithGoogleWeb(GoogleSignInAccount account) async {
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    await firebase.signInWithCredential(credential);
    return user;
  }

  Future<void> signOut() async {
    await firebase.signOut();
    await google.signOut();
  }
}
