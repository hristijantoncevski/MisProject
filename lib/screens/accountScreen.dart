import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:misproject/screens/account_info.dart';
import 'package:misproject/screens/login_screen.dart';
import 'package:misproject/screens/order_history_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final userLoggedIn = FirebaseAuth.instance.currentUser?.displayName;
  final userId = FirebaseAuth.instance.currentUser!.uid;
  var userPicture = FirebaseAuth.instance.currentUser!.photoURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 10, right: 10),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          title(),
          content(),
        ],
      ),
    );
  }

  Widget title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: userPicture != null ? NetworkImage(userPicture!) : null,
              child: userPicture == null ? const Icon(Icons.account_circle, size: 60) : null,
            ),
            Text(userLoggedIn != null ? 'Hello, $userLoggedIn!' : 'Hello anonymous!',
              style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            //const Icon(Icons.account_circle, size: 60),
          ],
        ),
      ],
    );
  }

  Widget content() {
    return Expanded(
      child: ListView(
        children: [
          if(userLoggedIn != null)
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextButton(
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountInfo())
                );
              },
              child: const Text('Account info', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistory()));
              },
              child: const Text('Order History', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: userLoggedIn != null ? Colors.redAccent : Colors.greenAccent,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text(userLoggedIn != null ? 'Log Out' : 'Log In',
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
