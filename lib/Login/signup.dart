import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'auth_service.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _hasError = false;
  bool _success = false;
  String _errorMessage = "";

  Future<void> createUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _success = false;
      _errorMessage = "";
    });

    try {
      var response = await http.post(
        Uri.parse("http://message.amoseraja.tech/api/create"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'name': _name.text,
          'emailId': _email.text,
          'password': _password.text,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _success = true;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
          EasyLoading.showSuccess('Account Created!');
          EasyLoading.dismiss();
        });
        // Optionally navigate to another screen or perform additional actions
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = "Failed to create user: ${response.body}";
          EasyLoading.showError('Error in creating Account');
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = "An error occurred: $e";
        EasyLoading.showError('An unexpected error occurred');
      });
    } finally {
      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(),
              const Text(
                "Signup",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(),
                    labelText: "Name",
                    hintText: "Enter Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    hintText: "Enter Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator()
                  : Container(
                height: 50,
                width: 340,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: (){
                    createUser();
                    EasyLoading.showSuccess("sucessfully login");
                    EasyLoading.dismiss();

                  },
                  child: Text("Get Started", style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_success) const Text("User added successfully!",style: TextStyle(color: Colors.green),),
              if (_hasError) Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  InkWell(
                    onTap: () => goToLogin(context),
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}
