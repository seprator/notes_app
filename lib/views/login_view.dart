
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_exeptions.dart';
import 'package:notes_app/services/auth/bloc/auth_event.dart';
import 'package:notes_app/utilities/dialogs/error_dialog.dart';

import '../services/auth/bloc/auth_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(
        title: const Text("Login"),
      ),
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
                context.read<AuthBloc>().add(
                      AuthEventLogIn(
                        email,
                        password,
                      ),
                    );
              } on UserNotFoundAuthException {
                await showErrorDialog(
                    context,
                    'User not found',
                  );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                    context,
                    'Wrong password',
                  );
              } on GenericAuthException {
                await showErrorDialog(
                    context,
                  'authentication error',
                );
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: (() {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
              }),
            child: const Text("Not Registered Yet? Register Here!"),
          )
        ],
      ),
    );
  }
}


