import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(hintText: 'Username'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signup(context);
                },
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signup(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Simpan username menggunakan shared_preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);

    // Lakukan validasi signup dan berpindah ke halaman Home jika berhasil
    if (username.isNotEmpty && password.isNotEmpty) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Signup Failed'),
          content: Text('Please enter a valid username and password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}