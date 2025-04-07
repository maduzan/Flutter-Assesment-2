import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample/service/service.dart';

class Splasher extends StatefulWidget {
  const Splasher({super.key});

  @override
  State<Splasher> createState() => _SplasherState();
}

class _SplasherState extends State<Splasher> {
  void initState() {
    super.initState();

    _navigate();
  }

  Future<void> _navigate() async {
    final firebase = getIt<FirebaseAuth>();
    final User? user = firebase.currentUser;

    await Future.delayed(Duration(seconds: 2)); // Show splash for 2 seconds

    if (user != null) {
      GoRouter.of(context).go('/home'); // User is logged in, go to home
    } else {
      GoRouter.of(context).go('/login'); // Otherwise, go to login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Welcome", style: TextStyle(fontSize: 40))),
        ],
      ),
    );
  }
}
