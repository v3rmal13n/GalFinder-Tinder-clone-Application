import 'package:flutter/material.dart';
import 'package:galfinder/screens/auth/login.dart';
import 'package:galfinder/screens/auth/register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => RegistrationForm(),
        '/login': (context) => Login(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => UnknownRoutePage(), // Создайте виджет для неизвестных маршрутов
        );
      },
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('404 - Страница не найдена'),
      ),
      body: Center(
        child: Text('404 - Страница не найдена'),
      ),
    );
  }
}
