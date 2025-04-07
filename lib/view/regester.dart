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
    final _formKey = GlobalKey<FormState>();

    bool isObscured = true;

    return StreamBuilder<User?>(
      stream: _authService.authStateStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            key: _formKey,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.app_registration_rounded, size: 150),
                SizedBox(height: 30),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: fullname,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full Name is required';
                      }
                      return null; // Valid input
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: telephone,
                    decoration: InputDecoration(
                      hintText: "Mobile Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile Number is required';
                      } else if (value.length <= 10) {
                        return 'Mobile Number must be 10 characters long';
                      }
                      return null; // Valid input
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Email",

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null; // Valid input
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    obscureText: isObscured,

                    controller: password,
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter';
                      } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Password must contain at least one number';
                      }
                      return null; // Valid input
                    },
                  ),
                ),

                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _authcontraller.signUp(email.text, password.text);
                      await _authcontraller.addUserToFirest(
                        email.text,
                        password.text,
                        telephone.text,
                        fullname.text,
                      );

                      print("Valid password: ${password.text}");
                      Navigator.pop(context);
                    }
                  },

                  child: Text("Regester"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
