import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  final String accessToken;
  Home({required this.accessToken});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String helloMessage = '';

  @override
  void initState() {
    super.initState();
    fetchHelloMessage();
  }

  Future<void> fetchHelloMessage() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/v1/user/profile'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['username']; // Извлекаем данные из поля "username"
        final firstname = userData['firstname'];
        final lastname = userData['lastname'];
        final email = userData['email'];

        setState(() {
          helloMessage = 'Имя: $firstname\nФамилия: $lastname\nEmail: $email';
        });
      } else if (response.statusCode == 403) {
        // Обработка ошибок аутентификации
      } else {
        // Обработка других ошибок
      }
    } catch (error) {
      // Обработка ошибок
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная страница'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Добро пожаловать на главную страницу!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              helloMessage.isNotEmpty ? helloMessage : 'Загрузка данных...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
