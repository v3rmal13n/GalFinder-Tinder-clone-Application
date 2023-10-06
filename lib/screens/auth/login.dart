import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:galfinder/screens/auth/home.dart'; // Import your Home.dart

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
                SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white), // White text color
                  decoration: InputDecoration(
                    labelText: 'Email:',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Пароль:',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: handleSubmit,
                  child: Text(
                    'Войти',
                    style: TextStyle(color: Colors.blue),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white), // Blue button color
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/'); // Redirect to the main page
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
