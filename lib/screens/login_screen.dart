import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatelessWidget {
  final _emailController =
      TextEditingController(text: 'swapna.balugu@gmail.com');
  final _passwordController = TextEditingController(text: 'Swapna@123');

  LoginScreen({super.key});

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        //Push to named route "/productList"
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/productList');
      }
    } catch (e) {
      debugPrint('Failed to sign in: $e');
      QuickAlert.show(
        // ignore: use_build_context_synchronously
        context: context,
        type: QuickAlertType.error,
        title: 'SignIn Error',
        text: 'Failed to sign in: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () => _login(context),
            ),
          ],
        ),
      ),
    );
  }
}
