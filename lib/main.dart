import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:pariwisata_wonogiri/dashboard.dart';

void main() => runApp(MyApp());
const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};
Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    // const url =  "http://127.0.0.1:8000/api/login";
    // var response = await http.post()
    var url = Uri.http('10.0.2.2:8000', 'api/login');
    var response = await http.post(url, body: {
        'email': data.name,
        'password': data.password
     });
    var jsonResponse = convert.jsonDecode(response.body) as Map <String, dynamic>;
    return Future.delayed(loginTime).then((_) {
      if (jsonResponse['status'] == "400") {
        return jsonResponse['messages'];
      }
      // if (users[data.name] != data.password) {
      //   return 'Password does not match';
      // }
      return null;
    });
  }
  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      } 
      return "Something error";
    });
  }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: Scaffold(
        body: Builder(builder: (context) => FlutterLogin(
        titleTag: "Login Pengunjung",
        logo: const AssetImage('assets/login_logo.png'),
        onLogin: _authUser,
        onSubmitAnimationCompleted: () {
        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Dashboard(title: '')), (route) => false);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Dashboard(title: ''),
          ));
        },
      onRecoverPassword: _recoverPassword,
      ),
      )
      ),
    );
  }
}