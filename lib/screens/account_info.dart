import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:misproject/screens/mainScreen.dart';
import 'package:misproject/services/authProvider.dart';
import 'package:provider/provider.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final userLoggedIn = FirebaseAuth.instance.currentUser;
  File? _image;
  String imageUrl = '';
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const MainScreen())),
        ),
      ),
      body: Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          children: [
            const Text(
              'Account Information',
              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Name: ${userLoggedIn!.displayName}',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${userLoggedIn!.email}',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
                final ImagePicker imagePicker = ImagePicker();
                final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
                final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
                if (pickedImage != null){
                  setState(() {
                    _image = File(pickedImage.path);
                    print(_image);
                  });

                  String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child('images');

                  Reference referenceImageToUpload = referenceDirImages.child(uniqueName);

                  try {
                    await referenceImageToUpload.putFile(File(_image!.path));
                    imageUrl = await referenceImageToUpload.getDownloadURL();

                    await userDocRef.update({'imageUrl': imageUrl});

                  } catch (error) {
                    print(error);
                  }
                  authProvider.user!.updatePhotoURL(imageUrl);

                  setState(() {

                  });
                } else {
                  print('No image taken');
                }
              },
              child: const Text('Change profile picture', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () async {
                final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);
                final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);

                await userDocRef.update({'imageUrl': null});
                await authProvider.user!.updatePhotoURL(null);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete profile picture', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),

          ],
        ),
      ),
    )
    );
  }
}
