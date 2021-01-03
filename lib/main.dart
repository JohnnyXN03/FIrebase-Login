import 'package:firebase/screens/signin.dart';
import 'package:firebase/screens/signin.dart';
import 'package:firebase/screens/welcome.dart';
import 'package:flutter/material.dart';
import './screens/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Signin(),
        '/first': (context) => Welcome(),
      },
    );
  }
}
