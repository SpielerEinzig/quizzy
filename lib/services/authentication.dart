import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential credential =
        await _firebaseAuth.signInWithCredential(authCredential);

    final User? user = credential.user;

    final User? currentUser = _firebaseAuth.currentUser;

    assert(currentUser!.uid == user!.uid);

    return currentUser;
  }

  Future<Future<GoogleSignInAccount?>> signOutWithGoogle() async {
    return _googleSignIn.signOut();
  }

  //facebook Sign in

  Future<User?> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ["email", "public_profile"],
    );

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final userData = await FacebookAuth.instance.getUserData();

    final userEmail = userData["email"];
    final name = userData["name"];

    print(name);
    print(userEmail);

    // Once signed in, return the UserCredential
    UserCredential credential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    final User? user = credential.user;

    final User? currentUser = _firebaseAuth.currentUser;

    assert(currentUser!.uid == user!.uid);

    return currentUser;
  }
}
