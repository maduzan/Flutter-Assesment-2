import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sample/model/adduser.dart';
import 'package:sample/service/service.dart';

class Authservice {
  final FirebaseAuth firebaseAuth;

  final StreamController<User?> _authStateController =
      StreamController<User?>.broadcast();

  Authservice({required this.firebaseAuth});

  authService() {
    // Listen to FirebaseAuth changes and update the StreamController
    firebaseAuth.authStateChanges().listen((User? user) {
      _authStateController.add(user);
    });
  }

  Stream<User?> get authStateStream => _authStateController.stream;

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<void> authenticate(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Authentication failed: ${e.toString()}');
      throw Exception('Authentication failed: $e');
    }
  }

  void logout() async {
    final firebase = getIt<FirebaseAuth>();

    await firebase.signOut();
  }

  void addUserToFirestore(
    String email,
    String password,
    String telephone,
    String fullname,
  ) async {
    final firestore = getIt<FirebaseFirestore>();

    // Create Use rModel instance
    UserModel user = UserModel(
      email: email,
      password: password,
      telephone: telephone,
      fullname: fullname,
    );

    await firestore
        .collection('users')
        .add(user.toMap())
        .then((value) {
          print('User added successfully!');
        })
        .catchError((error) {
          print('Error adding user: $error');
        });
  }
}
