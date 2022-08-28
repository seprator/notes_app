import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:notes_app/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot share empty note.',
    optionBuilder: () => {
      'OK': null,
    },
  );
}
