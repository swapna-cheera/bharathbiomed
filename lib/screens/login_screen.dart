import 'package:bharathbiomedpharma/services/firebase_auth_service.dart';
import 'package:bharathbiomedpharma/services/firebase_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _emailController =
  //     TextEditingController(text: 'swapna.balugu@gmail.com');
  // final _passwordController = TextEditingController(text: 'Swapna@123');

  final _emailController = TextEditingController(
      // text: 'swapna.balugu@gmail.com',
      text: 'bharathbiomedpharma@gmail.com');
  final _passwordController = TextEditingController(
      // text: 'Swapna@123',
      text: 'Bharath@2024');

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      User? user = await _authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (user != null) {
        await FirebaseFirestoreService().syncData();

        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/productList');
      } else {
        QuickAlert.show(
          // ignore: use_build_context_synchronously
          context: context,
          type: QuickAlertType.error,
          title: 'SignIn Error',
          text:
              'Failed to sign in. Please check your credentials and try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/blogo.png', height: 100, width: 100),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () =>
                    _formKey.currentState!.validate() ? _login(context) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
