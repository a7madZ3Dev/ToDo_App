// @dart=2.9

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './layout/home_layout.dart';
import './shared/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.purple),
        primarySwatch: Colors.purple,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.amber[600]),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.purple)),
          floatingLabelStyle: TextStyle(color: Colors.purple),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.amber[600],
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}
