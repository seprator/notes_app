import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          TextField(
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            controller: _email,
            decoration: const InputDecoration(hintText: "Enter Your Email"),
          ),
          TextField(
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            controller: _password,
            decoration: const InputDecoration(hintText: "Enter Your password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final UserCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('weak password ...');
                } else if (e.code == 'email-already-in-use') {
                  print('email already in use ...');
                } else if (e.code == 'invalid-email') {
                  print('invalid email ...');
                }
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: (() {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/login/", (route) => false);
              
              }),
              child: Text("Already Registered? Login Here!"))
        ],
      ),
    );
  }
}
