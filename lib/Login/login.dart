import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../Get_All_User.dart';
import 'auth_service.dart';
import 'signup.dart';


import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isPasswordVisible = false;

  bool _isLoading = false;
  bool _hasError = false;
  bool _success = false;
  String _errorMessage = "";

  Future<void> LoginUser() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _success = false;
      _errorMessage = "";
    });

    try {
      var response = await http.post(
        Uri.parse("http://message.amoseraja.tech/api/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          "emailId":_email.text,
          "password":_password.text,

        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          EasyLoading.showSuccess('Great Success!');

          Navigator.push(context, MaterialPageRoute(builder: (context)=>Getall()));
          EasyLoading.dismiss();

          _success = true;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = "Failed to create user: ${response.body}";
          EasyLoading.showError('error in login!');
          EasyLoading.dismiss();
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height:400,
            width: MediaQuery.of(context).size.width,

          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _email,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                border: OutlineInputBorder(),
                labelText: "Email",
                hintText: "Enter Email",
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _password,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade300,
                border: OutlineInputBorder(),
                labelText: "Password",
                hintText: "Enter Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          _isLoading?
              CircularProgressIndicator()
          :Container(
            height: 50,
            width: 390,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
              onPressed:() {
                //_login();
                LoginUser();
                EasyLoading.show();
                EasyLoading.dismiss();
              },
              // onPressed: () {
              //   _login();
              //   //Navigator.push(context, MaterialPageRoute(builder: (context) => bot()));
              // },
              child: Text("Get Started", style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 20),
          if (_success)  Text("User added successfully!"),
          if (_hasError) Text("error in login", style: const TextStyle(color: Colors.red)),
          SizedBox( height: 5,),

          ElevatedButton(onPressed: () async {
            await _auth.loginWithGoogle();

            EasyLoading.showSuccess("sucessfully login");
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Getall()));
            EasyLoading.dismiss();
          }, child: Text("sign in Google")),

          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? "),
              InkWell(
                onTap: () => goToSignup(context),
                child: const Text("Signup", style: TextStyle(color: Colors.deepPurpleAccent)),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Future<void> _login() async {
    await _auth.loginUserWithEmailAndPassword(
      _email.text,
      _password.text,
    );
  }

  void goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }
}
