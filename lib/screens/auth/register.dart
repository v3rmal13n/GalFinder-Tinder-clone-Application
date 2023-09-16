import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String errorMessage = '';

  Future<void> handleSubmit() async {
    final String firstname = firstnameController.text;
    final String lastname = lastnameController.text;
    final String email = emailController.text;
    final String username = usernameController.text;
    final String password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/v1/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'username': username,
          'password': password,
        },
      ),
    );

    if (response.statusCode == 200) {
      // Регистрация успешна
      print('Регистрация успешна');

      // Перенаправляем на страницу входа (страницу с логином)
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      // Обработка ошибок при регистрации
      if (response.statusCode == 403) {
        setState(() {
          errorMessage = 'Такого аккаунта нет';
        });
      } else {
        setState(() {
          errorMessage = 'Ошибка при регистрации';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Зарегистрироваться',
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
                TextField(
                  controller: firstnameController,
                  style: TextStyle(color: Colors.white), // белый текст
                  decoration: InputDecoration(
                    labelText: 'Имя',
                    labelStyle: TextStyle(color: Colors.white), // белая метка
                  ),
                ),
                TextField(
                  controller: lastnameController,
                  style: TextStyle(color: Colors.white), // белый текст
                  decoration: InputDecoration(
                    labelText: 'Фамилия',
                    labelStyle: TextStyle(color: Colors.white), // белая метка
                  ),
                ),
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white), // белый текст
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white), // белая метка
                  ),
                ),
                TextField(
                  controller: usernameController,
                  style: TextStyle(color: Colors.white), // белый текст
                  decoration: InputDecoration(
                    labelText: 'Имя пользователя',
                    labelStyle: TextStyle(color: Colors.white), // белая метка
                  ),
                ),
                TextField(
                  controller: passwordController,
                  style: TextStyle(color: Colors.white), // белый текст
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    labelStyle: TextStyle(color: Colors.white), // белая метка
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text(
                    'Зарегистрироваться',
                    style: TextStyle(color: Colors.white), // белый текст кнопки
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black), // черный цвет кнопки
                  ),
                ),
                SizedBox(height: 16),
                if (errorMessage.isEmpty) // Отображать только если errorMessage пусто
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: Text(
                      'Уже есть аккаунт? Войти',
                      style: TextStyle(color: Colors.white), // белый текст кнопки
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black), // черный цвет кнопки
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
