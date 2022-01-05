import 'package:firebase_auth/firebase_auth.dart';
abstract class AuthBase{
  User? get currentUser;
  Future<User> signInAnonymously();
  Future<void> signOut();
}
class Auth implements AuthBase{
  final _firbaseAuth = FirebaseAuth.instance;

  @override
  User? get currentUser  => _firbaseAuth.currentUser;

  @override
  Future<User> signInAnonymously()async{
    final userCredential = await _firbaseAuth.signInAnonymously();
    return userCredential.user!;
  }

  @override
  Future<void> signOut()async{
   await _firbaseAuth.signOut();
  }
}