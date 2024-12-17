import 'dart:js';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/app_provider.dart';
import 'package:to_do_app/home.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppProvider(),
      child: const MyToDo())
  );
}


class MyToDo extends StatelessWidget {
  const MyToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: HomePage(),
    );
  }
}


