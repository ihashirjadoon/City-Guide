import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadImage(File imageFile) async {
  final storageRef = FirebaseStorage.instance.ref();
  final imageRef = storageRef
      .child('attractions/images/${DateTime.now().millisecondsSinceEpoch}.jpg');

  // Upload file
  await imageRef.putFile(imageFile);

  // Get and return the download URL
  return await imageRef.getDownloadURL();
}

class AddAttractionScreen extends StatefulWidget {
  @override
  _AddAttractionScreenState createState() => _AddAttractionScreenState();
}

class _AddAttractionScreenState extends State<AddAttractionScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> submitForm() async {
    if (_image != null) {
      // Upload image and get its URL
      String imageUrl = await uploadImage(_image!);

      // Save the image URL to Firestore
      final attractionData = {
        'imageUrl': imageUrl,
        'createdAt': DateTime.now(),
      };

      await FirebaseFirestore.instance
          .collection('attractions')
          .add(attractionData);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image uploaded successfully!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image to upload.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Attraction"),
        backgroundColor: Colors.lightGreen[600],
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_image != null)
                Image.file(
                  _image!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Choose Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen[600],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
