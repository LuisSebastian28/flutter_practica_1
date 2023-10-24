import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:guide_form/movies.dart';

class AuthState {
  final bool isAuthenticated;

  AuthState(this.isAuthenticated);
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState(false));

  void authenticateUser(BuildContext context) {
    saveSession(context);
    emit(AuthState(true));
  }

  void saveSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    print("Se inicio sesión correctamente");

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MoviesScreen(),
      ),
    );
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    emit(AuthState(false));
    print("Se cerro la sesion Correctamente");
  }
}

class MyForms extends StatefulWidget {
  const MyForms({Key? key});

  @override
  State<MyForms> createState() => _MyForms();
}

class _MyForms extends State<MyForms> {
  GlobalKey<FormState> _signInKey = GlobalKey();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text("Mi formulario")),
      body: BlocProvider(
          create: (_) => AuthCubit(),
          child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            return Form(
              key: _signInKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "Enter Email",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: "Enter Password",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20)),
                    ),
                  ),
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                        onPressed: () {
                          if (_signInKey.currentState!.validate()) {
                            context.read<AuthCubit>().authenticateUser(context);
                          }
                        },
                        child: const Text("Iniciar Sesion")),
                  ),
                  if (state.isAuthenticated)
                    TextButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                      },
                      child: const Text("Cerrar sesión"),
                    ),
                ],
              ),
            );
          })),
    ));
  }
}
