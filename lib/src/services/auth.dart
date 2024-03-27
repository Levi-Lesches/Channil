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
    print("Hola2");
    final account = await google.signIn();
    print("Hola part dos");
    print("Account: $account");
    if (account == null) return null;
    print("Here");
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final credential2 = await firebase.signInWithCredential(credential);
    print("Done: ${credential2.user?.uid}");
    return user;
  }

  Future<FirebaseUser?> signInWithGoogleWeb(GoogleSignInAccount account) async {
    final auth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final credential2 = await firebase.signInWithCredential(credential);
    print("Done: ${credential2.user?.uid}");
    return user;
  }

  Future<SignUpResult> signUpWithEmailAndPassword({required String email, required String password}) async {
    try {
      await firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return SignUpResult.ok;
    } on FirebaseAuthException catch (error) {
      return switch (error.code) {
        "email-already-in-use" => SignUpResult.accountExists,
        "invalid-email" => SignUpResult.invalidEmail,
        "operation-not-allowed" => SignUpResult.notAllowed,
        "weak-password" => SignUpResult.weakPassword,
        _ => SignUpResult.unknownError,
      };
    } 
  }

  Future<SignInResult> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return SignInResult.ok;
    } on FirebaseAuthException catch (error) {
      return switch (error.code) {
        "invalid-credential" => SignInResult.wrongPassword,
        "invalid-email" => SignInResult.invalidEmail,
        "missing-password" => SignInResult.missingPassword,
        "user-disabled" => SignInResult.disabledAccount,
        _ => SignInResult.unknownError,
      };
    } 
  }

  Future<void> signOut() async {
    await firebase.signOut();
    await google.signOut();
  }
}

enum SignUpResult {
  ok,
  weakPassword,
  accountExists,
  invalidEmail,
  notAllowed,
  unknownError,
}

enum SignInResult {
  ok,
  wrongPassword,
  missingPassword,
  invalidEmail,
  disabledAccount,
  unknownError,
}
