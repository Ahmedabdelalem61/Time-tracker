import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;

  Future<User?> signInWithFacebook();

  Future<User?> signInWithGoogle();

  Stream<User?> authStateChange();

  Future<User> signInAnonymously();

  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firbaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChange() => _firbaseAuth.authStateChanges();

  @override
  User? get currentUser => _firbaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firbaseAuth.signInAnonymously();
    return userCredential.user!;
  }

  @override
  Future<void> signOut() async {
    final facebookSigin = FacebookLogin();
    //await facebookSigin.logOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firbaseAuth.signOut();
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn =  GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final signInAuth = await googleUser.authentication;
      if (signInAuth.idToken != null) {
        final userCredential = await _firbaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          accessToken: signInAuth.accessToken,
          idToken: signInAuth.idToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: "Error while getting google if token",
          message: "Error while getting google if token",
        );
      }
    } else {
      throw FirebaseAuthException(
        code: "Error while google user not found",
        message: "Error while google user not found",
      );
    }
  }

  @override
  Future<User?> signInWithFacebook() async {
    print(".........................");
    final fb =  FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredential = await _firbaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return userCredential.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: "facebook(meta) sign in cancelled",
          message: "facebook(meta) sign in cancelled",
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: "facebook(meta) sign in error May account not found",
          message: "facebook(meta) sign in error",
        );
      default:
        throw UnimplementedError();
    }
  }
}
