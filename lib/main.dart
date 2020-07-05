import 'package:firebase/screens/welcome.dart';
import 'package:flutter/material.dart';

import 'screens/homescreen.dart';
import './screens/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {'/': (context) => HomePage(), '/first': (context) => Welcome()},
    );
  }
}
