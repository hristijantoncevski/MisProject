import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:misproject/screens/login_screen.dart';
import 'package:misproject/services/authProvider.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}
class _RegisterState extends State<Register> {
  final TextEditingController nameTextController = TextEditingController();
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
                'Register',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameTextController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
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
                    await authProvider.signUp(emailTextController.text, passwordTextController.text);

                    final user = authProvider.user;
                    if (user != null) {
                      await user.updateDisplayName(nameTextController.text);
                      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

                      await userDocRef.set({
                        'name': nameTextController.text,
                        'email': emailTextController.text,
                      });

                      print('User registered successfully');
                    }

                    if(context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                  } catch (e) {
                    print(e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                ),
                child: const Text('Register'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
                child: const Text('Already registered? Click here to login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
