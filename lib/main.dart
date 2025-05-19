import 'package:flutter/material.dart';
import 'package:notes/views/home.dart';
import 'package:provider/provider.dart';
import 'package:notes/viewmodels/change_notifier_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => NotesProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Comic-Relief'),
      home: const Home(),
    );
  }
}
