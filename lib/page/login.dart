import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto/Models/ModelLogin.dart';
import 'package:proyecto/extra/Ambiente.dart';
import 'package:proyecto/page/Home.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final txtUserController = TextEditingController();
  final txtPasswordController = TextEditingController();

  Future<void> fnLogin() async {
    var response = await http.post(
      Uri.parse('${Ambiente.urlServer}/api/login'),
      body: jsonEncode(<String, String>{
        'email': txtUserController.text,
        'password': txtPasswordController.text,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    Map<String, dynamic> jsonResp = jsonDecode(response.body);
    var objResp = ModelLogin.fromJson(jsonResp);

    if (objResp.acceso == "OK") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: objResp.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          Image.asset('assets/images/login.png', width: 200,height: 250),
          TextField(
            controller: txtUserController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Usuario',
            ),
          ),
          TextField(
            controller: txtPasswordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Contraseña',
            ),
          ),
          TextButton(
            onPressed: () {
              fnLogin();
            },
            style: ButtonStyle(
              foregroundColor:
              MaterialStateProperty.all<Color>(Colors.blue),
            ),
            child: const Text("Accesar"),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Login(),
    ),
  );
}
