import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signin.dart';
import 'Reviews.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  // Function to check if the user is an admin
  Future<void> _checkAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final adminDoc = await FirebaseFirestore.instance
            .collection('Admin')
            .doc('FirstAdmin')
            .get();

        if (adminDoc.exists && adminDoc.data()?['UserID'] == user.uid) {
          setState(() {
            _isAdmin = true;
          });
        }
      } catch (e) {
        print("Error checking admin status: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Colors.lightGreen[600],
        foregroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.off(() => const SignIn());
            },
            child: const Icon(Icons.logout),
          ),
          GestureDetector(
            onTap: () {
              Get.off(() => const Reviews());
            },
            child: const Icon(Icons.reviews),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isAdmin)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => AddAttraction());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen[600],
                ),
                child: const Text("Add City"),
              ),
            ),
          Expanded(
            child: Center(
              child: Text(
                _isAdmin ? "Welcome, Admin!" : "Welcome, User!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen[800],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CitySelectionScreen extends StatelessWidget {
  final List<String> cities = ['City1', 'City2', 'City3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select a City')),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cities[index]),
            onTap: () {
              Get.to(() => AddAttraction(selectedCity: cities[index]));
            },
          );
        },
      ),
    );
  }
}

class AddAttraction extends StatefulWidget {
  final String? selectedCity;

  AddAttraction({this.selectedCity});

  @override
  _AddAttractionState createState() => _AddAttractionState();
}

class _AddAttractionState extends State<AddAttraction> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String imageUrl = '';
  String city = '';

  @override
  void initState() {
    super.initState();
    city = widget.selectedCity ?? '';
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final attractionData = {
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'city': city,
        'createdAt': DateTime.now(),
      };

      await addAttraction(attractionData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attraction added successfully!')),
      );

      Navigator.pop(context);
    }
  }

  Future<void> addAttraction(Map<String, dynamic> attractionData) async {
    await FirebaseFirestore.instance
        .collection('attractions')
        .add(attractionData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Attraction')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                initialValue: city,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a city' : null,
                onSaved: (value) => city = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an image URL' : null,
                onSaved: (value) => imageUrl = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: Text('Add Attraction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
