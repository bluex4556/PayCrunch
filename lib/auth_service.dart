import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay_crunch/screens/home.dart';
import 'package:pay_crunch/screens/login_screen.dart';

import 'models/user.dart';

class AuthService {

  static String userId;

  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (_, snapshot) {
        FirebaseUser user = snapshot.data as FirebaseUser;
        if (snapshot.hasData)
          {
              userId = user.uid;
            return Home();

          }
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

  static User addUser(String userId) {
    print("adding user");
    Firestore.instance
        .collection('users')
        .document(userId)
        .setData({'userId': userId, 'balance': 0});
    return User(username: userId, balance: 0);
  }

  static Future<User> getCurrentUser() async {
    return Firestore.instance
        .collection('users')
        .document(AuthService.userId)
        .get()
        .then((data) {
      return new User(username: AuthService.userId, balance: data['balance']);
    }).catchError((error) {
      return addUser(AuthService.userId);
    });
  }
}
