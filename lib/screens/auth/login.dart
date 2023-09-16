import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:galfinder/screens/auth/home.dart'; // Импорт вашего Home.dart

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';

  Future<void> handleSubmit() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/v1/auth/authenticate'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['token'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(accessToken: accessToken),
        ),
      );
    } else {
      if (response.statusCode == 403) {
        setState(() {
          errorMessage = 'Такого аккаунта нет';
        });
      } else {
        setState(() {
          errorMessage = 'Ошибка при входе';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Войти',
          style: TextStyle(color: Colors.white), // белый цвет текста шапки
        ),
        backgroundColor: Colors.black, // черный фон шапки
      ),
      body: Container(
        color: Colors.grey[800], // серый фон
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 8), // Уменьшаем высоту поля
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white), // белый текст
                  decoration: InputDecoration(
                    labelText: 'Email:',
                    labelStyle: TextStyle(color: Colors.white), // белая метка
                  ),
                ),
                SizedBox(height: 8), // Уменьшаем высоту поля
                TextField(
                  controller: passwordController,
                  style: TextStyle(color: Colors.white), // белый текст
                  decoration: InputDecoration(
                    labelText: 'Пароль:',
                    labelStyle: TextStyle(color: Colors.white), // белая метка
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text(
                    'Войти',
                    style: TextStyle(color: Colors.white), // белый текст кнопки
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black), // черный цвет кнопки
                  ),
                ),
                SizedBox(height: 8), // Расстояние между кнопкой "Войти" и кнопкой "Зарегистрироваться"
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/'); // Перенаправление на главную страницу
                  },
                  child: Text(
                    'У вас нет аккаунта? Создать',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
