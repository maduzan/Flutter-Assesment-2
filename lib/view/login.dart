import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample/contraller/authcontraller.dart';
import 'package:sample/model/authservice.dart';
import 'package:sample/service/service.dart';
import 'package:sample/view/regester.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _authService = getIt<Authservice>();
  final _authcontraller = getIt<AuthController>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateStream,
      builder: (context, snapshot) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.5,
                child: ClipOval(
                  child: Image(
                    image: AssetImage('images/online.jpg'),
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 40),
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

              ElevatedButton(
                onPressed: () async {
                  await _authcontraller.signIn(email.text, password.text);

                  GoRouter.of(context).go('/home');
                },

                child: Text("Login"),
              ),
              SizedBox(height: 10),
              Text("if you haven an account"),
              TextButton(
                onPressed: () {
                  // Ensure navigation to the register page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Regester()),
                  );
                },
                child: Text("Register"),
              ),
            ],
          ),
        );
      },
    );
  }
}
