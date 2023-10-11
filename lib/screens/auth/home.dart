import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Home extends StatefulWidget {
  final String accessToken;
  Home({required this.accessToken});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String helloMessage = '';
  String selectedGender = '';

  bool isMaleSelected = false;
  bool isFemaleSelected = false;

  File? _userImageFile;
  Uint8List _userImageBytes = Uint8List(0);

  final ImagePicker _picker = ImagePicker();
  String _photoUrl = 'http://localhost:8080/api/v1/user/profile/photo';

  @override
  void initState() {
    super.initState();
    fetchHelloMessage();
    fetchUserPhoto();
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
        final firstname = data['firstname'];
        final lastname = data['lastname'];
        final email = data['email'];

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

  Future<void> fetchUserPhoto() async {
    try {
      final response = await http.get(
        Uri.parse('$_photoUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final Uint8List photoBytes = response.bodyBytes;
        setState(() {
          _userImageBytes = photoBytes;
        });
      } else {
        print(response.statusCode);
        // обработайте другие коды состояния по вашему усмотрению
      }
    } catch (error) {
      print("Ошибка: $error");
    }
  }

  Future<void> updateGender(String gender) async {
    final genderData = {'gender': gender};

    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/v1/user/profile/gender'),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(genderData),
      );
      if (response.statusCode == 200) {
        print('Пол успешно обновлен: $gender');
        setState(() {
          if (gender == 'male') {
            isMaleSelected = true;
            isFemaleSelected = false;
          } else if (gender == 'female') {
            isMaleSelected = false;
            isFemaleSelected = true;
          }
        });
      } else {
        print('Ошибка при обновлении пола: ${response.statusCode}');
      }
    } catch (error) {
      print('Ошибка при обновлении пола: $error');
    }
  }

  Future<void> _uploadUserImage() async {
    if (_userImageFile == null) {
      return;
    }

    final uri = Uri.parse('$_photoUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer ${widget.accessToken}';
    final file = await http.MultipartFile.fromPath('file', _userImageFile!.path);
    request.files.add(file);

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Фотография успешно загружена');
        // Обновите _userImageBytes и перестройте виджет
        final newResponse = await http.get(Uri.parse('$_photoUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}'),
            headers: {'Authorization': 'Bearer ${widget.accessToken}'});
        if (newResponse.statusCode == 200) {
          final Uint8List newPhotoBytes = newResponse.bodyBytes;
          setState(() {
            _userImageBytes = newPhotoBytes;
          });
        }
      } else {
        print('Ошибка при загрузке фотографии: ${response.statusCode}');
      }
    } catch (error) {
      print('Ошибка при загрузке фотографии: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Профиль пользователя'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Добро пожаловать на главную страницу!',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    helloMessage.isNotEmpty ? helloMessage : 'Загрузка данных...',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Выберите ваш пол:',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (!isMaleSelected) {
                          updateGender('male');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isMaleSelected ? Colors.grey : null,
                      ),
                      child: Text('Мужчина'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (!isFemaleSelected) {
                          updateGender('female');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: isFemaleSelected ? Colors.grey : null,
                      ),
                      child: Text('Женщина'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

                    setState(() {
                      if (pickedFile != null) {
                        _userImageFile = File(pickedFile.path);
                        _uploadUserImage();
                      }
                    });
                  },
                  child: Text('Загрузить свою фотографию'),
                ),
              ],
            ),
          ),
          if (_userImageBytes.isNotEmpty)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 400,
                height: 400,
                child: Image.memory(
                  _userImageBytes,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
