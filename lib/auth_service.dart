import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay_crunch/screens/home.dart';
import 'package:pay_crunch/screens/login_screen.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (_, snapshot) {
        if (snapshot.hasData)
          return Home();
        else
          return LoginScreen();
      },
    );
  }
  signOut(){
    FirebaseAuth.instance.signOut();
  }
  //sign in
  signIn(AuthCredential credential) {
    FirebaseAuth.instance.signInWithCredential(credential);
  }
}
