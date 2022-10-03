import 'package:flutter/widgets.dart';
import 'package:notes_app/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'password reset',
    content: 'password reset email has been sent,please check your inbox',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
