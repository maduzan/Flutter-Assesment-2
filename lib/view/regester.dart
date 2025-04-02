import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:sample/contraller/authcontraller.dart';
import 'package:sample/model/authservice.dart';
import 'package:sample/service/service.dart';

class Regester extends StatefulWidget {
  const Regester({super.key});

  @override
  State<Regester> createState() => _RegesterState();
}

class _RegesterState extends State<Regester> {
  final _authService = getIt<Authservice>();
  final _authcontraller = getIt<AuthController>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController fullname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateStream,
      builder: (context, snapshot) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Icon(Icons.app_registration_rounded, size: 200),
              SizedBox(height: 30),

              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: fullname,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: telephone,
                  decoration: InputDecoration(
                    hintText: "Mobile Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Email",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  await _authcontraller.signUp(email.text, password.text);
                  await _authcontraller.addUserToFirest(
                    password.text,
                    telephone.text,
                    fullname.text,
                  );

                  Navigator.pop(context);
                },

                child: Text("Regester"),
              ),
            ],
          ),
        );
      },
    );
  }
}
