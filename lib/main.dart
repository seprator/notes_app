
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/constants/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
// ignore: unused_import
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes/create_update_note_view.dart';
import 'package:notes_app/views/notes/notes_view.dart';
// ignore: unused_import
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email-view.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      
    },
  ));
}
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: AuthService.firebase().initialize(),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.done:
//               final user = AuthService.firebase().currentUser;

//               if (user != null) {
//                 if (user.isEmailVerified) {
//                   return const NotesView();
//                 } else {
//                   return const VerifyEmailView();

//                 }
//               } else {
//                 return const LoginView();
//               }

//             default:
//               return const CircularProgressIndicator();
//           }
//         });
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('testing'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(listener: (
          context,
          state,
        ) {
          _controller.clear();
        }, builder: (context, state) {
          final invalidValue =
              (state is CounterStateInvalidNumber) ? state.invalidValue : "";
          return Column(
            children: [
              Text('current value => ${state.value}'),
              Visibility(
                child: Text('invalid input: $invalidValue'),
                visible: state is CounterStateInvalidNumber,
              ),
              TextField(
                decoration:
                    const InputDecoration(hintText: 'enter a number here'),
                controller: _controller,
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: (() {
                        context
                            .read<CounterBloc>()
                            .add(DecrementEvent(_controller.text));
                      }),
                      child: const Text('-')),
                  TextButton(
                      onPressed: (() {
                        context
                            .read<CounterBloc>()
                            .add(IncrementEvent(_controller.text));
                      }),
                      child: const Text('+'))
                ],
              )

            ],
          );
        }),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}
@immutable
abstract class CounrterEvent {
  final String value;
  const CounrterEvent(this.value);
}

class IncrementEvent extends CounrterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounrterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounrterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(CounterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
  
}
