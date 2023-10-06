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
      // Registration successful
      print('Registration successful');

      // Redirect to the login page
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      // Handle registration errors
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
          style: TextStyle(color: Colors.blue), // Blue text color for the app bar
        ),
        backgroundColor: Colors.white, // White app bar background
      ),
      body: Container(
        color: Colors.blue, // Blue background
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
                  style: TextStyle(color: Colors.white), // White text color
                  decoration: InputDecoration(
                    labelText: 'Имя',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: lastnameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Фамилия',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Имя пользователя',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                TextField(
                  controller: passwordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text(
                    'Зарегистрироваться',
                    style: TextStyle(color: Colors.blue),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white), // Blue button color
                  ),
                ),
                SizedBox(height: 16),
                if (errorMessage.isEmpty)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/login');
                    },
                    child: Text(
                      'Уже есть аккаунт? Войти',
                      style: TextStyle(color: Colors.blue),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white), // Blue button color
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
