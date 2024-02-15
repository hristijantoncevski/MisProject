import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:misproject/screens/mainScreen.dart';
import 'package:misproject/screens/register_screen.dart';
import 'package:misproject/services/authProvider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/logo/logoFoodly.png", height: 115, width: 115),
              const SizedBox(height: 16),
              const Text(
                'Login',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailTextController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: passwordTextController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
                    await authProvider.signIn(emailTextController.text, passwordTextController.text);
                    if(context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                  } catch (e) {
                    print(e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                child: const Text('Not registered? Click here to register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}