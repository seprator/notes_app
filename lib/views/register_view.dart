
import 'package:flutter/material.dart';


import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_exeptions.dart';

import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/utitilies.show_error_dialog.dart';
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
                final userCredential = await AuthService.firebase()
                    .createUser(email: email, password: password);
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);

              } on WeakPasswordAuthException {
                await showErrorDialog(
                    context,
                    'Weak password',
                  );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                    context,
                    'Invalid email',
                  );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                    context,
                  'Email already in use',
                  );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'failed to register',
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: (() {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              
              }),
              child: const Text("Already Registered? Login Here!"))
        ],
      ),
    );
  }
}
