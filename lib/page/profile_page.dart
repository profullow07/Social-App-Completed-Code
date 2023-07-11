import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/componantes/profile_button.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // controller
  final controller = TextEditingController();

  // auth instance
  final currentUser = FirebaseAuth.instance.currentUser;

  // firefirebase firestore instance
  final firestore = FirebaseFirestore.instance.collection("Users");

  // edit to profile
  Future<void> editToProfile(String flied) async {
    String newField = "";
   await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[300],
              title: Text(flied),
              content: TextField(
                decoration: InputDecoration(
                  hintText: "Enter your $flied",
                ),
                autofocus: true,
                onChanged: (value) {
                  newField = value;
                },
              ),
              actions: [
                // cancel button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                // save button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(newField),
                  child: const Text("Save"),
                )
              ],
            ));

    // update to firebase user with new field
    if (newField.isNotEmpty) {
      await firestore.doc(currentUser!.uid).update({flied: newField});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore.doc(currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snapshotData = snapshot.data!.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  // profile icon
                  const Center(
                    child: Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                  // currnt user
                  Center(
                      child: Text(
                    currentUser!.email!,
                  )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // my details
                  Text(
                    "My Details",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),

                  // profile name
                  ProfileButton(
                    name: snapshotData['email'],
                    sectionName: 'Username',
                    onPressed: () => editToProfile(
                      'email',
                    ),
                  ),

                  // profile bio
                  ProfileButton(
                    name: snapshotData['bio'],
                    sectionName: 'Bio',
                    onPressed: () => editToProfile(
                      'bio',
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error $Error.toString"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
