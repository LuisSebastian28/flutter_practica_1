import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:guide_form/string_state.dart';

class StringCubit extends Cubit<StringState> {
  int counter = 0;
  String process = "Procesando...";
  String complet = "Completado";
  bool timerActive = false;

  StringCubit() : super(StringLoading());

  void addData(BuildContext context) {
    if (state is! StringNew || !timerActive) {
      timerActive = true;
      emit(StringNew(data: process));

      Future.delayed(const Duration(seconds: 3), () {
        var intValue = Random().nextInt(10);
        timerActive = false;
        if (intValue > 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Error al Pagar",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          emit(StringNew(data: complet));
        }
        Future.delayed(const Duration(seconds: 1), () {
          emit(StringLoading());
        });
      });
    }
  }
}
